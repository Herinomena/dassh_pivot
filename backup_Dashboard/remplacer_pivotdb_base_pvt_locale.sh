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
echo "Restauration de la base de données '$DB_NAME'..."

# --- Vérification préalable de la base ---
if ! mysql -h"$DB_SERVEUR" -u"$DB_USER" -p"$DB_PASSWORD" -e "USE $DB_NAME" 2>/dev/null; then
    echo "La base $DB_NAME n'existe pas, création..."
    mysql -h"$DB_SERVEUR" -u"$DB_USER" -p"$DB_PASSWORD" -e "CREATE DATABASE $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
fi

# --- Restauration avec gestion des erreurs ---
echo "Début de la restauration..."
start_time=$(date +%s)

mysql -h"$DB_SERVEUR" -u"$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" < "$FICHIER_BACKUP_RECENT" 2> >(grep -v "Using a password on the command line")

if [ $? -eq 0 ]; then
    end_time=$(date +%s)
    duration=$((end_time - start_time))
    echo "✅ Restauration réussie en $duration secondes"
else
    echo "❌ ERREUR : Échec de la restauration"
    echo "Problèmes possibles :"
    echo "- Fichier de backup corrompu"
    echo "- Problèmes de permissions"
    echo "- Espace disque insuffisant"
    exit 1
fi

# --- Vérification finale ---
table_count=$(mysql -h"$DB_SERVEUR" -u"$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" -sN -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = '$DB_NAME'")
echo "Base restaurée avec $table_count tables"
