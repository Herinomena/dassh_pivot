#!/bin/bash

# --- Paramètres ---
DB_SERVEUR="localhost"
DB_USER="root"
DB_PASSWORD="Her!nomen@_11"
DB_NAME="base_pvt_locale"
DOSSIER_BACKUP="/home/herinomena/Images/backup_Dashboard"

# --- Recherche du fichier de backup le plus récent ---
FICHIER_BACKUP_RECENT=$(find "$DOSSIER_BACKUP" -maxdepth 1 -type f -name "*.sql" -printf "%T@ %p\n" | sort -n | tail -1 | cut -d' ' -f2-)

if [ -z "$FICHIER_BACKUP_RECENT" ]; then
    echo "ERREUR : Aucun fichier .sql trouvé dans le dossier '$DOSSIER_BACKUP'."
    exit 1
fi

echo "Fichier de backup sélectionné : '$FICHIER_BACKUP_RECENT'"
echo "Préparation de la restauration..."

# --- Sauvegarde du fichier original ---
BACKUP_ORIGINAL="${FICHIER_BACKUP_RECENT}.original"
cp "$FICHIER_BACKUP_RECENT" "$BACKUP_ORIGINAL"

if [ $? -ne 0 ]; then
    echo "❌ ERREUR : Impossible de créer une copie de sauvegarde du fichier"
    exit 1
fi

# --- Modification directe du fichier source ---
echo "Remplacement de 'pivotdb' par '$DB_NAME' dans le fichier de backup..."
sed -i "s/pivotdb/$DB_NAME/g" "$FICHIER_BACKUP_RECENT"

if [ $? -ne 0 ]; then
    echo "❌ ERREUR : Échec du traitement du fichier de backup"
    mv "$BACKUP_ORIGINAL" "$FICHIER_BACKUP_RECENT"
    exit 1
fi

# --- Vérification préalable de la base ---
if ! mysql -h"$DB_SERVEUR" -u"$DB_USER" -p"$DB_PASSWORD" -e "USE $DB_NAME" 2>/dev/null; then
    echo "La base $DB_NAME n'existe pas, création..."
    mysql -h"$DB_SERVEUR" -u"$DB_USER" -p"$DB_PASSWORD" -e "CREATE DATABASE $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
fi

# --- Préparation du fichier sans les vues ---
FICHIER_SANS_VUES="/tmp/backup_sans_vues.sql"
echo "Création d'un fichier temporaire sans les vues..."
grep -v "CREATE ALGORITHM=UNDEFINED" "$FICHIER_BACKUP_RECENT" | grep -v "CREATE VIEW" > "$FICHIER_SANS_VUES"

# --- Restauration avec gestion des erreurs ---
echo "Début de la restauration (sans les vues)..."
start_time=$(date +%s)

mysql -h"$DB_SERVEUR" -u"$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" < "$FICHIER_SANS_VUES" 2> >(grep -v "Using a password on the command line")

if [ $? -eq 0 ]; then
    end_time=$(date +%s)
    duration=$((end_time - start_time))
    echo "✅ Restauration réussie en $duration secondes (vues exclues)"
    # Suppression des fichiers temporaires
    rm -f "$BACKUP_ORIGINAL" "$FICHIER_SANS_VUES"
else
    echo "❌ ERREUR : Échec de la restauration"
    # Restauration du fichier original en cas d'échec
    mv "$BACKUP_ORIGINAL" "$FICHIER_BACKUP_RECENT"
    rm -f "$FICHIER_SANS_VUES"
    echo "Problèmes possibles :"
    echo "- Fichier de backup corrompu"
    echo "- Problèmes de permissions"
    echo "- Espace disque insuffisant"
    exit 1
fi

# --- Vérification finale ---
table_count=$(mysql -h"$DB_SERVEUR" -u"$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" -sN -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = '$DB_NAME' AND table_type = 'BASE TABLE'")
view_count=$(mysql -h"$DB_SERVEUR" -u"$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" -sN -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = '$DB_NAME' AND table_type = 'VIEW'")

echo "Résultat de la restauration :"
echo "- Tables restaurées : $table_count"
echo "- Vues non restaurées : $view_count"
echo "Note : Les vues ont été intentionnellement exclues de la restauration"
