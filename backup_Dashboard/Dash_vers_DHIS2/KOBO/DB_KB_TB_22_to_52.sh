#!/bin/bash

source /home/herinomena/Images/backup_Dashboard/Dash_vers_DHIS2/KOBO/.env
# Define MySQL credentials using environment variables
MYSQL_OPTS="--defaults-extra-file=<(printf '[client]\nuser=%s\npassword=%s\nhost=%s' \"$MYSQL_USER\" \"$MYSQL_PASSWORD\" \"$MYSQL_HOST\")"
CSV_FILE="/home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/KOBO/DB_KB_TB_22_to_52"


# Define SQL query
SQL_QUERY="SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SELECT  
 Case dbc.name
 when 'DB_KB_TB_22' then 'kbpOHJj3UPK'
 when 'DB_KB_TB_23' then 'bid7mhEWj8o'
 when 'DB_KB_TB_24' then 'd8BNVInmsTb'
 when 'DB_KB_TB_25' then 'KB2OSrwZ763'
 when 'DB_KB_TB_26' then 'Yyol3lso9Xh'
 when 'DB_KB_TB_27' then 'hBzNwcepJnk'
 when 'DB_KB_TB_28' then 'WpOPbwYQ5gz'
 when 'DB_KB_TB_29' then 'nX7tTTSKMpa'
 when 'DB_KB_TB_30' then 'gWndqdWN59T'
 when 'DB_KB_TB_31' then 'sUoTTof2sxi'
 when 'DB_KB_TB_32' then 'p17BdCwrB9h'
 when 'DB_KB_TB_33' then 'hcGugwhTu3O'
 when 'DB_KB_TB_34' then 'EILFQTsscSK'
 when 'DB_KB_TB_35' then 'id61uY1QJLa'
 when 'DB_KB_TB_36' then 'lGlHMpP192d'
 when 'DB_KB_TB_37' then 'io3q0A52Qyb'
 when 'DB_KB_TB_38' then 'D7htTeGwXGz'
 when 'DB_KB_TB_46' then 'APFxsXKRhqM'
 when 'DB_KB_TB_47' then 'bbqxdklJwKU'
 when 'DB_KB_TB_48' then 'PyGyQc05U8A'
 when 'DB_KB_TB_49' then 'pioHnQNmehe'
 when 'DB_KB_TB_50' then 'Dkjuh5AKwcM'
 when 'DB_KB_TB_51' then 'tD1bZYdTbbM'
 when 'DB_KB_TB_52' then 'CqOOmXte7wU'
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
    dbc.name IN ('DB_KB_TB_22','DB_KB_TB_23','DB_KB_TB_24','DB_KB_TB_25','DB_KB_TB_26','DB_KB_TB_27','DB_KB_TB_28','DB_KB_TB_29','DB_KB_TB_30','DB_KB_TB_31','DB_KB_TB_32','DB_KB_TB_33','DB_KB_TB_34','DB_KB_TB_35','DB_KB_TB_36','DB_KB_TB_37','DB_KB_TB_38','DB_KB_TB_46','DB_KB_TB_47','DB_KB_TB_48','DB_KB_TB_49','DB_KB_TB_50','DB_KB_TB_51','DB_KB_TB_52')
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
