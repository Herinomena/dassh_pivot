#!/bin/bash

source /home/herinomena/Images/backup_Dashboard/Dash_vers_DHIS2/KOBO/.env
# Define MySQL credentials using environment variables
MYSQL_OPTS="--defaults-extra-file=<(printf '[client]\nuser=%s\npassword=%s\nhost=%s' \"$MYSQL_USER\" \"$MYSQL_PASSWORD\" \"$MYSQL_HOST\")"
CSV_FILE="/home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/KOBO/DB_KB_CRENI_1_to_13_and_DB_KB_COMM_1_to_9"


# Define SQL query
SQL_QUERY="SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SELECT  
 Case dbc.name 
 when 'DB_KB_CRENI_1' then 'QTbxHDpALKA'
 when 'DB_KB_CRENI_2' then 'DwGiIFUfWpI'
 when 'DB_KB_CRENI_3' then 'n2nPnoSamaR'
 when 'DB_KB_CRENI_4' then 'qMyvYPzeCdH'
 when 'DB_KB_CRENI_5' then 'XViXVZagav8'
 when 'DB_KB_CRENI_6' then 'pbC158FIfcI'
 when 'DB_KB_CRENI_7' then 'jODo5UhZtuS'
 when 'DB_KB_CRENI_8' then 'HVMa6TilqOL'
 when 'DB_KB_CRENI_9' then 'eAU2rJP6sE2'
 when 'DB_KB_CRENI_10' then 'gIQ9IREGWh7'
 when 'DB_KB_CRENI_11' then 'Q0Pz0GK2c6h'
 when 'DB_KB_CRENI_12' then 'MJhbZ3dequ1'
 when 'DB_KB_CRENI_13' then 'YuflCwzW7Tm'
 when 'DB_KB_COMM_1' then 'aWTZmAclosY'
 when 'DB_KB_COMM_2' then 'QV1TH3NSTW6'
 when 'DB_KB_COMM_3' then 'n2NNsLPusux'
 when 'DB_KB_COMM_4' then 'K5FtZgEJDgu'
 when 'DB_KB_COMM_5' then 'kxtWgauoLEZ'
 when 'DB_KB_COMM_6' then 'sPnsZIJglv6'
 when 'DB_KB_COMM_7' then 'P6O0gq8pQOv'
  when 'DB_KB_COMM_8' then 'CDMGqo9V8a5'
   when 'DB_KB_COMM_9' then 'GpQ89hkf4DB'
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
    dbc.name IN ('DB_KB_CRENI_1','DB_KB_CRENI_2','DB_KB_CRENI_3','DB_KB_CRENI_4','DB_KB_CRENI_5','DB_KB_CRENI_6','DB_KB_CRENI_7','DB_KB_CRENI_8','DB_KB_CRENI_9','DB_KB_CRENI_10','DB_KB_CRENI_11','DB_KB_CRENI_12','DB_KB_CRENI_13','DB_KB_COMM_1','DB_KB_COMM_2','DB_KB_COMM_3','DB_KB_COMM_4','DB_KB_COMM_5','DB_KB_COMM_6','DB_KB_COMM_7','DB_KB_COMM_8','DB_KB_COMM_9')
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
