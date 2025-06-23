-- Function returning a refcursor with commanders' performance report: 
-- number of tanks, missions, and experience level based on missions count.
CREATE OR REPLACE FUNCTION fn_commander_performance()
RETURNS refcursor AS $$
DECLARE
    ref refcursor := 'my_cursor';
BEGIN
    OPEN ref FOR
    SELECT
        c.cid AS commander_id,
        COUNT(DISTINCT t.tid) AS num_tanks,
        COUNT(DISTINCT m.mid) AS num_missions,
        CASE 
            WHEN COUNT(DISTINCT m.mid) >= 5 THEN 'Experienced'
            WHEN COUNT(DISTINCT m.mid) >= 2 THEN 'Intermediate'
            ELSE 'Newbie'
        END AS experience_level
    FROM
        commander c
        JOIN crew cr ON c.cid = cr.cid
        JOIN tank t ON t.cid = cr.cid
        JOIN unit u ON t.unid = u.unid
        JOIN participates p ON u.unid = p.unid
        JOIN mission m ON p.mid = m.mid
    GROUP BY c.cid;
    
    RETURN ref;
END;
$$ LANGUAGE plpgsql;


BEGIN;
SELECT fn_commander_performance();
FETCH ALL FROM my_cursor;
CLOSE my_cursor;
COMMIT;




-- Function returning a soldier-unit summary for a specific commander,
-- including unit name, tank ID, and crew role.
CREATE OR REPLACE FUNCTION fn_soldier_unit_summary(commander_id numeric)
RETURNS TABLE (
    soldier_id numeric,
    unit_name varchar,
    tank_id numeric,
    crew_type varchar
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        s.sid AS soldier_id,
        u.uname AS unit_name,
        t.tid AS tank_id,
        cm.type AS crew_type
    FROM 
        soldiers s
        JOIN crew cr ON s.c_id = cr.cid
        JOIN commander c ON cr.cid = c.cid
        JOIN tank t ON t.cid = cr.cid
        JOIN unit u ON t.unid = u.unid
        LEFT JOIN crewmate cm ON cm.crid = s.sid
    WHERE c.cid = commander_id;
END;
$$ LANGUAGE plpgsql;


SELECT * FROM fn_soldier_unit_summary(19);


