--- Select Queries

-- Select Query 1 : Calculates the average service duration (in days) for commanders and non-commanders (soldiers who are not commanders).
-- Subquery for Commanders
SELECT 'Commander' AS role, 
    AVG(s.releaseDate - s.draftDate) AS avgServiceDuration
FROM SOLDIERS s
JOIN COMMANDER c ON s.sID = c.cID

UNION ALL

-- Subquery for Non-Commanders
SELECT 'Non-Commander' AS role, 
    AVG(s.releaseDate - s.draftDate) AS avgServiceDuration
FROM SOLDIERS s
LEFT JOIN COMMANDER c ON s.sID = c.cID
WHERE c.cID IS NULL;

-- Select Query 2 : Retrieves units with a mission count above the average mission count across all units.
SELECT u.unID, u.uName, COUNT(p.mID) AS missionCount
FROM UNIT u
JOIN participates p ON u.unID = p.unID
GROUP BY u.unID, u.uName
HAVING COUNT(p.mID) > (
    SELECT AVG(missionCount)
    FROM (
        SELECT COUNT(p.mID) AS missionCount
        FROM participates p
        GROUP BY p.unID
    ) subquery
)
ORDER BY missionCount DESC;

-- Select Query 3 : Retrieves units and the number of tanks each unit has.
SELECT u.uName AS unitName, COUNT(t.tID) AS numberOfTanks
FROM UNIT u
LEFT JOIN TANK t ON u.unID = t.unID
GROUP BY u.uName
ORDER BY numberOfTanks DESC;

-- Select Query 4 : Retrieves crewmates who were drafted between March and April.
SELECT * FROM CREWMATE
WHERE crID IN (
  SELECT sID
  FROM SOLDIERS
  WHERE EXTRACT(MONTH FROM draftDate) BETWEEN 3 AND 4
);

-- Select Query 5 : Finding the 10 oldest soldiers.
SELECT 
  s.firstName || ' ' || s.lastName AS commanderName,
  s.draftDate,
  s.releaseDate,
  FLOOR((s.releaseDate - s.draftDate)/365) AS yearsServed,
  FLOOR(MOD((s.releaseDate - s.draftDate), 365)/30) AS monthsServed,
  MOD((s.releaseDate - s.draftDate), 30) AS daysServed
FROM SOLDIERS s
JOIN COMMANDER c ON s.sID = c.cID
ORDER BY (s.releaseDate - s.draftDate) DESC
FETCH FIRST 10 ROWS ONLY;

-- Select Query 6 : Retrieves the first name, last name, unit ID, and mission count of soldiers who have participated in 3 or more missions, ordered by mission count in descending order.
SELECT 
  s.firstName, 
  s.lastName, 
  u.unID, 
  COUNT(p.mID) AS missionCount
FROM COMMANDER c
JOIN SOLDIERS s ON c.cID = s.sID
JOIN UNIT u ON u.cID = c.cID
JOIN participates p ON u.unID = p.unID
GROUP BY s.firstName, s.lastName, u.unID
HAVING COUNT(p.mID) >= 3
ORDER BY missionCount DESC;

-- Select Query 7 : How many soldiers serve under each commander, including the commander's name and the number of soldiers, sorted by the number of soldiers.
SELECT 
  s.firstName AS commanderFirstName,
  s.lastName AS commanderLastName,
  COUNT(cm.crID) AS soldiersUnderCommand
FROM COMMANDER c
JOIN SOLDIERS s ON c.cID = s.sID
JOIN CREWMATE cm ON c.cID = cm.cID
GROUP BY s.firstName, s.lastName
ORDER BY soldiersUnderCommand DESC;

-- Select Query 8 : A list of names of soldiers who served at least part of the service in the calendar year 2023, with date of enlistment, date of discharge, and the number of days they served in 2023 only.
SELECT 
  s.firstName || ' ' || s.lastName AS commanderName,
  u.uName AS unitName,
  COUNT(p.mID) AS missionCount
FROM COMMANDER c
JOIN SOLDIERS s ON c.cID = s.sID
JOIN UNIT u ON c.cID = u.cID
JOIN participates p ON u.unID = p.unID
GROUP BY s.firstName, s.lastName, u.uName
ORDER BY missionCount DESC
FETCH FIRST 10 ROWS ONLY;


--- Delete Queries

-- Delete Query 1 : Deletes participation records (participates table) associated with unit ID 101.
DELETE FROM participates AS p 
WHERE p.UNID = 101;

-- Delete Query 2 : Unit 5 disbanded due to disciplinary problems, wiping out the crew members in the unit's tanks.
DELETE FROM CREWMATE
WHERE crID IN (
  SELECT cr.crID
  FROM CREWMATE cr
  JOIN COMMANDER c ON cr.cID = c.cID
  JOIN UNIT u ON u.cID = c.cID
  WHERE u.unID = 5
);
rollback;

-- Delete Query 3 : It was decided to release from reserve service all soldiers who have not been in active service for more than 15 years and who are not commanders or drivers. They will be deleted from the database.
begin;
DELETE FROM CREWMATE
WHERE crID IN (
    SELECT sID
    FROM SOLDIERS
    WHERE sID NOT IN (SELECT cID FROM COMMANDER)
      AND sID NOT IN (
          SELECT crID FROM CREWMATE WHERE LOWER(type) = 'driver'
      )
      AND releaseDate < CURRENT_DATE - INTERVAL '15 years'
);
DELETE FROM SOLDIERS
WHERE sID NOT IN (SELECT cID FROM COMMANDER)
  AND sID NOT IN (
      SELECT crID FROM CREWMATE WHERE LOWER(type) = 'driver'
  )
  AND releaseDate < CURRENT_DATE - INTERVAL '15 years';
rollback;


--- Update Queries

-- Update Query 1 : Updates the uName (unit name) to 'Inactive Unit' for units  that have not participated in any missions  within the last 12 months .
UPDATE UNIT
SET uName = 'Inactive Unit'
WHERE unID NOT IN (
    SELECT p.unID
    FROM participates p
    WHERE p.mID IN (
        SELECT m.mID
        FROM MISSION m
        WHERE m.mdate >= CURRENT_DATE + INTERVAL '-12 months'
    )
);


-- Update Query 2 : Updates the firstName and lastName of the commander (COMMANDER table) assigned to unit ID 10.
UPDATE SOLDIERS
SET firstName = 'ANO',
    lastName = 'NIMI'
WHERE sID = (
    SELECT u.cID
    FROM UNIT u
    WHERE u.unID = 101
);

-- Update Query 3 : Update the release date for every soldier who is a commander, who has served for less than two years and an half - an addition of one year to the release.
UPDATE SOLDIERS s
SET releaseDate = releaseDate + INTERVAL '12 months'
WHERE sID IN (
  SELECT s2.sID
  FROM SOLDIERS s2
  JOIN COMMANDER c ON s2.sID = c.cID
  WHERE s2.releaseDate - s2.draftDate < 912
);
