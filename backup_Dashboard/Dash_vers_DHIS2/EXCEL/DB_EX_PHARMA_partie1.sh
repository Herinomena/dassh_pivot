#!/bin/bash

source /home/herinomena/Images/backup_Dashboard/Dash_vers_DHIS2/EXCEL/.env
# Define MySQL credentials using environment variables
MYSQL_OPTS="--defaults-extra-file=<(printf '[client]\nuser=%s\npassword=%s\nhost=%s' \"$MYSQL_USER\" \"$MYSQL_PASSWORD\" \"$MYSQL_HOST\")"
CSV_FILE="/home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/EXCEL/DB_EX_PHARMA_partie1"


# Define SQL query
SQL_QUERY="SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SELECT
	CASE dbc.name
		WHEN 'DB_EX_PHARMA_91' THEN 'WMxytDTTKGD'
		WHEN 'DB_EX_PHARMA_90' THEN 's6c2HMk4bno'
		WHEN 'DB_EX_PHARMA_9' THEN 'sIiYwY1NkXk'
		WHEN 'DB_EX_PHARMA_89' THEN 'f4w1x43Nye2'
		WHEN 'DB_EX_PHARMA_88' THEN 'nsC6t3VUHoz'
		WHEN 'DB_EX_PHARMA_87' THEN 'qYE84rJKcB9'
		WHEN 'DB_EX_PHARMA_86' THEN 'O6gxYzMO94V'
		WHEN 'DB_EX_PHARMA_85' THEN 'Rjm9f6OPXkC'
		WHEN 'DB_EX_PHARMA_84' THEN 'CjAhW12LIoV'
		WHEN 'DB_EX_PHARMA_83' THEN 'QoJ0KlPwpTU'
		WHEN 'DB_EX_PHARMA_82' THEN 'TbwzD0yKQrz'
		WHEN 'DB_EX_PHARMA_81' THEN 'GboDzxuWBwf'
		WHEN 'DB_EX_PHARMA_80' THEN 'GeVt7DPspDw'
		WHEN 'DB_EX_PHARMA_8' THEN 'IsC5hNS7Clw'
		WHEN 'DB_EX_PHARMA_79' THEN 'Uz2BcNKGFOZ'
		WHEN 'DB_EX_PHARMA_78' THEN 'UcgEoXyOSWf'
		WHEN 'DB_EX_PHARMA_77' THEN 'w4LJ0fwBFTU'
		WHEN 'DB_EX_PHARMA_76' THEN 'PcyqcbaS75u'
		WHEN 'DB_EX_PHARMA_75' THEN 'BYpNugZIXNB'
		WHEN 'DB_EX_PHARMA_74' THEN 'PrLR25ProwV'
		WHEN 'DB_EX_PHARMA_73' THEN 'vIko5LA72eq'
		WHEN 'DB_EX_PHARMA_72' THEN 'PcBStlZCWfI'
		WHEN 'DB_EX_PHARMA_71' THEN 'Z1LEcyOpfuX'
		WHEN 'DB_EX_PHARMA_70' THEN 'POThVbMuJEQ'
		WHEN 'DB_EX_PHARMA_7' THEN 'zukVTltNjyT'
		WHEN 'DB_EX_PHARMA_69' THEN 'wU7HHp0dn3h'
		WHEN 'DB_EX_PHARMA_68' THEN 'DBpFSnU6AXQ'
		WHEN 'DB_EX_PHARMA_67' THEN 'dOyL10RXAdQ'
		WHEN 'DB_EX_PHARMA_66' THEN 'hKI9KZmygGq'
		WHEN 'DB_EX_PHARMA_65' THEN 'uZOyQWX4qGa'
		WHEN 'DB_EX_PHARMA_64' THEN 'z55x78vcplZ'
		WHEN 'DB_EX_PHARMA_63' THEN 'SDYNw67RLOO'
		WHEN 'DB_EX_PHARMA_62' THEN 'eW7xVc4ZTRk'
		WHEN 'DB_EX_PHARMA_61' THEN 'yBJC3TB2rz5'
		WHEN 'DB_EX_PHARMA_60' THEN 'q7DMei9O6oc'
		WHEN 'DB_EX_PHARMA_6' THEN 'bKqwn35Ei1o'
		WHEN 'DB_EX_PHARMA_59' THEN 'cNOhxk8yfZx'
		WHEN 'DB_EX_PHARMA_58' THEN 'mdkTtm9G3i6'
		WHEN 'DB_EX_PHARMA_57' THEN 'qRycCDC1UMI'
		WHEN 'DB_EX_PHARMA_56' THEN 'z5bSTRtXbii'
		WHEN 'DB_EX_PHARMA_55' THEN 'sAprF39bWzE'
		WHEN 'DB_EX_PHARMA_54' THEN 'R8EOMoeZmu4'
		WHEN 'DB_EX_PHARMA_53' THEN 'WS2xtNiaN76'
		WHEN 'DB_EX_PHARMA_52' THEN 'YP3ejAeLeQW'
		WHEN 'DB_EX_PHARMA_51' THEN 'y33WhXpNmxh'
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
    dbc.name IN ('DB_EX_PHARMA_91','DB_EX_PHARMA_90','DB_EX_PHARMA_9','DB_EX_PHARMA_89','DB_EX_PHARMA_88','DB_EX_PHARMA_87','DB_EX_PHARMA_86','DB_EX_PHARMA_85','DB_EX_PHARMA_84','DB_EX_PHARMA_83','DB_EX_PHARMA_82','DB_EX_PHARMA_81','DB_EX_PHARMA_80','DB_EX_PHARMA_8','DB_EX_PHARMA_79','DB_EX_PHARMA_78','DB_EX_PHARMA_77','DB_EX_PHARMA_76','DB_EX_PHARMA_75','DB_EX_PHARMA_74','DB_EX_PHARMA_73','DB_EX_PHARMA_72','DB_EX_PHARMA_71','DB_EX_PHARMA_70','DB_EX_PHARMA_7','DB_EX_PHARMA_69','DB_EX_PHARMA_68','DB_EX_PHARMA_67','DB_EX_PHARMA_66','DB_EX_PHARMA_65','DB_EX_PHARMA_64','DB_EX_PHARMA_63','DB_EX_PHARMA_62','DB_EX_PHARMA_61','DB_EX_PHARMA_60','DB_EX_PHARMA_6','DB_EX_PHARMA_59','DB_EX_PHARMA_58','DB_EX_PHARMA_57','DB_EX_PHARMA_56','DB_EX_PHARMA_55','DB_EX_PHARMA_54','DB_EX_PHARMA_53','DB_EX_PHARMA_52','DB_EX_PHARMA_51')
    AND EXTRACT(YEAR_MONTH FROM  DATE(dbdb.periode)) >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 10 MONTH), '%Y%m')
    GROUP BY cc.id,EXTRACT(YEAR_MONTH FROM DATE(dbdb.periode)),dbc.id"

# Generate timestamp for output file
TIMESTAMP=$(date +%Y%m%d%H%M%S)

# Execute SQL query and save output to CSV file
eval "mysql $MYSQL_OPTS \"$MYSQL_DATABASE\" -e \"$SQL_QUERY\"" | tail -n +1 | sed 's/\t/","/g;s/^/"/;s/$/"/;' > "${CSV_FILE}_date_$TIMESTAMP.csv"

echo "SQL query executed successfully and output saved to ${CSV_FILE}_date_$TIMESTAMP.csv"


# Define path to CSV file
# CSV_FILE="/home/lrakotovoavy/PIVOT/Travail_PIVOT/DEV/DHIS/Migration/initMigration/AdmissionCrenasCreni06_20230419151722.csv"

# Send POST request to DHIS2 endpoint with CSV file as payload and capture response to log file
curl -X POST -H "Content-Type: application/csv" -u "${DHIS2_USERNAME}:${DHIS2_PASSWORD}" --data-binary "@${CSV_FILE}_date_$TIMESTAMP.csv" "${DHIS2_URL}" > "${CSV_FILE}_date_$TIMESTAMP.log" 2>&1

# Check if request was successful or not
if [ $? -eq 0 ]; then
  echo "CSV file uploaded successfully to DHIS2 endpoint: ${DHIS2_URL}"
  echo "Response written to log file: ${CSV_FILE}_date_$TIMESTAMP.log"
else
  echo "Failed to upload CSV file to DHIS2 endpoint. Check log file for details: ${CSV_FILE}_date_$TIMESTAMP.log"
fi
