#!/bin/bash

source /home/herinomena/Images/backup_Dashboard/Dash_vers_DHIS2/EXCEL/.env
# Define MySQL credentials using environment variables
MYSQL_OPTS="--defaults-extra-file=<(printf '[client]\nuser=%s\npassword=%s\nhost=%s' \"$MYSQL_USER\" \"$MYSQL_PASSWORD\" \"$MYSQL_HOST\")"
CSV_FILE="/home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/EXCEL/DB_EX_SOC_partie2"

# Define SQL query
SQL_QUERY="SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SELECT

 CASE dbc.name  
WHEN 'DB_EX_SOC_90' THEN 'eLS3YuhtO6H'
WHEN 'DB_EX_SOC_9' THEN 'cIvc1Og54Ab'
WHEN 'DB_EX_SOC_89' THEN 'qff6kHjXzL8'
WHEN 'DB_EX_SOC_88' THEN 'WR497Y0rcCs'
WHEN 'DB_EX_SOC_87' THEN 'rlD421WQNpB'
WHEN 'DB_EX_SOC_86' THEN 'kd3dIU5qxBO'
WHEN 'DB_EX_SOC_85' THEN 'b7tbg06mBkT'
WHEN 'DB_EX_SOC_84' THEN 'C1wbyZJjG4W'
WHEN 'DB_EX_SOC_83' THEN 'e6XHJ1LuewN'
WHEN 'DB_EX_SOC_82' THEN 'b6Z5AyZNaKS'
WHEN 'DB_EX_SOC_81' THEN 'gs3tsFDgp4Y'
WHEN 'DB_EX_SOC_80' THEN 'xytsv4OR0II'
WHEN 'DB_EX_SOC_8' THEN 'KUUOkwuSBI7'
WHEN 'DB_EX_SOC_79' THEN 'cR5oz5uvl4a'
WHEN 'DB_EX_SOC_78' THEN 'xKkFaHdzcE1'
WHEN 'DB_EX_SOC_77' THEN 'bLssHsCBtL3'
WHEN 'DB_EX_SOC_76' THEN 'fi0nAKewYPT'
WHEN 'DB_EX_SOC_75' THEN 'dXpetbIjAND'
WHEN 'DB_EX_SOC_74' THEN 'Su5zTbtITEr'
WHEN 'DB_EX_SOC_73' THEN 'oExHCrAeu2t'
WHEN 'DB_EX_SOC_72' THEN 'aFzzjtFntRb'
WHEN 'DB_EX_SOC_71' THEN 'OqqeS5R3xtS'
WHEN 'DB_EX_SOC_70' THEN 'Wa8Degicj2B'
WHEN 'DB_EX_SOC_7' THEN 'IxaMJp1yjtu'
WHEN 'DB_EX_SOC_69' THEN 'lfgyD50d07m'
WHEN 'DB_EX_SOC_68' THEN 'eiWMw2hKeKn'
WHEN 'DB_EX_SOC_66' THEN 'fWGklQq7HHu'
WHEN 'DB_EX_SOC_65' THEN 'V28BnsypLCB'
WHEN 'DB_EX_SOC_64' THEN 'vuz8L7Jj07w'
WHEN 'DB_EX_SOC_63' THEN 'ncMYKdgPLLW'
WHEN 'DB_EX_SOC_62' THEN 'ykeMxtffmv5'
WHEN 'DB_EX_SOC_61' THEN 'POhiv0wH3gH'
WHEN 'DB_EX_SOC_60' THEN 'eocfZHbxKrQ'
WHEN 'DB_EX_SOC_6' THEN 'Eq4Ro0W2rNl'
WHEN 'DB_EX_SOC_59' THEN 'mM8SiG3Ig2f'
WHEN 'DB_EX_SOC_58' THEN 'jdXRXg5SEjA'
WHEN 'DB_EX_SOC_57' THEN 'f1Fj5oWyF1N'
WHEN 'DB_EX_SOC_56' THEN 'z2m4QA3f8PG'
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
    dbc.name IN ('DB_EX_SOC_90','DB_EX_SOC_9','DB_EX_SOC_89','DB_EX_SOC_88','DB_EX_SOC_87','DB_EX_SOC_86','DB_EX_SOC_85','DB_EX_SOC_84','DB_EX_SOC_83','DB_EX_SOC_82','DB_EX_SOC_81','DB_EX_SOC_80','DB_EX_SOC_8','DB_EX_SOC_79','DB_EX_SOC_78','DB_EX_SOC_77','DB_EX_SOC_76','DB_EX_SOC_75','DB_EX_SOC_74','DB_EX_SOC_73','DB_EX_SOC_72','DB_EX_SOC_71','DB_EX_SOC_70','DB_EX_SOC_7','DB_EX_SOC_69','DB_EX_SOC_68','DB_EX_SOC_67','DB_EX_SOC_66','DB_EX_SOC_65','DB_EX_SOC_64','DB_EX_SOC_63','DB_EX_SOC_62','DB_EX_SOC_61','DB_EX_SOC_60','DB_EX_SOC_6','DB_EX_SOC_59','DB_EX_SOC_58','DB_EX_SOC_57','DB_EX_SOC_56')
    AND EXTRACT(YEAR_MONTH FROM  DATE(dbdb.periode)) >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 10 MONTH), '%Y%m')
  GROUP BY cc.id,EXTRACT(YEAR_MONTH FROM DATE(dbdb.periode)),dbc.id"

# Generate timestamp for output file
TIMESTAMP=$(date +%Y%m%d%H%M%S)

# Execute SQL query and save output to CSV file
eval "mysql $MYSQL_OPTS \"$MYSQL_DATABASE\" -e \"$SQL_QUERY\"" | tail -n +1 | sed 's/\t/","/g;s/^/"/;s/$/"/;' > "${CSV_FILE}_date_$TIMESTAMP.csv"
echo "SQL query executed successfully and output saved to ${CSV_FILE}_date_$TIMESTAMP.csv"
#!/bin/bash


# Send POST request to DHIS2 endpoint with CSV file as payload and capture response to log file
curl -X POST -H "Content-Type: application/csv" -u "${DHIS2_USERNAME}:${DHIS2_PASSWORD}" --data-binary "@${CSV_FILE}_date_$TIMESTAMP.csv" "${DHIS2_URL}" > "${CSV_FILE}_date_$TIMESTAMP.log" 2>&1

# Check if request was successful or not
if [ $? -eq 0 ]; then
  echo "CSV file uploaded successfully to DHIS2 endpoint: ${DHIS2_URL}"
  echo "Response written to log file: ${CSV_FILE}_date_$TIMESTAMP.log"
else
  echo "Failed to upload CSV file to DHIS2 endpoint. Check log file for details: ${CSV_FILE}_date_$TIMESTAMP.log"
fi
