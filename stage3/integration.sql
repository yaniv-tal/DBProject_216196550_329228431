-- ahuvya betsalel 329228431
-- yaniv tal 216196550

-- Table for crews
CREATE TABLE Crew (
  c_ID INTEGER PRIMARY KEY,
  c_size INTEGER NOT NULL,
  cID INTEGER NOT NULL,
  FOREIGN KEY (cID) REFERENCES Commander(cID)
);

-- Table for military bases
CREATE TABLE Base (
  base_ID INTEGER PRIMARY KEY,
  location VARCHAR(15) NOT NULL
);

-- Table for general sea vessels
CREATE TABLE Sea_Vessel (
  sea_ID INTEGER PRIMARY KEY,
  launcher_amount INTEGER NOT NULL,
  nickname VARCHAR(15) NOT NULL,
  capacity INTEGER NOT NULL,
  test_date DATE NOT NULL,
  lease_expiration_date DATE NOT NULL,
  c_ID INTEGER NOT NULL,
  base_ID INTEGER NOT NULL,
  FOREIGN KEY (c_ID) REFERENCES Crew(c_ID),
  FOREIGN KEY (base_ID) REFERENCES Base(base_ID)
);

-- Table for submarines
CREATE TABLE Submarine (
  oxygen_density REAL NOT NULL,
  max_depth INTEGER NOT NULL,
  sea_ID INTEGER PRIMARY KEY,
  FOREIGN KEY (sea_ID) REFERENCES Sea_Vessel(sea_ID)
);

-- Table for warships
CREATE TABLE Warship (
  cannons_amount INTEGER NOT NULL,
  sea_ID INTEGER PRIMARY KEY,
  FOREIGN KEY (sea_ID) REFERENCES Sea_Vessel(sea_ID)
);

-- Table for missile ships
CREATE TABLE Missile_Ship (
  missle_capacity INTEGER NOT NULL,
  sea_ID INTEGER PRIMARY KEY,
  FOREIGN KEY (sea_ID) REFERENCES Warship(sea_ID)
);

-- Table for destroyers
CREATE TABLE Destroyer (
  sea_ID INTEGER PRIMARY KEY,
  FOREIGN KEY (sea_ID) REFERENCES Warship(sea_ID)
);

-- Add 'rank' column to Soldiers table
ALTER TABLE Soldiers ADD COLUMN rank VARCHAR(15);

-- Allow 'lastname' column to be nullable
ALTER TABLE Soldiers ALTER COLUMN lastname DROP NOT NULL;

-- Set default value for 'draftdate' to today's date
ALTER TABLE Soldiers ALTER COLUMN draftdate SET DEFAULT CURRENT_DATE;

-- Set default value for 'releaseDate' to 3 years from today's date
ALTER TABLE Soldiers ALTER COLUMN releaseDate SET DEFAULT (CURRENT_DATE + INTERVAL '3 years');

-- Add 'c_ID' column to Soldiers if it doesn't already exist
ALTER TABLE Soldiers ADD COLUMN c_ID INTEGER;

-- Add foreign key constraint to Soldiers referencing Crew
ALTER TABLE Soldiers ADD CONSTRAINT fk_soldiers_crew FOREIGN KEY (c_ID) REFERENCES Crew(c_ID);

-- Add 'c_ID' column to Tank if it doesn't already exist
ALTER TABLE Tank ADD COLUMN c_ID INTEGER;

-- Add foreign key constraint to Tank referencing Crew
ALTER TABLE Tank ADD CONSTRAINT fk_tank_crew FOREIGN KEY (c_ID) REFERENCES Crew(c_ID);
