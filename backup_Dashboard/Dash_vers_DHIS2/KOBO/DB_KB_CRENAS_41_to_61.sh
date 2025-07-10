#!/bin/bash

source /home/herinomena/Images/backup_Dashboard/Dash_vers_DHIS2/KOBO/.env
# Define MySQL credentials using environment variables
MYSQL_OPTS="--defaults-extra-file=<(printf '[client]\nuser=%s\npassword=%s\nhost=%s' \"$MYSQL_USER\" \"$MYSQL_PASSWORD\" \"$MYSQL_HOST\")"
CSV_FILE="/home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/KOBO/DB_KB_CRENAS_41_to_61"


# Define SQL query
SQL_QUERY="SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SELECT  
 Case dbc.name 
 when 'DB_KB_CRENAS_41' then 'AF6Z0CqbZqH'
 when 'DB_KB_CRENAS_42' then 'SMXudGGwmV3'
 when 'DB_KB_CRENAS_43' then 'ARlJDvcEffO'
 when 'DB_KB_CRENAS_44' then 'Pw8lJUKh4PC'
 when 'DB_KB_CRENAS_45' then 'NMpGeWYYPKv'
 when 'DB_KB_CRENAS_46' then 'sojVaGtwWU6'
 when 'DB_KB_CRENAS_47' then 'oCtaEirQuw2'
 when 'DB_KB_CRENAS_48' then 'V8tPflzUxxa'
 when 'DB_KB_CRENAS_49' then 'mY50T63pLmm'
 when 'DB_KB_CRENAS_50' then 'KjTJno52V1l'
 when 'DB_KB_CRENAS_51' then 'lymIXHTiuBP'
 when 'DB_KB_CRENAS_52' then 'DJdYQWvEbqZ'
 when 'DB_KB_CRENAS_53' then 'LdJ7xV0tJ8z'
 when 'DB_KB_CRENAS_54' then 'IYaiobCAewF'
 when 'DB_KB_CRENAS_55' then 'yM39wFXn6JS'
 when 'DB_KB_CRENAS_56' then 'i4MxkIW3I4D'
 when 'DB_KB_CRENAS_57' then 'VYclIHOBo6w'
 when 'DB_KB_CRENAS_58' then 'XugD5JmwKw4'
 when 'DB_KB_CRENAS_59' then 'dJx1wMVBgmY'
 when 'DB_KB_CRENAS_60' then 'z8k5CwCL5vE'
 when 'DB_KB_CRENAS_61' then 'WwAKrIgQ9r8'
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
    dbc.name IN  ('DB_KB_CRENAS_41','DB_KB_CRENAS_42','DB_KB_CRENAS_43','DB_KB_CRENAS_44','DB_KB_CRENAS_45','DB_KB_CRENAS_46','DB_KB_CRENAS_47','DB_KB_CRENAS_48','DB_KB_CRENAS_49','DB_KB_CRENAS_50','DB_KB_CRENAS_51','DB_KB_CRENAS_52','DB_KB_CRENAS_53','DB_KB_CRENAS_54','DB_KB_CRENAS_55','DB_KB_CRENAS_56','DB_KB_CRENAS_57','DB_KB_CRENAS_58','DB_KB_CRENAS_59','DB_KB_CRENAS_60','DB_KB_CRENAS_61')
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
