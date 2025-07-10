#!/bin/bash

source /home/herinomena/Images/backup_Dashboard/Dash_vers_DHIS2/KOBO/.env
# Define MySQL credentials using environment variables
MYSQL_OPTS="--defaults-extra-file=<(printf '[client]\nuser=%s\npassword=%s\nhost=%s' \"$MYSQL_USER\" \"$MYSQL_PASSWORD\" \"$MYSQL_HOST\")"
CSV_FILE="/home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/KOBO/DB_KB_COMM_10_to_30"


# Define SQL query
SQL_QUERY="SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SELECT  
 Case dbc.name 
 when 'DB_KB_COMM_10' then 'UnIpJD7UUM3'
 when 'DB_KB_COMM_11' then 'jofrXibv4iH'
 when 'DB_KB_COMM_12' then 'N58gsmoiZAK'
 when 'DB_KB_COMM_13' then 'vN1d8Vd0g8u'
 when 'DB_KB_COMM_14' then 'EMgYeXsjaeF'
 when 'DB_KB_COMM_15' then 'Ty7tNkRgyuV'
 when 'DB_KB_COMM_16' then 'UoBHf0XwsmF'
 when 'DB_KB_COMM_17' then 'iayLLs7s8Bx'
 when 'DB_KB_COMM_18' then 'Ab7jmkFjSI9'
 when 'DB_KB_COMM_19' then 'kWGAvRcxTqn'
 when 'DB_KB_COMM_20' then 'OISXCE8ES8h'
 when 'DB_KB_COMM_21' then 'lfOr4ojgsoC'
 when 'DB_KB_COMM_22' then 'JAfmyk94jCb'
 when 'DB_KB_COMM_23' then 'MgO6iuHPaPK'
 when 'DB_KB_COMM_24' then 'EdBFo8gpKA7'
 when 'DB_KB_COMM_25' then 'SC1XUpdo98X'
 when 'DB_KB_COMM_26' then 'HpHO0t9iN3s'
 when 'DB_KB_COMM_27' then 'G5DrNndVjBH'
 when 'DB_KB_COMM_28' then 'C1niXkshyMh'
 when 'DB_KB_COMM_29' then 'AxC2AFnVL2J'
 when 'DB_KB_COMM_30' then 'bRSIxlgc6ZG'
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
    dbc.name IN ('DB_KB_COMM_10','DB_KB_COMM_11','DB_KB_COMM_12','DB_KB_COMM_13','DB_KB_COMM_14','DB_KB_COMM_15','DB_KB_COMM_16','DB_KB_COMM_17','DB_KB_COMM_18','DB_KB_COMM_19','DB_KB_COMM_20','DB_KB_COMM_21','DB_KB_COMM_22','DB_KB_COMM_23','DB_KB_COMM_24','DB_KB_COMM_25','DB_KB_COMM_26','DB_KB_COMM_27','DB_KB_COMM_28','DB_KB_COMM_29','DB_KB_COMM_30')
     AND EXTRACT(YEAR_MONTH FROM  DATE(dbdb.periode)) >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 4 MONTH), '%Y%m')
GROUP BY cc.id  , EXTRACT(YEAR_MONTH FROM DATE(dbdb.periode)),dbc.id"

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
