-- Procedure that promotes commanders based on number of missions: 
-- commanders with 5+ missions become 'admiral', with 3-4 missions become 'captain', otherwise 'sailor'.

CREATE OR REPLACE PROCEDURE pr_promote_commanders()
LANGUAGE plpgsql
AS $$
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN 
        SELECT s.sid AS soldier_id, COUNT(DISTINCT m.mid) AS missions
        FROM commander c
        JOIN crew cr ON c.cid = cr.cid
        JOIN soldiers s ON c.cid = s.sid
        JOIN tank t ON t.cid = cr.cid
        JOIN unit u ON t.unid = u.unid
        JOIN participates p ON u.unid = p.unid
        JOIN mission m ON p.mid = m.mid
        GROUP BY s.sid
    LOOP
        IF rec.missions >= 5 THEN
            UPDATE soldiers SET rank = 'admiral' WHERE sid = rec.soldier_id;
        ELSIF rec.missions >= 3 THEN
            UPDATE soldiers SET rank = 'captain' WHERE sid = rec.soldier_id;
        ELSE
            UPDATE soldiers SET rank = 'sailor' WHERE sid = rec.soldier_id;
        END IF;
    END LOOP;
END;
$$;


CALL pr_promote_commanders();




-- Procedure that assigns a soldier to a crew under a specific commander with a specified role.
-- Throws an exception if no crew exists for the commander.

CREATE OR REPLACE PROCEDURE pr_auto_assign_crewmate(soldier_id int, commander_id int, crew_type varchar)
LANGUAGE plpgsql
AS $$
DECLARE
    crew_id int;
BEGIN
    -- Find crew assigned to the commander
    SELECT cr.cid INTO crew_id
    FROM crew cr
    WHERE cr.cid = commander_id
    LIMIT 1;

    -- Raise error if no crew found
    IF crew_id IS NULL THEN
        RAISE EXCEPTION 'No crew exists for commander ID %', commander_id;
    END IF;

    -- Assign soldier to the crew
    INSERT INTO crewmate (crid, cid, type)
    VALUES (soldier_id, crew_id, crew_type);

    RAISE NOTICE 'Soldier % assigned to crew % under commander % as %',
        soldier_id, crew_id, commander_id, crew_type;
END;
$$;


CALL pr_auto_assign_crewmate(6666, 99, 'Gunner');
