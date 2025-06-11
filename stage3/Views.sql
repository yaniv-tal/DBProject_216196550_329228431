-- ahuvya betsalel 329228431
-- yaniv tal 216196550


-- Create a view showing all information about the vessel conveniently
CREATE VIEW v_all_ships AS
SELECT 
    sv.sea_id,
    sv.nickname,
    sv.capacity,
    b.location AS base_location,
    CASE 
        WHEN d.sea_id IS NOT NULL THEN 'Destroyer'
        WHEN ms.sea_id IS NOT NULL THEN 'Missile Ship'
        WHEN sub.sea_id IS NOT NULL THEN 'Submarine'
        ELSE 'Sea Vessel'
    END AS ship_type
FROM sea_vessel sv
LEFT JOIN base b ON sv.base_id = b.base_id
LEFT JOIN warship ws ON sv.sea_id = ws.sea_id
LEFT JOIN destroyer d ON ws.sea_id = d.sea_id
LEFT JOIN missile_ship ms ON ws.sea_id = ms.sea_id
LEFT JOIN submarine sub ON sv.sea_id = sub.sea_id;

SELECT *
FROM v_all_ships;





-- Create a view showing tank details with unit name and commander's full name
CREATE VIEW v_tank_details AS
SELECT 
    t.tid AS tank_id, 
    u.uname AS unit_name, 
    s.firstname || ' ' || s.lastname AS commander_name
FROM tank t
JOIN unit u ON t.unid = u.unid
JOIN soldiers s ON t.cid = s.sid;

SELECT *
FROM v_tank_details;





-- Count how many ships exist for each type
SELECT ship_type, COUNT(*) AS count
FROM v_all_ships
GROUP BY ship_type;

-- Count destroyers per base location
SELECT COUNT(sea_id), base_location
FROM v_all_ships
WHERE ship_type = 'Destroyer'
GROUP BY base_location;

-- Count how many tanks each unit has
SELECT unit_name, COUNT(*) AS tank_count
FROM v_tank_details
GROUP BY unit_name;

-- Update commander's name of tank ID 2 to 'John Doe'
-- Query
UPDATE soldiers
SET firstname = 'ahuvya', lastname = 'betsalel'
WHERE sid = (
    SELECT t.cid
    FROM tank t
    JOIN v_tank_details td ON t.tid = td.tank_id
    WHERE td.tank_id = 5
);
-- check
SELECT commander_name
FROM v_tank_details
WHERE tank_id = 5;
