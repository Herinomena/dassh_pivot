#!/bin/bash

source /home/herinomena//Images/backup_Dashboard/Dash_vers_DHIS2/MALNUT/.env
# Define MySQL credentials using environment variables
MYSQL_OPTS="--defaults-extra-file=<(printf '[client]\nuser=%s\npassword=%s\nhost=%s' \"$MYSQL_USER\" \"$MYSQL_PASSWORD\" \"$MYSQL_HOST\")"
CSV_FILE="/home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/MALNUT/Sortie/SortieCrenasCrenisupa5ans"

# Define SQL query
SQL_QUERY="SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SELECT 
   if (cc.id= 1,'edCktR1uhwP','DQo3BjJX5kj') AS 'dataelement',
    EXTRACT(YEAR_MONTH FROM rms.date) AS 'period',
    cc.orgunit AS 'orgunit',
    case rmem.id
	when 3 then 'BpzWtciyF3X'
	when 133 then 'ZnQVyTYzWtN' 
	when 5 then 'bJHWH1dfjEN'   
    when 1 then 'H3S4fJqoM8o'   
	when 11 then 'co58Llsxtp1'
    when 9 then 'wn3ePZFZJix'
    when 7 then 'BbDIIAQFiXS'
    END
     AS 'catoptcombo',
    'HllvX50cXC0' AS 'attroptcombo',
    COUNT(r.id) AS 'value'
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
    register_malnutrition_exit_mode rmem ON rms.exit_mode_id = rmem.id
        LEFT JOIN
    patient p ON r.patient_id = p.id
        LEFT JOIN
    fokontany f ON f.id = p.fokontany_id
    where pr.id in(151,153) and rmem.id is not null and
    ((p.age_unity = 1 AND p.age > 59) OR (p.age_unity = 2 AND p.age > 5))
    AND EXTRACT(YEAR_MONTH FROM  rms.date) >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 4 MONTH), '%Y%m')
group by cc.id,YEAR(rms.date),month(rms.date),rmem.id"

# Generate timestamp for output file
TIMESTAMP=$(date +%Y%m%d%H%M%S)

# Execute SQL query and save output to CSV file
mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -h "$MYSQL_HOST" "$MYSQL_DATABASE" -e "$SQL_QUERY" | tail -n +1 | sed 's/\t/","/g;s/^/"/;s/$/"/;' > "${CSV_FILE}_date_$TIMESTAMP.csv"

echo "SQL query executed successfully and output saved to ${CSV_FILE}_date_$TIMESTAMP.csv"
# Execute SQL query and save output to CSV file
eval "mysql $MYSQL_OPTS \"$MYSQL_DATABASE\" -e \"$SQL_QUERY\"" | tail -n +1 | sed 's/\t/","/g;s/^/"/;s/$/"/;' > "${CSV_FILE}_date_$TIMESTAMP.csv"

# Send POST request to DHIS2 endpoint with CSV file as payload and capture response to log file
curl -X POST -H "Content-Type: application/csv" -u "${DHIS2_USERNAME}:${DHIS2_PASSWORD}" --data-binary "@${CSV_FILE}_date_$TIMESTAMP.csv" "${DHIS2_URL}" > "${CSV_FILE}_date_$TIMESTAMP.log" 2>&1

# Check if request was successful or not
if [ $? -eq 0 ]; then
  echo "CSV file uploaded successfully to DHIS2 endpoint: ${DHIS2_URL}"
  echo "Response written to log file: ${CSV_FILE}_date_$TIMESTAMP.log"
else
  echo "Failed to upload CSV file to DHIS2 endpoint. Check log file for details: ${CSV_FILE}_date_$TIMESTAMP.log"
fi
