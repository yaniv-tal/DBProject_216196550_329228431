-- This block tries to assign a soldier as a crewmate under a commander with a specific role,
-- then prints a summary of all soldiers under that commander.
DO $$
DECLARE
    sid INT := 502;
    cid INT := 301;
    role TEXT := 'engineer';
    rec RECORD;
BEGIN
    BEGIN
        CALL pr_auto_assign_crewmate(sid, cid, role);
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Failed to assign soldier % to commander % as %: %', sid, cid, role, SQLERRM;
    END;

    RAISE NOTICE 'Displaying crew members under commander %:', cid;

    FOR rec IN
        SELECT * FROM fn_soldier_unit_summary(cid)
    LOOP
        RAISE NOTICE 'Soldier % assigned to unit %, tank % as %',
            rec.soldier_id, rec.unit_name, rec.tank_id, rec.crew_type;
    END LOOP;
END;
$$ LANGUAGE plpgsql;




-- This block fetches commander performance data via a refcursor 
-- and logs each commander's stats and experience level.
DO $$
DECLARE
    ref refcursor;
    rec RECORD;
BEGIN
    -- Open the cursor returned by the function
    ref := fn_commander_performance();

    LOOP
        FETCH ref INTO rec;
        EXIT WHEN NOT FOUND;

        RAISE NOTICE 'Commander ID: %, # Tanks: %, # Missions: %, Level: %',
            rec.commander_id, rec.num_tanks, rec.num_missions, rec.experience_level;

        IF rec.experience_level = 'Experienced' THEN
            RAISE NOTICE '>> Commander % is highly experienced.', rec.commander_id;
        ELSIF rec.experience_level = 'Intermediate' THEN
            RAISE NOTICE '>> Commander % has moderate experience.', rec.commander_id;
        ELSE
            RAISE NOTICE '>> Commander % is new or inexperienced.', rec.commander_id;
        END IF;
    END LOOP;

    CLOSE ref;
EXCEPTION
    WHEN OTHERS THEN
        RAISE WARNING 'Error in commander performance main program: %', SQLERRM;
END
$$ LANGUAGE plpgsql;
