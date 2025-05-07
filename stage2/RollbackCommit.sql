-- Delete Query : It was decided to release from reserve service all soldiers who have not been in active service for more than 15 years and who are not commanders or drivers. They will be deleted from the database.
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




-- Update Query : Update the release date for every soldier who is a commander, who has served for less than two years and an half - an addition of one year to the release.
begin;
UPDATE SOLDIERS s
SET releaseDate = releaseDate + INTERVAL '12 months'
WHERE sID IN (
  SELECT s2.sID
  FROM SOLDIERS s2
  JOIN COMMANDER c ON s2.sID = c.cID
  WHERE s2.releaseDate - s2.draftDate < 912
);
commit;
