#!/bin/bash

source /home/herinomena/Images/backup_Dashboard/Dash_vers_DHIS2/KOBO/.env
# Define MySQL credentials using environment variables
MYSQL_OPTS="--defaults-extra-file=<(printf '[client]\nuser=%s\npassword=%s\nhost=%s' \"$MYSQL_USER\" \"$MYSQL_PASSWORD\" \"$MYSQL_HOST\")"
CSV_FILE="/home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/KOBO/DB_KB_COMM_31_to_51"

# Define SQL query
SQL_QUERY="SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SELECT  
 Case dbc.name 
 when 'DB_KB_COMM_31' then 'FGr0HASMDx2'
 when 'DB_KB_COMM_32' then 'WT6kC6buB70'
 when 'DB_KB_COMM_33' then 'coeDmocV7mu'
 when 'DB_KB_COMM_34' then 'y8aTtlaFFCZ'
 when 'DB_KB_COMM_35' then 'QZUBEctWSgq'
 when 'DB_KB_COMM_36' then 'O4SM2QirGy1'
 when 'DB_KB_COMM_37' then 'ipFvn817XCF'
 when 'DB_KB_COMM_38' then 'dBUCI9Qube0'
 when 'DB_KB_COMM_39' then 'mItWLNykSng'
 when 'DB_KB_COMM_40' then 'Fv2o3BFkHkt'
 when 'DB_KB_COMM_41' then 'LobQX4t5Hoy'
 when 'DB_KB_COMM_42' then 'Lidt1SwTwWA'
 when 'DB_KB_COMM_43' then 'lkAPNy4Hiar'
 when 'DB_KB_COMM_44' then 'ki3TaFkkwJN'
 when 'DB_KB_COMM_45' then 'sG8q1lKWdtS'
 when 'DB_KB_COMM_46' then 'JDd2eJngit9'
 when 'DB_KB_COMM_47' then 'seyOhlluqZP'
 when 'DB_KB_COMM_48' then 'wwbv3NQLcOq'
 when 'DB_KB_COMM_49' then 'PfUFLFKBub2'
 when 'DB_KB_COMM_50' then 'ezhNbisxiE6'
 when 'DB_KB_COMM_51' then 'bD8ldlFuPwo'
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
    dbc.name IN ('DB_KB_COMM_31','DB_KB_COMM_32','DB_KB_COMM_33','DB_KB_COMM_34','DB_KB_COMM_35','DB_KB_COMM_36','DB_KB_COMM_37','DB_KB_COMM_38','DB_KB_COMM_39','DB_KB_COMM_40','DB_KB_COMM_41','DB_KB_COMM_42','DB_KB_COMM_43','DB_KB_COMM_44','DB_KB_COMM_45','DB_KB_COMM_46','DB_KB_COMM_47','DB_KB_COMM_48','DB_KB_COMM_49','DB_KB_COMM_50','DB_KB_COMM_51')
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
