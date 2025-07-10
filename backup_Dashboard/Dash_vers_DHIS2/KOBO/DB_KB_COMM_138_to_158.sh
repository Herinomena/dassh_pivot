#!/bin/bash

source /home/herinomena/Images/backup_Dashboard/Dash_vers_DHIS2/KOBO/.env
# Define MySQL credentials using environment variables
MYSQL_OPTS="--defaults-extra-file=<(printf '[client]\nuser=%s\npassword=%s\nhost=%s' \"$MYSQL_USER\" \"$MYSQL_PASSWORD\" \"$MYSQL_HOST\")"
CSV_FILE="/home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/KOBO/DB_KB_COMM_138_to_158"

# Define SQL query
SQL_QUERY="SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SELECT  
 Case dbc.name 
 when 'DB_KB_COMM_138' then 'f6lAPd15Y8G'
 when 'DB_KB_COMM_139' then 'A0OHp64RAZj'
 when 'DB_KB_COMM_140' then 'vUkYllYjl1n'
 when 'DB_KB_COMM_141' then 'fx2CxJy4U7p'
 when 'DB_KB_COMM_142' then 'MT5nsOP1dzF'
 when 'DB_KB_COMM_143' then 'SMT5qNuOy9u'
 when 'DB_KB_COMM_144' then 'OpfuLq6uxdy'
 when 'DB_KB_COMM_145' then 'snLC9YkgWXw'
 when 'DB_KB_COMM_146' then 'ijrLw584yXl'
 when 'DB_KB_COMM_147' then 'zg22lWX0t7m'
 when 'DB_KB_COMM_148' then 'hshnUhOuErq'
 when 'DB_KB_COMM_149' then 'ahmB7SCZ1fn'
 when 'DB_KB_COMM_150' then 'EBqpUVWwvLM'
 when 'DB_KB_COMM_151' then 'FqYmobbuKfc'
 when 'DB_KB_COMM_152' then 'QKYnD0h1DIx'
 when 'DB_KB_COMM_153' then 'fHMKkBhCHwB'
 when 'DB_KB_COMM_154' then 'hV8Jt9SvGLb'
 when 'DB_KB_COMM_155' then 'HrzQ86UdqIU'
 when 'DB_KB_COMM_156' then 'R5FEp0eif2I'
 when 'DB_KB_COMM_157' then 'QaRTWIz8NMH'
 when 'DB_KB_COMM_158' then 'P6PQSkTsBQQ'
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
    dbc.name IN ('DB_KB_COMM_138','DB_KB_COMM_139','DB_KB_COMM_140','DB_KB_COMM_141','DB_KB_COMM_142','DB_KB_COMM_143','DB_KB_COMM_144','DB_KB_COMM_145','DB_KB_COMM_146','DB_KB_COMM_147','DB_KB_COMM_148','DB_KB_COMM_149','DB_KB_COMM_150','DB_KB_COMM_151','DB_KB_COMM_152','DB_KB_COMM_153','DB_KB_COMM_154','DB_KB_COMM_155','DB_KB_COMM_156','DB_KB_COMM_157','DB_KB_COMM_158')
    AND EXTRACT(YEAR_MONTH FROM  DATE(dbdb.periode)) >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 4 MONTH), '%Y%m')
 GROUP BY cc.id  , EXTRACT(YEAR_MONTH FROM DATE(dbdb.periode)),dbc.id"

# Generate timestamp for output file
TIMESTAMP=$(date +%Y%m%d%H%M%S)

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
