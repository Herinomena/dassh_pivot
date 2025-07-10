#!/bin/bash

source /home/herinomena/Images/backup_Dashboard/Dash_vers_DHIS2/KOBO/.env
# Define MySQL credentials using environment variables
MYSQL_OPTS="--defaults-extra-file=<(printf '[client]\nuser=%s\npassword=%s\nhost=%s' \"$MYSQL_USER\" \"$MYSQL_PASSWORD\" \"$MYSQL_HOST\")"
CSV_FILE="/home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/KOBO/DB_KB_COMM_159_to_181"

# Define SQL query
SQL_QUERY="SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SELECT  
 Case dbc.name 
 when 'DB_KB_COMM_159' then 'QyCtSGkbNW1'
 when 'DB_KB_COMM_160' then 'UwsfciKtdbz'
 when 'DB_KB_COMM_161' then 'h57tQFOwy1u'
 when 'DB_KB_COMM_162' then 'a33cXSrr3ZU'
 when 'DB_KB_COMM_163' then 'WGZ8R8uVkSA'
 when 'DB_KB_COMM_164' then 'lpaqxyEa80U'
 when 'DB_KB_COMM_165' then 'ccGGY4ph48l'
 when 'DB_KB_COMM_166' then 'yudPgmcVOpk'
 when 'DB_KB_COMM_167' then 'H33fZMHGsow'
 when 'DB_KB_COMM_168' then 'uEgrnODHaoG'
 when 'DB_KB_COMM_169' then 'AxuJQOwzipc'
 when 'DB_KB_COMM_170' then 'JXwCPj1EEMK'
 when 'DB_KB_COMM_171' then 'EGwhljfqYUR'
 when 'DB_KB_COMM_172' then 'lOrjKeaCPMC'
 when 'DB_KB_COMM_173' then 'MlD3QcXwePy'
 when 'DB_KB_COMM_174' then 'cbfvEwfUNYZ'
 when 'DB_KB_COMM_175' then 'YGC5XnglSei'
 when 'DB_KB_COMM_176' then 'ehdfrJoX7gW'
 when 'DB_KB_COMM_177' then 'EFhotEVzLF9'
 when 'DB_KB_COMM_178' then 'mb9rgKw0l6A'
 when 'DB_KB_COMM_179' then 'wQe8fRvKvmF'
 when 'DB_KB_COMM_180' then 'xiqwB85FliG'
 when 'DB_KB_COMM_181' then 'jINpqujZC6a'
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
    dbc.name IN  ('DB_KB_COMM_159','DB_KB_COMM_160','DB_KB_COMM_161','DB_KB_COMM_162','DB_KB_COMM_163','DB_KB_COMM_164','DB_KB_COMM_165','DB_KB_COMM_166','DB_KB_COMM_167','DB_KB_COMM_168','DB_KB_COMM_169','DB_KB_COMM_170','DB_KB_COMM_171','DB_KB_COMM_172','DB_KB_COMM_173','DB_KB_COMM_174','DB_KB_COMM_175','DB_KB_COMM_176','DB_KB_COMM_177','DB_KB_COMM_178','DB_KB_COMM_179','DB_KB_COMM_180','DB_KB_COMM_181')
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
