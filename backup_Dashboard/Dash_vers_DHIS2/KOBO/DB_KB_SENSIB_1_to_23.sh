#!/bin/bash

source /home/herinomena/Images/backup_Dashboard/Dash_vers_DHIS2/KOBO/.env
# Define MySQL credentials using environment variables
MYSQL_OPTS="--defaults-extra-file=<(printf '[client]\nuser=%s\npassword=%s\nhost=%s' \"$MYSQL_USER\" \"$MYSQL_PASSWORD\" \"$MYSQL_HOST\")"
CSV_FILE="/home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/KOBO/DB_KB_SENSIB_1_to_23"


# Define SQL query
SQL_QUERY="SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SELECT  
 Case dbc.name 
 when 'DB_KB_SENSIB_1' then 'bQXXVnwMeGf'
 when 'DB_KB_SENSIB_2' then 'xV2ECttjY97'
 when 'DB_KB_SENSIB_3' then 'jXGcD0XR9zb'
 when 'DB_KB_SENSIB_4' then 'wpK4iDxTATG'
 when 'DB_KB_SENSIB_5' then 'xYHD8Pqqnfj'
 when 'DB_KB_SENSIB_6' then 'ZtpQG8DFpd2'
 when 'DB_KB_SENSIB_12' then 'VXwSVLixdXE'
 when 'DB_KB_SENSIB_13' then 'SfZPUV2Jz7T'
 when 'DB_KB_SENSIB_14' then 'csvfSg8Qgc1'
 when 'DB_KB_SENSIB_15' then 'DkUGCAXVSbd'
 when 'DB_KB_SENSIB_16' then 'LndiBz5pYzc'
 when 'DB_KB_SENSIB_17' then 'cUHXHB14JXH'
 when 'DB_KB_SENSIB_18' then 'bKs5Xkbjy7K'
 when 'DB_KB_SENSIB_19' then 'snISBbaEXaq'
 when 'DB_KB_SENSIB_20' then 'Z4aW7HEdHM5'
 when 'DB_KB_SENSIB_21' then 'z3tvuKF0Eub'
 when 'DB_KB_SENSIB_22' then 't8SkpgSShWA'
 when 'DB_KB_SENSIB_23' then 'DaZhPtikNja'
 END AS 'dataelement',
 EXTRACT(YEAR_MONTH FROM DATE(dbdb.periode)) AS 'period',
    cc.orgunit AS 'orgunit',
    'HllvX50cXC0' AS 'catoptcombo',
    'HllvX50cXC0' AS 'attroptcombo',
    sum(dbdb.value) AS 'value'

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
    dbc.name IN  ('DB_KB_SENSIB_1' ,'DB_KB_SENSIB_2','DB_KB_SENSIB_3','DB_KB_SENSIB_4','DB_KB_SENSIB_5','DB_KB_SENSIB_6','DB_KB_SENSIB_12','DB_KB_SENSIB_13','DB_KB_SENSIB_14','DB_KB_SENSIB_15','DB_KB_SENSIB_16','DB_KB_SENSIB_17','DB_KB_SENSIB_18','DB_KB_SENSIB_19','DB_KB_SENSIB_20','DB_KB_SENSIB_21','DB_KB_SENSIB_22','DB_KB_SENSIB_23')
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
