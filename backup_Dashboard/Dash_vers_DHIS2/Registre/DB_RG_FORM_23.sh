#!/bin/bash

source /home/herinomena/Images/backup_Dashboard/Dash_vers_DHIS2/Registre/.env
# Define MySQL credentials using environment variables
MYSQL_OPTS="--defaults-extra-file=<(printf '[client]\nuser=%s\npassword=%s\nhost=%s' \"$MYSQL_USER\" \"$MYSQL_PASSWORD\" \"$MYSQL_HOST\")"
CSV_FILE="/home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/Registre/DB_FORM_RH_23"

# Define SQL query
SQL_QUERY="SELECT 
    'DVQ5ILOlENs' as 'dataelement',
    EXTRACT(YEAR_MONTH FROM DATE(acc.date_debut)) AS 'period',
    cc.orgunit as 'orgunit',
    CASE p.genre
        WHEN 1 THEN 'JhOfA5uF8C6'
        WHEN 2 THEN 'x0CDRytLSu4'
    END AS 'catoptcombo',
    'HllvX50cXC0' AS 'attroptcombo',
    count(acc.id) as 'value'
FROM
    affectation_care_center acc
        LEFT JOIN
    personne p ON acc.personne_id = p.id
        LEFT JOIN
    affectation_specialite asp ON acc.affectation_specialite_id = asp.id
    left join
	care_center cc on acc.care_center_id = cc.id
WHERE
    asp.name = 'AC'
    and acc.date_fin is null
Group by
	cc.id, acc.date_debut, acc.id"

# Generate timestamp for output file
TIMESTAMP=$(date +%Y%m%d%H%M%S)

# Execute SQL query and save output to CSV file
eval "mysql $MYSQL_OPTS \"$MYSQL_DATABASE\" -e \"$SQL_QUERY\"" | tail -n +1 | sed 's/\t/","/g;s/^/"/;s/$/"/;' > "${CSV_FILE}_date_$TIMESTAMP.csv"

echo "SQL query executed successfully and output saved to ${CSV_FILE}_date_$TIMESTAMP.csv"


# Send POST request to DHIS2 endpoint with CSV file as payload and capture response to log file
curl -X POST -H "Content-Type: application/csv" -u "${DHIS2_USERNAME}:${DHIS2_PASSWORD}" --data-binary "@${CSV_FILE}_date_$TIMESTAMP.csv" "${DHIS2_URL}" > "${CSV_FILE}_date_$TIMESTAMP.log" 2>&1

# Check if request was successful or not
if [ $? -eq 0 ]; then
  echo "CSV file uploaded successfully to DHIS2 endpoint: ${DHIS2_URL}"
  echo "Response written to log file: ${CSV_FILE}_date_$TIMESTAMP.log"
else
  echo "Failed to upload CSV file to DHIS2 endpoint. Check log file for details: ${CSV_FILE}_date_$TIMESTAMP.log"
fi
