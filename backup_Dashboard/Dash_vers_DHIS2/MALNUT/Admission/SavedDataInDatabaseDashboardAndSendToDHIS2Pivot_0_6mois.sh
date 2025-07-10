#!/bin/bash

source /home/herinomena//Images/backup_Dashboard/Dash_vers_DHIS2/MALNUT/.env
# Define MySQL credentials using environment variables
MYSQL_OPTS="--defaults-extra-file=<(printf '[client]\nuser=%s\npassword=%s\nhost=%s' \"$MYSQL_USER\" \"$MYSQL_PASSWORD\" \"$MYSQL_HOST\")"
CSV_FILE="/home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/MALNUT/Admission/AdmissionCrenasCreni0a6mois.csv"

# Define SQL query
SQL_QUERY="SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SELECT 
  if (cc.id= 1,'rL0jtzGzc9x','LzGYqN4fBGN') AS 'dataelement',
    EXTRACT(YEAR_MONTH FROM rme.date) AS 'period',
    cc.orgunit AS 'orgunit',
    
    case rmam.id
	when 1 then 
    (CASE rmca.id	
		when 1 then 'nZQd0EH1rNN'
		when 3 then 'c7XTOybF7LB'
		when 5 then 'fN7PCngbZf9'
        when 7 then 'swhw584IK9V'
        when 9 then 'hvJVLdvhZOg'
        END )
    
	when 3 then  
    (CASE rmca.id	
		when 1 then 'HqBcfexdI1Q'
		when 3 then 'yhzT9ehnKf4'
		when 5 then 'WHiHSISOOxY'
        when 7 then 'd9LeqLEQHi9'
        when 9 then 'wzf6ACbvIF8'
        END )
	when 5 then 
    (CASE rmca.id	
		when 1 then 'U8wlQsvHarX'
		when 3 then 'wF8CADMFj7r'
		when 5 then 'UNqsE65kcqL'
        when 7 then 'iVNLKDxptjG'
        when 9 then 'hkv2mXyGox4'
        END )
    when 7 then 
    (CASE rmca.id	
		when 1 then 'rZwTTnPzZTe'
		when 3 then 'AGsJwFv75TW'
		when 5 then 'cGf74ZsJT90'
        when 7 then 'pnEITNl6vfL'
        when 9 then 'HJtyDOmL9Ls'
        END )
	when 9 then 
    (CASE rmca.id	
		when 1 then 'BUwaUfNRuG0'
		when 3 then 'UXUykk5haUM'
		when 5 then 'LqISP2TgPFG'
        when 7 then 'i2Bxthivzy1'
        when 9 then 'caFy7pJB863'
        END )
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
    patient p ON r.patient_id = p.id
        LEFT JOIN
    fokontany f ON f.id = p.fokontany_id
    where (p.age_unity = 1) and (p.age >= 0 AND p.age <= 5) and rme.date is not null and rmca.id is not null and rmam.id is not null
     AND EXTRACT(YEAR_MONTH FROM  rme.date) >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 4 MONTH), '%Y%m')
group by cc.id, EXTRACT(YEAR_MONTH FROM rme.date)"

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
