/* 1. Liste de l'ensemble des agences :  */
SELECT Nom_Agence FROM agence;

/* 2. Liste de l'ensemble du personnel technique de l'agence de Bordeaux : */
SELECT Nom_Agent,Prenom_Agent 
FROM agent
JOIN adresse ON agent.Code_Adresse = adresse.Code_Adresse
WHERE Ville = "Bordeaux";	

/* 3. Nombre total de capteurs déployés : */
SELECT COUNT(Code_Capteur) AS Nbr_Capteur 
FROM capteur;

/* 4. Liste des rapports publiés entre 2018 et 2022 */
SELECT Nom_Rapport,date 
FROM rapport 
JOIN date ON rapport.Code_Date = date.Code_Date
WHERE date BETWEEN "2018-01-01" AND "2022-12-31";


/* 5. Afficher les concentrations de CH4 (en ppm) dans les régions « Ile-de-France », « Bretagne » et « Occitanie » en mai et juin 2023. */
SELECT Valeur_Mesure,Date/*,Sigle_Gaz,Region*/
FROM mesure
JOIN gaz ON mesure.Code_Gaz = gaz.Code_Gaz
JOIN capteur ON mesure.Code_Capteur = capteur.Code_Capteur
JOIN adresse ON capteur.Code_Adresse = adresse.Code_Adresse
JOIN date ON mesure.Code_Date = date.Code_Date
WHERE Sigle_GAz = "CH4" 
AND(
Region = "Île-de-France" 
OR Region ="Bretagne" 
OR Region = "Occitanie") 
AND Date BETWEEN '2023-05-01' AND '2023-06-30';


/* 6. Liste des noms des agents techniques maintenant des capteurs concernant les gaz à effet de serre provenant de l’industrie (GESI).  */

SELECT DISTINCT Nom_Agent,Prenom_Agent 
FROM agent
JOIN capteur ON agent.Code_Agent = capteur.Code_Agent
JOIN gaz ON capteur.Code_Gaz = gaz.Code_Gaz
WHERE Type_de_Gaz = "GESI"
AND Poste_Agent = "Agent Technique";

/* 7. Titres et dates des rapports concernant des concentrations de NH3, classés par ordre antichronologique. */
SELECT Nom_Rapport,date.Date/*,Sigle_GAz*/
FROM rapport
JOIN date ON rapport.Code_Date = date.Code_Date
JOIN se_lier ON rapport.Code_Rapport = se_lier.Code_Rapport
JOIN mesure ON se_lier.Code_Mesure = mesure.Code_Mesure
JOIN gaz ON mesure.Code_Gaz = gaz.Code_Gaz
WHERE Sigle_GAz = "NH3"
ORDER BY date.Date DESC; 

/* 8. Afficher le mois où la concentration de PFC a été la moins importante pour chaque région. */
SELECT 
	adresse.Region,
	MONTH(date.Date) AS Mois, /* MONTH() --> Fonction pour obtenir le mois d'une date */ 
	mesure.Valeur_Mesure
FROM mesure
JOIN gaz ON mesure.Code_Gaz = gaz.Code_Gaz
JOIN capteur ON mesure.Code_Capteur = capteur.Code_Capteur
JOIN adresse  ON capteur.Code_Adresse = adresse.Code_Adresse
JOIN date ON mesure.Code_Date = date.Code_Date
WHERE Sigle_GAz = "PFC"
AND mesure.Valeur_Mesure IN ( /*On récupère la valeur minimale mesuré des régions pour ensuite les comparer avec le PFC*/
	SELECT MIN(mesure.Valeur_Mesure)
	FROM mesure
	JOIN gaz ON mesure.Code_Gaz = gaz.Code_Gaz
	JOIN capteur ON mesure.Code_Capteur = capteur.Code_Capteur
	JOIN adresse ad ON capteur.Code_Adresse = ad.Code_Adresse
	WHERE gaz.Sigle_Gaz = 'PFC'
	AND ad.Region = adresse.Region /* On récupère uniquement les adresses de la requête principale */
);


/* 9. Moyenne des concentrations (en ppm) dans la région « Ile-de-France » en 2020, pour chaque gaz étudié. */

SELECT gaz.Nom_Gaz,ROUND(AVG(mesure.Valeur_Mesure),2) AS Moyenne_Gaz_Mesure
FROM mesure
JOIN gaz ON mesure.Code_Gaz = gaz.Code_Gaz
JOIN capteur ON mesure.Code_Capteur = capteur.Code_Capteur
JOIN adresse ON capteur.Code_Adresse = adresse.Code_Adresse
JOIN date ON mesure.Code_Date = date.Code_Date
WHERE adresse.Region = "Île-de-France" 
AND EXTRACT(YEAR FROM date.Date) = 2020
GROUP BY gaz.Nom_Gaz,adresse.Region;

/* 10.  Taux de productivité des agents administratifs de l'agence de Rouen (le taux est calculé en nombre de rapports écrits par mois en moyenne, sur la durée de leur contrat) */
SELECT 
	agent.Nom_Agent,
	agent.Prenom_Agent,
	COUNT(DISTINCT rapport.Code_Rapport) AS Nb_Rapports,
	TIMESTAMPDIFF(MONTH, dd.Date, MAX(dr.Date)) AS Duree_Contrat_Mois,
	ROUND(COUNT(DISTINCT rapport.Code_Rapport) / TIMESTAMPDIFF(MONTH, dd.Date, MAX(dr.Date)), 2) AS Taux_Productivite
FROM agent
JOIN agence ON agent.Code_Agence = agence.Code_Agence
JOIN adresse ON agence.Code_Adresse = adresse.Code_Adresse
JOIN date dd ON agent.Code_Date_Debuter = dd.Code_Date /*On doit séparer les deux table date pour pouvoir récupérer les dates */
JOIN rediger ON agent.Code_Agent = rediger.Code_Agent
JOIN rapport ON rediger.Code_Rapport = rapport.Code_Rapport
JOIN date dr ON rapport.Code_Date = dr.Code_Date
WHERE adresse.Ville = 'Rouen'
AND agent.Poste_Agent = 'Agent administratif'
GROUP BY agent.Code_Agent
ORDER BY Taux_Productivite DESC;


/* 11.  Pour un gaz donné, liste des rapports contenant des données qui le concernent (on doit pouvoir donner le nom du gaz en paramètre) */
/*DELIMITER $$

CREATE PROCEDURE GetRapportsByGaz(Sigle_Gaz VARCHAR(50))
BEGIN
    SELECT rapport.Nom_Rapport 
    FROM rapport
    JOIN se_lier ON rapport.Code_Rapport = se_lier.Code_Rapport
    JOIN mesure ON se_lier.Code_Mesure = mesure.Code_Mesure
    JOIN gaz ON mesure.Code_Gaz = gaz.Code_Gaz
    WHERE gaz.Sigle_Gaz = Sigle_Gaz;
END $$

DELIMITER ;
*/
CALL GetRapportsByGaz('CO2');
CALL GetRapportsByGaz('NH3');


/* 12.  Liste des régions dans lesquelles il y a plus de capteurs que de personnel d’agence. */
		
SELECT 
    adresse.Region, 
    COUNT(DISTINCT capteur.Code_Capteur) AS Nbr_Capteur,
    COUNT(DISTINCT agent.Code_Agent) AS Nbr_Agent
FROM agent
JOIN capteur ON agent.Code_Agent = capteur.Code_Agent
JOIN adresse ON capteur.Code_Adresse = adresse.Code_Adresse
GROUP BY adresse.Region
HAVING Nbr_Capteur > Nbr_Agent
