#!/bin/bash

source /home/herinomena/Images/backup_Dashboard/Dash_vers_DHIS2/TB/.env
# Define MySQL credentials using environment variables
MYSQL_OPTS="--defaults-extra-file=<(printf '[client]\nuser=%s\npassword=%s\nhost=%s' \"$MYSQL_USER\" \"$MYSQL_PASSWORD\" \"$MYSQL_HOST\")"
CSV_FILE="/home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/TB/DB_RG_TB_30"

# Define SQL query
SQL_QUERY="SELECT 
    'WJPrRbKCTz2' AS 'dataelement',
       EXTRACT(YEAR_MONTH FROM rtc.date) AS 'period',
    cc.orgunit AS 'orgunit',
    'HllvX50cXC0' AS 'catoptcombo',
    'HllvX50cXC0' AS 'attroptcombo',
    COUNT(rtcs.id) AS 'value'
FROM
    register AS r
        LEFT JOIN
    register_tuberculosis_entry AS rte ON r.id = rte.register_id
        LEFT JOIN
    register_tuberculosis_controles rtcs ON rtcs.register_id = r.id
        LEFT JOIN
    register_tuberculosis_controle rtc ON rtc.id = rtcs.controle_id
        LEFT JOIN
    register_tuberculosis_diagnostic_result AS rtdr ON rtdr.id = rte.diagnostic_result_id
        LEFT JOIN
    register_tuberculosis_admission_mode AS rtam ON rtam.id = rte.admission_mode_id
        LEFT JOIN
    register_tuberculosis_regim_treatement AS rtrt ON rtrt.id = rte.regim_treatement_id
        LEFT JOIN
    register_tuberculosis_tuberculosis_form AS rttf ON rte.tuberculosis_form_id = rttf.id
        LEFT JOIN
    register_tuberculosis_exit AS rts ON rts.register_id = r.id
        LEFT JOIN
    register_tuberculosis_exit_mode AS rtem ON rts.exit_mode_id = rtem.id
        LEFT JOIN
    care_center_projet ccp ON ccp.id = r.care_center_projet_id
        LEFT JOIN
    projet pr ON pr.id = ccp.projet_id
        LEFT JOIN
    care_center cc ON cc.id = ccp.care_center_id
        LEFT JOIN
    patient p ON p.id = r.patient_id
        LEFT JOIN
    fokontany f ON f.id = p.fokontany_id
WHERE
    rtc.date IS NOT NULL
        AND cc.id IS NOT NULl
        AND EXTRACT(YEAR_MONTH FROM  rtc.date) >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 4 MONTH), '%Y%m')
GROUP BY cc.id,EXTRACT(YEAR_MONTH FROM rtc.date)"

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
