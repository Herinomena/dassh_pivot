#!/bin/bash

source /home/herinomena/Images/backup_Dashboard/Dash_vers_DHIS2/KOBO/.env
# Define MySQL credentials using environment variables
MYSQL_OPTS="--defaults-extra-file=<(printf '[client]\nuser=%s\npassword=%s\nhost=%s' \"$MYSQL_USER\" \"$MYSQL_PASSWORD\" \"$MYSQL_HOST\")"
CSV_FILE="/home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/KOBO/DB_KB_COMM_117_to_137"

# Define SQL query
SQL_QUERY="SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SELECT  
 Case dbc.name 
 when 'DB_KB_COMM_117' then 'k5OE0vWV2tf'
 when 'DB_KB_COMM_118' then 'DYLNCmFSuEZ'
 when 'DB_KB_COMM_119' then 'NXrHAgGQUIY'
 when 'DB_KB_COMM_120' then 'GagIJWn9pqx'
 when 'DB_KB_COMM_121' then 'Gy6yn60zvzq'
 when 'DB_KB_COMM_122' then 'pMiZvXWlWD1'
 when 'DB_KB_COMM_123' then 'p1HpcjEO5Wp'
 when 'DB_KB_COMM_124' then 'OdSmdBPAL6o'
 when 'DB_KB_COMM_125' then 'Wed8qStutG6'
 when 'DB_KB_COMM_126' then 'tA2IJKGBaQM'
 when 'DB_KB_COMM_127' then 'QuOnZ0XB1X4'
 when 'DB_KB_COMM_128' then 'R70Rkg4bsFB'
 when 'DB_KB_COMM_129' then 'C5Si3dH9m72'
 when 'DB_KB_COMM_130' then 'tb4heSIvjzY'
 when 'DB_KB_COMM_131' then 'eMRG9ZIxsup'
 when 'DB_KB_COMM_132' then 'H4grhorkRX2'
 when 'DB_KB_COMM_133' then 'U2QPPSJvjeO'
 when 'DB_KB_COMM_134' then 'rddu4sNkPHM'
 when 'DB_KB_COMM_135' then 'aFHVCdhPquQ'
 when 'DB_KB_COMM_136' then 'jkYpYskVTqg'
  when 'DB_KB_COMM_137' then 'JKdUUt7ckEU'
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
    dbc.name IN  ('DB_KB_COMM_117','DB_KB_COMM_118','DB_KB_COMM_119','DB_KB_COMM_120','DB_KB_COMM_121','DB_KB_COMM_122','DB_KB_COMM_123','DB_KB_COMM_124','DB_KB_COMM_125','DB_KB_COMM_126','DB_KB_COMM_127','DB_KB_COMM_128','DB_KB_COMM_129','DB_KB_COMM_130','DB_KB_COMM_131','DB_KB_COMM_132','DB_KB_COMM_133','DB_KB_COMM_134','DB_KB_COMM_135','DB_KB_COMM_136','DB_KB_COMM_137')
    AND EXTRACT(YEAR_MONTH FROM  DATE(dbdb.periode)) >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 6 MONTH), '%Y%m')
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
