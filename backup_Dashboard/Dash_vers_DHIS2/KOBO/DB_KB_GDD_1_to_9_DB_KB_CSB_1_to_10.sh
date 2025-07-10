#!/bin/bash

source /home/herinomena/Images/backup_Dashboard/Dash_vers_DHIS2/KOBO/.env
# Define MySQL credentials using environment variables
MYSQL_OPTS="--defaults-extra-file=<(printf '[client]\nuser=%s\npassword=%s\nhost=%s' \"$MYSQL_USER\" \"$MYSQL_PASSWORD\" \"$MYSQL_HOST\")"
CSV_FILE="/home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/KOBO/DB_KB_GDD_1_to_9_DB_KB_CSB_1_to_10"


# Define SQL query
SQL_QUERY="SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SELECT  
 Case dbc.name
 when 'DB_KB_CSB_1' then 'T5bpt4KFz0k'
 when 'DB_KB_CSB_2' then 'lYoyZUrzhug'
 when 'DB_KB_CSB_3' then 'NDtvrFgNEHv'
 when 'DB_KB_CSB_4' then 'fSJvYMS0u65'
 when 'DB_KB_CSB_5' then 'CGfFhZJQhv4'
 when 'DB_KB_CSB_6' then 'N9qb8P9DZRf'
 when 'DB_KB_CSB_7' then 'PsEokk5tLgU'
 when 'DB_KB_CSB_8' then 'yb7vUY2ZsPE'
 when 'DB_KB_CSB_9' then 'kJNIl5wbemD'
 when 'DB_KB_CSB_10' then 'RdQsP0hxBuj'
 when 'DB_KB_GDD_1' then 'xCemaIOhh30'
 when 'DB_KB_GDD_2' then 'BoqTFXHytFA'
 when 'DB_KB_GDD_3' then 'T0IYMo8Kdgu'
 when 'DB_KB_GDD_4' then 'iXMrwvE0t0d'
 when 'DB_KB_GDD_5' then 't8VrT0IU9Di'
 when 'DB_KB_GDD_6' then 'IT0tzEujuti'
 when 'DB_KB_GDD_7' then 'ycSXl1ZCvp5'
 when 'DB_KB_GDD_8' then 'W6TZwuQGxtE'
 when 'DB_KB_GDD_9' then 'z4FnDreEIDT'
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
    dbc.name IN ('DB_KB_CSB_1','DB_KB_CSB_2','DB_KB_CSB_3','DB_KB_CSB_4','DB_KB_CSB_5','DB_KB_CSB_6','DB_KB_CSB_7','DB_KB_CSB_8','DB_KB_CSB_9','DB_KB_CSB_10','DB_KB_GDD_1','DB_KB_GDD_2','DB_KB_GDD_3','DB_KB_GDD_4','DB_KB_GDD_5','DB_KB_GDD_6','DB_KB_GDD_7','DB_KB_GDD_8','DB_KB_GDD_9')
    AND EXTRACT(YEAR_MONTH FROM  DATE(dbdb.periode)) >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 10 MONTH), '%Y%m')
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
