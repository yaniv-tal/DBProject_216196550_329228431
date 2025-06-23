-- This trigger function assigns a default crew ID to a soldier before insertion if none is provided.
CREATE OR REPLACE FUNCTION assign_default_crew()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.c_id IS NULL THEN
        SELECT c_id INTO NEW.c_id FROM crew ORDER BY c_id LIMIT 1;
        RAISE NOTICE 'Assigned soldier % to default crew %', NEW.sid, NEW.c_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_assign_crew
BEFORE INSERT ON soldiers
FOR EACH ROW EXECUTE FUNCTION assign_default_crew();




-- This trigger prevents inserting a tank record without an associated unit ID (unID).
CREATE OR REPLACE FUNCTION trg_block_tank_without_unit()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.unID IS NULL THEN
        RAISE EXCEPTION 'Cannot insert Tank without associated unit (unID)';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_block_tank
BEFORE INSERT ON tank
FOR EACH ROW
EXECUTE FUNCTION trg_block_tank_without_unit();
