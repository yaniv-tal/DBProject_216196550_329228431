# מיני פרויקט בבסיסי נתונים – חיל השריון של צה"ל

![image](https://github.com/user-attachments/assets/d34ede51-2778-4658-9dac-424b2d7373fb)

**מגישים:**  
- יניב טל – 216196550  
- אהוביה בצלאל – 329228431

**מרצה:**  
מר יעקב ברזילי

**קישור ל־GitHub:**  
[https://github.com/yaniv-tal/DBProject_216196550_329228431](https://github.com/yaniv-tal/DBProject_216196550_329228431)

---

## תוכן עניינים

- שלב 1 - עיצוב ויצירת DB, שימוש ב־ERDPLUS והכנסת נתונים  
  - תיאור המערכת  
  - תרשים ERD של הישויות והקשרים 
  - תרשים DSD  
  - תיאור הישויות והתכונות שלהן
  - תיאור הקשרים  
  - רשימת הסכמות של בסיס הנתונים
  - הסכמות של הישויות
  - הסכמות של הקשרים
  - הוכחה שהסכמות מנורמלות בNF3
  - קוד SQL של יצירת הטבלאות (CREATE)
  - קוד SQL של זריקת הטבלאות (DROP) 
  - הכנסת מידע לטבלאות
  - הכנסת מידע לSOLIDERS – דרך 1, Mockaroo file
  - הכנסת מידע לCOMMANDER – דרך 2, קובץ Excel	
  - הכנסת מידע לCREWMATE – דרך 3, סקריפט בפייתון	
  - הכנסת מידע לUNIT – דרך 4, קובץ טקסט	
  - הכנסת מידע לTANK – דרך 3, סקריפט בפייתון	
  - הכנסת מידע לMISSION – דרך 1, Mockaroo file	
  - הכנסת מידע לparticipate – דרך 2, קובץ Excel	
  - גיבוי הטבלאות
  - שחזור הטבלאות
    
- שלב 2 - שאילתות (וכן השאילתות עם פרמטרים)
    - שאילתות
    - 8 שאילתות SELECT
    - 3 שאילתות DELETE
    - 3 שאילתות UPDATE
    - שאילתת UPDATE עם COMMIT
    - אילוצים

---

## שלב 1 – עיצוב ויצירת DB, שימוש ב־ERDPLUS והכנסת נתונים

### תיאור המערכת

זרוע השריון הישראלית, המוכרת גם כחיל השריון (חש"ן), עומדת כחוד החנית של צבא הגנה לישראל (צה"ל). זרוע זו, מהווה כוח התקפי עיקרי בשדה הקרב, ומשלבת טכנולוגיה מתקדמת, אומץ לב ורוח לחימה עזה.

זרוע השריון היא זרוע עוצמתית וחיונית בצה"ל, הממלאת תפקיד מרכזי בהגנת המדינה. כוח השריון מאפשר לצה"ל לבצע מגוון רחב של משימות בשדה הקרב, ולהוות גורם הרתעה משמעותי מול אויביה.

המערכת שנבנה תספק בסיס נתונים לחיל השריון. היא תתחלק לשלושה חלקים:

1. **ניהול מידע על החיילים** – שמירת פרטים אישיים ומפקדים.  
2. **ניהול יחידות** – שם היחידה, המפקד שלה והטנקים שבשירותה.  
3. **ניהול משימות** – מידע על זמני משימות והיחידות המשתתפות בהן.

---

### תרשים ERD של הישויות והקשרים
![image](https://github.com/user-attachments/assets/c2940116-608c-46cf-b77d-5f92aed48a68)


---

### תרשים DSD

![image](https://github.com/user-attachments/assets/b17a63be-be32-42ab-879f-4367fee3f163)


---

### תיאור הישויות והתכונות שלהן

#### `SOLDIERS`- קבוצה של כל החיילים
- `sID` – תעודת זהות  
- `firstName` – שם פרטי  
- `lastName` – שם משפחה  
- `draftDate` – תאריך גיוס  
- `releaseDate` – תאריך שחרור

#### `COMMANDER`- מפקד על טנק או על יחידה. יורש מחיילים
- `cID` – מפתח, תעודת זהות

#### `CREWMATE`- איש צוות בתוך טנק. יורש מחיילים
- `crID` – מפתח, תעודת זהות  
- `cID` – מפתח זר, תעודת הזהות של מפקד הצוות
- `type` – סוג החייל (נהג, טען או תותחן)

#### `UNIT`- יחידה בחיל השריון
- `unID` – מפתח, מספר יחידה מזהה
- `cID` – מפתח זר, תעודת הזהות של מפקד היחידה
- `uName` – שם היחידה

#### `TANK`- טנק בחיל השריון
- `tID` – מפתח, מספר טנק מזהה
- `cID` – מפתח זר, תעודת הזהות של מפקד הטנק
- `unID` – מפתח זר, מספר היחידה המזהה של הטנק

#### `MISSION` - משימה בחיל השריון
- `mID` – מפתח, מספר משימה מזהה
- `mDate` – התאריך בו יוצאת המשימה לפועל

---

### תיאור הקשרים

#### `participates` - רבים לרבים - יחידה שמשתתפת במשימה
- `mID` – מפתח, מספר המשימה מזהה
- `mDate` – מפתח, מספר היחידה מזהה

1. `serves_under` – חייל משרת תחת מפקד (יחיד לרבים).  
2. `commands` – מפקד שולט בטנק (יחיד לרבים).
3. `belongs` - טנק שייך ליחידה (יחיד לרבים).
4. `orders` - מפקד נותן הוראות ליחידה (יחיד לרבים).
---

### רשימת הסכמות של בסיס הנתונים
#### הסכמות של הישויות
- SOLIDERS(sID,firstName,lastName,draftDate,releaseDate)
- COMMANDER(cID)
- CREWMATE(crID,cID,type)
- TANK(tID,unID,cID)
- UNIT(unID,cID,uName)
- MISSION(mID,mdate)
#### הסכמות של הקשרים
- participates(mID,unID)

### הוכחה שהסכמות מנורמלות בNF3
## הוכחה שהסכמות מנורמלות ב-NF3

**SOLDIERS (חיילים)** – המפתח הראשי הוא `sID`. כל שאר התכונות תלויות ישירות במפתח הראשי `sID`. ולכן הטבלה ב-NF3.

**COMMANDER (מפקד)** – `cID` הוא מפתח ראשי וגם מפתח זר המפנה ל-`sID` בטבלה `SOLDIERS`. אין מאפיינים נוספים ולכן הטבלה ב-NF3.

**CREWMATE (איש צוות)** – `type` תלוי ב-`cID` וגם `crID` תלוי ישירות ב-`crID` כמפתח זר. הטבלה ב-NF3.

**UNIT (יחידה)** – `uName` ו-`cID` תלויים במפתח הראשי `unID`. הטבלה נמצאת ב-NF3.

**TANK (טנק)** – `unID` ו-`cID` הן תכונות עם יחסים של מפתחות זרים. אך אין תלות טרנזיטיבית כיוון ש-`tID` הוא המפתח הראשי. ולכן הטבלה ב-NF3.

**MISSION (משימה)** – מכיוון ש-`mdate` תלוי ישירות במפתח הראשי `mID`, הטבלה ב-NF3.

**PARTICIPATES (משתתף)** – גם `mID` וגם `unID` הם מפתחות זרים, והם יוצרים יחד מפתח מורכב. כל מאפיין במפתח המורכב קובע לחלוטין את המאפיינים האחרים.

למסקנה כל הטבלאות עונות על התנאים ל-3NF.


#### קוד SQL של יצירת הטבלאות (CREATE)

```sql
CREATE TABLE SOLDIERS
(
  sID numeric(9) NOT NULL,
  firstName VARCHAR(20) NOT NULL,
  lastName VARCHAR(20) NOT NULL,
  draftDate DATE NOT NULL,
  releaseDate DATE NOT NULL,
  PRIMARY KEY (sID)
);

CREATE TABLE MISSION
(
  mdate DATE NOT NULL,
  mID numeric(9) NOT NULL,
  PRIMARY KEY (mID)
);

CREATE TABLE COMMANDER
(
  cID numeric(9) NOT NULL,
  PRIMARY KEY (cID),
  FOREIGN KEY (cID) REFERENCES SOLDIERS(sID)
);

CREATE TABLE CREWMATE
(
  type VARCHAR(20) NOT NULL,
  crID numeric(9) NOT NULL,
  cID numeric(9) NOT NULL,
  PRIMARY KEY (crID),
  FOREIGN KEY (crID) REFERENCES SOLDIERS(sID),
  FOREIGN KEY (cID) REFERENCES COMMANDER(cID)
);

CREATE TABLE UNIT
(
  unID numeric(9) NOT NULL,
  uName VARCHAR(20) NOT NULL,
  cID numeric(9) NOT NULL,
  PRIMARY KEY (unID),
  FOREIGN KEY (cID) REFERENCES COMMANDER(cID)
);

CREATE TABLE TANK
(
  tID numeric(9) NOT NULL,
  unID numeric(9) NOT NULL,
  cID numeric(9) NOT NULL,
  PRIMARY KEY (tID),
  FOREIGN KEY (unID) REFERENCES UNIT(unID),
  FOREIGN KEY (cID) REFERENCES COMMANDER(cID)
);

CREATE TABLE participates
(
  mID numeric(9) NOT NULL,
  unID numeric(9) NOT NULL,
  PRIMARY KEY (mID, unID),
  FOREIGN KEY (mID) REFERENCES MISSION(mID),
  FOREIGN KEY (unID) REFERENCES UNIT(unID)
);
```
#### קוד SQL של זריקת הטבלאות (DROP)	
```sql
DROP TABLE CREWMATE;
DROP TABLE TANK;
DROP TABLE participates;
DROP TABLE MISSION;
DROP TABLE UNIT;
DROP TABLE COMMANDER;
DROP TABLE SOLDIERS;
```
