#!/bin/bash

# --- Configuration ---
BACKUP_DIR="/home/herinomena/Images/backup_Dashboard"
DB_NAME="base_pvt_locale"
OLD_DB_NAME="pivotdb"

# --- Trouver le fichier de backup le plus récent ---
latest_backup=$(find "$BACKUP_DIR" -maxdepth 1 -type f -name "*.sql" -printf "%T@ %p\n" | sort -nr | head -1 | cut -d' ' -f2-)

if [ -z "$latest_backup" ]; then
    echo "Aucun fichier de backup (.sql) trouvé dans $BACKUP_DIR"
    exit 1
fi

echo "Fichier de backup le plus récent trouvé : $latest_backup"

# --- Créer une copie de sauvegarde du fichier original ---
backup_copy="${latest_backup}.original"
if [ ! -f "$backup_copy" ]; then
    cp "$latest_backup" "$backup_copy"
    echo "Copie de sauvegarde créée : $backup_copy"
else
    echo "Une copie de sauvegarde existe déjà : $backup_copy"
fi

# --- Remplacer pivotdb par base_pvt_locale ---
echo "Remplacement de '$OLD_DB_NAME' par '$DB_NAME' dans le fichier..."
temp_file="${latest_backup}.modified"

# Utilisation de sed pour le remplacement en tenant compte des différents formats possibles
sed -e "s/\`${OLD_DB_NAME}\`/\`${DB_NAME}\`/g" \
    -e "s/${OLD_DB_NAME}\./${DB_NAME}\./g" \
    -e "s/USE \`${OLD_DB_NAME}\`/USE \`${DB_NAME}\`/g" \
    -e "s/DATABASE \`${OLD_DB_NAME}\`/DATABASE \`${DB_NAME}\`/g" \
    "$latest_backup" > "$temp_file"

# Vérifier si le remplacement a fonctionné
replace_count=$(grep -c "$OLD_DB_NAME" "$temp_file")
if [ "$replace_count" -gt 0 ]; then
    echo "Attention : Il reste $replace_count occurrences de '$OLD_DB_NAME' non remplacées"
else
    echo "Toutes les occurrences de '$OLD_DB_NAME' ont été remplacées par '$DB_NAME'"
fi

# --- Remplacer le fichier original par la version modifiée ---
mv "$temp_file" "$latest_backup"
echo "Fichier original mis à jour : $latest_backup"

# --- Vérification finale ---
final_check=$(grep -c "$DB_NAME" "$latest_backup")
echo "Le fichier contient maintenant $final_check occurrences de '$DB_NAME'"

echo "Opération terminée avec succès!"