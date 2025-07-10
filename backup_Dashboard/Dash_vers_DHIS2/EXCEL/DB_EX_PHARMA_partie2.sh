#!/bin/bash

source /home/herinomena/Images/backup_Dashboard/Dash_vers_DHIS2/EXCEL/.env
# Define MySQL credentials using environment variables
MYSQL_OPTS="--defaults-extra-file=<(printf '[client]\nuser=%s\npassword=%s\nhost=%s' \"$MYSQL_USER\" \"$MYSQL_PASSWORD\" \"$MYSQL_HOST\")"
CSV_FILE="/home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/EXCEL/DB_EX_PHARMA_partie2"

# Define SQL query
SQL_QUERY="SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SELECT
	CASE dbc.name
		WHEN 'DB_EX_PHARMA_50' THEN 'dKkiNwGtEZC'
		WHEN 'DB_EX_PHARMA_5' THEN 'I2r8CvcNWUW'
		WHEN 'DB_EX_PHARMA_49' THEN 'mnhUnpHP0YB'
		WHEN 'DB_EX_PHARMA_48' THEN 'Rp20Ap4qieL'
		WHEN 'DB_EX_PHARMA_47' THEN 'hk8a2O2gjGf'
		WHEN 'DB_EX_PHARMA_46' THEN 'ZNMQgTZ1UGP'
		WHEN 'DB_EX_PHARMA_45' THEN 'nfQhnbCbm57'
		WHEN 'DB_EX_PHARMA_44' THEN 'KZfbb82EtLy'
		WHEN 'DB_EX_PHARMA_43' THEN 'xvmja7UWMt8'
		WHEN 'DB_EX_PHARMA_42' THEN 'UpFnWOq50iA'
		WHEN 'DB_EX_PHARMA_40' THEN 'wEXXcwvITAF'
		WHEN 'DB_EX_PHARMA_4' THEN 'mkHZfELr4BY'
		WHEN 'DB_EX_PHARMA_39' THEN 'wE9SsnNxAWL'
		WHEN 'DB_EX_PHARMA_38' THEN 'ZKaOXkByuOO'
		WHEN 'DB_EX_PHARMA_37' THEN 'WigGsHTNFfD'
		WHEN 'DB_EX_PHARMA_36' THEN 'mAVLqMWl6oR'
		WHEN 'DB_EX_PHARMA_35' THEN 'omhFUvQP5nX'
		WHEN 'DB_EX_PHARMA_34' THEN 'bJulwJk4xat'
		WHEN 'DB_EX_PHARMA_33' THEN 'DFafL2Aci8x'
		WHEN 'DB_EX_PHARMA_32' THEN 'R94VDcbFvTF'
		WHEN 'DB_EX_PHARMA_31' THEN 'id2RGPbQ4i9'
		WHEN 'DB_EX_PHARMA_30' THEN 'tfl93Izm6lP'
		WHEN 'DB_EX_PHARMA_3' THEN 'PqXF1LXHTiP'
		WHEN 'DB_EX_PHARMA_29' THEN 'upuKVEEYZd9'
		WHEN 'DB_EX_PHARMA_28' THEN 'DJkmSntLmyq'
		WHEN 'DB_EX_PHARMA_27' THEN 'D8w1iyAsUvN'
		WHEN 'DB_EX_PHARMA_26' THEN 'vwduY5E44oh'
		WHEN 'DB_EX_PHARMA_25' THEN 'dJoftQh57IN'
		WHEN 'DB_EX_PHARMA_24' THEN 'QGMHSMyLifU'
		WHEN 'DB_EX_PHARMA_23' THEN 'DSkVw0pZejm'
		WHEN 'DB_EX_PHARMA_22' THEN 'wr1Hg5OlFuJ'
		WHEN 'DB_EX_PHARMA_21' THEN 'MlNAxSP36Rd'
		WHEN 'DB_EX_PHARMA_20' THEN 'HCY5H7cFpWM'
		WHEN 'DB_EX_PHARMA_2' THEN 'fJN2Xq8eDXF'
		WHEN 'DB_EX_PHARMA_19' THEN 'FRlDV9S7FhV'
		WHEN 'DB_EX_PHARMA_18' THEN 'EiBoxf1gPyK'
		WHEN 'DB_EX_PHARMA_17' THEN 'U4Pf0Rkzi1r'
		WHEN 'DB_EX_PHARMA_16' THEN 'qdpuaGzBJer'
		WHEN 'DB_EX_PHARMA_15' THEN 'NK6pyfUg8SG'
		WHEN 'DB_EX_PHARMA_14' THEN 'HPqZfS2e1ox'
		WHEN 'DB_EX_PHARMA_13' THEN 'KgcMzp9fOg7'
		WHEN 'DB_EX_PHARMA_12' THEN 'nOykx0E8Smi'
		WHEN 'DB_EX_PHARMA_11' THEN 'vVCDL3t2KxO'
		WHEN 'DB_EX_PHARMA_10' THEN 'YXF6zE9CEBS'
		WHEN 'DB_EX_PHARMA_1' THEN 'qZSM7ODLRt4'
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
    dbc.name IN ('DB_EX_PHARMA_50','DB_EX_PHARMA_5','DB_EX_PHARMA_49','DB_EX_PHARMA_48','DB_EX_PHARMA_47','DB_EX_PHARMA_46','DB_EX_PHARMA_45','DB_EX_PHARMA_44','DB_EX_PHARMA_43','DB_EX_PHARMA_42','DB_EX_PHARMA_40','DB_EX_PHARMA_4','DB_EX_PHARMA_39','DB_EX_PHARMA_38','DB_EX_PHARMA_37','DB_EX_PHARMA_36','DB_EX_PHARMA_35','DB_EX_PHARMA_34','DB_EX_PHARMA_33','DB_EX_PHARMA_32','DB_EX_PHARMA_31','DB_EX_PHARMA_30','DB_EX_PHARMA_3','DB_EX_PHARMA_29','DB_EX_PHARMA_28','DB_EX_PHARMA_27','DB_EX_PHARMA_26','DB_EX_PHARMA_25','DB_EX_PHARMA_24','DB_EX_PHARMA_23','DB_EX_PHARMA_22','DB_EX_PHARMA_21','DB_EX_PHARMA_20','DB_EX_PHARMA_2','DB_EX_PHARMA_19','DB_EX_PHARMA_18','DB_EX_PHARMA_17','DB_EX_PHARMA_16','DB_EX_PHARMA_15','DB_EX_PHARMA_14','DB_EX_PHARMA_13','DB_EX_PHARMA_12','DB_EX_PHARMA_11','DB_EX_PHARMA_10','DB_EX_PHARMA_1')
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
