#!/bin/bash
source /home/herinomena/Images/backup_Dashboard/Dash_vers_DHIS2/EXCEL/.env
# Define MySQL credentials using environment variables
MYSQL_OPTS="--defaults-extra-file=<(printf '[client]\nuser=%s\npassword=%s\nhost=%s' \"$MYSQL_USER\" \"$MYSQL_PASSWORD\" \"$MYSQL_HOST\")"
CSV_FILE="/home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/EXCEL/DB_EX_MNT"


# Define SQL query
SQL_QUERY="SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SELECT  
  CASE dbc.name                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
		WHEN 'DB_EX_MNT_HTA_CHRD_GI_1' THEN 'b1gr9Zixe9l'
        WHEN 'DB_EX_MNT_HTA_CHRD_GI_2' THEN 'c5VVBNz0wye'
        WHEN 'DB_EX_MNT_HTA_CHRD_GI_3' THEN 'hau81QLhowY'
        WHEN 'DB_EX_MNT_HTA_CHRD_GI_4' THEN 'Mm7pE1hNke7'
		WHEN 'DB_EX_MNT_HTA_CSB_GI_7'  THEN 'IfwlB1oWTzo'
        WHEN 'DB_EX_MNT_HTA_CSB_GI_8'  THEN 'P3zfYWJanTi'
        WHEN 'DB_EX_MNT_DBT_CHRD_GI_1' THEN 'eYoFF08NBvG'
		WHEN 'DB_EX_MNT_DBT_CHRD_GI_2' THEN 'OibsA1gX0QV'
		WHEN 'DB_EX_MNT_DBT_CHRD_GI_3' THEN 'CcTcpgYahPp'
		WHEN 'DB_EX_MNT_DBT_CHRD_GI_4' THEN 'iiVq5h0ntrz'
		WHEN 'DB_EX_MNT_DBT_GI_1' 		THEN 'WTLzVZzlRRo'
		WHEN 'DB_EX_MNT_DBT_GI_2' 		THEN 'Vr97XLsdcYg'
		WHEN 'DB_EX_MNT_DBT_GI_3' 		THEN 'bcnXA1PHIck'
		WHEN 'DB_EX_MNT_DBT_GI_4' 		THEN 'nSkpg2ovMWu'
		WHEN 'DB_EX_MNT_DBT_GI_5' 		THEN 'Rcjptuse1nc'
		WHEN 'DB_EX_MNT_DBT_GI_6' 		THEN 'G3c0Bg7fdb4'
		WHEN 'DB_EX_MNT_HTA_CSB_GI_1' 	THEN 'N2xfte5rugj'
		WHEN 'DB_EX_MNT_HTA_CSB_GI_2' 	THEN 'Dms9wCv6SOW'
		WHEN 'DB_EX_MNT_HTA_CSB_GI_3' 	THEN 'ZDDImK4r0lK'
		WHEN 'DB_EX_MNT_HTA_CSB_GI_4' 	THEN 'FvIHyUcDyxi'
		WHEN 'DB_EX_MNT_HTA_CSB_GI_5' 	THEN 'c06Ae7xR7IN'
		WHEN 'DB_EX_MNT_HTA_CSB_GI_6' 	THEN 'VTTazlSH50x'
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
    dbc.name IN ('DB_EX_MNT_HTA_CHRD_GI_1','DB_EX_MNT_HTA_CHRD_GI_2','DB_EX_MNT_HTA_CHRD_GI_3','DB_EX_MNT_HTA_CHRD_GI_4','DB_EX_MNT_HTA_CHRD_GI_7','DB_EX_MNT_HTA_CHRD_GI_8','DB_EX_MNT_DBT_CHRD_GI_1','DB_EX_MNT_DBT_CHRD_GI_2','DB_EX_MNT_DBT_CHRD_GI_3','DB_EX_MNT_DBT_CHRD_GI_4','DB_EX_MNT_DBT_GI_1','DB_EX_MNT_DBT_GI_2','DB_EX_MNT_DBT_GI_3','DB_EX_MNT_DBT_GI_4','DB_EX_MNT_DBT_GI_5','DB_EX_MNT_DBT_GI_6','DB_EX_MNT_HTA_CSB_GI_1','DB_EX_MNT_HTA_CSB_GI_2','DB_EX_MNT_HTA_CSB_GI_3','DB_EX_MNT_HTA_CSB_GI_4','DB_EX_MNT_HTA_CSB_GI_5','DB_EX_MNT_HTA_CSB_GI_6') 
    AND EXTRACT(YEAR_MONTH FROM  DATE(dbdb.periode)) >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 20 MONTH), '%Y%m')
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
