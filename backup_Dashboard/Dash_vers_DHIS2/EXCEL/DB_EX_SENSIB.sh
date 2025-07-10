#!/bin/bash

source /home/herinomena/Images/backup_Dashboard/Dash_vers_DHIS2/EXCEL/.env
# Define MySQL credentials using environment variables
MYSQL_OPTS="--defaults-extra-file=<(printf '[client]\nuser=%s\npassword=%s\nhost=%s' \"$MYSQL_USER\" \"$MYSQL_PASSWORD\" \"$MYSQL_HOST\")"
CSV_FILE="/home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/EXCEL/DB_EX_SENSIB"


# Define SQL query
SQL_QUERY="SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SELECT

	CASE dbc.name  
		WHEN 'DB_EX_SENSIB_7' THEN 'klfD4xo8M5a'
		WHEN 'DB_EX_SENSIB_6' THEN 'SlIYasDDn6s'
		WHEN 'DB_EX_SENSIB_5' THEN 'qQBfqh9Y2AB'
		WHEN 'DB_EX_SENSIB_43' THEN 'lVBMgnDcHSm'
		WHEN 'DB_EX_SENSIB_42' THEN 'zkCSsXBvirJ'
		WHEN 'DB_EX_SENSIB_41' THEN 'gdu3QI2xMcR'
		WHEN 'DB_EX_SENSIB_40' THEN 'A63I2KPVlpd'
		WHEN 'DB_EX_SENSIB_4' THEN 'Udd9PinO6Q8'
		WHEN 'DB_EX_SENSIB_39' THEN 'Lu1kupbWi6G'
		WHEN 'DB_EX_SENSIB_38' THEN 'F2DHjIrwtzO'
		WHEN 'DB_EX_SENSIB_37' THEN 'e72aaL6OPTB'
		WHEN 'DB_EX_SENSIB_36' THEN 'm1CjyMsG6wL'
		WHEN 'DB_EX_SENSIB_35' THEN 'CcHidSF7oQv'
		WHEN 'DB_EX_SENSIB_34' THEN 'pKQNvBWgSsG'
		WHEN 'DB_EX_SENSIB_33' THEN 'aHPPre4bgBC'
		WHEN 'DB_EX_SENSIB_32' THEN 'aAApXHr6qeB'
		WHEN 'DB_EX_SENSIB_3' THEN 'dyKFsCpTP27'
		WHEN 'DB_EX_SENSIB_2' THEN 'V0GG70PJRGU'
		WHEN 'DB_EX_SENSIB_1' THEN 'ThPd8Y0VjgD'
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
    dbc.name IN ('DB_EX_SENSIB_7','DB_EX_SENSIB_6','DB_EX_SENSIB_5','DB_EX_SENSIB_43','DB_EX_SENSIB_42','DB_EX_SENSIB_41','DB_EX_SENSIB_40','DB_EX_SENSIB_4','DB_EX_SENSIB_39','DB_EX_SENSIB_38','DB_EX_SENSIB_37','DB_EX_SENSIB_36','DB_EX_SENSIB_35','DB_EX_SENSIB_34','DB_EX_SENSIB_33','DB_EX_SENSIB_32','DB_EX_SENSIB_3','DB_EX_SENSIB_2','DB_EX_SENSIB_1')
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
