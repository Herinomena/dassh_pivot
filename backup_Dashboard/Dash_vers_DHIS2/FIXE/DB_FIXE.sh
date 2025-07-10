#!/bin/bash

source /home/herinomena/Images/backup_Dashboard/Dash_vers_DHIS2/FIXE/.env
# Define MySQL credentials using environment variables
MYSQL_OPTS="--defaults-extra-file=<(printf '[client]\nuser=%s\npassword=%s\nhost=%s' \"$MYSQL_USER\" \"$MYSQL_PASSWORD\" \"$MYSQL_HOST\")"
CSV_FILE="/home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/FIXE/DB_FIXE"



# Define SQL query
SQL_QUERY="SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SELECT  
 Case dbc.name
 when 'DB_EX_CSB_FIXE_1' then 'blMyN7VmlL3'
 when 'DB_EX_CSB_FIXE_2' then 'V5WM4Q68lnx'
 when 'DB_EX_CSB_FIXE_3' then 'uZRfhVSvm9I'
 when 'DB_EX_CSB_FIXE_4' then 'koBBTJEpPp0'
 when 'DB_EX_CSB_FIXE_5' then 'itqA6wTtFhe'
 when 'DB_EX_CSB_FIXE_6' then 'q9QY10sRJZR'
 when 'DB_EX_CSB_FIXE_7' then 'rvWcNmYFnEC'
 when 'DB_EX_CSB_FIXE_8' then 'j9WXjgFrMdq'
 when 'DB_EX_CSB_FIXE_9' then 'o4QKj39jQ6p'
 when 'DB_EX_CSB_FIXE_10' then 'wLqzKuAma7H'
 when 'DB_EX_CSB_FIXE_11' then 'N4PjI2rnjLf'
 when 'DB_EX_CSB_FIXE_12' then 'QqbaSMrnTvP'
  when 'DB_EX_CHRD_FIXE_1' then 'vW4wAGkHwpa'
 when 'DB_EX_CHRD_FIXE_2' then 'bzN7medNt14'
 when 'DB_EX_CHRD_FIXE_3' then 'd383rr0kACo'
 when 'DB_EX_CHRD_FIXE_4' then 'HTekFk58QA3'
 when 'DB_EX_CHRD_FIXE_5' then 'jdQjUWFZZuy'
 when 'DB_EX_CHRD_FIXE_6' then 'psSgjP63P9y'
 when 'DB_EX_CHRD_FIXE_7' then 'JtIujaPzVT2'
 when 'DB_EX_CHRD_FIXE_8' then 'IhVywMZYkQb'
 when 'DB_EX_CHRD_FIXE_9' then 'TvgTHBPmqAl'
 when 'DB_EX_CHRD_FIXE_10' then 'yTEg7n6m8MJ'
  when 'DB_EX_COMM_FIXE_1' then 'wnE2PvxyltI'
 when 'DB_EX_COMM_FIXE_2' then 'klz5C0bzxRN'
 when 'DB_EX_COMM_FIXE_3' then 'G0CCIOxUfP8'
 when 'DB_EX_COMM_FIXE_4' then 'zhZmoCJT5xx'

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
    dbc.name IN ('DB_EX_CSB_FIXE_1','DB_EX_CSB_FIXE_2','DB_EX_CSB_FIXE_3','DB_EX_CSB_FIXE_4','DB_EX_CSB_FIXE_5','DB_EX_CSB_FIXE_6','DB_EX_CSB_FIXE_7','DB_EX_CSB_FIXE_8','DB_EX_CSB_FIXE_9','DB_EX_CSB_FIXE_10','DB_EX_CSB_FIXE_11','DB_EX_CSB_FIXE_12','DB_EX_COMM_FIXE_1','DB_EX_COMM_FIXE_2','DB_EX_COMM_FIXE_3','DB_EX_COMM_FIXE_4','DB_EX_CHRD_FIXE_1','DB_EX_CHRD_FIXE_2','DB_EX_CHRD_FIXE_3','DB_EX_CHRD_FIXE_4','DB_EX_CHRD_FIXE_5','DB_EX_CHRD_FIXE_6','DB_EX_CHRD_FIXE_7','DB_EX_CHRD_FIXE_8','DB_EX_CHRD_FIXE_9','DB_EX_CHRD_FIXE_10')
    AND EXTRACT(YEAR_MONTH FROM  DATE(dbdb.periode)) >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 2 MONTH), '%Y%m')
    GROUP BY cc.id,dbc.id ,EXTRACT(YEAR_MONTH FROM DATE(dbdb.periode))"

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
