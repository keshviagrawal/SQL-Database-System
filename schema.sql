-- DROP DATABASE IF EXISTS money_heist;
-- CREATE DATABASE money_heist;
-- USE money_heist;

-- /* ---------------------------
--    1) POLICE (parent)
--    --------------------------- */
-- CREATE TABLE POLICE
-- (
--     police_id INT AUTO_INCREMENT PRIMARY KEY,
--     first_name VARCHAR(50) NOT NULL,
--     mid_name VARCHAR(50),
--     last_name VARCHAR(50),
--     unit VARCHAR(100) NOT NULL,
--     role VARCHAR(100) NOT NULL
-- );

-- -- 2) POLICE_CONTACT
-- CREATE TABLE POLICE_CONTACT
-- (
--     police_id INT NOT NULL,
--     phone_number VARCHAR(15) NOT NULL,
--     email VARCHAR(100) NOT NULL,
--     PRIMARY KEY (police_id, phone_number, email),
--     FOREIGN KEY (police_id) REFERENCES POLICE(police_id)
--         ON DELETE CASCADE
--         ON UPDATE CASCADE
-- );

-- -- 3) TEAM_MEMBERS
-- CREATE TABLE TEAM_MEMBERS
-- (
--     member_id INT AUTO_INCREMENT PRIMARY KEY,
--     code_name VARCHAR(50) NOT NULL,
--     is_inside_mint BOOLEAN NOT NULL DEFAULT FALSE,
--     role VARCHAR(100) NOT NULL
-- );

-- -- 4) TEAM_MEMBER_CONTACT
-- CREATE TABLE TEAM_MEMBER_CONTACT
-- (
--     member_id INT NOT NULL,
--     phone_number VARCHAR(15) NOT NULL,
--     email VARCHAR(100) NOT NULL,
--     PRIMARY KEY (member_id, phone_number, email),
--     FOREIGN KEY (member_id) REFERENCES TEAM_MEMBERS(member_id)
--         ON DELETE CASCADE
--         ON UPDATE CASCADE
-- );

-- -- 5) CREW
-- CREATE TABLE CREW
-- (
--     member_id INT PRIMARY KEY,
--     FOREIGN KEY (member_id) REFERENCES TEAM_MEMBERS(member_id)
--         ON DELETE CASCADE
--         ON UPDATE CASCADE
-- );

-- -- 6) PROFESSOR
-- CREATE TABLE PROFESSOR
-- (
--     member_id INT PRIMARY KEY,
--     professor_name VARCHAR(100) NOT NULL,
--     FOREIGN KEY (member_id) REFERENCES TEAM_MEMBERS(member_id)
--         ON DELETE CASCADE
--         ON UPDATE CASCADE
-- );

-- -- 7) HACKER
-- CREATE TABLE HACKER
-- (
--     member_id INT PRIMARY KEY,
--     FOREIGN KEY (member_id) REFERENCES TEAM_MEMBERS(member_id)
--         ON DELETE CASCADE
--         ON UPDATE CASCADE
-- );

-- -- 8) SECURITY_SYSTEM
-- CREATE TABLE SECURITY_SYSTEM
-- (
--     system_id INT AUTO_INCREMENT PRIMARY KEY,
--     system_type VARCHAR(100) NOT NULL,
--     status ENUM('Active','Inactive','Under Maintenance') NOT NULL,
--     location_description TEXT,
--     security_level VARCHAR(50),
--     member_id INT,
--     FOREIGN KEY (member_id) REFERENCES HACKER(member_id)
--         ON DELETE SET NULL
--         ON UPDATE CASCADE
-- );

-- -- 9) SAFEHOUSE
-- CREATE TABLE SAFEHOUSE
-- (
--     safehouse_id INT AUTO_INCREMENT PRIMARY KEY,
--     capacity INT NOT NULL,
--     security_level VARCHAR(50) NOT NULL,
--     is_active BOOLEAN NOT NULL DEFAULT TRUE,
--     street VARCHAR(100) NOT NULL,
--     city VARCHAR(50) NOT NULL,
--     code INT NOT NULL
-- );

-- -- 10) EQUIPMENT (updated: removed equipment_type & criticality_level; curr_location_id kept)
-- CREATE TABLE EQUIPMENT
-- (
--     equipment_id INT AUTO_INCREMENT PRIMARY KEY,
--     total_quantity INT DEFAULT 0,
--     equipment_count INT NOT NULL,
--     curr_location_id INT NOT NULL,
--     FOREIGN KEY (curr_location_id) REFERENCES SAFEHOUSE(safehouse_id)
--         ON DELETE CASCADE
--         ON UPDATE CASCADE,
--     -- composite key requested (equipment_id, curr_location_id) as an index/unique
--     -- equipment_id is already PK; still create an explicit UNIQUE to reflect the "composite key" requirement
--     UNIQUE KEY uk_equipment_loc (equipment_id, curr_location_id)
-- );

-- -- 11) SUPPLIER
-- CREATE TABLE SUPPLIER
-- (
--     first_name VARCHAR(50) NOT NULL,
--     mid_name VARCHAR(50),
--     last_name VARCHAR(50),
--     supplier_id INT AUTO_INCREMENT PRIMARY KEY,
--     reliability_score ENUM('High','Medium','Low') NOT NULL
-- );

-- -- 12) SUPPLIER_CONTACT
-- CREATE TABLE SUPPLIER_CONTACT
-- (
--     supplier_id INT NOT NULL,
--     phone_number VARCHAR(15) NOT NULL,
--     email VARCHAR(100) NOT NULL,
--     PRIMARY KEY (supplier_id, phone_number, email),
--     FOREIGN KEY (supplier_id) REFERENCES SUPPLIER(supplier_id)
--         ON DELETE CASCADE
--         ON UPDATE CASCADE
-- );

-- -- 13) EVIDENCE
-- -- Keep composite PK (evidence_id, police_id) per your request, but add UNIQUE(evidence_id)
-- CREATE TABLE EVIDENCE
-- (
--     evidence_id INT NOT NULL,
--     police_id INT NOT NULL,
--     PRIMARY KEY (evidence_id, police_id),
--     UNIQUE KEY uk_evidence_eid (evidence_id),   -- allows single-column FK references to evidence_id
--     description TEXT,
--     -- found_time removed per request
--     threat_level VARCHAR(50) NOT NULL,
--     FOREIGN KEY (police_id) REFERENCES POLICE(police_id)
--         ON DELETE CASCADE
--         ON UPDATE CASCADE
-- );

-- -- 14) HOSTAGES (references POLICE)
-- CREATE TABLE HOSTAGES
-- (
--     hostage_id INT AUTO_INCREMENT PRIMARY KEY,
--     first_name VARCHAR(50) NOT NULL,
--     mid_name VARCHAR(50),
--     last_name VARCHAR(50),
--     age INT NOT NULL,
--     status ENUM('Pending','In-Progress','Resolved') NOT NULL,
--     zone VARCHAR(20) NOT NULL,
--     govt_posn VARCHAR(100),
--     risk_factor VARCHAR(20) NOT NULL,
--     police_id INT,
--     FOREIGN KEY (police_id) REFERENCES POLICE(police_id)
--         ON DELETE SET NULL
--         ON UPDATE CASCADE
-- );

-- -- 15) HOSTAGE_MEDICAL_CONDITION
-- CREATE TABLE HOSTAGE_MEDICAL_CONDITION
-- (
--     hostage_id INT NOT NULL,
--     hostage_ailment VARCHAR(255) NOT NULL,
--     PRIMARY KEY (hostage_id, hostage_ailment),
--     FOREIGN KEY (hostage_id) REFERENCES HOSTAGES(hostage_id)
--         ON DELETE CASCADE
--         ON UPDATE CASCADE
-- );

-- -- 16) DEPENDENTS
-- CREATE TABLE DEPENDENTS
-- (
--     dependent_id INT AUTO_INCREMENT PRIMARY KEY,
--     first_name VARCHAR(50) NOT NULL,
--     mid_name VARCHAR(50),
--     last_name VARCHAR(50),
--     hostage_id INT NOT NULL,
--     relation VARCHAR(50) NOT NULL,
--     age INT NOT NULL,
--     FOREIGN KEY (hostage_id) REFERENCES HOSTAGES(hostage_id)
--         ON DELETE CASCADE
--         ON UPDATE CASCADE
-- );

-- -- 17) MONITORED (links HOSTAGES and SECURITY_SYSTEM)
-- CREATE TABLE MONITORED
-- (
--     hostage_id INT NOT NULL,
--     system_id INT NOT NULL,
--     PRIMARY KEY (hostage_id, system_id),
--     FOREIGN KEY (hostage_id) REFERENCES HOSTAGES(hostage_id)
--         ON DELETE CASCADE
--         ON UPDATE CASCADE,
--     FOREIGN KEY (system_id) REFERENCES SECURITY_SYSTEM(system_id)
--         ON DELETE CASCADE
--         ON UPDATE CASCADE
-- );

-- -- 18) CLAIMS (POLICE <-> HOSTAGES)
-- CREATE TABLE CLAIMS
-- (
--     police_id INT NOT NULL,
--     hostage_id INT NOT NULL,
--     PRIMARY KEY (police_id, hostage_id),
--     FOREIGN KEY (police_id) REFERENCES POLICE(police_id)
--         ON DELETE CASCADE
--         ON UPDATE CASCADE,
--     FOREIGN KEY (hostage_id) REFERENCES HOSTAGES(hostage_id)
--         ON DELETE CASCADE
--         ON UPDATE CASCADE
-- );

-- -- 19) NEGOTIATES (POLICE <-> TEAM_MEMBERS)
-- CREATE TABLE NEGOTIATES
-- (
--     police_id INT NOT NULL,
--     member_id INT NOT NULL,
--     PRIMARY KEY (police_id, member_id),
--     FOREIGN KEY (police_id) REFERENCES POLICE(police_id)
--         ON DELETE CASCADE
--         ON UPDATE CASCADE,
--     FOREIGN KEY (member_id) REFERENCES TEAM_MEMBERS(member_id)
--         ON DELETE CASCADE
--         ON UPDATE CASCADE
-- );

-- -- ---------------------------
-- -- New mission-related tables
-- -- ---------------------------

-- -- 20) mission_details
-- -- mission_id is the PRIMARY KEY and will hold start/end/zone/description/stage
-- CREATE TABLE MISSION_DETAILS
-- (
--     mission_id INT AUTO_INCREMENT PRIMARY KEY,
--     start_time TIMESTAMP NOT NULL,
--     end_time TIMESTAMP,
--     stage ENUM('Planned','Ongoing','Completed','Failed') NOT NULL,
--     zone VARCHAR(20) NOT NULL,
--     description TEXT
-- );

-- -- 21) mission_identifier
-- -- composite key (mission_id, mission_code) as requested
-- -- make mission_code UNIQUE so other tables can reference mission_code alone
-- CREATE TABLE MISSION_IDENTIFIER
-- (
--     mission_id INT NOT NULL,
--     mission_code VARCHAR(20) NOT NULL,
--     PRIMARY KEY (mission_id, mission_code),
--     UNIQUE KEY uk_mission_code (mission_code),
--     FOREIGN KEY (mission_id) REFERENCES MISSION_DETAILS(mission_id)
--         ON DELETE CASCADE
--         ON UPDATE CASCADE
-- );

-- -- 22) time_details
-- -- composite key (member_id, mission_code) as primary; contains timestamp
-- CREATE TABLE TIME_DETAILS
-- (
--     member_id INT NOT NULL,
--     mission_code VARCHAR(20) NOT NULL,
--     timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
--     PRIMARY KEY (member_id, mission_code),
--     FOREIGN KEY (member_id) REFERENCES TEAM_MEMBERS(member_id)
--         ON DELETE CASCADE
--         ON UPDATE CASCADE,
--     FOREIGN KEY (mission_code) REFERENCES MISSION_IDENTIFIER(mission_code)
--         ON DELETE CASCADE
--         ON UPDATE CASCADE
-- );

-- -- ---------------------------
-- -- COLLECTED_DURING (updated)
-- -- police_id should ref POLICE not EVIDENCE
-- -- evidence_id references only evidence.evidence_id (allowed because evidence.evidence_id has UNIQUE)
-- -- mission_code references mission_identifier.mission_code (not MISSIONS)
-- -- ---------------------------
-- CREATE TABLE COLLECTED_DURING
-- (
--     police_id INT NOT NULL,
--     evidence_id INT NOT NULL,
--     mission_code VARCHAR(20) NOT NULL,
--     PRIMARY KEY (police_id, evidence_id, mission_code),
--     FOREIGN KEY (police_id) REFERENCES POLICE(police_id)
--         ON DELETE CASCADE
--         ON UPDATE CASCADE,
--     FOREIGN KEY (evidence_id) REFERENCES EVIDENCE(evidence_id)
--         ON DELETE CASCADE
--         ON UPDATE CASCADE,
--     FOREIGN KEY (mission_code) REFERENCES MISSION_IDENTIFIER(mission_code)
--         ON DELETE CASCADE
--         ON UPDATE CASCADE
-- );

-- -- ---------------------------
-- -- COMMUNICATION_LOG (updated: add negotiator_id referencing POLICE)
-- -- ---------------------------
-- CREATE TABLE COMMUNICATION_LOG
-- (
--     channel_id INT PRIMARY KEY AUTO_INCREMENT,
--     timestamp TIMESTAMP NOT NULL,
--     msg_type TEXT NOT NULL,
--     negotiator_id INT NOT NULL,
--     duration INT NOT NULL,
--     content TEXT NOT NULL,
--     FOREIGN KEY (negotiator_id) REFERENCES POLICE(police_id)
--         ON DELETE CASCADE
--         ON UPDATE CASCADE
-- );

-- -- ---------------------------
-- -- STRATEGIC_PLANNING (fixed)
-- -- mission_code should reference MISSION_IDENTIFIER (mission_code)
-- -- channel_id references COMMUNICATION_LOG
-- -- ---------------------------
-- CREATE TABLE STRATEGIC_PLANNING
-- (
--     member_id INT NOT NULL,
--     mission_code VARCHAR(20) NOT NULL,
--     channel_id INT NOT NULL,
--     police_id INT NOT NULL,
--     PRIMARY KEY (police_id, member_id, mission_code, channel_id),
--     FOREIGN KEY (member_id) REFERENCES TEAM_MEMBERS(member_id)
--         ON DELETE CASCADE
--         ON UPDATE CASCADE,
--     FOREIGN KEY (mission_code) REFERENCES MISSION_IDENTIFIER(mission_code)
--         ON DELETE CASCADE
--         ON UPDATE CASCADE,
--     FOREIGN KEY (channel_id) REFERENCES COMMUNICATION_LOG(channel_id)
--         ON DELETE CASCADE
--         ON UPDATE CASCADE,
--     FOREIGN KEY (police_id) REFERENCES POLICE(police_id)
--         ON DELETE CASCADE
--         ON UPDATE CASCADE
-- );

-- -- ---------------------------
-- -- EQUIPMENT_SPECIFICATIONS (new)
-- -- moved equipment_type and criticality_level out of EQUIPMENT
-- -- ---------------------------
-- CREATE TABLE EQUIPMENT_SPECIFICATIONS
-- (
--     equipment_id INT NOT NULL PRIMARY KEY,
--     equipment_type VARCHAR(100) NOT NULL,
--     critical ENUM('High','Medium','Low') NOT NULL,
--     FOREIGN KEY (equipment_id) REFERENCES EQUIPMENT(equipment_id)
--         ON DELETE CASCADE
--         ON UPDATE CASCADE
-- );

-- -- ---------------------------
-- -- MISSION_EXECUTION (updated)
-- -- remove mission_execution_id
-- -- mission_code must reference MISSION_IDENTIFIER(mission_code)
-- -- primary key is composite to prevent duplicate assignments
-- -- ---------------------------
-- CREATE TABLE MISSION_EXECUTION
-- (
--     mission_code VARCHAR(20) NOT NULL,
--     member_id INT NOT NULL,
--     safehouse_id INT,
--     equipment_id INT,
--     UNIQUE KEY unique_exec (mission_code, member_id, safehouse_id, equipment_id),
--     PRIMARY KEY (mission_code, member_id, safehouse_id, equipment_id),
--     FOREIGN KEY (mission_code) REFERENCES MISSION_IDENTIFIER(mission_code)
--         ON DELETE CASCADE
--         ON UPDATE CASCADE,
--     FOREIGN KEY (member_id) REFERENCES TEAM_MEMBERS(member_id)
--         ON DELETE CASCADE
--         ON UPDATE CASCADE,
--     FOREIGN KEY (safehouse_id) REFERENCES SAFEHOUSE(safehouse_id)
--         ON DELETE SET NULL
--         ON UPDATE CASCADE,
--     FOREIGN KEY (equipment_id) REFERENCES EQUIPMENT(equipment_id)
--         ON DELETE SET NULL
--         ON UPDATE CASCADE
-- );

-- -- ---------------------------
-- -- RESOURCE_COORDINATION
-- -- ---------------------------
-- CREATE TABLE RESOURCE_COORDINATION
-- (
--     supplier_id INT NOT NULL,
--     member_id INT NOT NULL,
--     safehouse_id INT NOT NULL,
--     PRIMARY KEY (supplier_id, member_id, safehouse_id),
--     FOREIGN KEY (supplier_id) REFERENCES SUPPLIER(supplier_id)
--         ON DELETE CASCADE
--         ON UPDATE CASCADE,
--     FOREIGN KEY (member_id) REFERENCES TEAM_MEMBERS(member_id)
--         ON DELETE CASCADE
--         ON UPDATE CASCADE,
--     FOREIGN KEY (safehouse_id) REFERENCES SAFEHOUSE(safehouse_id)
--         ON DELETE CASCADE
--         ON UPDATE CASCADE
-- );

-- -- ---------------------------
-- -- LOOT
-- -- ---------------------------
-- CREATE TABLE LOOT
-- (
--     production_date DATE NOT NULL,
--     batch_id INT AUTO_INCREMENT,
--     status ENUM('Stored','In-Transit','Secured') NOT NULL,
--     amount DECIMAL(15,2) NOT NULL,
--     stored_in_safehouse_id INT NOT NULL,
--     PRIMARY KEY (batch_id, stored_in_safehouse_id),
--     FOREIGN KEY (stored_in_safehouse_id) REFERENCES SAFEHOUSE(safehouse_id)
--         ON DELETE CASCADE
--         ON UPDATE CASCADE
-- );

-- -- ---------------------------
-- -- EVIDENCE_FOUND_DATE (new)
-- -- single-column FK to evidence.evidence_id (allowed because evidence has UNIQUE(evidence_id))
-- -- ---------------------------
-- CREATE TABLE EVIDENCE_FOUND_DATE
-- (
--     evidence_id INT NOT NULL PRIMARY KEY,
--     found_date DATE NOT NULL,
--     FOREIGN KEY (evidence_id) REFERENCES EVIDENCE(evidence_id)
--         ON DELETE CASCADE
--         ON UPDATE CASCADE
-- );


DROP DATABASE IF EXISTS money_heist;
CREATE DATABASE money_heist;
USE money_heist;

/* ---------------------------
   1) POLICE (parent)
   --------------------------- */
CREATE TABLE POLICE
(
    police_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    mid_name VARCHAR(50),
    last_name VARCHAR(50),
    unit VARCHAR(100) NOT NULL,
    role VARCHAR(100) NOT NULL
);

-- 2) POLICE_CONTACT
CREATE TABLE POLICE_CONTACT
(
    police_id INT NOT NULL,
    phone_number VARCHAR(15) NOT NULL,
    email VARCHAR(100) NOT NULL,
    PRIMARY KEY (police_id, phone_number, email),
    FOREIGN KEY (police_id) REFERENCES POLICE(police_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 3) TEAM_MEMBERS
CREATE TABLE TEAM_MEMBERS
(
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    code_name VARCHAR(50) NOT NULL,
    is_inside_mint BOOLEAN NOT NULL DEFAULT FALSE,
    role VARCHAR(100) NOT NULL
);

-- 4) TEAM_MEMBER_CONTACT
CREATE TABLE TEAM_MEMBER_CONTACT
(
    member_id INT NOT NULL,
    phone_number VARCHAR(15) NOT NULL,
    email VARCHAR(100) NOT NULL,
    PRIMARY KEY (member_id, phone_number, email),
    FOREIGN KEY (member_id) REFERENCES TEAM_MEMBERS(member_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 5) CREW
CREATE TABLE CREW
(
    member_id INT PRIMARY KEY,
    FOREIGN KEY (member_id) REFERENCES TEAM_MEMBERS(member_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 6) PROFESSOR
CREATE TABLE PROFESSOR
(
    member_id INT PRIMARY KEY,
    professor_name VARCHAR(100) NOT NULL,
    FOREIGN KEY (member_id) REFERENCES TEAM_MEMBERS(member_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 7) HACKER
CREATE TABLE HACKER
(
    member_id INT PRIMARY KEY,
    FOREIGN KEY (member_id) REFERENCES TEAM_MEMBERS(member_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 8) SECURITY_SYSTEM
CREATE TABLE SECURITY_SYSTEM
(
    system_id INT AUTO_INCREMENT PRIMARY KEY,
    system_type VARCHAR(100) NOT NULL,
    status ENUM('Active','Inactive','Under Maintenance') NOT NULL,
    location_description TEXT,
    security_level VARCHAR(50),
    member_id INT,
    FOREIGN KEY (member_id) REFERENCES HACKER(member_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- 9) SAFEHOUSE
CREATE TABLE SAFEHOUSE
(
    safehouse_id INT AUTO_INCREMENT PRIMARY KEY,
    capacity INT NOT NULL,
    security_level VARCHAR(50) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    street VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    code INT NOT NULL
);

-- 10) EQUIPMENT (updated: removed equipment_type & criticality_level; curr_location_id kept)
CREATE TABLE EQUIPMENT
(
    equipment_id INT AUTO_INCREMENT PRIMARY KEY,
    total_quantity INT DEFAULT 0,
    equipment_count INT NOT NULL,
    curr_location_id INT NOT NULL,
    FOREIGN KEY (curr_location_id) REFERENCES SAFEHOUSE(safehouse_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    -- composite key requested (equipment_id, curr_location_id) as an index/unique
    -- equipment_id is already PK; still create an explicit UNIQUE to reflect the "composite key" requirement
    UNIQUE KEY uk_equipment_loc (equipment_id, curr_location_id)
);

-- 11) SUPPLIER
CREATE TABLE SUPPLIER
(
    first_name VARCHAR(50) NOT NULL,
    mid_name VARCHAR(50),
    last_name VARCHAR(50),
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    reliability_score ENUM('High','Medium','Low') NOT NULL
);

-- 12) SUPPLIER_CONTACT
CREATE TABLE SUPPLIER_CONTACT
(
    supplier_id INT NOT NULL,
    phone_number VARCHAR(15) NOT NULL,
    email VARCHAR(100) NOT NULL,
    PRIMARY KEY (supplier_id, phone_number, email),
    FOREIGN KEY (supplier_id) REFERENCES SUPPLIER(supplier_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 13) EVIDENCE
-- Keep composite PK (evidence_id, police_id) per your request, but add UNIQUE(evidence_id)
CREATE TABLE EVIDENCE
(
    evidence_id INT NOT NULL,
    police_id INT NOT NULL,
    PRIMARY KEY (evidence_id, police_id),
    UNIQUE KEY uk_evidence_eid (evidence_id),   -- allows single-column FK references to evidence_id
    description TEXT,
    -- found_time removed per request
    threat_level VARCHAR(50) NOT NULL,
    FOREIGN KEY (police_id) REFERENCES POLICE(police_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 14) HOSTAGES (references POLICE)
CREATE TABLE HOSTAGES
(
    hostage_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    mid_name VARCHAR(50),
    last_name VARCHAR(50),
    age INT NOT NULL,
    status ENUM('Pending','In-Progress','Resolved') NOT NULL,
    zone VARCHAR(20) NOT NULL,
    govt_posn VARCHAR(100),
    risk_factor VARCHAR(20) NOT NULL,
    police_id INT,
    FOREIGN KEY (police_id) REFERENCES POLICE(police_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- 15) HOSTAGE_MEDICAL_CONDITION
CREATE TABLE HOSTAGE_MEDICAL_CONDITION
(
    hostage_id INT NOT NULL,
    hostage_ailment VARCHAR(255) NOT NULL,
    PRIMARY KEY (hostage_id, hostage_ailment),
    FOREIGN KEY (hostage_id) REFERENCES HOSTAGES(hostage_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 16) DEPENDENTS
CREATE TABLE DEPENDENTS
(
    dependent_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    mid_name VARCHAR(50),
    last_name VARCHAR(50),
    hostage_id INT NOT NULL,
    relation VARCHAR(50) NOT NULL,
    age INT NOT NULL,
    FOREIGN KEY (hostage_id) REFERENCES HOSTAGES(hostage_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 17) MONITORED (links HOSTAGES and SECURITY_SYSTEM)
CREATE TABLE MONITORED
(
    hostage_id INT NOT NULL,
    system_id INT NOT NULL,
    PRIMARY KEY (hostage_id, system_id),
    FOREIGN KEY (hostage_id) REFERENCES HOSTAGES(hostage_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (system_id) REFERENCES SECURITY_SYSTEM(system_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 18) CLAIMS (POLICE <-> HOSTAGES)
CREATE TABLE CLAIMS
(
    police_id INT NOT NULL,
    hostage_id INT NOT NULL,
    PRIMARY KEY (police_id, hostage_id),
    FOREIGN KEY (police_id) REFERENCES POLICE(police_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (hostage_id) REFERENCES HOSTAGES(hostage_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 19) NEGOTIATES (POLICE <-> TEAM_MEMBERS)
CREATE TABLE NEGOTIATES
(
    police_id INT NOT NULL,
    member_id INT NOT NULL,
    PRIMARY KEY (police_id, member_id),
    FOREIGN KEY (police_id) REFERENCES POLICE(police_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (member_id) REFERENCES TEAM_MEMBERS(member_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ---------------------------
-- New mission-related tables
-- ---------------------------

-- 20) mission_details
-- mission_id is the PRIMARY KEY and will hold start/end/zone/description/stage
CREATE TABLE MISSION_DETAILS
(
    mission_id INT AUTO_INCREMENT PRIMARY KEY,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP,
    stage ENUM('Planned','Ongoing','Completed','Failed') NOT NULL,
    zone VARCHAR(20) NOT NULL,
    description TEXT
);

-- 21) mission_identifier
-- composite key (mission_id, mission_code) as requested
-- make mission_code UNIQUE so other tables can reference mission_code alone
CREATE TABLE MISSION_IDENTIFIER
(
    mission_id INT NOT NULL,
    mission_code VARCHAR(20) NOT NULL,
    PRIMARY KEY (mission_id, mission_code),
    UNIQUE KEY uk_mission_code (mission_code),
    FOREIGN KEY (mission_id) REFERENCES MISSION_DETAILS(mission_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 22) time_details
-- composite key (member_id, mission_code) as primary; contains timestamp
CREATE TABLE TIME_DETAILS
(
    member_id INT NOT NULL,
    mission_code VARCHAR(20) NOT NULL,
    timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (member_id, mission_code),
    FOREIGN KEY (member_id) REFERENCES TEAM_MEMBERS(member_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (mission_code) REFERENCES MISSION_IDENTIFIER(mission_code)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ---------------------------
-- COLLECTED_DURING (updated)
-- police_id should ref POLICE not EVIDENCE
-- evidence_id references only evidence.evidence_id (allowed because evidence.evidence_id has UNIQUE)
-- mission_code references mission_identifier.mission_code (not MISSIONS)
-- ---------------------------
CREATE TABLE COLLECTED_DURING
(
    police_id INT NOT NULL,
    evidence_id INT NOT NULL,
    mission_code VARCHAR(20) NOT NULL,
    PRIMARY KEY (police_id, evidence_id, mission_code),
    FOREIGN KEY (police_id) REFERENCES POLICE(police_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (evidence_id) REFERENCES EVIDENCE(evidence_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (mission_code) REFERENCES MISSION_IDENTIFIER(mission_code)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ---------------------------
-- COMMUNICATION_LOG (updated: add negotiator_id referencing POLICE)
-- ---------------------------
CREATE TABLE COMMUNICATION_LOG
(
    channel_id INT PRIMARY KEY AUTO_INCREMENT,
    timestamp TIMESTAMP NOT NULL,
    msg_type TEXT NOT NULL,
    negotiator_id INT NOT NULL,
    duration INT NOT NULL,
    content TEXT NOT NULL,
    FOREIGN KEY (negotiator_id) REFERENCES POLICE(police_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ---------------------------
-- STRATEGIC_PLANNING (fixed)
-- mission_code should reference MISSION_IDENTIFIER (mission_code)
-- channel_id references COMMUNICATION_LOG
-- ---------------------------
CREATE TABLE STRATEGIC_PLANNING
(
    member_id INT NOT NULL,
    mission_code VARCHAR(20) NOT NULL,
    channel_id INT NOT NULL,
    police_id INT NOT NULL,
    PRIMARY KEY (police_id, member_id, mission_code, channel_id),
    FOREIGN KEY (member_id) REFERENCES TEAM_MEMBERS(member_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (mission_code) REFERENCES MISSION_IDENTIFIER(mission_code)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (channel_id) REFERENCES COMMUNICATION_LOG(channel_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (police_id) REFERENCES POLICE(police_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ---------------------------
-- EQUIPMENT_SPECIFICATIONS (new)
-- moved equipment_type and criticality_level out of EQUIPMENT
-- ---------------------------
CREATE TABLE EQUIPMENT_SPECIFICATIONS
(
    equipment_id INT NOT NULL PRIMARY KEY,
    equipment_type VARCHAR(100) NOT NULL,
    critical ENUM('High','Medium','Low') NOT NULL,
    FOREIGN KEY (equipment_id) REFERENCES EQUIPMENT(equipment_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ---------------------------
-- MISSION_EXECUTION (updated)
-- remove mission_execution_id
-- mission_code must reference MISSION_IDENTIFIER(mission_code)
-- primary key is composite to prevent duplicate assignments
-- ---------------------------
CREATE TABLE MISSION_EXECUTION
(
    mission_execution_id INT AUTO_INCREMENT PRIMARY KEY,
    mission_code VARCHAR(20) NOT NULL,
    member_id INT NOT NULL,
    safehouse_id INT,
    equipment_id INT,
    UNIQUE KEY unique_exec (mission_code, member_id, safehouse_id, equipment_id),
    FOREIGN KEY (mission_code) REFERENCES MISSION_IDENTIFIER(mission_code)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (member_id) REFERENCES TEAM_MEMBERS(member_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (safehouse_id) REFERENCES SAFEHOUSE(safehouse_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    FOREIGN KEY (equipment_id) REFERENCES EQUIPMENT(equipment_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- ---------------------------
-- RESOURCE_COORDINATION
-- ---------------------------
CREATE TABLE RESOURCE_COORDINATION
(
    supplier_id INT NOT NULL,
    member_id INT NOT NULL,
    safehouse_id INT NOT NULL,
    PRIMARY KEY (supplier_id, member_id, safehouse_id),
    FOREIGN KEY (supplier_id) REFERENCES SUPPLIER(supplier_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (member_id) REFERENCES TEAM_MEMBERS(member_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (safehouse_id) REFERENCES SAFEHOUSE(safehouse_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ---------------------------
-- LOOT
-- ---------------------------
CREATE TABLE LOOT
(
    production_date DATE NOT NULL,
    batch_id INT AUTO_INCREMENT,
    status ENUM('Stored','In-Transit','Secured') NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    stored_in_safehouse_id INT NOT NULL,
    PRIMARY KEY (batch_id, stored_in_safehouse_id),
    FOREIGN KEY (stored_in_safehouse_id) REFERENCES SAFEHOUSE(safehouse_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ---------------------------
-- EVIDENCE_FOUND_DATE (new)
-- single-column FK to evidence.evidence_id (allowed because evidence has UNIQUE(evidence_id))
-- ---------------------------
CREATE TABLE EVIDENCE_FOUND_DATE
(
    evidence_id INT NOT NULL PRIMARY KEY,
    found_date DATE NOT NULL,
    FOREIGN KEY (evidence_id) REFERENCES EVIDENCE(evidence_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);