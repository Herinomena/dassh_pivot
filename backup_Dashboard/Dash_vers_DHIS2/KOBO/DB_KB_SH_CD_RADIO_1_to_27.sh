#!/bin/bash

source /home/herinomena/Images/backup_Dashboard/Dash_vers_DHIS2/KOBO/.env
# Define MySQL credentials using environment variables
MYSQL_OPTS="--defaults-extra-file=<(printf '[client]\nuser=%s\npassword=%s\nhost=%s' \"$MYSQL_USER\" \"$MYSQL_PASSWORD\" \"$MYSQL_HOST\")"
CSV_FILE="/home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/KOBO/DB_KB_SH_CD_RADIO_1_to_27"


# Define SQL query
SQL_QUERY="SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SELECT  
 Case dbc.name
 when 'DB_KB_SH_CD_RADIO_1' then 'TSjNtck3fkG'
 when 'DB_KB_SH_CD_RADIO_2' then 'ociWPmgYZ1G'
 when 'DB_KB_SH_CD_RADIO_3' then 'DgLm7Xyoygr'
 when 'DB_KB_SH_CD_RADIO_4' then 'anp8LB9oeMe'
 when 'DB_KB_SH_CD_RADIO_5' then 'WXgDtGvl2gw'
 when 'DB_KB_SH_CD_RADIO_6' then 'EojATJHb9Oh'
 when 'DB_KB_SH_CD_RADIO_7' then 'BY8OHtKtPCe'
 when 'DB_KB_SH_CD_RADIO_8' then 'DbE4F6AxhJd'
 when 'DB_KB_SH_CD_RADIO_9' then 'XTqA47AvEYH'
 when 'DB_KB_SH_CD_RADIO_10' then 'aj9HlgQMrvE'
 when 'DB_KB_SH_CD_RADIO_11' then 'WXkvt3JcLcE'
 when 'DB_KB_SH_CD_RADIO_12' then 'f7VgnQfFAyG'
 when 'DB_KB_SH_CD_RADIO_13' then 'GnzqmTyJP2N'
 when 'DB_KB_SH_CD_RADIO_14' then 'QGVZY7quRsD'
 when 'DB_KB_SH_CD_RADIO_15' then 'TyoQ8FijBca'
 when 'DB_KB_SH_CD_RADIO_16' then 'uBG3qGKFcgl'
 when 'DB_KB_SH_CD_RADIO_17' then 'PcM7EposHrF'
 when 'DB_KB_SH_CD_RADIO_18' then 'hYAgCPzW4yP'
 when 'DB_KB_SH_CD_RADIO_19' then 'SCik1BVkqSO'
 when 'DB_KB_SH_CD_RADIO_20' then 'iTJX4BHNeRW'
 when 'DB_KB_SH_CD_RADIO_21' then 'AlOr8H4YtBZ'
 when 'DB_KB_SH_CD_RADIO_22' then 'qY5G0pRUAVK'
 when 'DB_KB_SH_CD_RADIO_23' then 'Co8SGXdAWHi'
 when 'DB_KB_SH_CD_RADIO_24' then 'ZdyXoKvPji8'
 when 'DB_KB_SH_CD_RADIO_25' then 'UBEE4D3ZOwO'
 when 'DB_KB_SH_CD_RADIO_26' then 'iuYfCAKkFgz'
 when 'DB_KB_SH_CD_RADIO_27' then 'IMRs9VdlIZ7'
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
    dbc.name IN ('DB_KB_SH_CD_RADIO_1','DB_KB_SH_CD_RADIO_2','DB_KB_SH_CD_RADIO_3','DB_KB_SH_CD_RADIO_4','DB_KB_SH_CD_RADIO_5','DB_KB_SH_CD_RADIO_6','DB_KB_SH_CD_RADIO_7','DB_KB_SH_CD_RADIO_8','DB_KB_SH_CD_RADIO_9','DB_KB_SH_CD_RADIO_10','DB_KB_SH_CD_RADIO_11','DB_KB_SH_CD_RADIO_12','DB_KB_SH_CD_RADIO_13','DB_KB_SH_CD_RADIO_14','DB_KB_SH_CD_RADIO_15','DB_KB_SH_CD_RADIO_16','DB_KB_SH_CD_RADIO_17','DB_KB_SH_CD_RADIO_18','DB_KB_SH_CD_RADIO_19','DB_KB_SH_CD_RADIO_20','DB_KB_SH_CD_RADIO_21','DB_KB_SH_CD_RADIO_22','DB_KB_SH_CD_RADIO_23','DB_KB_SH_CD_RADIO_24','DB_KB_SH_CD_RADIO_25','DB_KB_SH_CD_RADIO_26','DB_KB_SH_CD_RADIO_27')
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
