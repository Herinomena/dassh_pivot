#!/bin/bash

source /home/herinomena//Images/backup_Dashboard/Dash_vers_DHIS2/MALNUT/.env
# Define MySQL credentials using environment variables
MYSQL_OPTS="--defaults-extra-file=<(printf '[client]\nuser=%s\npassword=%s\nhost=%s' \"$MYSQL_USER\" \"$MYSQL_PASSWORD\" \"$MYSQL_HOST\")"
CSV_FILE="/home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/MALNUT/Admission/AdmissionCrenasCreni2a5ans"

# Define SQL query
SQL_QUERY="SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SELECT 
  if (cc.id= 1,'rL0jtzGzc9x','LzGYqN4fBGN') AS 'dataelement',
    EXTRACT(YEAR_MONTH FROM rme.date) AS 'period',
    cc.orgunit AS 'orgunit',
    
    case rmam.id
	when 1 then 
    (CASE rmca.id	
		when 1 then 'SJjtbBPXEU8'
		when 3 then 'BHwwsHAgzya'
		when 5 then 'E2To0wYV6kS'
        when 7 then 'xmpOi7JupIF'
        when 9 then 'O83P0XMnk9M'
        END )
    
	when 3 then  
    (CASE rmca.id	
		when 1 then 'RZdMbM81pjU'
		when 3 then 'fNIdpXvB94x'
		when 5 then 'Gm3ypat7ldX'
        when 7 then 'R7bzrOHEpSE'
        when 9 then 'i107q0xwZx2'
        END )
	when 5 then 
    (CASE rmca.id	
		when 1 then 'RFti2RxXB8o'
		when 3 then 'zYLbYenh7QY'
		when 5 then 'q1Nii1h9jVi'
        when 7 then 'dOR63GGSQxe'
        when 9 then 'pEfYjODfQ0b'
        END )
    when 7 then 
    (CASE rmca.id	
		when 1 then 'qSeXXOJ4fFd'
		when 3 then 'hUcIs3vVgN3'
		when 5 then 'yWHnqKE8IPK'
        when 7 then 'K44WsBOkdPe'
        when 9 then 'pMxQDRuCqAw'
        END )
	when 9 then 
    (CASE rmca.id	
		when 1 then 'vMCym99yh2z'
		when 3 then 'ok0Y8Jm9bbn'
		when 5 then 'Gw81U2vHX7N'
        when 7 then 'nvgAB65MBJa'
        when 9 then 'F6xHqZNPpI6'
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
    Where
   ((p.age_unity = 1) AND (p.age >= 25 AND p.age <=59))  and rme.date is not null and rmca.id is not null and rmam.id is not null 
    AND EXTRACT(YEAR_MONTH FROM  rme.date) >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 4 MONTH), '%Y%m')
group by cc.id, EXTRACT(YEAR_MONTH FROM rme.date)"

# Generate timestamp for output file
TIMESTAMP=$(date +%Y%m%d%H%M%S)

# Execute SQL query and save output to CSV file
eval "mysql $MYSQL_OPTS \"$MYSQL_DATABASE\" -e \"$SQL_QUERY\"" | tail -n +1 | sed 's/\t/","/g;s/^/"/;s/$/"/;' > "${CSV_FILE}_date_$TIMESTAMP.csv"

echo "SQL query executed successfully and output saved to ${CSV_FILE}_date_$TIMESTAMP.csv"
#

# Send POST request to DHIS2 endpoint with CSV file as payload and capture response to log file
curl -X POST -H "Content-Type: application/csv" -u "${DHIS2_USERNAME}:${DHIS2_PASSWORD}" --data-binary "@${CSV_FILE}_date_$TIMESTAMP.csv" "${DHIS2_URL}" > "${CSV_FILE}_date_$TIMESTAMP.log" 2>&1

# Check if request was successful or not
if [ $? -eq 0 ]; then
  echo "CSV file uploaded successfully to DHIS2 endpoint: ${DHIS2_URL}"
  echo "Response written to log file: ${CSV_FILE}_date_$TIMESTAMP.log"
else
  echo "Failed to upload CSV file to DHIS2 endpoint. Check log file for details: ${CSV_FILE}_date_$TIMESTAMP.log"
fi
