#!/bin/bash

source /home/herinomena/Images/backup_Dashboard/Dash_vers_DHIS2/KOBO/.env
# Define MySQL credentials using environment variables
MYSQL_OPTS="--defaults-extra-file=<(printf '[client]\nuser=%s\npassword=%s\nhost=%s' \"$MYSQL_USER\" \"$MYSQL_PASSWORD\" \"$MYSQL_HOST\")"
CSV_FILE="/home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/KOBO/DB_KB_PALU_1_to_20"



# Define SQL query
SQL_QUERY="SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SELECT  
 Case dbc.name
 when 'DB_KB_PALU_1' then 'nt8IM6rfocZ'
 when 'DB_KB_PALU_2' then 'BmJxUjMq7hY'
 when 'DB_KB_PALU_3' then 'FwCN3ACDk84'
 when 'DB_KB_PALU_4' then 'CxQUO7chdFq'
 when 'DB_KB_PALU_5' then 'Fc1vQwpk08U'
 when 'DB_KB_PALU_6' then 'ZKWzB2i6Li7'
 when 'DB_KB_PALU_7' then 'nucCEtoeClN'
 when 'DB_KB_PALU_8' then 'kV5P9HxHWHV'
 when 'DB_KB_PALU_9' then 'rpwPTVmAe2j'
 when 'DB_KB_PALU_10' then 'M7ZTms09KWN'
 when 'DB_KB_PALU_11' then 'pyxmTjUy87I'
 when 'DB_KB_PALU_12' then 'Eu7OkafjTAR'
 when 'DB_KB_PALU_13' then 'FxSV12zuLNa'
 when 'DB_KB_PALU_14' then 'PmMru6j8jqS'
 when 'DB_KB_PALU_15' then 'TEsw82kOC9v'
 when 'DB_KB_PALU_16' then 'yW074EinJC6'
 when 'DB_KB_PALU_17' then 'rmyaKM4dXtO'
 when 'DB_KB_PALU_18' then 'GbGXtYC1dl2'
 when 'DB_KB_PALU_19' then 'idej5Vj92PS'
 when 'DB_KB_PALU_20' then 'ZtvZU4hBnGM'
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
    dbc.name IN ('DB_KB_PALU_1','DB_KB_PALU_2','DB_KB_PALU_3','DB_KB_PALU_4','DB_KB_PALU_5','DB_KB_PALU_6','DB_KB_PALU_7','DB_KB_PALU_8','DB_KB_PALU_9','DB_KB_PALU_10','DB_KB_PALU_11','DB_KB_PALU_12','DB_KB_PALU_13','DB_KB_PALU_14','DB_KB_PALU_15','DB_KB_PALU_16','DB_KB_PALU_17','DB_KB_PALU_18','DB_KB_PALU_19','DB_KB_PALU_20')
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
