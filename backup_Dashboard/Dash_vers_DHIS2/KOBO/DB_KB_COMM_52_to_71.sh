#!/bin/bash

source /home/herinomena/Images/backup_Dashboard/Dash_vers_DHIS2/KOBO/.env
# Define MySQL credentials using environment variables
MYSQL_OPTS="--defaults-extra-file=<(printf '[client]\nuser=%s\npassword=%s\nhost=%s' \"$MYSQL_USER\" \"$MYSQL_PASSWORD\" \"$MYSQL_HOST\")"
CSV_FILE="/home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/KOBO/DB_KB_COMM_52_to_71"

# Define SQL query
SQL_QUERY="SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SELECT  
 Case dbc.name 
 when 'DB_KB_COMM_52' then 'ruD2XnL1yRu'
 when 'DB_KB_COMM_53' then 'sjnaP3QrRYA'
 when 'DB_KB_COMM_54' then 'NgUkWslC0s0'
 when 'DB_KB_COMM_55' then 'sGERqkHeUZG'
 when 'DB_KB_COMM_56' then 'io65qIf7VdA'
 when 'DB_KB_COMM_57' then 'Z4zORNwQBYg'
 when 'DB_KB_COMM_58' then 'FpuT0C3w7tK'
 when 'DB_KB_COMM_59' then 'lLKqRwajXYy'
 when 'DB_KB_COMM_60' then 'LMvZAAapzbM'
 when 'DB_KB_COMM_61' then 'CPElGY2d9E0'
 when 'DB_KB_COMM_62' then 'IIjH9e0BXAm'
 when 'DB_KB_COMM_63' then 'TaNYfQsdyRS'
 when 'DB_KB_COMM_64' then 'WfqnEy0hNLH'
 when 'DB_KB_COMM_65' then 'zP5qsbPM0bw'
 when 'DB_KB_COMM_66' then 'P9cnaDPdqXA'
 when 'DB_KB_COMM_67' then 'vMNKkQsIrbu'
 when 'DB_KB_COMM_68' then 'I0eFPxVkJ8k'
 when 'DB_KB_COMM_69' then 'NROcu10kiF0'
 when 'DB_KB_COMM_70' then 'Uag0CseO8lw'
 when 'DB_KB_COMM_71' then 'gluYcym5EpE'
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
    dbc.name IN ('DB_KB_COMM_52','DB_KB_COMM_53','DB_KB_COMM_54','DB_KB_COMM_55','DB_KB_COMM_56','DB_KB_COMM_57','DB_KB_COMM_58','DB_KB_COMM_59','DB_KB_COMM_60','DB_KB_COMM_61','DB_KB_COMM_62','DB_KB_COMM_63','DB_KB_COMM_64','DB_KB_COMM_65','DB_KB_COMM_66','DB_KB_COMM_67','DB_KB_COMM_68','DB_KB_COMM_69','DB_KB_COMM_70','DB_KB_COMM_71')
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
