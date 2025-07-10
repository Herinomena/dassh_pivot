#!/bin/bash

source /home/herinomena/Images/backup_Dashboard/Dash_vers_DHIS2/KOBO/.env
# Define MySQL credentials using environment variables
MYSQL_OPTS="--defaults-extra-file=<(printf '[client]\nuser=%s\npassword=%s\nhost=%s' \"$MYSQL_USER\" \"$MYSQL_PASSWORD\" \"$MYSQL_HOST\")"
CSV_FILE="/home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/KOBO/DB_KB_SOC_7_to_40"


# Define SQL query
SQL_QUERY="SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SELECT  
 Case dbc.name 
 when 'DB_KB_SOC_7' then 'sbR8mlX7zcT'
 when 'DB_KB_SOC_8' then 'UwAE5oqsgy4'
 when 'DB_KB_SOC_9' then 'yCyFn2NLhGE'
 when 'DB_KB_SOC_10' then 'mnGcclJ7f2L'
 when 'DB_KB_SOC_11' then 'C2nb2NTCWXC'
 when 'DB_KB_SOC_18' then 'pQk2xvYpOrU'
 when 'DB_KB_SOC_19' then 'nyoDu0XUCQD'
 when 'DB_KB_SOC_20' then 'EcwGKtwZWaW'
 when 'DB_KB_SOC_21' then 'MDkaJH5IQMB'
 when 'DB_KB_SOC_22' then 'Ge4Tz1BCcYE'
 when 'DB_KB_SOC_23' then 'YJnSItKs7Ak'
 when 'DB_KB_SOC_24' then 'vebP5hxoFQl'
 when 'DB_KB_SOC_25' then 'HVUhiDPn9av'
 when 'DB_KB_SOC_26' then 'CjTyMLTGXpL'
 when 'DB_KB_SOC_27' then 'q1hRP24M7Qd'
 when 'DB_KB_SOC_28' then 'GnGpp4UdDoG'
 when 'DB_KB_SOC_29' then 'XcVDnVE49cq'
 when 'DB_KB_SOC_30' then 'OU5AvTpHtlw'
 when 'DB_KB_SOC_31' then 'dO7YdZvspJD'
 when 'DB_KB_SOC_32' then 'FR2iETwg2a4'
 when 'DB_KB_SOC_33' then 'HFnkFzv5lqO'
 when 'DB_KB_SOC_34' then 'mlqrIbS0cPg'
 when 'DB_KB_SOC_35' then 'l2P7TxKqIAm'
 when 'DB_KB_SOC_36' then 'H1k0v3Eroim'
 when 'DB_KB_SOC_37' then 'tJ12HJIVr5S'
 when 'DB_KB_SOC_38' then 'ME9rtjjHBCk'
 when 'DB_KB_SOC_39' then 'KMog5rrzQwR'
 when 'DB_KB_SOC_40' then 'EQYLXLQr3ee'
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
    dbc.name IN ('DB_KB_SOC_7','DB_KB_SOC_8','DB_KB_SOC_33','DB_KB_SOC_34','DB_KB_SOC_9','DB_KB_SOC_28','DB_KB_SOC_29','DB_KB_SOC_30','DB_KB_SOC_31','DB_KB_SOC_35','DB_KB_SOC_36','DB_KB_SOC_37','DB_KB_SOC_38','DB_KB_SOC_39','DB_KB_SOC_10','DB_KB_SOC_40','DB_KB_SOC_11','DB_KB_SOC_26','DB_KB_SOC_32','DB_KB_SOC_18''DB_KB_SOC_19','DB_KB_SOC_20','DB_KB_SOC_21','DB_KB_SOC_22','DB_KB_SOC_23','DB_KB_SOC_24','DB_KB_SOC_25','DB_KB_SOC_27')
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
