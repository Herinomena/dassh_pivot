#!/bin/bash

source /home/herinomena/Images/backup_Dashboard/Dash_vers_DHIS2/KOBO/.env
# Define MySQL credentials using environment variables
MYSQL_OPTS="--defaults-extra-file=<(printf '[client]\nuser=%s\npassword=%s\nhost=%s' \"$MYSQL_USER\" \"$MYSQL_PASSWORD\" \"$MYSQL_HOST\")"
CSV_FILE="/home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/KOBO/DB_KB_STER_1_to_13_DB_KB_DIAGN_1_to_12"


# Define SQL query
SQL_QUERY="SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SELECT  
 Case dbc.name
 when 'DB_KB_STER_1' then 'HAMAIwo7CSs'
 when 'DB_KB_STER_2' then 'HPEnB8w7lV7'
 when 'DB_KB_STER_3' then 'U57JDyGC5xi'
 when 'DB_KB_STER_4' then 'CoYupWaftW3'
 when 'DB_KB_STER_5' then 'vUOtNMdcyir'
 when 'DB_KB_STER_6' then 'lQHlyuiDJ5g'
 when 'DB_KB_STER_7' then 'xDuU4bpRJVm'
 when 'DB_KB_STER_8' then 'NLZfAO4rp8K'
 when 'DB_KB_STER_9' then 'KwVJkdxtX34'
 when 'DB_KB_STER_10' then 'whOnU9Djhae'
 when 'DB_KB_STER_11' then 'WHOxYYQslaD'
 when 'DB_KB_STER_12' then 'h7625Iqg7PR'
 when 'DB_KB_STER_13' then 'Tdn62maklZp'
 when 'DB_KB_DIAGN_1' then 'YJKrnDAKgfS'
 when 'DB_KB_DIAGN_2' then 'bnmRe3NX77R'
 when 'DB_KB_DIAGN_3' then 'BpQ8Isc556W'
 when 'DB_KB_DIAGN_4' then 'kGdILj748bd'
 when 'DB_KB_DIAGN_5' then 'BGlCeInnHsi'
 when 'DB_KB_DIAGN_6' then 'QsIAwOUA1Lq'
 when 'DB_KB_DIAGN_7' then 'wC1X3bxWAV9'
 when 'DB_KB_DIAGN_8' then 'ol1Wpd9WH6F'
 when 'DB_KB_DIAGN_9' then 'PTZkOtVZQQO'
 when 'DB_KB_DIAGN_10' then 'LfQzUKEuGGu'
 when 'DB_KB_DIAGN_11' then 'VUQIjWP0Cb9'
 when 'DB_KB_DIAGN_12' then 'FaPsiuvbW2S'
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
    dbc.name IN ('DB_KB_STER_1','DB_KB_STER_2','DB_KB_STER_3','DB_KB_STER_4','DB_KB_STER_5','DB_KB_STER_6','DB_KB_STER_7','DB_KB_STER_8','DB_KB_STER_9','DB_KB_STER_10','DB_KB_STER_11','DB_KB_STER_12','DB_KB_STER_13','DB_KB_DIAGN_1','DB_KB_DIAGN_2','DB_KB_DIAGN_3','DB_KB_DIAGN_4','DB_KB_DIAGN_5','DB_KB_DIAGN_6','DB_KB_DIAGN_7','DB_KB_DIAGN_8','DB_KB_DIAGN_9','DB_KB_DIAGN_10','DB_KB_DIAGN_11','DB_KB_DIAGN_12')
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
