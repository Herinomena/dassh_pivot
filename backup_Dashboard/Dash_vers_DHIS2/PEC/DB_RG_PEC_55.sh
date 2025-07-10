#!/bin/bash

source /home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/PEC/.env
# Define MySQL credentials using environment variables
MYSQL_OPTS="--defaults-extra-file=<(printf '[client]\nuser=%s\npassword=%s\nhost=%s' \"$MYSQL_USER\" \"$MYSQL_PASSWORD\" \"$MYSQL_HOST\")"
CSV_FILE="/home/herinomena/Documents/Export_dashbord_DHIS/Script_Migration_Dash_vers_DHIS2/PEC/DB_RG_PEC_55"

# Define SQL query
SQL_QUERY="SELECT 
    'oTP9PARr3vC' AS 'dataelement',
    EXTRACT(YEAR_MONTH FROM DATE(rpe.date)) AS 'period',
    cc.orgunit AS 'orgunit',
    CASE rpse.id                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               WHEN 5 THEN 'kXYZqOsQ29U' 
		WHEN 15 THEN 'z0WL7neZtyQ'
		WHEN 37 THEN 'xVxaO1qKLCz'
		WHEN 7 THEN 'cH8vtk6aiKy' 
		WHEN 33 THEN 'C2zTZFS9jba' 
		WHEN 57 THEN 'XuyZAJeaHJf' 
		WHEN 69 THEN 'GVGuXSP1M0O' 
		WHEN 63 THEN 'C5qZ934ajjZ' 
		WHEN 31 THEN 'qFwV1CKLeYx' 
		WHEN 41 THEN 'ilQgXQDWDsY' 
		WHEN 29 THEN 'Yk4G5Y9yR0T' 
		WHEN 71 THEN 'iXVjEB0GSWA' 
		WHEN 19 THEN 'b9PwR8YhcCA' 
		WHEN 49 THEN 'isiWPjgZjLg' 
		WHEN 59 THEN 'LvNclcKH3fs' 
		WHEN 75 THEN 'v6omLdNVBhH' 
		WHEN 121 THEN 'DAs3krOyYcO' 
		WHEN 119 THEN 'VtL7Q2KLqck' 
		WHEN 77 THEN 'QIPyF71hZB7' 
		WHEN 15 THEN 'J7qmWGh8xR2' 
		WHEN 115 THEN 'Dz821wNfzDl' 
		WHEN 11 THEN 'Y6z1HzPuTU6' 
		WHEN 53 THEN 'gcddKyDmRf4' 
		WHEN 123 THEN 'cSDyryYvurY' 
		WHEN 113 THEN 'Nb4DqURdZoh' 
		WHEN 39 THEN 'y0M1ZYT9pD5'  
		WHEN 125 THEN 'Jedb1TOmFy4' 
		WHEN 55 THEN 'UqeSx2AmZQp' 
		WHEN 25 THEN 'T0OrXFAUyeQ' 
		WHEN 13 THEN 'jb30YDKwTtW' 
		WHEN 79 THEN 'fcBm1brTZRK' 
		WHEN 9 THEN 'ypOFfz4g3Py' 
		WHEN 47 THEN 'WSBy3G0s8SQ' 
		WHEN 73 THEN 'CtYRuTlYvlS' 
		WHEN 1 THEN 'UJV19f4ctOn' 
		WHEN 111 THEN 'VeLqRzIsv4Y' 
		WHEN 23 THEN 'h1C4Y6j93Db' 
		WHEN 43 THEN 'sO7nJrz86WH' 
		WHEN 21 THEN 'EG89imvgpLM' 
		WHEN 61 THEN 'KqvpHZQbX2u' 
		WHEN 27 THEN 'EF7ZPo6Nqh9' 
		WHEN 65 THEN 'o3kyzDF46Eb' 
		WHEN 17 THEN 'JulpK7w1VDy'
    END AS 'catoptcombo',
    'HllvX50cXC0' AS 'attroptcombo',
    COUNT(rpr.id) AS 'value'
FROM
    register AS r
        LEFT JOIN
    patient AS p ON p.id = r.patient_id
        LEFT JOIN
    fokontany AS f ON p.fokontany_id = f.id
        LEFT JOIN
    commune AS c ON f.commune_id = c.id
        LEFT JOIN
    register_pec_entry AS rpe ON rpe.register_id = r.id
        LEFT JOIN
    register_pec_sortie AS rps ON rps.register_id = r.id
        LEFT JOIN
    register_pec_type_sortie AS rpts ON rpts.id = rps.type_sortie_id
        LEFT JOIN
    register_pec_service AS rpse ON rpse.id = rpe.service_id
        LEFT JOIN
    register_pec_statut AS rpst ON rpst.id = rpe.statut_id
        LEFT JOIN
    care_center_projet AS ccp ON r.care_center_projet_id = ccp.id
        LEFT JOIN
    care_center AS cc ON ccp.care_center_id = cc.id
        LEFT JOIN
    chrd AS ch ON ch.care_center_id = cc.id
        LEFT JOIN
    projet AS pr ON ccp.projet_id = pr.id
        LEFT JOIN
    program AS pg ON pg.id = pr.program_id
        LEFT JOIN
    district AS d ON d.id = ch.district_id
        LEFT JOIN
    register_pec_reference AS rpr ON rpr.entry_id = rpe.id
        LEFT JOIN
    care_center AS ccr ON rpr.care_center_transferant_id = ccr.id
        LEFT JOIN
    register_pec_moyen_transport AS rpmt ON rpmt.id = rpr.moyen_transport_id
WHERE
    pr.id IN (137 , 187)
       AND rpe.date IS NOT NULL
        AND rpse.id IS NOT NULL
        and rpe.is_refered = 1
        AND EXTRACT(YEAR_MONTH FROM DATE(rpe.date)) >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 4 MONTH), '%Y%m')
GROUP BY cc.id , EXTRACT(YEAR_MONTH FROM DATE(rpe.date)) , rpse.id
;"

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
