#!/bin/bash

source /home/herinomena/Images/backup_Dashboard/Dash_vers_DHIS2/KOBO/.env
# Define MySQL credentials using environment variables
MYSQL_OPTS="--defaults-extra-file=<(printf '[client]\nuser=%s\npassword=%s\nhost=%s' \"$MYSQL_USER\" \"$MYSQL_PASSWORD\" \"$MYSQL_HOST\")"
CSV_FILE="/home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/KOBO/DB_KB_CRENAS_1_to_21"


# Define SQL query
SQL_QUERY="SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SELECT  
 Case dbc.name 
 when 'DB_KB_CRENAS_1' then 'VC62M134gr9'
 when 'DB_KB_CRENAS_2' then 'u9glPU257K0'
 when 'DB_KB_CRENAS_3' then 'x26eKyU7hSM'
 when 'DB_KB_CRENAS_4' then 'ggFSeAq7FBB'
 when 'DB_KB_CRENAS_5' then 'wFWw6dA2YmT'
 when 'DB_KB_CRENAS_7' then 'dLp3Ejw4Qvx'
 when 'DB_KB_CRENAS_8' then 'd3Uc7BSsJOM'
 when 'DB_KB_CRENAS_9' then 'YzzccntEND6'
 when 'DB_KB_CRENAS_11' then 'IFUmsuqQUeQ'
 when 'DB_KB_CRENAS_12' then 'Nh1oZ1TWFFP'
 when 'DB_KB_CRENAS_13' then 'GyU5fmOLA5o'
 when 'DB_KB_CRENAS_14' then 'ycMIfD278nm'
 when 'DB_KB_CRENAS_15' then 'DpYQuiMhSOf'
 when 'DB_KB_CRENAS_16' then 'y2hdTTsyV48'
 when 'DB_KB_CRENAS_17' then 'vTxvTvvCO7Y'
 when 'DB_KB_CRENAS_18' then 'YLPaFkAgyRX'
 when 'DB_KB_CRENAS_19' then 'SuycA3cmWYq'
 when 'DB_KB_CRENAS_20' then 'zU9KZvcoyaJ'
 when 'DB_KB_CRENAS_21' then 'FrmEHG1yn20'
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
    dbc.name IN ('DB_KB_CRENAS_1','DB_KB_CRENAS_2','DB_KB_CRENAS_3','DB_KB_CRENAS_4','DB_KB_CRENAS_5','DB_KB_CRENAS_7','DB_KB_CRENAS_8','DB_KB_CRENAS_9','DB_KB_CRENAS_11','DB_KB_CRENAS_12','DB_KB_CRENAS_13','DB_KB_CRENAS_14','DB_KB_CRENAS_15','DB_KB_CRENAS_16','DB_KB_CRENAS_17','DB_KB_CRENAS_18','DB_KB_CRENAS_19','DB_KB_CRENAS_20','DB_KB_CRENAS_21')
    AND EXTRACT(YEAR_MONTH FROM  DATE(dbdb.periode)) >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 4 MONTH), '%Y%m')
    GROUP BY cc.id  , EXTRACT(YEAR_MONTH FROM DATE(dbdb.periode)),dbc.id
    "

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
