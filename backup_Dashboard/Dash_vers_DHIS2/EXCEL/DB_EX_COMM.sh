#!/bin/bash

source /home/herinomena/Images/backup_Dashboard/Dash_vers_DHIS2/EXCEL/.env
# Define MySQL credentials using environment variables
MYSQL_OPTS="--defaults-extra-file=<(printf '[client]\nuser=%s\npassword=%s\nhost=%s' \"$MYSQL_USER\" \"$MYSQL_PASSWORD\" \"$MYSQL_HOST\")"
CSV_FILE="/home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/EXCEL/DB_EX_COMM"

# Define SQL query
SQL_QUERY="SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SELECT
	CASE dbc.name
		WHEN 'DB_EX_COMM_186' THEN 'u6POqVnIylo'
		WHEN 'DB_EX_COMM_185' THEN 'Ky2okaTt56G'
		WHEN 'DB_EX_COMM_184' THEN 'wHHWPz5Bhf8'
		WHEN 'DB_EX_COMM_183' THEN 'pHcTBbKuihL'
		WHEN 'DB_EX_COMM_182' THEN 'YX5pbn2HjWC'
		WHEN 'DB_EX_COMM_181' THEN 'E7aFAqdqAQR'
		WHEN 'DB_EX_COMM_180' THEN 'a7ib9HxovTZ'
		WHEN 'DB_EX_COMM_179' THEN 'PxOLIRJJowZ'
		WHEN 'DB_EX_COMM_178' THEN 'B27So9BxwW7'
		WHEN 'DB_EX_COMM_177' THEN 'WpxI3pT1PCe'
		WHEN 'DB_EX_COMM_176' THEN 'uHgEDJ95bCF'
		WHEN 'DB_EX_COMM_175' THEN 'eE3FEidMw9h'
		WHEN 'DB_EX_COMM_174' THEN 'hQL8ZawyY81'
		WHEN 'DB_EX_COMM_173' THEN 'KKhIqVCHkt7'
		WHEN 'DB_EX_COMM_172' THEN 'wGEY9vxmWPe'
		WHEN 'DB_EX_COMM_171' THEN 'pE5SryTXsEc'
		WHEN 'DB_EX_COMM_170' THEN 'Vnu2JPDTWc5'
		WHEN 'DB_EX_COMM_169' THEN 'NFQgJR1ZCuI'
		WHEN 'DB_EX_COMM_168' THEN 'viN4s7er51C'
		WHEN 'DB_EX_COMM_167' THEN 'lHWs0PO6hMU'
		WHEN 'DB_EX_COMM_166' THEN 'DCBHR9baRvx'
		WHEN 'DB_EX_COMM_165' THEN 'xG9Ts2QQ2zU'
		WHEN 'DB_EX_COMM_164' THEN 'coC0WpUrVkP'
		WHEN 'DB_EX_COMM_163' THEN 'M5MsgQS6XN5'
		WHEN 'DB_EX_COMM_162' THEN 'mDWWXKjDq6S'
		WHEN 'DB_EX_COMM_160' THEN 'kRkDUS6KGQU'
		WHEN 'DB_EX_COMM_159' THEN 'bWnORIPd3y8'
		WHEN 'DB_EX_COMM_158' THEN 'V2ro5dzpXR7'
		WHEN 'DB_EX_COMM_157' THEN 'qqCVBn4JZZw'
		WHEN 'DB_EX_COMM_156' THEN 'V2aphDkwQUO'
		WHEN 'DB_EX_COMM_155' THEN 'Bb56sQL7xHq'
		WHEN 'DB_EX_COMM_154' THEN 'Tb3c0ei65ns'
		WHEN 'DB_EX_COMM_153' THEN 'w5saUr1jQBd'
		WHEN 'DB_EX_COMM_152' THEN 'zk2yAzUWJIG'
		WHEN 'DB_EX_COMM_151' THEN 'r6w0xpKLaZQ'
		WHEN 'DB_EX_COMM_150' THEN 'rhSV6b8zEqk'
		WHEN 'DB_EX_COMM_149' THEN 'xSTQCNxPfDX'
		WHEN 'DB_EX_COMM_148' THEN 'uIA8HBtld7q'
		WHEN 'DB_EX_COMM_147' THEN 'AhvXIgT7NAR'
		WHEN 'DB_EX_COMM_146' THEN 'LaKZXZIFwwK'
		WHEN 'DB_EX_COMM_145' THEN 'eLu4zLanlMr'
		WHEN 'DB_EX_COMM_144' THEN 'KcWT2BQjwBY'
		WHEN 'DB_EX_COMM_143' THEN 'QIOiEqJv2lP'
		WHEN 'DB_EX_COMM_142' THEN 'A7SoEm8sGLE'
		WHEN 'DB_EX_COMM_141' THEN 'XSPDSDU5hSq'
		WHEN 'DB_EX_COMM_140' THEN 'S5jBpH6HlxB'
		WHEN 'DB_EX_COMM_139' THEN 'deQi4GOXAUY'
		WHEN 'DB_EX_COMM_138' THEN 'q8ZpFE2xUPL'
		WHEN 'DB_EX_COMM_137' THEN 'Ql7LaAVZt5w'
		WHEN 'DB_EX_COMM_136' THEN 'fx6sq9qhIqa'
		WHEN 'DB_EX_COMM_135' THEN 'lKQmP7Bc1P0'
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
    dbc.name IN ('DB_EX_COMM_186','DB_EX_COMM_185','DB_EX_COMM_184','DB_EX_COMM_183','DB_EX_COMM_182','DB_EX_COMM_181','DB_EX_COMM_180','DB_EX_COMM_179','DB_EX_COMM_178','DB_EX_COMM_177','DB_EX_COMM_176','DB_EX_COMM_175','DB_EX_COMM_174','DB_EX_COMM_173','DB_EX_COMM_172','DB_EX_COMM_171','DB_EX_COMM_170','DB_EX_COMM_169','DB_EX_COMM_168','DB_EX_COMM_167','DB_EX_COMM_166','DB_EX_COMM_165','DB_EX_COMM_164','DB_EX_COMM_163','DB_EX_COMM_162','DB_EX_COMM_160','DB_EX_COMM_159','DB_EX_COMM_158','DB_EX_COMM_157','DB_EX_COMM_156','DB_EX_COMM_155','DB_EX_COMM_154','DB_EX_COMM_153','DB_EX_COMM_152','DB_EX_COMM_151','DB_EX_COMM_150','DB_EX_COMM_149','DB_EX_COMM_148','DB_EX_COMM_147','DB_EX_COMM_146','DB_EX_COMM_145','DB_EX_COMM_144','DB_EX_COMM_143','DB_EX_COMM_142','DB_EX_COMM_141','DB_EX_COMM_140','DB_EX_COMM_139','DB_EX_COMM_138','DB_EX_COMM_137','DB_EX_COMM_136','DB_EX_COMM_135')
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
