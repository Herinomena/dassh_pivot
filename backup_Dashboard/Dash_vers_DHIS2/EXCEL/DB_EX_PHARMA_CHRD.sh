#!/bin/bash

source /home/herinomena/Images/backup_Dashboard/Dash_vers_DHIS2/EXCEL/.env
# Define MySQL credentials using environment variables
MYSQL_OPTS="--defaults-extra-file=<(printf '[client]\nuser=%s\npassword=%s\nhost=%s' \"$MYSQL_USER\" \"$MYSQL_PASSWORD\" \"$MYSQL_HOST\")"
CSV_FILE="/home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/EXCEL/DB_EX_PHARMA_CHRD"


# Define SQL query
SQL_QUERY="SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SELECT
	CASE dbc.name  
			WHEN 'DB_EX_PHARMA_CHRDU_5' THEN 'p92QHqg1nUe'
			WHEN 'DB_EX_PHARMA_CHRDU_4' THEN 'YSje6gNeq9S'
			WHEN 'DB_EX_PHARMA_CHRDU_3' THEN 'XU4XVqeeRPf'
			WHEN 'DB_EX_PHARMA_CHRDU_2' THEN 'XNNou0T3AfB'
			WHEN 'DB_EX_PHARMA_CHRDU_1' THEN 'InJBnd2wunq'
			WHEN 'DB_EX_PHARMA_CHRD_9' THEN 'p3mRjrwMPLt'
			WHEN 'DB_EX_PHARMA_CHRD_8' THEN 'jXfLcjoYZ2n'
			WHEN 'DB_EX_PHARMA_CHRD_7' THEN 'rMnfGvRsOgl'
			WHEN 'DB_EX_PHARMA_CHRD_6' THEN 'xRIAcUjLUrM'
			WHEN 'DB_EX_PHARMA_CHRD_5' THEN 'MlLI5lenQO3'
			WHEN 'DB_EX_PHARMA_CHRD_4' THEN 'OPitfpM0XXy'
			WHEN 'DB_EX_PHARMA_CHRD_3' THEN 'eAzrXjLUESJ'
			WHEN 'DB_EX_PHARMA_CHRD_2' THEN 'CT5396OyGpB'
			WHEN 'DB_EX_PHARMA_CHRD_18' THEN 'zgkBnI32Cxj'
			WHEN 'DB_EX_PHARMA_CHRD_17' THEN 'gOkWyIlnVjf'
			WHEN 'DB_EX_PHARMA_CHRD_16' THEN 'hztHFSw7xcd'
			WHEN 'DB_EX_PHARMA_CHRD_15' THEN 'ZiwgdVYsyB0'
			WHEN 'DB_EX_PHARMA_CHRD_14' THEN 'pyRC7OmRdYH'
			WHEN 'DB_EX_PHARMA_CHRD_13' THEN 'H4vmzotWZLN'
			WHEN 'DB_EX_PHARMA_CHRD_12' THEN 'xwGQS9yfk2r'
			WHEN 'DB_EX_PHARMA_CHRD_11' THEN 'jdISxy0y0vV'
			WHEN 'DB_EX_PHARMA_CHRD_10' THEN 'gsnFDnq3tcQ'
			WHEN 'DB_EX_PHARMA_CHRD_1' THEN 'CVihPTLeCjR'
	 END AS 'dataelement',
 EXTRACT(YEAR_MONTH FROM DATE(dbdb.periode)) AS 'period',
    cc.orgunit AS 'orgunit',
      'HllvX50cXC0' AS 'catoptcombo',
    'HllvX50cXC0' AS 'attroptcombo',
    dbdb.value AS 'value'

FROM
    donnee_brute_donnee_brute AS dbdb
        LEFT JOIN
    donnee_brute_affectation dba ON dba.donnee_brute_id = dbdb.id
        LEFT JOIN
    donnee_brute_type_value AS dbtv ON dbtv.id = dbdb.type_value_id
        LEFT JOIN
    donnee_brute_type AS dbt ON dbt.id = dbdb.type_id
        LEFT JOIN
    donnee_brute_code AS dbc ON dbc.id = dbdb.code_id
        LEFT JOIN
    care_center AS cc ON cc.id = dbdb.carecenter_id
        LEFT JOIN
    site_communautaire AS sc ON sc.care_center_id = cc.id
        LEFT JOIN
    fokontany AS f ON f.id = sc.fokontany_id
        LEFT JOIN
    commune c ON c.id = f.commune_id
        LEFT JOIN
    csb ON csb.id = sc.csb_id
        LEFT JOIN
    district d ON d.id = sc.csb_id
WHERE
    dbc.name IN ('DB_EX_PHARMA_CHRDU_5','DB_EX_PHARMA_CHRDU_4','DB_EX_PHARMA_CHRDU_3','DB_EX_PHARMA_CHRDU_2','DB_EX_PHARMA_CHRDU_1','DB_EX_PHARMA_CHRD_9','DB_EX_PHARMA_CHRD_8','DB_EX_PHARMA_CHRD_7','DB_EX_PHARMA_CHRD_6','DB_EX_PHARMA_CHRD_5','DB_EX_PHARMA_CHRD_4','DB_EX_PHARMA_CHRD_3','DB_EX_PHARMA_CHRD_2','DB_EX_PHARMA_CHRD_18','DB_EX_PHARMA_CHRD_17','DB_EX_PHARMA_CHRD_16','DB_EX_PHARMA_CHRD_15','DB_EX_PHARMA_CHRD_14','DB_EX_PHARMA_CHRD_13','DB_EX_PHARMA_CHRD_12','DB_EX_PHARMA_CHRD_11','DB_EX_PHARMA_CHRD_10','DB_EX_PHARMA_CHRD_1')
    AND EXTRACT(YEAR_MONTH FROM  DATE(dbdb.periode)) >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 10 MONTH), '%Y%m')
    GROUP BY cc.id,EXTRACT(YEAR_MONTH FROM DATE(dbdb.periode)),dbc.id"

# Generate timestamp for output file
TIMESTAMP=$(date +%Y%m%d%H%M%S)

# Execute SQL query and save output to CSV file
eval "mysql $MYSQL_OPTS \"$MYSQL_DATABASE\" -e \"$SQL_QUERY\"" | tail -n +1 | sed 's/\t/","/g;s/^/"/;s/$/"/;' > "${CSV_FILE}_date_$TIMESTAMP.csv"

echo "SQL query executed successfully and output saved to ${CSV_FILE}_date_$TIMESTAMP.csv"


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
