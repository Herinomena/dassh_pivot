DB_SERVEUR="217.70.190.209"
DB_USER="mysqlwb"
DB_PASS="Pivot**15"
DB_NAME="pivotdb"  # Échappement des caractères spéciaux
BACKUP_DIR="/home/herinomena/Images/backup_Dashboard"
DATE=$(date +%Y%m%d_%H%M%S)

# Commandes de sauvegarde
mysqldump -h$DB_SERVEUR -u$DB_USER -p$DB_PASS --databases "$DB_NAME" > "$BACKUP_DIR/backup_$DATE.sql" 2> "$BACKUP_DIR/backup_error.log"

# Vérification du succès
if [ $? -eq 0 ]; then
    echo "Sauvegarde réussie"
    exit 0
else
    echo "Échec de la sauvegarde - voir backup_error.log"
    exit 1
fi
