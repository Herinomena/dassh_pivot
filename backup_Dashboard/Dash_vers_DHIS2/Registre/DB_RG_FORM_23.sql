SELECT 
    asp.name AS 'Name', p.nom AS 'Nom AC',
    cc.name as 'Centre de soins',
    CASE p.genre
        WHEN 1 THEN 'Féminin'
        WHEN 2 THEN 'Masculin'
    END AS 'Genre'
    -- count(acc.id) as 'Nombre'
FROM
    affectation_care_center acc
        LEFT JOIN
    personne p ON acc.personne_id = p.id
        LEFT JOIN
    affectation_specialite asp ON acc.affectation_specialite_id = asp.id
    left join
	care_center cc on acc.care_center_id = cc.id
WHERE
    asp.name = 'AC'
    and acc.date_fin is null
Group by
	cc.id