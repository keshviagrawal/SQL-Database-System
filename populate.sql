-- -- MERGED POPULATE SCRIPT
-- -- This file concatenates `populate_gpt.sql` followed by `populate.sql`.
-- -- WARNING: Both source files contain INSERTs that include explicit primary-key values
-- -- (e.g., police_id, member_id, safehouse_id, equipment_id, etc.). Running this
-- -- merged script against an existing database may raise duplicate-key errors.
-- --
-- -- Recommendations (see report below): run this on a fresh database created from
-- -- `schema.sql`, or inspect/adjust explicit id ranges before running.

-- -- --------------------------------------------------
-- -- BEGIN: content from populate_gpt.sql
-- -- --------------------------------------------------

-- -- populate_part1_core.sql
-- -- PART 1: Core entities for money_heist (generic realistic theme)
-- -- Run after schema.sql (which defines tables with AUTO_INCREMENT)

-- USE money_heist;

-- -- =========================
-- -- 1) POLICE (10 rows)
-- -- =========================
-- INSERT INTO POLICE (first_name, mid_name, last_name, unit, role) VALUES
-- ('Arjun', NULL, 'Khanna', 'Counter Terror Unit', 'Lead Negotiator'),
-- ('Ritu', 'K.', 'Verma', 'Intelligence Unit', 'Field Commander'),
-- ('Siddharth', NULL, 'Patel', 'Cyber Crime', 'Forensics Specialist'),
-- ('Meera', NULL, 'Nair', 'Investigation', 'Case Officer'),
-- ('Vikram', 'S.', 'Sharma', 'Rapid Response', 'Tactical Lead'),
-- ('Priya', 'A.', 'Desai', 'Crisis Unit', 'Field Liaison'),
-- ('Hemant', NULL, 'Ghosh', 'Evidence Unit', 'Evidence Custodian'),
-- ('Neha', NULL, 'Bose', 'Negotiation', 'Analyst'),
-- ('Rakesh', NULL, 'Kumar', 'Surveillance', 'Intel Operator'),
-- ('Sonal', NULL, 'Rao', 'Legal Affairs', 'Legal Advisor');

-- -- (IDs will be 1..10 in this insertion order)

-- -- =========================
-- -- 2) TEAM_MEMBERS (12 rows)
-- -- =========================
-- INSERT INTO TEAM_MEMBERS (code_name, is_inside_mint, role) VALUES
-- ('PROF', FALSE, 'Master Planner'),
-- ('GHOST', TRUE, 'Infiltration Lead'),
-- ('CIPHER', FALSE, 'Hacker'),
-- ('RAM', TRUE, 'Demolition Expert'),
-- ('FALCON', FALSE, 'Lookout / Scout'),
-- ('VIXEN', TRUE, 'Negotiator Liaison'),
-- ('TITAN', FALSE, 'Muscle / Logistics'),
-- ('MANTIS', FALSE, 'Medic'),
-- ('PHOENIX', TRUE, 'Vault Specialist'),
-- ('ECHO', FALSE, 'Communications'),
-- ('NOVA', TRUE, 'Driver / Escape Lead'),
-- ('ORION', FALSE, 'Supply Coordinator');

-- -- (member_id 1..12 in this insertion order)

-- -- =========================
-- -- 3) SAFEHOUSE (5 rows)
-- -- =========================
-- INSERT INTO SAFEHOUSE (capacity, security_level, is_active, street, city, code) VALUES
-- (8, 'Red', TRUE, '14 Orchard Lane', 'Hyderabad', 301),
-- (6, 'Yellow', TRUE, '9 Riverfront Ave', 'Bengaluru', 302),
-- (12, 'Red', TRUE, '23 Old Mill Rd', 'Mumbai', 303),
-- (5, 'Green', TRUE, '7 Hillcrest Drive', 'Pune', 304),
-- (10, 'Yellow', TRUE, '88 Lakeside Blvd', 'Chennai', 305);

-- -- (safehouse_id 1..5)

-- -- =========================
-- -- 4) SUPPLIER (6 rows)
-- -- =========================
-- INSERT INTO SUPPLIER (first_name, mid_name, last_name, reliability_score) VALUES
-- ('Arman', NULL, 'Singh', 'High'),
-- ('Leela', 'P.', 'Iyer', 'Medium'),
-- ('Deepak', NULL, 'Reddy', 'Low'),
-- ('Simran', NULL, 'Kaur', 'High'),
-- ('Karan', NULL, 'Joshi', 'Medium'),
-- ('Maya', NULL, 'Patel', 'High');

-- -- (supplier_id 1..6)

-- -- =========================
-- -- 5) HOSTAGES (20 rows)
-- -- - hostage_id is AUTO_INCREMENT (we omit it here)
-- -- - police_id references POLICE (we use ids 1..10 from above)
-- -- =========================
-- INSERT INTO HOSTAGES (first_name, mid_name, last_name, age, status, zone, govt_posn, risk_factor, police_id) VALUES
-- ('Aditi', NULL, 'Kapoor', 45, 'Pending', 'North', 'Treasury Manager', 'High', 1),
-- ('Rohan', 'K', 'Mehta', 38, 'In-Progress', 'South', 'Regional Director', 'Medium', 2),
-- ('Sneha', NULL, 'Reddy', 29, 'Pending', 'East', 'Accountant', 'Low', 1),
-- ('Imran', NULL, 'Sheikh', 32, 'Resolved', 'West', 'Civil Servant', 'High', 5),
-- ('Neha', 'M', 'Singh', 27, 'In-Progress', 'North', 'Legal Counsel', 'Medium', 2),
-- ('Vikram', NULL, 'Patnaik', 50, 'Pending', 'East', 'Bank Governor', 'High', 3),
-- ('Meena', NULL, 'Roy', 41, 'In-Progress', 'West', 'Finance Officer', 'Medium', 4),
-- ('Arjun', NULL, 'Bhat', 34, 'Pending', 'North', 'Security Chief', 'High', 6),
-- ('Simmi', NULL, 'Gupta', 22, 'In-Progress', 'South', 'Teller', 'Low', 7),
-- ('Adil', NULL, 'Khan', 36, 'Pending', 'East', 'IT Admin', 'Medium', 3),
-- ('Sunita', NULL, 'Pillai', 48, 'Pending', 'West', 'Registrar', 'High', 8),
-- ('Rakesh', NULL, 'Agarwal', 39, 'In-Progress', 'North', 'Logistics Head', 'Medium', 2),
-- ('Mira', NULL, 'Das', 26, 'Pending', 'South', 'Analyst', 'Low', 9),
-- ('Karan', NULL, 'Shah', 31, 'Resolved', 'East', 'Procurement Officer', 'Medium', 4),
-- ('Priya', NULL, 'Chopra', 28, 'In-Progress', 'West', 'Communications Lead', 'High', 1),
-- ('Ravi', NULL, 'Kumar', 55, 'Pending', 'North', 'Senior Auditor', 'High', 5),
-- ('Anjali', NULL, 'Bhandari', 33, 'In-Progress', 'South', 'Assistant Manager', 'Medium', 6),
-- ('Tarun', NULL, 'Bhatt', 29, 'Pending', 'East', 'Security Analyst', 'Low', 7),
-- ('Navya', NULL, 'Rao', 42, 'In-Progress', 'West', 'Head of Ops', 'High', 8),
-- ('Iqbal', NULL, 'Ansari', 46, 'Pending', 'North', 'Treasury Clerk', 'Medium', 9);

-- -- (hostage_id 1..20 in insertion order)

-- -- =========================
-- -- End of PART 1 (core entities)
-- -- Next: PART 2 will populate contacts, dependents, medical conditions, team roles, security systems, etc.
-- -- Run this file first, then run part2 and part3 in order.
-- -- If you want, I can combine all parts into one populate.sql after generating the rest.
-- -- =========================

-- USE money_heist;

-- -- =============================
-- -- 1) POLICE_CONTACT  (each police has 1–2 contacts)
-- -- IDs 1..10 from POLICE
-- -- =============================
-- INSERT IGNORE INTO POLICE_CONTACT (police_id, phone_number, email) VALUES
-- (1, '9876543201', 'arjun.khanna@ctu.gov'),
-- (1, '9876543202', 'akhanna@ctu.gov'),
-- (2, '9811122233', 'ritu.verma@intel.gov'),
-- (3, '9822233344', 'sid.patel@cyber.gov'),
-- (4, '9833344455', 'meera.nair@inv.gov'),
-- (5, '9844455566', 'vikram.sharma@rrf.gov'),
-- (6, '9855566677', 'priya.desai@crisis.gov'),
-- (7, '9866677788', 'hemant.ghosh@evid.gov'),
-- (8, '9877788899', 'neha.bose@nego.gov'),
-- (9, '9888899900', 'rakesh.kumar@surv.gov'),
-- (10,'9899900011', 'sonal.rao@legal.gov');

-- -- =============================
-- -- 2) TEAM_MEMBER_CONTACT (IDs 1..12 from TEAM_MEMBERS)
-- -- =============================
-- INSERT IGNORE INTO TEAM_MEMBER_CONTACT (member_id, phone_number, email) VALUES
-- (1, '9001100001', 'prof@operation.net'),
-- (2, '9001100002', 'ghost@operation.net'),
-- (3, '9001100003', 'cipher@operation.net'),
-- (4, '9001100004', 'ram@operation.net'),
-- (5, '9001100005', 'falcon@operation.net'),
-- (6, '9001100006', 'vixen@operation.net'),
-- (7, '9001100007', 'titan@operation.net'),
-- (8, '9001100008', 'mantis@operation.net'),
-- (9, '9001100009', 'phoenix@operation.net'),
-- (10,'9001100010', 'echo@operation.net'),
-- (11,'9001100011', 'nova@operation.net'),
-- (12,'9001100012', 'orion@operation.net');

-- -- =============================
-- -- 3) DEPENDENTS (20 hostages from Part 1)
-- -- =============================
-- -- 1–2 dependents per hostage
-- INSERT INTO DEPENDENTS (first_name, mid_name, last_name, hostage_id, relation, age) VALUES
-- ('Kavya', NULL, 'Kapoor', 1, 'Daughter', 17),
-- ('Rajiv', NULL, 'Kapoor', 1, 'Husband', 48),

-- ('Mitali', NULL, 'Mehta', 2, 'Wife', 34),

-- ('Rupa', NULL, 'Reddy', 3, 'Mother', 55),

-- ('Sara', NULL, 'Sheikh', 4, 'Wife', 30),

-- ('Ishita', NULL, 'Singh', 5, 'Sister', 21),

-- ('Rahul', NULL, 'Patnaik', 6, 'Son', 22),
-- ('Neeraj', NULL, 'Patnaik', 6, 'Son', 19),

-- ('Om', NULL, 'Roy', 7, 'Husband', 44),

-- ('Reena', NULL, 'Bhat', 8, 'Wife', 31),

-- ('Trisha', NULL, 'Gupta', 9, 'Sister', 19),

-- ('Kashish', NULL, 'Khan', 10, 'Wife', 33),

-- ('Mahima', NULL, 'Pillai', 11, 'Daughter', 18),
-- ('Arvind', NULL, 'Pillai', 11, 'Husband', 50),

-- ('Anish', NULL, 'Agarwal', 12, 'Son', 12),

-- ('Vidya', NULL, 'Das', 13, 'Mother', 53),

-- ('Naina', NULL, 'Shah', 14, 'Wife', 29),

-- ('Rohit', NULL, 'Chopra', 15, 'Brother', 24),

-- ('Vaishnavi', NULL, 'Kumar', 16, 'Wife', 52),

-- ('Dev', NULL, 'Bhandari', 17, 'Husband', 35);

-- -- ... (rest of populate_gpt.sql content follows) 

-- -- --------------------------------------------------
-- -- END: content from populate_gpt.sql
-- -- --------------------------------------------------


-- -- --------------------------------------------------
-- -- BEGIN: content from populate.sql
-- -- --------------------------------------------------

-- USE money_heist;

-- -- =========================
-- -- POLICE + CONTACTS
-- -- =========================

-- -- POLICE (15 rows)
-- INSERT INTO POLICE (first_name, mid_name, last_name, unit, role) VALUES
-- ('Alicia','M.','Ramos','Negotiations Unit','Lead Negotiator'),
-- ('David',NULL,'Khan','Tactical Response','Field Commander'),
-- ('Priya','S.','Singh','Forensics','Evidence Analyst'),
-- ('Marcus',NULL,'Lopez','Intelligence','Analyst'),
-- ('Hannah','E.','Osei','Negotiations Unit','Negotiator'),
-- ('Liu',NULL,'Chen','Tactical Response','Tactical Officer'),
-- ('Omar','A.','Zayed','Cyber','Digital Forensics'),
-- ('Natalie',NULL,'Brown','Hostage Response','Coordinator'),
-- ('Igor',NULL,'Petrov','Tactical Response','Sniper'),
-- ('Sofia',NULL,'Garcia','Liaison','Public Liaison'),
-- ('Ahmed',NULL,'Saleem','Intelligence','Analyst'),
-- ('Grace',NULL,'Park','Forensics','Lab Tech'),
-- ('Kofi',NULL,'Mensah','Negotiations Unit','Support Negotiator'),
-- ('Yara',NULL,'Alami','Tactical Response','Medic'),
-- ('Tom',NULL,'Reed','Logistics','Logistics Officer');
-- -- POLICE_CONTACT (25 rows)

-- INSERT INTO POLICE_CONTACT (police_id, phone_number, email) VALUES
-- (11,'+1-555-0101','alicia.ramos@citypd.example'),(1,'+1-555-0102','a.ramos@citypd.example'),
-- (2,'+1-555-0201','david.khan@citypd.example'),(2,'+1-555-0202','khan.david@citypd.example'),
-- (3,'+1-555-0301','priya.singh@citypd.example'),(4,'+1-555-0401','marcus.lopez@citypd.example'),
-- (5,'+1-555-0501','hannah.osei@citypd.example'),(5,'+1-555-0502','h.osei@citypd.example'),
-- (6,'+1-555-0601','liu.chen@citypd.example'),(7,'+1-555-0701','omar.zayed@citypd.example'),
-- (8,'+1-555-0801','natalie.brown@citypd.example'),(9,'+1-555-0901','igor.petrov@citypd.example'),
-- (10,'+1-555-1001','sofia.garcia@citypd.example'),(11,'+1-555-1101','ahmed.saleem@citypd.example'),
-- (12,'+1-555-1201','grace.park@citypd.example'),(13,'+1-555-1301','kofi.mensah@citypd.example'),
-- (14,'+1-555-1401','yara.alami@citypd.example'),(15,'+1-555-1501','tom.reed@citypd.example'),
-- (3,'+1-555-0302','priya.alt@citypd.example'),(4,'+1-555-0402','marcus.alt@citypd.example'),
-- (6,'+1-555-0602','liu.alt@citypd.example'),(7,'+1-555-0702','omar.alt@citypd.example'),
-- (8,'+1-555-0802','natalie.alt@citypd.example'),(9,'+1-555-0902','igor.alt@citypd.example'),(10,'+1-555-1002','sofia.alt@citypd.example');

-- -- TEAM_MEMBERS (20 rows)
-- INSERT INTO TEAM_MEMBERS (member_id, code_name, is_inside_mint, role) VALUES
-- (1001,'The Professor',FALSE,'Mastermind'),(1002,'Tokyo',TRUE,'Operative'),(1003,'Rio',TRUE,'Hacker'),
-- (1004,'Denver',TRUE,'Demolitions'),(1005,'Berlin',FALSE,'Coordinator'),(1006,'Nairobi',TRUE,'Logistics'),
-- (1007,'Helsinki',TRUE,'Enforcer'),(1008,'Oslo',TRUE,'Driver'),(1009,'Stockholm',FALSE,'Negotiator Support'),
-- (1010,'Lisbon',FALSE,'Field Planner'),(1011,'Palermo',TRUE,'Tactical Lead'),(1012,'Bogota',TRUE,'Support'),
-- (1013,'Manila',TRUE,'Medic'),(1014,'Sierra',FALSE,'Observer'),(1015,'Delta',TRUE,'Tech Support'),
-- (1016,'Echo',FALSE,'Scout'),(1017,'Foxtrot',TRUE,'Analyst'),(1018,'Gamma',TRUE,'Mechanic'),(1019,'Hotel',FALSE,'Communications'),(1020,'India',TRUE,'Backup');

-- -- ... (rest of populate.sql follows)

-- -- --------------------------------------------------
-- -- END: content from populate.sql
-- -- --------------------------------------------------

-- -- END OF MERGED SCRIPT

-- -- MERGE REPORT (auto-generated): potential contradictions and notes
-- -- 1) Primary-key collisions: both source files include explicit primary-key values for many
-- --    tables (POLICE, TEAM_MEMBERS, SAFEHOUSE, EQUIPMENT, MISSIONS, HOSTAGES, etc.). If you
-- --    run this merged script on an existing DB or run both parts sequentially, you'll likely
-- --    get duplicate-key errors. Recommended: run on a fresh DB (drop/create via schema.sql) or
-- --    remove explicit id columns in one source before running.
-- -- 2) Duplicate contact rows: both files include many contact entries for police/team members.
-- --    I changed contact insert statements in `populate_gpt.sql` to use INSERT IGNORE to avoid
-- --    immediate failure; however duplicates may still exist across the rest of the data.
-- -- 3) MISSION_EXECUTION schema change: `schema.sql` now defines a surrogate `mission_execution_id`
-- --    primary key and allows safehouse_id/equipment_id to be NULL. Existing INSERTs that specify
-- --    (mission_code, member_id, safehouse_id, equipment_id) will still work (auto-increment id will
-- --    be assigned), but if you previously relied on the composite PK that is now a unique index,
-- --    behavior differs slightly.
-- -- 4) Referenced IDs: many INSERTs reference explicit foreign keys (e.g., police_id=1). If you
-- --    allow auto-assignment of ids, those references may break. Decide whether to retain explicit
-- --    IDs (and ensure non-overlap) or let the DB assign and rewrite FK references accordingly.

-- -- If you want, I can:
-- -- - Produce a "clean" merged script that rewrites all explicit id usage to use auto-increment (remove
-- --   id columns) and remap foreign keys accordingly (more involved), OR
-- -- - Offset explicit id ranges in one file to avoid collisions (e.g., add 10000 to all explicit ids in
-- --   populate.sql), OR
-- -- - Produce a merged script that truncates tables first and then inserts both datasets (lose previous data), OR
-- -- - Attempt a smarter de-duplication pass that merges rows for the same logical entities (harder but doable).

-- -- Tell me which approach you prefer and I'll produce a runnable merged script accordingly.


USE money_heist;

INSERT INTO POLICE (police_id, first_name, mid_name, last_name, unit, role) VALUES
(1,'Alicia',NULL,'Moreno','Negotiations Unit','Senior Negotiator'),
(2,'Rajat','K.','Singh','Tactical Unit','Field Commander'),
(3,'Meera',NULL,'Patel','Intelligence','Analyst'),
(4,'David',NULL,'Lopez','Forensics','Investigator'),
(5,'Hannah',NULL,'Khan','Negotiations Unit','Negotiator'),
(6,'Omar',NULL,'Hussain','Tactical Unit','Sniper Lead'),
(7,'Priya',NULL,'Bose','Logistics','Coordinator'),
(8,'Liam',NULL,'Turner','Forensics','Technician'),
(9,'Sofia',NULL,'Garcia','Intelligence','Field Analyst'),
(10,'Noah',NULL,'Reed','Special Ops','Team Lead'),
(11,'Imran',NULL,'Qureshi','Negotiations Unit','Support Negotiator'),
(12,'Eva',NULL,'Martinez','Field Ops','Liaison'),
(13,'Carlos',NULL,'Dominguez','Tactical Unit','Breacher'),
(14,'Yuki',NULL,'Sato','Cyber','Digital Forensics'),
(15,'Maya',NULL,'Sharma','Victim Support','Case Worker');

INSERT INTO POLICE_CONTACT (police_id, phone_number, email) VALUES
(1,'+91-9000010001','alicia.moreno@pd.example'),
(14,'+91-9030310014','yuki.sato@pd.example'),
(2,'+91-9000010002','rajat.singh@pd.example'),
(2,'+91-9000010002','rajat.singh1213@pd.example'),
(3,'+91-9000010003','meera.patel@pd.example'),
(4,'+91-9000010004','david.lopez@pd.example'),
(12,'+91-9233010012','eva.martinez@pd.example'),
(5,'+91-9000010005','hannah.khan@pd.example'),
(6,'+91-9000010006','omar.hussain@pd.example'),
(7,'+91-9000010007','priya.bose@pd.example'),
(7,'+91-9000010007','priya.bose7667@pd.example'),
(8,'+91-9000010008','liam.turner1@pd.example'),
(8,'+91-9001111208','liam.turner@pd.example'),
(8,'+91-9000010008','liam.turner2123@pd.example'),
(9,'+91-9000010009','sofia.garcia@pd.example'),
(10,'+91-9000010010','noah.reed@pd.example'),
(10,'+91-9000010010','nossrfdh.reed@pd.example'),
(3,'+91-9000010209','meera.patel@pd.example'),
(11,'+91-9000010011','imran.qureshi@pd.example'),
(12,'+91-9000010012','eva.martinez@pd.example'),
(12,'+91-9089010012','eva.martinez@pd.example'),
(13,'+91-9000010013','carlos.dominguez@pd.example'),
(14,'+91-9000010014','yuki.sato@pd.example'),
(15,'+91-9000010015','maya.sharma@pd.example'),
(7,'+91-9200010007','priya.bose@pd.example');

-- 3) TEAM_MEMBERS (15 rows)
INSERT INTO TEAM_MEMBERS (member_id, code_name, is_inside_mint, role) VALUES
(1,'Tokyo',TRUE,'Inside Operative'),
(2,'Berlin',FALSE,'Tactical Lead'),
(3,'Nairobi',TRUE,'Counterfeiter'),
(4,'Rio',TRUE,'Electronics'),
(5,'Denver',TRUE,'Runner'),
(6,'Moscow',FALSE,'Demolitions'),
(7,'Helsinki',TRUE,'Muscle'),
(8,'Oslo',FALSE,'Scout'),
(9,'Stockholm',FALSE,'Negotiator Support'),
(10,'Lisbon',FALSE,'Field Liaison'),
(11,'Palermo',FALSE,'Strategist'),
(12,'Bogota',TRUE,'Logistics'),
(13,'Marseille',FALSE,'Sniper Support'),
(14,'Manila',TRUE,'Hacker Support'),
(15,'Rome',FALSE,'Medic');

-- 4) TEAM_MEMBER_CONTACT (15 rows)
INSERT INTO TEAM_MEMBER_CONTACT (member_id, phone_number, email) VALUES
(1,'+91-9100010001','tokyo@example'),
(2,'+91-9100010002','berlin@example'),
(3,'+91-9100010003','nairobi@example'),
(4,'+91-9100010004','rio@example'),
(5,'+91-9100010005','denver@example'),
(6,'+91-9100010006','moscow@example'),
(7,'+91-9100010007','helsinki@example'),
(8,'+91-9100010008','oslo@example'),
(9,'+91-9100010009','stockholm@example'),
(10,'+91-9100010010','lisbon@example'),
(11,'+91-9100010011','palermo@example'),
(12,'+91-9100010012','bogota@example'),
(13,'+91-9100010013','marseille@example'),
(14,'+91-9100010014','manila@example'),
(15,'+91-9100010015','rome@example');

-- 5) CREW (15 rows)
INSERT INTO CREW (member_id) VALUES
(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12),(13),(14),(15);

-- -- 6) PROFESSOR (15 rows)
-- INSERT INTO PROFESSOR (member_id, professor_name) VALUES
-- (1,'Sergio Marquina'),(2,'Prof Berlin'),(3,'Prof Nairobi'),(4,'Prof Rio'),(5,'Prof Denver'),
-- (6,'Prof Moscow'),(7,'Prof Helsinki'),(8,'Prof Oslo'),(9,'Prof Stockholm'),(10,'Prof Lisbon'),
-- (11,'Prof Palermo'),(12,'Prof Bogota'),(13,'Prof Marseille'),(14,'Prof Manila'),(15,'Prof Rome');

-- 6) PROFESSOR (15 rows)
INSERT INTO PROFESSOR (member_id, professor_name) VALUES
(1,'Sergio Marquina');

-- 7) HACKER
INSERT INTO HACKER (member_id) VALUES
(2),(3),(5),(6),(7),(9),(10),(11),(12),(14),(15);

-- 8) SECURITY_SYSTEM (15 rows)
INSERT INTO SECURITY_SYSTEM (system_id, system_type, status, location_description, security_level, member_id) VALUES
(1,'Camera','Active','Entrance hall cameras','High',2),
(2,'Sensor','Active','Vault proximity sensors','High',2),
(3,'Alarm','Inactive','Secondary corridor alarm','Medium',3),
(4,'Camera','Active','Rooftop coverage','Medium',7),
(5,'Lock','Under Maintenance','External lock system','High',5),
(6,'Camera','Active','Parking area cameras','Low',6),
(7,'Sensor','Active','Perimeter sensor array','High',7),
(8,'Alarm','Active','Control room alarm','High',10),
(9,'Camera','Inactive','Back alley camera','Low',9),
(10,'Sensor','Active','Air ventilation monitors','Medium',10),
(11,'Lock','Active','Inner vault lock','High',11),
(12,'Camera','Active','Street camera','Low',12),
(13,'Sensor','Under Maintenance','Water sensor near vault','Medium',11),
(14,'Alarm','Active','Silent alarm','High',14),
(15,'Camera','Active','Lobby camera','Medium',15);

-- 9) SAFEHOUSE (15 rows)
INSERT INTO SAFEHOUSE (safehouse_id, capacity, security_level, is_active, street, city, code) VALUES
(1,6,'High',1,'1 Mint St','Capital',10001),
(2,4,'Medium',1,'12 River Rd','Riverside',10002),
(3,8,'High',1,'3 Market Ln','Oldtown',10003),
(4,3,'Low',1,'45 Hill St','Uptown',10004),
(5,10,'High',1,'78 Harbor Ave','Seaport',10005),
(6,5,'Medium',1,'9 Baker St','Downtown',10006),
(7,2,'Low',1,'22 Pine Rd','Suburb',10007),
(8,7,'High',1,'100 Oak Blvd','Capital',10008),
(9,4,'Medium',1,'11 Lakeview','Lakeside',10009),
(10,6,'High',1,'55 King St','Uptown',10010),
(11,3,'Low',1,'23 Elm St','Suburb',10011),
(12,5,'Medium',1,'66 Main St','Oldtown',10012),
(13,8,'High',1,'7 Castle Rd','Historic',10013),
(14,4,'Medium',1,'88 Grove Ave','Riverside',10014),
(15,9,'High',1,'2 Manor Dr','Capital',10015);

-- 10) EQUIPMENT (15 rows)
INSERT INTO EQUIPMENT (equipment_id, total_quantity, equipment_count, curr_location_id) VALUES
(1,10,2,1),(2,5,1,2),(3,20,3,3),(4,8,1,4),(5,15,2,5),(6,6,1,6),(7,12,2,7),(8,4,1,8),(9,9,2,9),(10,7,1,10),(11,3,1,11),(12,14,2,12),(13,2,1,13),(14,11,2,14),(15,16,3,15);

-- 11) SUPPLIER (15 rows)
INSERT INTO SUPPLIER (first_name, mid_name, last_name, supplier_id, reliability_score) VALUES
('Ramesh',NULL,'Iyer',1,'High'),('Leila',NULL,'Khan',2,'Medium'),('Tom',NULL,'Wright',3,'High'),('Ana',NULL,'Silva',4,'Medium'),
('Chen',NULL,'Li',5,'High'),('Sara',NULL,'Nolan',6,'Low'),('Ola',NULL,'Bjorn',7,'Medium'),('Diego',NULL,'Marin',8,'High'),
('Emma',NULL,'Clark',9,'Medium'),('Vikram',NULL,'Desai',10,'High'),('Rita',NULL,'Borges',11,'Low'),('Paul',NULL,'Adams',12,'Medium'),
('Hana',NULL,'Sato',13,'High'),('Yusef',NULL,'Elman',14,'Medium'),('Nina',NULL,'Kovacs',15,'High');

-- 12) SUPPLIER_CONTACT (15 rows)
INSERT INTO SUPPLIER_CONTACT (supplier_id, phone_number, email) VALUES
(1,'+91-9300010001','ramesh.iyer@supply.example'),(2,'+91-9300010002','leila.khan@supply.example'),
(3,'+91-9300010003','tom.wright@supply.example'),(4,'+91-9300010004','ana.silva@supply.example'),
(5,'+91-9300010005','chen.li@supply.example'),(6,'+91-9300010006','sara.nolan@supply.example'),
(7,'+91-9300010007','ola.bjorn@supply.example'),(8,'+91-9300010008','diego.marin@supply.example'),
(9,'+91-9300010009','emma.clark@supply.example'),(10,'+91-9300010010','vikram.desai@supply.example'),
(11,'+91-9300010011','rita.borges@supply.example'),(12,'+91-9300010012','paul.adams@supply.example'),
(13,'+91-9300010013','hana.sato@supply.example'),(14,'+91-9300010014','yusef.elman@supply.example'),
(15,'+91-9300010015','nina.kovacs@supply.example');

-- 13) EVIDENCE (15 rows)
INSERT INTO EVIDENCE (evidence_id, police_id, description, threat_level) VALUES
(1,1,'Surveillance footage of suspects near mint','High'),
(2,2,'Toolset with explosive residue','High'),
(3,3,'USB with forged currency designs','Medium'),
(4,14,'Handwritten notes about vault timings','Medium'),
(5,5,'Walkie-talkie frequency logs','Low'),
(6,6,'Sniper scope lens','High'),
(7,7,'Van rental receipts','Low'),
(8,7,'Forensics sample: paint chips','Low'),
(9,1,'Network logs from security cameras','High'),
(10,10,'Blueprints of the mint','High'),
(11,12,'Anonymous tip transcripts','Medium'),
(12,1,'Supplier invoices','Low'),
(13,3,'Access card duplicates','High'),
(14,9,'Encrypted laptop','High'),
(15,15,'Medical records of hostage','Medium');

-- 14) HOSTAGES (15 rows)
INSERT INTO HOSTAGES (hostage_id, first_name, mid_name, last_name, age, status, zone, govt_posn, risk_factor, police_id) VALUES
(1,'Rita',NULL,'Fernandes',32,'Pending','ZoneA','Treasury Official','High',1),
(2,'Samuel',NULL,'Green',45,'In-Progress','ZoneB','Bank Manager','High',2),
(3,'Lina',NULL,'Cho',28,'Pending','ZoneC','Cashier','Medium',3),
(4,'Omar',NULL,'Abdullah',39,'In-Progress','ZoneA','Maintenance Head','Medium',4),
(5,'Priyanka',NULL,'Verma',34,'Pending','ZoneB','Admin','Low',5),
(6,'Carlos',NULL,'Mendez',50,'In-Progress','ZoneC','Security Chief','High',6),
(7,'Sara',NULL,'Lopez',26,'Pending','ZoneA','Intern','Low',7),
(8,'Jamal',NULL,'Khan',31,'In-Progress','ZoneB','Supervisor','Medium',8),
(9,'Marta',NULL,'Silva',29,'Pending','ZoneC','Clerk','Low',9),
(10,'Igor',NULL,'Petrov',41,'Pending','ZoneA','Engineer','High',10),
(11,'Aisha',NULL,'Rahman',37,'In-Progress','ZoneB','HR Lead','Medium',11),
(12,'Ben',NULL,'Rossi',48,'Pending','ZoneC','Accountant','Low',12),
(13,'Nora',NULL,'Alvarez',22,'Pending','ZoneA','Trainee','Low',13),
(14,'Kenji',NULL,'Yamada',44,'In-Progress','ZoneB','Manager','High',14),
(15,'Laila',NULL,'Hassan',35,'Pending','ZoneC','Receptionist','Medium',15);

-- 15) HOSTAGE_MEDICAL_CONDITION (15 rows)
INSERT INTO HOSTAGE_MEDICAL_CONDITION (hostage_id, hostage_ailment) VALUES
(1,'Asthma'),(2,'Diabetes'),(3,'None'),(4,'Hypertension'),(5,'Pregnancy'),(6,'None'),(7,'Allergy'),(8,'None'),(9,'Anxiety'),(10,'None'),(11,'None'),(12,'None'),(13,'None'),(14,'Heart Condition'),(15,'None');

-- 16) DEPENDENTS (15 rows)
INSERT INTO DEPENDENTS (dependent_id, first_name, mid_name, last_name, hostage_id, relation, age) VALUES
(1,'Sam',NULL,'Fernandes',1,'Son',6),(2,'Rohit',NULL,'Green',2,'Son',12),(3,'Maya',NULL,'Cho',3,'Daughter',5),
(4,'Zara',NULL,'Abdullah',4,'Wife',35),(5,'Isha',NULL,'Verma',5,'Sister',28),(6,'Luis',NULL,'Mendez',6,'Son',20),
(7,'Nina',NULL,'Lopez',7,'Mother',50),(8,'Omar Jr',NULL,'Khan',8,'Son',8),(9,'Paulo',NULL,'Silva',9,'Brother',31),
(10,'Anton',NULL,'Petrov',10,'Son',15),(11,'Hana',NULL,'Rahman',11,'Daughter',9),(12,'Giorgio',NULL,'Rossi',12,'Son',25),
(13,'Elena',NULL,'Alvarez',13,'Mother',48),(14,'Sora',NULL,'Yamada',14,'Daughter',16),(15,'Muna',NULL,'Hassan',15,'Sister',30);

-- 17) MONITORED (15 rows)
INSERT INTO MONITORED (hostage_id, system_id) VALUES
(1,1),(1,2),(2,2),(2,3),(3,3),(4,5),(4,4),(5,5),(6,6),(7,7),(8,8),(7,9),(9,9),(10,10),(11,11),(12,12),(9,10),(13,13),(14,14),(15,15);

-- 18) CLAIMS (15 rows)
INSERT INTO CLAIMS (police_id, hostage_id) VALUES
(1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(7,7),(8,8),(9,9),(10,10),(11,11),(12,12),(13,13),(14,14),(15,15);

-- 19) NEGOTIATES (15 rows)
INSERT INTO NEGOTIATES (police_id, member_id) VALUES
(1,9),(2,10),(3,11),(4,12),(5,1),(6,2),(7,3),(8,4),(9,5),(10,6),(11,7),(12,8),(13,13),(14,14),(15,15);

-- 20) MISSION_DETAILS (15 rows)
INSERT INTO MISSION_DETAILS (mission_id, start_time, end_time, stage, zone, description) VALUES
(1,'2025-10-01 08:00:00','2025-10-01 18:00:00','Completed','ZoneA','Initial recon mission'),
(2,'2025-10-05 09:00:00',NULL,'Ongoing','ZoneB','Supply drop operation'),
(3,'2025-10-10 06:00:00',NULL,'Planned','ZoneC','Vault entry dry-run'),
(4,'2025-10-15 22:00:00','2025-10-16 03:00:00','Completed','ZoneA','Main operation'),
(5,'2025-11-01 07:00:00',NULL,'Ongoing','ZoneB','Evacuation support'),
(6,'2025-11-05 11:00:00',NULL,'Planned','ZoneC','Diversion activities'),
(7,'2025-11-08 12:00:00',NULL,'Planned','ZoneA','Intel gathering'),
(8,'2025-11-10 14:00:00',NULL,'Planned','ZoneB','Tech infiltration'),
(9,'2025-11-12 16:00:00',NULL,'Planned','ZoneC','Supply chain disruption'),
(10,'2025-11-14 18:00:00',NULL,'Planned','ZoneA','Cover extraction'),
(11,'2025-11-16 20:00:00',NULL,'Planned','ZoneB','Communications blackout'),
(12,'2025-11-18 21:00:00',NULL,'Planned','ZoneC','Secondary breach'),
(13,'2025-11-20 22:00:00',NULL,'Planned','ZoneA','Signal interception'),
(14,'2025-11-22 23:00:00',NULL,'Planned','ZoneB','Final approach'),
(15,'2025-11-25 09:00:00',NULL,'Planned','ZoneC','Post-op cleanup');

-- 21) MISSION_IDENTIFIER (15 rows)
INSERT INTO MISSION_IDENTIFIER (mission_id, mission_code) VALUES
(1,'M001'),(2,'M002'),(3,'M003'),(4,'M004'),(5,'M005'),(6,'M006'),(7,'M007'),(8,'M008'),(9,'M009'),(10,'M010'),(11,'M011'),(12,'M012'),(13,'M013'),(14,'M014'),(15,'M015');

-- 22) TIME_DETAILS (15 rows)
INSERT INTO TIME_DETAILS (member_id, mission_code, timestamp) VALUES
(1,'M001','2025-10-01 08:10:00'),(2,'M002','2025-10-05 09:15:00'),(3,'M003','2025-10-10 06:05:00'),
(4,'M004','2025-10-15 22:10:00'),(5,'M005','2025-11-01 07:20:00'),(6,'M006','2025-11-05 11:30:00'),
(7,'M007','2025-11-08 12:05:00'),(8,'M008','2025-11-10 14:25:00'),(9,'M009','2025-11-12 16:45:00'),
(10,'M010','2025-11-14 18:10:00'),(11,'M011','2025-11-16 20:05:00'),(12,'M012','2025-11-18 21:20:00'),
(13,'M013','2025-11-20 22:15:00'),(14,'M014','2025-11-22 23:30:00'),(15,'M015','2025-11-25 09:05:00');

-- 23) COMMUNICATION_LOG (15 rows)
INSERT INTO COMMUNICATION_LOG (channel_id, timestamp, msg_type, negotiator_id, duration, content) VALUES
(1,'2025-10-01 09:00:00','Email',1,30,'Initial contact established'),
(2,'2025-10-05 10:00:00','Phone',2,45,'Supply confirmation'),
(3,'2025-10-10 11:00:00','Radio',3,20,'Scope alignment'),
(4,'2025-10-15 12:00:00','Video',4,60,'Live feed exchange'),
(5,'2025-11-01 13:00:00','Chat',5,15,'Quick update'),
(6,'2025-11-05 14:00:00','Phone',6,50,'Tactical brief'),
(7,'2025-11-08 15:00:00','Radio',7,25,'Position report'),
(8,'2025-11-10 16:00:00','Email',8,10,'Logistics note'),
(9,'2025-11-12 17:00:00','Video',9,40,'Negotiation clip'),
(10,'2025-11-14 18:30:00','Phone',10,35,'Coordination'),
(11,'2025-11-16 19:00:00','Chat',11,20,'Fallback plan'),
(12,'2025-11-18 20:10:00','Radio',12,55,'Comm blackout practice'),
(13,'2025-11-20 21:30:00','Email',13,5,'Quick ping'),
(14,'2025-11-22 22:45:00','Video',14,70,'Final instructions'),
(15,'2025-11-25 09:10:00','Phone',15,60,'Debrief');

-- 24) STRATEGIC_PLANNING (15 rows)
INSERT INTO STRATEGIC_PLANNING (member_id, mission_code, channel_id, police_id) VALUES
(1,'M001',1,1),(2,'M002',2,2),(3,'M003',3,3),(4,'M004',4,4),(5,'M005',5,5),(6,'M006',6,6),(7,'M007',7,7),(8,'M008',8,8),(9,'M009',9,9),(10,'M010',10,10),(11,'M011',11,11),(12,'M012',12,12),(13,'M013',13,13),(14,'M014',14,14),(15,'M015',15,15);

-- 25) EQUIPMENT_SPECIFICATIONS (15 rows)
INSERT INTO EQUIPMENT_SPECIFICATIONS (equipment_id, equipment_type, critical) VALUES
(1,'Drill','High'),(2,'Rope','Medium'),(3,'Printer','High'),(4,'Explosives','High'),(5,'Radio','Medium'),(6,'Scope','High'),(7,'Van','Low'),(8,'Laptop','Medium'),(9,'Router','Medium'),(10,'Drill Bits','Low'),(11,'Lockpick Kit','Medium'),(12,'Batteries','Low'),(13,'Access Card','High'),(14,'Encrypted HDD','High'),(15,'Medical Kit','Medium');

-- 26) MISSION_EXECUTION (15 rows)
INSERT INTO MISSION_EXECUTION (mission_code, member_id, safehouse_id, equipment_id) VALUES
('M001',1,1,1),('M002',2,2,2),('M003',3,3,3),('M004',4,4,4),('M005',5,5,5),('M006',6,6,6),('M007',7,7,7),('M008',8,8,8),('M009',9,9,9),('M010',10,10,10),('M011',11,11,11),('M012',12,12,12),('M013',13,13,13),('M014',14,14,14),('M015',15,15,15);

-- 27) RESOURCE_COORDINATION (15 rows)
INSERT INTO RESOURCE_COORDINATION (supplier_id, member_id, safehouse_id) VALUES
(1,1,1),(2,2,2),(3,3,3),(4,4,4),(5,5,5),(6,6,6),(7,7,7),(8,8,8),(9,9,9),(10,10,10),(11,11,11),(12,12,12),(13,13,13),(14,14,14),(15,15,15);

-- 28) LOOT (15 rows) -- omit batch_id so AUTO_INCREMENT applies
INSERT INTO LOOT (production_date, status, amount, stored_in_safehouse_id) VALUES
('2025-10-01','Stored',1000000.00,1),('2025-10-05','In-Transit',250000.00,2),('2025-10-10','Secured',500000.00,3),('2025-10-15','Stored',750000.00,4),('2025-11-01','Stored',600000.00,5),('2025-11-05','In-Transit',120000.00,6),('2025-11-08','Stored',900000.00,7),('2025-11-10','Secured',300000.00,8),('2025-11-12','Stored',450000.00,9),('2025-11-14','Stored',200000.00,10),('2025-11-16','In-Transit',150000.00,11),('2025-11-18','Stored',350000.00,12),('2025-11-20','Stored',275000.00,13),('2025-11-22','Secured',425000.00,14),('2025-11-25','Stored',180000.00,15);

-- 29) EVIDENCE_FOUND_DATE (15 rows)
INSERT INTO EVIDENCE_FOUND_DATE (evidence_id, found_date) VALUES
(1,'2025-10-02'),(2,'2025-10-06'),(3,'2025-10-11'),(4,'2025-10-16'),(5,'2025-11-02'),(6,'2025-11-06'),(7,'2025-11-09'),(8,'2025-11-11'),(9,'2025-11-13'),(10,'2025-11-15'),(11,'2025-11-17'),(12,'2025-11-19'),(13,'2025-11-21'),(14,'2025-11-23'),(15,'2025-11-26');

-- 30) COLLECTED_DURING (15 rows)
INSERT INTO COLLECTED_DURING (police_id, evidence_id, mission_code) VALUES
(1,1,'M001'),(2,2,'M002'),(3,3,'M003'),(4,4,'M004'),(5,5,'M005'),(6,6,'M006'),(7,7,'M007'),(8,8,'M008'),(9,9,'M009'),(10,10,'M010'),(11,11,'M011'),(12,12,'M012'),(13,13,'M013'),(14,14,'M014'),(15,15,'M015');

-- 31) EVIDENCE_FOUND_DATE already added above

-- 32) EVIDENCE (already added above)

-- Done: all tables now have INSERTs (min 15 rows each)

