#!/bin/bash

source /home/herinomena/Images/backup_Dashboard/Dash_vers_DHIS2/EXCEL/.env
# Define MySQL credentials using environment variables
MYSQL_OPTS="--defaults-extra-file=<(printf '[client]\nuser=%s\npassword=%s\nhost=%s' \"$MYSQL_USER\" \"$MYSQL_PASSWORD\" \"$MYSQL_HOST\")"
CSV_FILE="/home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/EXCEL/DB_EX_REF"


# Define SQL query
SQL_QUERY="SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SELECT

	CASE dbc.name  
		WHEN 'DB_EX_REF_9' THEN 'O4HtZkYsdYx'
		WHEN 'DB_EX_REF_8' THEN 'pKTUACWHnzU'
		WHEN 'DB_EX_REF_6' THEN 'mLKEsLOUWXC'
		WHEN 'DB_EX_REF_5' THEN 'K8hwsSqrykf'
		WHEN 'DB_EX_REF_4' THEN 'SV6vaf8jQOi'
		WHEN 'DB_EX_REF_36' THEN 'hkNbCV07p8Z'
		WHEN 'DB_EX_REF_35' THEN 'swm0P83nDgz'
		WHEN 'DB_EX_REF_34' THEN 'tYtLTomrz4e'
		WHEN 'DB_EX_REF_33' THEN 'k3bC5lqjnR8'
		WHEN 'DB_EX_REF_32' THEN 'Wn9hULk2DgG'
		WHEN 'DB_EX_REF_31' THEN 'WFUyPtmxbZ1'
		WHEN 'DB_EX_REF_30' THEN 'hMz5nxgAOz0'
		WHEN 'DB_EX_REF_3' THEN 'YnXNpojLS81'
		WHEN 'DB_EX_REF_29' THEN 'WrD1sBqy5nY'
		WHEN 'DB_EX_REF_28' THEN 'xkQgjuCPp6t'
		WHEN 'DB_EX_REF_27' THEN 'SPW7Zm8gbi2'
		WHEN 'DB_EX_REF_26' THEN 'JtAYLpx7q3h'
		WHEN 'DB_EX_REF_25' THEN 'srgGoVJpRfV'
		WHEN 'DB_EX_REF_24' THEN 'jol23ZF2jy1'
		WHEN 'DB_EX_REF_23' THEN 'E7TSSEBqGRX'
		WHEN 'DB_EX_REF_22' THEN 'APe5o7wES2B'
		WHEN 'DB_EX_REF_21' THEN 'El8TT7KjLjh'
		WHEN 'DB_EX_REF_20' THEN 'PmzvlJ57CX7'
		WHEN 'DB_EX_REF_2' THEN 'ed9V5BPHk4q'
		WHEN 'DB_EX_REF_19' THEN 'xm80wbTXP2E'
		WHEN 'DB_EX_REF_18' THEN 'TjvbUa8bojN'
		WHEN 'DB_EX_REF_17' THEN 'iiFuhaMbNLT'
		WHEN 'DB_EX_REF_16' THEN 'uZrboFybD6e'
		WHEN 'DB_EX_REF_15' THEN 'sx7Zz5E6N0j'
		WHEN 'DB_EX_REF_14' THEN 'PAqjqw5CRiT'
		WHEN 'DB_EX_REF_13' THEN 'AGTBoEEzIuH'
		WHEN 'DB_EX_REF_12' THEN 'f1wnxmSSfU1'
		WHEN 'DB_EX_REF_11' THEN 'eJb0R2JaV1u'
		WHEN 'DB_EX_REF_10' THEN 'X4RSDFjdXQ0'
		WHEN 'DB_EX_REF_1' THEN 'IEKYA4PnJNe'
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
    dbc.name IN ('DB_EX_REF_9','DB_EX_REF_8','DB_EX_REF_6','DB_EX_REF_5','DB_EX_REF_4','DB_EX_REF_36','DB_EX_REF_35','DB_EX_REF_34','DB_EX_REF_33','DB_EX_REF_32','DB_EX_REF_31','DB_EX_REF_30','DB_EX_REF_3','DB_EX_REF_29','DB_EX_REF_28','DB_EX_REF_27','DB_EX_REF_26','DB_EX_REF_25','DB_EX_REF_24','DB_EX_REF_23','DB_EX_REF_22','DB_EX_REF_21','DB_EX_REF_20','DB_EX_REF_2','DB_EX_REF_19','DB_EX_REF_18','DB_EX_REF_17','DB_EX_REF_16','DB_EX_REF_15','DB_EX_REF_14','DB_EX_REF_13','DB_EX_REF_12','DB_EX_REF_11','DB_EX_REF_10','DB_EX_REF_1')
    AND EXTRACT(YEAR_MONTH FROM  DATE(dbdb.periode)) >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 10 MONTH), '%Y%m')
GROUP BY cc.id,EXTRACT(YEAR_MONTH FROM DATE(dbdb.periode)),dbc.id"

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
