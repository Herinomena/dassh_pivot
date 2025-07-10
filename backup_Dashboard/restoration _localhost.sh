#!/bin/bash

# --- Paramètres ---
DB_SERVEUR="localhost"
DB_USER="root"
DB_PASS="Her!nomen@_11"
DB_NAME="base_pvt_locale"
# On définit maintenant le RÉPERTOIRE des sauvegardes, pas un fichier spécifique
BACKUP_DIR="/home/herinomena/Images/backup_Dashboard"

# --- AVERTISSEMENT DE SÉCURITÉ ---
# Stocker un mot de passe en clair dans un script est un risque de sécurité.

# --- Recherche dynamique du dernier fichier de sauvegarde ---
echo "Recherche du dernier fichier de sauvegarde dans le répertoire : $BACKUP_DIR"

# ls -1t: Liste les fichiers par date de modification (le plus récent en premier), un par ligne.
# *.sql: Ne prend en compte que les fichiers se terminant par .sql.
# head -n 1: Ne garde que la première ligne du résultat.
# Le chemin complet du fichier est stocké dans la variable CHEMIN_BACKUP.
CHEMIN_BACKUP=$(ls -1t "$BACKUP_DIR"/*.sql | head -n 1)

# --- Vérification de sécurité ---
# On s'assure qu'un fichier a bien été trouvé avant de continuer.
if [ -z "$CHEMIN_BACKUP" ]; then
    echo "Erreur : Aucun fichier de sauvegarde (.sql) n'a été trouvé dans $BACKUP_DIR"
    exit 1
fi

echo "Le fichier le plus récent est : $CHEMIN_BACKUP"
echo "Début de la restauration de la base de données '$DB_NAME'..."

# Utilisation de --password="$DB_PASS" pour passer le mot de passe de manière sécurisée (pour les caractères spéciaux)
mysql -h"$DB_SERVEUR" -u"$DB_USER" --password="$DB_PASS" "$DB_NAME" < "$CHEMIN_BACKUP"

echo "Restauration terminée."
