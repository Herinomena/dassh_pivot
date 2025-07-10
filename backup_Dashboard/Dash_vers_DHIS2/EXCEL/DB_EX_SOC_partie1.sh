#!/bin/bash


source /home/herinomena/Images/backup_Dashboard/Dash_vers_DHIS2/EXCEL/.env
# Define MySQL credentials using environment variables
MYSQL_OPTS="--defaults-extra-file=<(printf '[client]\nuser=%s\npassword=%s\nhost=%s' \"$MYSQL_USER\" \"$MYSQL_PASSWORD\" \"$MYSQL_HOST\")"
CSV_FILE="/home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/EXCEL/DB_EX_SOC_partie1"

# Define SQL query
SQL_QUERY="SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SELECT

	CASE dbc.name  
		WHEN 'DB_EX_SOC_57' THEN 'f1Fj5oWyF1N'
		WHEN 'DB_EX_SOC_56' THEN 'z2m4QA3f8PG'
		WHEN 'DB_EX_SOC_55' THEN 'w3cYUQdOcst'
		WHEN 'DB_EX_SOC_54' THEN 'cMyGhXWiFEG'
		WHEN 'DB_EX_SOC_53' THEN 'bluHw8BMkin'
		WHEN 'DB_EX_SOC_52' THEN 'P8193XVgGCf'
		WHEN 'DB_EX_SOC_51' THEN 'o4GEgFUOvKG'
		WHEN 'DB_EX_SOC_50' THEN 'u7ouTHB96xe'
		WHEN 'DB_EX_SOC_5' THEN 'VuFGLXOe1cB'
		WHEN 'DB_EX_SOC_49' THEN 'ih9tWstzgQ6'
		WHEN 'DB_EX_SOC_48' THEN 'SNMQVs7tm4d'
		WHEN 'DB_EX_SOC_47' THEN 'it4ZncIUip8'
		WHEN 'DB_EX_SOC_46' THEN 'IW9V9CgU8eR'
		WHEN 'DB_EX_SOC_45' THEN 'Yrqu453hxXU'
		WHEN 'DB_EX_SOC_44' THEN 'Upde88fuhko'
		WHEN 'DB_EX_SOC_4' THEN 'D7dS9rg8UEp'
		WHEN 'DB_EX_SOC_31' THEN 'Kzo4l40hd3G'
		WHEN 'DB_EX_SOC_30' THEN 'qvUB9vFYwHT'
		WHEN 'DB_EX_SOC_3' THEN 'XjJV5jcEfiv'
		WHEN 'DB_EX_SOC_29' THEN 'MuP5U2lVxD5'
		WHEN 'DB_EX_SOC_28' THEN 'sZfy7nK6cRS'
		WHEN 'DB_EX_SOC_27' THEN 'rN7aeiNMK08'
		WHEN 'DB_EX_SOC_26' THEN 'vcUoN9FggVZ'
		WHEN 'DB_EX_SOC_25' THEN 'ODq7DFD65Hw'
		WHEN 'DB_EX_SOC_24' THEN 'EbX2eyFYwmh'
		WHEN 'DB_EX_SOC_23' THEN 'UROlx3sR8qp'
		WHEN 'DB_EX_SOC_22' THEN 'Rk2Kjtj4R4d'
		WHEN 'DB_EX_SOC_21' THEN 'GR5dRp4L6sa'
		WHEN 'DB_EX_SOC_20' THEN 'HhUxJ83ceYp'
		WHEN 'DB_EX_SOC_2' THEN 'yN3jcO4r8N8'
		WHEN 'DB_EX_SOC_19' THEN 'IO3njLhqV3E'
		WHEN 'DB_EX_SOC_18' THEN 'ZWBA1Ji1rRq'
		WHEN 'DB_EX_SOC_17' THEN 'wcUmvgYHtck'
		WHEN 'DB_EX_SOC_16' THEN 'dD0dlcX8xca'
		WHEN 'DB_EX_SOC_14' THEN 'v9lrwaH6cUS'
		WHEN 'DB_EX_SOC_13' THEN 'pkyWkGaP05E'
		WHEN 'DB_EX_SOC_12' THEN 'xhRMMW7ulkS'
		WHEN 'DB_EX_SOC_11' THEN 'luyjjE8ggNF'
		WHEN 'DB_EX_SOC_10' THEN 'NArrb1D9KJv'
		WHEN 'DB_EX_SOC_1' THEN 'TgGEimPwOFi'
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
    dbc.name IN ('DB_EX_SOC_55','DB_EX_SOC_54','DB_EX_SOC_53','DB_EX_SOC_52','DB_EX_SOC_51','DB_EX_SOC_50','DB_EX_SOC_5','DB_EX_SOC_49','DB_EX_SOC_48','DB_EX_SOC_47','DB_EX_SOC_46','DB_EX_SOC_45','DB_EX_SOC_44','DB_EX_SOC_4','DB_EX_SOC_31','DB_EX_SOC_30','DB_EX_SOC_3','DB_EX_SOC_29','DB_EX_SOC_28','DB_EX_SOC_27','DB_EX_SOC_26','DB_EX_SOC_25','DB_EX_SOC_24','DB_EX_SOC_23','DB_EX_SOC_22','DB_EX_SOC_21','DB_EX_SOC_20','DB_EX_SOC_2','DB_EX_SOC_19','DB_EX_SOC_18','DB_EX_SOC_17','DB_EX_SOC_16','DB_EX_SOC_14','DB_EX_SOC_13','DB_EX_SOC_12','DB_EX_SOC_11','DB_EX_SOC_10','DB_EX_SOC_1')
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
