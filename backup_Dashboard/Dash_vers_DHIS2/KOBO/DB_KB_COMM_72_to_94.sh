#!/bin/bash

source /home/herinomena/Images/backup_Dashboard/Dash_vers_DHIS2/KOBO/.env
# Define MySQL credentials using environment variables
MYSQL_OPTS="--defaults-extra-file=<(printf '[client]\nuser=%s\npassword=%s\nhost=%s' \"$MYSQL_USER\" \"$MYSQL_PASSWORD\" \"$MYSQL_HOST\")"
CSV_FILE="/home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/KOBO/DB_KB_COMM_72_to_94"

# Define SQL query
SQL_QUERY="SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SELECT  
 Case dbc.name 
 when 'DB_KB_COMM_72' then 'T5sgmrQJF1y'
 when 'DB_KB_COMM_73' then 'RfIBzvkCblT'
 when 'DB_KB_COMM_74' then 'ZFcoNtoPeie'
 when 'DB_KB_COMM_75' then 'otx1TXa0kUw'
 when 'DB_KB_COMM_76' then 'YjjJ712Tjlv'
 when 'DB_KB_COMM_77' then 'bJ4U8BY08Sw'
 when 'DB_KB_COMM_78' then 'YAcOauWLXOh'
 when 'DB_KB_COMM_79' then 'z4xPLNyGzRY'
 when 'DB_KB_COMM_80' then 'TH7Pol2KG97'
 when 'DB_KB_COMM_81' then 'dWwZTuz9ywP'
 when 'DB_KB_COMM_82' then 'LQh3z5cn6Sn'
 when 'DB_KB_COMM_83' then 'TIP7yrrgq6L'
 when 'DB_KB_COMM_84' then 'dEeHpvmIDIZ'
 when 'DB_KB_COMM_85' then 'sCRcrk88HfU'
 when 'DB_KB_COMM_86' then 'CcBJ9R1cTeS'
 when 'DB_KB_COMM_87' then 'nHqha7gOCEB'
 when 'DB_KB_COMM_88' then 'BvYRfsPPVX0'
 when 'DB_KB_COMM_89' then 'Hc1IoeAYeVn'
 when 'DB_KB_COMM_90' then 'Re1TKSQlOc2'
 when 'DB_KB_COMM_91' then 'mmgVIJKwPvf'
 when 'DB_KB_COMM_92' then 'qzEMckqw0Rg'
 when 'DB_KB_COMM_93' then 't2r6zBDicjO'
 when 'DB_KB_COMM_94' then 'RbHiLInXasu'
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
    dbc.name IN ('DB_KB_COMM_72','DB_KB_COMM_73','DB_KB_COMM_74','DB_KB_COMM_75','DB_KB_COMM_76','DB_KB_COMM_77','DB_KB_COMM_78','DB_KB_COMM_79','DB_KB_COMM_80','DB_KB_COMM_81','DB_KB_COMM_82','DB_KB_COMM_83','DB_KB_COMM_84','DB_KB_COMM_85','DB_KB_COMM_86','DB_KB_COMM_87','DB_KB_COMM_88','DB_KB_COMM_89','DB_KB_COMM_90','DB_KB_COMM_91','DB_KB_COMM_92','DB_KB_COMM_93','DB_KB_COMM_94')
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
