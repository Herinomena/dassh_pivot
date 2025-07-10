#!/bin/bash

source /home/herinomena/Images/backup_Dashboard/Dash_vers_DHIS2/KOBO/.env
# Define MySQL credentials using environment variables
MYSQL_OPTS="--defaults-extra-file=<(printf '[client]\nuser=%s\npassword=%s\nhost=%s' \"$MYSQL_USER\" \"$MYSQL_PASSWORD\" \"$MYSQL_HOST\")"
CSV_FILE="/home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/KOBO/DB_KB_SENSIB_24_to_46"


# Define SQL query
SQL_QUERY="SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SELECT  
 Case dbc.name 
 when 'DB_KB_SENSIB_24' then 'SV9KC8RSgfP'
 when 'DB_KB_SENSIB_25' then 'rLQo2tn2WMV'
 when 'DB_KB_SENSIB_26' then 'q7U0RnMI0HG'
 when 'DB_KB_SENSIB_27' then 'brFksxcTipt'
 when 'DB_KB_SENSIB_28' then 'nfpNmLQ1sK3'
 when 'DB_KB_SENSIB_29' then 'fRiDrF4COti'
 when 'DB_KB_SENSIB_30' then 'gwja3FnQqHP'
 when 'DB_KB_SENSIB_31' then 'gfG7Um1LSDO'
 when 'DB_KB_SENSIB_32' then 'qdwr4MLo1Kb'
 when 'DB_KB_SENSIB_33' then 'tjDyH91N1VT'
 when 'DB_KB_SENSIB_34' then 'lsjYv33tQvm'
 when 'DB_KB_SENSIB_35' then 'OFHxEwYabeR'
 when 'DB_KB_SENSIB_36' then 'j9luTdhKYkz'
 when 'DB_KB_SENSIB_37' then 'DLAz7Ma6o3c'
 when 'DB_KB_SENSIB_38' then 'SdnTRu33R1K'
 when 'DB_KB_SENSIB_39' then 'Tqlzo3earcM'
 when 'DB_KB_SENSIB_40' then 'btgnrjilufB'
 when 'DB_KB_SENSIB_41' then 'IGUABV1T13g'
 when 'DB_KB_SENSIB_42' then 'BWHnVUTsTuQ'
 when 'DB_KB_SENSIB_43' then 'heb2hkTqzBj'
 when 'DB_KB_SENSIB_44' then 'cFYe50f3WT4'
 when 'DB_KB_SENSIB_45' then 'u6OYXtheiLY'
 when 'DB_KB_SENSIB_46' then 'Pxpge6U3iGv'

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
    dbc.name IN  ('DB_KB_SENSIB_24','DB_KB_SENSIB_25','DB_KB_SENSIB_26','DB_KB_SENSIB_27','DB_KB_SENSIB_28','DB_KB_SENSIB_29','DB_KB_SENSIB_30','DB_KB_SENSIB_31','DB_KB_SENSIB_32','DB_KB_SENSIB_33','DB_KB_SENSIB_34','DB_KB_SENSIB_35','DB_KB_SENSIB_36','DB_KB_SENSIB_37','DB_KB_SENSIB_38','DB_KB_SENSIB_39','DB_KB_SENSIB_40','DB_KB_SENSIB_41','DB_KB_SENSIB_42','DB_KB_SENSIB_43','DB_KB_SENSIB_44','DB_KB_SENSIB_45','DB_KB_SENSIB_46')
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
