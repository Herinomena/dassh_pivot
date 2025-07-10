#!/bin/bash
source /home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/PEC/.env
# Define MySQL credentials using environment variables
MYSQL_OPTS="--defaults-extra-file=<(printf '[client]\nuser=%s\npassword=%s\nhost=%s' \"$MYSQL_USER\" \"$MYSQL_PASSWORD\" \"$MYSQL_HOST\")"
CSV_FILE="/home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/PEC/DB_RG_PEC_67"

# Define SQL query
SQL_QUERY="SELECT 
    'sJeL5aH05uE' AS 'dataelement',
    EXTRACT(YEAR_MONTH FROM DATE(r.date_creation)) AS 'period',
    cc.orgunit AS 'orgunit',
    'HllvX50cXC0' AS 'catoptcombo',
    'HllvX50cXC0' AS 'attroptcombo',
    COUNT(rpder.id) AS 'value'
FROM
    register_pec_reference AS rpr
        LEFT JOIN
    register_pec_deces_en_route AS rpder ON rpder.id = rpr.deces_route_id
        LEFT JOIN
    register AS r ON rpder.register_id = r.id
        LEFT JOIN
    patient AS p ON p.id = r.patient_id
        LEFT JOIN
    register_pec_entry AS rpe ON rpe.register_id = r.id
        LEFT JOIN
    care_center_projet AS ccp ON ccp.id = r.care_center_projet_id
        LEFT JOIN
    care_center AS cc ON cc.id = ccp.care_center_id
WHERE
    rpr.deces_en_route = 1
    AND EXTRACT(YEAR_MONTH FROM DATE(r.date_creation)) >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 4 MONTH), '%Y%m')
GROUP BY cc.id , EXTRACT(YEAR_MONTH FROM DATE(r.date_creation));"

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
