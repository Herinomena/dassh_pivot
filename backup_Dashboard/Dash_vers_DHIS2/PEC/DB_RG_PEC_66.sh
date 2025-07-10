#!/bin/bash

source /home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/PEC/.env
# Define MySQL credentials using environment variables
MYSQL_OPTS="--defaults-extra-file=<(printf '[client]\nuser=%s\npassword=%s\nhost=%s' \"$MYSQL_USER\" \"$MYSQL_PASSWORD\" \"$MYSQL_HOST\")"
CSV_FILE="//home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/PEC/DB_RG_PEC_66"

# Define SQL query
SQL_QUERY="SELECT 
    'Xcpy9NpCvQr' AS 'dataelement',
    EXTRACT(YEAR_MONTH FROM DATE(rpe.date)) AS 'period',
    cc.orgunit AS 'orgunit',
     'HllvX50cXC0' AS 'catoptcombo',
    'HllvX50cXC0' AS 'attroptcombo',
    COUNT(rpr.id) AS 'value'
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
        AND rpe.date IS NOT NULL
        and rpe.is_refered = 1
        and rpr.type_evasan = 1
        and rpmt.id = 1
        and rpr.is_traitement_ambulance = 1
        AND EXTRACT(YEAR_MONTH FROM DATE(rpe.date)) >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 4 MONTH), '%Y%m')
GROUP BY cc.id , EXTRACT(YEAR_MONTH FROM DATE(rpe.date)) 
;"

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
