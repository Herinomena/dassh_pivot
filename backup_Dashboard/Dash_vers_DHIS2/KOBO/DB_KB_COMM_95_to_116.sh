#!/bin/bash

source /home/herinomena/Images/backup_Dashboard/Dash_vers_DHIS2/KOBO/.env
# Define MySQL credentials using environment variables
MYSQL_OPTS="--defaults-extra-file=<(printf '[client]\nuser=%s\npassword=%s\nhost=%s' \"$MYSQL_USER\" \"$MYSQL_PASSWORD\" \"$MYSQL_HOST\")"
CSV_FILE="/home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/KOBO/DB_KB_COMM_95_to_116"

# Define SQL query
SQL_QUERY="SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SELECT  

 Case dbc.name 

 when 'DB_KB_COMM_95' then 'HsQA0VUBsVU'
 when 'DB_KB_COMM_96' then 'URIxItRXvSB'
 when 'DB_KB_COMM_97' then 'nV5aPAvI8Sp'
 when 'DB_KB_COMM_98' then 'EBJmuKr2cay'
 when 'DB_KB_COMM_99' then 'XVU2nSRj3Ow'
 when 'DB_KB_COMM_100' then 'mQ4JuifL9j9'
 when 'DB_KB_COMM_101' then 'YpKJkI63YmD'
 when 'DB_KB_COMM_102' then 'jSALAhNJI5r'
 when 'DB_KB_COMM_103' then 'nNjHk0zfTsh'
 when 'DB_KB_COMM_104' then 'LqSIz6B2wBR'
 when 'DB_KB_COMM_105' then 'QpskbUIHYkS'
 when 'DB_KB_COMM_106' then 'H5BvRusmkLz'
 when 'DB_KB_COMM_107' then 'B9jgnf74db7'
 when 'DB_KB_COMM_108' then 'aSVVmjdoL5V'
 when 'DB_KB_COMM_109' then 'ERbfeWIcmVy'
 when 'DB_KB_COMM_110' then 'H0joAEuW2dQ'
 when 'DB_KB_COMM_111' then 'AZIzNrSKQJn'
 when 'DB_KB_COMM_112' then 'CTepCfbEbkF'
 when 'DB_KB_COMM_113' then 'Eg5pssRn7Yu'
 when 'DB_KB_COMM_114' then 'NOX1kqj7wbd'
 when 'DB_KB_COMM_115' then 'OL3laVD9Fo4'
 when 'DB_KB_COMM_116' then 'MW7lkA0sFhm'
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
    dbc.name IN ('DB_KB_COMM_95','DB_KB_COMM_96','DB_KB_COMM_97','DB_KB_COMM_98','DB_KB_COMM_99','DB_KB_COMM_100','DB_KB_COMM_101','DB_KB_COMM_102','DB_KB_COMM_103','DB_KB_COMM_104','DB_KB_COMM_105','DB_KB_COMM_106','DB_KB_COMM_107','DB_KB_COMM_108','DB_KB_COMM_109','DB_KB_COMM_110','DB_KB_COMM_111','DB_KB_COMM_112','DB_KB_COMM_113','DB_KB_COMM_114','DB_KB_COMM_115','DB_KB_COMM_116')
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
