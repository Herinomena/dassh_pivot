#!/bin/bash

source /home/herinomena/Images/backup_Dashboard/Dash_vers_DHIS2/KOBO/.env
# Define MySQL credentials using environment variables
MYSQL_OPTS="--defaults-extra-file=<(printf '[client]\nuser=%s\npassword=%s\nhost=%s' \"$MYSQL_USER\" \"$MYSQL_PASSWORD\" \"$MYSQL_HOST\")"
CSV_FILE="/home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/KOBO/DB_REF_1_to_12_DB_KB_PHARMA_1_to_19"


# Define SQL query
SQL_QUERY="SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SELECT  
 Case dbc.name 
 when 'DB_KB_REF_1' then 'zGjbpx61cCh'
 when 'DB_KB_REF_2' then 'D2dzPrxMitN'
 when 'DB_KB_REF_3' then 'bQoyrzm0zO3'
 when 'DB_KB_REF_4' then 'rsUv7FRU87y'
 when 'DB_KB_REF_5' then 'uka4EBne7sG'
 when 'DB_KB_REF_6' then 'Iok8CQ21P6T'
 when 'DB_KB_REF_7' then 'SqQZb1ez2Ry'
 when 'DB_KB_REF_8' then 'd5m9Z2Vz6w5'
 when 'DB_KB_REF_9' then 'bCnUjsWrikJ'
 when 'DB_KB_REF_10' then 'MiiiqGvCxEw'
 when 'DB_KB_REF_11' then 'g1TyZQHH6E9'
 when 'DB_KB_REF_12' then 'TA8jfCrNWTl'
 when 'DB_KB_PHARMA_1' then 'pTHtjS4fwPd'
 when 'DB_KB_PHARMA_2' then 'g5I0h2R30qC'
 when 'DB_KB_PHARMA_3' then 'gahdTzetC7I'
 when 'DB_KB_PHARMA_4' then 'KEK1EXggHRC'
 when 'DB_KB_PHARMA_5' then 'pb0PRR9l6np'
 when 'DB_KB_PHARMA_6' then 'fQJ6FauTlYr'
 when 'DB_KB_PHARMA_7' then 'KdR24DNEsR0'
 when 'DB_KB_PHARMA_8' then 'WOceMNJE3Gk'
 when 'DB_KB_PHARMA_9' then 'wuOYA0F9bFJ'
  when 'DB_KB_PHARMA_10' then 'bUqQvXH31Nm'
 when 'DB_KB_PHARMA_11' then 'c7I07m89OSU'
 when 'DB_KB_PHARMA_12' then 'sxBKLGbQies'
 when 'DB_KB_PHARMA_13' then 'zTPzsPCxBYQ'
 when 'DB_KB_PHARMA_14' then 'HdxWUYDJ5P6'
 when 'DB_KB_PHARMA_15' then 'ukDLsp0NmOO'
 when 'DB_KB_PHARMA_16' then 'kZQbUX3Hr5u'
 when 'DB_KB_PHARMA_17' then 'ea8VjdtRy53'
 when 'DB_KB_PHARMA_18' then 'FhyjF6kL2c6'
 when 'DB_KB_PHARMA_19' then 'Gwe5DzAOEL9'
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
    dbc.name IN ('DB_KB_REF_1','DB_KB_REF_2','DB_KB_REF_3','DB_KB_REF_4','DB_KB_REF_5','DB_KB_REF_6','DB_KB_REF_7','DB_KB_REF_8','DB_KB_REF_9','DB_KB_REF_10','DB_KB_REF_11','DB_KB_REF_12','DB_KB_PHARMA_1','DB_KB_PHARMA_2','DB_KB_PHARMA_3','DB_KB_PHARMA_4','DB_KB_PHARMA_5','DB_KB_PHARMA_6','DB_KB_PHARMA_7','DB_KB_PHARMA_8','DB_KB_PHARMA_9','DB_KB_PHARMA_10','DB_KB_PHARMA_11','DB_KB_PHARMA_12','DB_KB_PHARMA_13','DB_KB_PHARMA_14','DB_KB_PHARMA_15','DB_KB_PHARMA_16','DB_KB_PHARMA_17','DB_KB_PHARMA_18','DB_KB_PHARMA_19')
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
