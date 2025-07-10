#!/bin/bash

source /home/herinomena//Images/backup_Dashboard/Dash_vers_DHIS2/MALNUT/.env
# Define MySQL credentials using environment variables
MYSQL_OPTS="--defaults-extra-file=<(printf '[client]\nuser=%s\npassword=%s\nhost=%s' \"$MYSQL_USER\" \"$MYSQL_PASSWORD\" \"$MYSQL_HOST\")"
CSV_FILE="/home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/MALNUT/Admission/DB_RG_CRENI_22"

# Define SQL query
SQL_QUERY="SELECT 
	'HRrmLjFxO7J' AS 'dataelement',
    EXTRACT(YEAR_MONTH FROM rme.date) AS 'period',
  	cc.orgunit AS 'orgunit',
	'HllvX50cXC0' AS 'catoptcombo',
    'HllvX50cXC0' AS 'attroptcombo',
   sum(datediff( rms.date,rme.date))AS 'value'
FROM
    register r
        LEFT JOIN
    register_malnutrition_entry rme ON rme.register_id = r.id
        LEFT JOIN
    care_center_projet ccp ON ccp.id = r.care_center_projet_id
        LEFT JOIN
    projet pr ON pr.id = ccp.projet_id
        LEFT JOIN
    care_center cc ON cc.id = ccp.care_center_id
        LEFT JOIN
    register_malnutrition_admission_mode rmam ON rmam.id = rme.admission_mode_id
        LEFT JOIN
    register_malnutrition_critere_admission rmca ON rmca.id = rme.critere_admission_id
        LEFT JOIN
    register_malnutrition_imc rmi ON rme.imc_id = rmi.id
        LEFT JOIN
    register_malnutrition_exit rms ON r.id = rms.register_id
    LEFT JOIN 
    register_malnutrition_exit_mode rmem on rms.exit_mode_id=rmem.id
        LEFT JOIN
    patient p ON r.patient_id = p.id
        LEFT JOIN
    fokontany f ON f.id = p.fokontany_id
WHERE
     ((p.age_unity = 1) AND (p.age >= 6 AND p.age <= 59)) and
     rmam.id=3 and
		rmem.id=9 and
         rme.date IS NOT NULL and
           rms.date IS NOT NULL
AND rmca.id IS NOT NULL
 AND rmam.id IS NOT NULL
  AND EXTRACT(YEAR_MONTH FROM  rme.date) >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 4 MONTH), '%Y%m')
GROUP BY cc.id,EXTRACT(YEAR_MONTH FROM rme.date)";

# Generate timestamp for output file
TIMESTAMP=$(date +%Y%m%d%H%M%S)

# Execute SQL query and save output to CSV file
eval "mysql $MYSQL_OPTS \"$MYSQL_DATABASE\" -e \"$SQL_QUERY\"" | tail -n +1 | sed 's/\t/","/g;s/^/"/;s/$/"/;' > "${CSV_FILE}_date_$TIMESTAMP.csv"

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
