-- INSERT commands for SOLDIERS
INSERT INTO SOLDIERS (sID, firstName, lastName, draftDate, releaseDate) VALUES
(1, 'John', 'Doe', TO_DATE('10-01-2015', 'DD-MM-YYYY'), TO_DATE('10-01-2020', 'DD-MM-YYYY')),
(2, 'Jane', 'Smith', TO_DATE('15-02-2016', 'DD-MM-YYYY'), TO_DATE('15-02-2021', 'DD-MM-YYYY')),
(3, 'Robert', 'Brown', TO_DATE('20-03-2017', 'DD-MM-YYYY'), TO_DATE('20-03-2022', 'DD-MM-YYYY')),
(4, 'Emily', 'Davis', TO_DATE('25-04-2018', 'DD-MM-YYYY'), TO_DATE('25-04-2023', 'DD-MM-YYYY')),
(5, 'Michael', 'Wilson', TO_DATE('30-05-2019', 'DD-MM-YYYY'), TO_DATE('30-05-2024', 'DD-MM-YYYY'));

-- INSERT commands for MISSION
INSERT INTO MISSION (mdate, mID) VALUES
(TO_DATE('10-05-2021', 'DD-MM-YYYY'), 1),
(TO_DATE('15-06-2021', 'DD-MM-YYYY'), 2),
(TO_DATE('20-07-2021', 'DD-MM-YYYY'), 3),
(TO_DATE('25-08-2021', 'DD-MM-YYYY'), 4),
(TO_DATE('30-09-2021', 'DD-MM-YYYY'), 5);

-- INSERT commands for COMMANDER
INSERT INTO COMMANDER (cID) VALUES
(1),
(2),
(3);

-- INSERT commands for CREWMATE
INSERT INTO CREWMATE (type, crID, cID) VALUES
('Driver', 4, 1),
('Gunner', 5, 2),
('Loader', 6, 3),
('Radio Operator', 7, 1),
('Mechanic', 8, 2);

-- INSERT commands for UNIT
INSERT INTO UNIT (unID, uName, cID) VALUES
(1, 'Alpha', 1),
(2, 'Bravo', 2),
(3, 'Charlie', 3);

-- INSERT commands for TANK
INSERT INTO TANK (tID, unID, cID) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 1, 1),
(5, 2, 2);

-- INSERT commands for participates
INSERT INTO participates (mID, unID) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 1),
(5, 2);
