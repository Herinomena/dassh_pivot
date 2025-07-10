#!/bin/bash

source /home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/PEC/.env
# Define MySQL credentials using environment variables
MYSQL_OPTS="--defaults-extra-file=<(printf '[client]\nuser=%s\npassword=%s\nhost=%s' \"$MYSQL_USER\" \"$MYSQL_PASSWORD\" \"$MYSQL_HOST\")"
CSV_FILE="/home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/PEC/DB_RG_PEC_11"

# Define SQL query
SQL_QUERY="SELECT 
    'eAVTO2ETpOT' AS 'dataelement',
    EXTRACT(YEAR_MONTH FROM DATE(rps.date)) AS 'period',
    cc.orgunit AS 'orgunit',
    CASE rpts.id
		WHEN 19 THEN 'NXwGfSxPU6o'
        WHEN 17 THEN 'c7DXo3NbBgO'
        WHEN 15 THEN 'zeOYlZXF0PI'
        WHEN 13 THEN 'CoMIs1A5t3T'
        WHEN 11 THEN 'kt9BuTrlkOY'
        WHEN 7 THEN 'WSvdhjDIAZj'
        WHEN 3 THEN 'LlfaUIccuYt'
        WHEN 1 THEN 'jGourScnJH5'
        WHEN 5 THEN 'COwruh8MCLf'
        WHEN 9 THEN 'SdN8xpffrAw'
    END AS 'catoptcombo',
    rpts.name,
    'HllvX50cXC0' AS 'attroptcombo',
    COUNT(rpe.id) AS 'value'
FROM
    register AS r
        LEFT JOIN
    patient AS p ON p.id = r.patient_id
        LEFT JOIN
    fokontany AS f ON p.fokontany_id = f.id
        LEFT JOIN
    commune AS c ON f.commune_id = c.id
        LEFT JOIN
    register_pec_entry AS rpe ON rpe.register_id = r.id
        LEFT JOIN
    register_pec_sortie AS rps ON rps.register_id = r.id
        LEFT JOIN
    register_pec_type_sortie AS rpts ON rpts.id = rps.type_sortie_id
        LEFT JOIN
    register_pec_service AS rpse ON rpse.id = rpe.service_id
        LEFT JOIN
    register_pec_statut AS rpst ON rpst.id = rpe.statut_id
        LEFT JOIN
    care_center_projet AS ccp ON r.care_center_projet_id = ccp.id
        LEFT JOIN
    care_center AS cc ON ccp.care_center_id = cc.id
        LEFT JOIN
    chrd AS ch ON ch.care_center_id = cc.id
        LEFT JOIN
    projet AS pr ON ccp.projet_id = pr.id
        LEFT JOIN
    program AS pg ON pg.id = pr.program_id
        LEFT JOIN
    district AS d ON d.id = ch.district_id
        LEFT JOIN
    register_pec_reference AS rpr ON rpr.entry_id = rpe.id
        LEFT JOIN
    care_center AS ccr ON rpr.care_center_transferant_id = ccr.id
        LEFT JOIN
    register_pec_moyen_transport AS rpmt ON rpmt.id = rpr.moyen_transport_id
WHERE
    pr.id IN (137 , 187)
        AND rps.date IS NOT NULL
        AND rpst.id = 3
        AND rpts.id IS NOT NULL
        AND EXTRACT(YEAR_MONTH FROM DATE(rps.date)) >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 4 MONTH), '%Y%m')
GROUP BY cc.id , EXTRACT(YEAR_MONTH FROM DATE(rps.date)) , rpts.id
;"

# Generate timestamp for output file
TIMESTAMP=$(date +%Y%m%d%H%M%S)

# Execute SQL query and save output to CSV file
eval "mysql $MYSQL_OPTS \"$MYSQL_DATABASE\" -e \"$SQL_QUERY\"" | tail -n +1 | sed 's/\t/","/g;s/^/"/;s/$/"/;' > "${CSV_FILE}

echo "SQL query executed successfully and output saved to ${CSV_FILE}_date_$TIMESTAMP.csv"
#!/bin/bash

# SEND DATA TO DHIS2 INSTANCE PIVOT 

# Define DHIS2 endpoint URL
DHIS2_URL="https://www.dhis2-pivot.org/prod/api/dataValueSets"

# Define DHIS2 username and password
DHIS2_USERNAME="lrakotovoavy"
DHIS2_PASSWORD="Wx12\"'(-"

# Define path to CSV file
# CSV_FILE="/home/lrakotovoavy/PIVOT/Travail_PIVOT/DEV/DHIS/Migration/initMigration/AdmissionCrenasCreni06_20230419151722.csv"

# Send POST request to DHIS2 endpoint with CSV file as payload and capture response to log file
curl -X POST -H "Content-Type: application/csv" -u "${DHIS2_USERNAME}:${DHIS2_PASSWORD}" --data-binary "@${CSV_FILE}_date_$TIMESTAMP.csv" "${DHIS2_URL}" > "${CSV_FILE}_date_$TIMESTAMP.log" 2>&1

# Check if request was successful or not
if [ $? -eq 0 ]; then
  echo "CSV file uploaded successfully to DHIS2 endpoint: ${DHIS2_URL}"
  echo "Response written to log file: ${CSV_FILE}_date_$TIMESTAMP.log"
else
  echo "Failed to upload CSV file to DHIS2 endpoint. Check log file for details: ${CSV_FILE}_date_$TIMESTAMP.log"
fi
