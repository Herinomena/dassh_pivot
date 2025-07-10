#!/bin/bash

source /home/herinomena/Images/backup_Dashboard/Dash_vers_DHIS2/KOBO/.env
# Define MySQL credentials using environment variables
MYSQL_OPTS="--defaults-extra-file=<(printf '[client]\nuser=%s\npassword=%s\nhost=%s' \"$MYSQL_USER\" \"$MYSQL_PASSWORD\" \"$MYSQL_HOST\")"
CSV_FILE="/home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/KOBO/DB_KB_CRENAS_22_to_40"


# Define SQL query
SQL_QUERY="SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SELECT  
 Case dbc.name 
 when 'DB_KB_CRENAS_22' then 'n3aWdRT7SM1'
 when 'DB_KB_CRENAS_23' then 'nPNGeImruBh'
 when 'DB_KB_CRENAS_24' then 'jHPnvPkbFDv'
 when 'DB_KB_CRENAS_25' then 'gGnNxgpaQKu'
 when 'DB_KB_CRENAS_26' then 'Tfox9udYDIX'
 when 'DB_KB_CRENAS_27' then 'tHWfotToibn'
 when 'DB_KB_CRENAS_28' then 'zhuyOlOP3iR'
 when 'DB_KB_CRENAS_29' then 'TvF4jLv7Q1a'
 when 'DB_KB_CRENAS_30' then 'DqdApwdeFGR'
 when 'DB_KB_CRENAS_31' then 'YYctCtJywLZ'
 when 'DB_KB_CRENAS_32' then 'ABOCOSnUwQ1'
 when 'DB_KB_CRENAS_33' then 'TNKdNEeTD4I'
 when 'DB_KB_CRENAS_34' then 'wJtFAOYK1Ig'
 when 'DB_KB_CRENAS_35' then 'ImQiW3TpFfK'
 when 'DB_KB_CRENAS_36' then 'tSXClTbS60q'
 when 'DB_KB_CRENAS_37' then 'gBO2W6E3wdt'
 when 'DB_KB_CRENAS_38' then 'DQvcl3xy5Eg'
 when 'DB_KB_CRENAS_39' then 'ZrTbZRmtAgJ'
 when 'DB_KB_CRENAS_40' then 'fvOJgVhOumD'
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
    dbc.name IN ('DB_KB_CRENAS_22','DB_KB_CRENAS_23','DB_KB_CRENAS_24','DB_KB_CRENAS_25','DB_KB_CRENAS_26','DB_KB_CRENAS_27','DB_KB_CRENAS_28','DB_KB_CRENAS_29','DB_KB_CRENAS_30','DB_KB_CRENAS_31','DB_KB_CRENAS_32','DB_KB_CRENAS_33','DB_KB_CRENAS_34','DB_KB_CRENAS_35','DB_KB_CRENAS_36','DB_KB_CRENAS_37','DB_KB_CRENAS_38','DB_KB_CRENAS_39','DB_KB_CRENAS_40')
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
