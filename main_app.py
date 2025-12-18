import mysql.connector
from mysql.connector import Error
from getpass import getpass
from colorama import Fore, Style, init

init(autoreset=True)


# ---------------------------------------------------------
# 1. CONNECT TO DATABASE
# ---------------------------------------------------------
def connect_db():
    print(Fore.CYAN + "\nEnter MySQL Credentials")
    try:
        connection = mysql.connector.connect(
            host="localhost",
            user=input(Fore.YELLOW + "Enter MySQL username: "),
            password=getpass(Fore.YELLOW + "Enter MySQL password: "),
            database="money_heist"
        )

        if connection.is_connected():
            print(Fore.GREEN + "\n✔ Connected to MySQL database successfully.\n")
            return connection

    except Error as e:
        print(Fore.RED + f"❌ Error while connecting to MySQL: {e}")
        return None


# ---------------------------------------------------------
# Helper for nice printing
# ---------------------------------------------------------
def print_header(title):
    print(Fore.MAGENTA + "\n" + "=" * 70)
    print(Fore.MAGENTA + f"{title}".center(70))
    print(Fore.MAGENTA + "=" * 70 + "\n")


def print_rows(rows):
    if not rows:
        print(Fore.YELLOW + "⚠ No records found.\n")
        return
    for r in rows:
        print(Fore.CYAN + str(r))
    print("\n" + Fore.MAGENTA + "-" * 70)


def _print_and_run(cur, query, params=None):
    """Helper: print SQL and params, execute and return fetched rows (if any)."""
    print(Fore.BLUE + "\n-- SQL QUERY --")
    print(Fore.BLUE + query.strip())
    if params:
        print(Fore.BLUE + f"-- PARAMS: {params}")
    try:
        if params:
            cur.execute(query, params)
        else:
            cur.execute(query)
    except Error as e:
        print(Fore.RED + f"❌ SQL execution error: {e}")
        return []
    # If it's a SELECT-like query, fetch rows
    try:
        return cur.fetchall()
    except Exception:
        return []


def _print_and_exec(cur, query, params=None):
    """Helper for non-SELECT statements: print SQL, execute, and return affected rowcount."""
    print(Fore.BLUE + "\n-- SQL QUERY --")
    print(Fore.BLUE + query.strip())
    if params:
        print(Fore.BLUE + f"-- PARAMS: {params}")
    try:
        if params:
            cur.execute(query, params)
        else:
            cur.execute(query)
        return cur.rowcount
    except Error as e:
        print(Fore.RED + f"❌ SQL execution error: {e}")
        return 0


# ---------------------------------------------------------
# BASIC READ QUERIES
# ---------------------------------------------------------
def view_all_hostages(connection):
    print_header("ALL HOSTAGES")
    try:
        cur = connection.cursor(dictionary=True)
        rows = _print_and_run(cur, "SELECT * FROM HOSTAGES")
        print_rows(rows)
        cur.close()
    except Error as e:
        print(Fore.RED + f"❌ Error fetching hostages: {e}")


def get_hostage_by_id(connection):
    print_header("SEARCH HOSTAGE BY ID")
    try:
        hid = int(input("Enter Hostage ID: "))
        cur = connection.cursor(dictionary=True)
        rows = _print_and_run(cur, "SELECT * FROM HOSTAGES WHERE hostage_id=%s", (hid,))
        result = rows[0] if rows else None
        if result:
            print(Fore.GREEN + "\n🎯 Hostage Found:")
            print(Fore.CYAN + str(result))
        else:
            print(Fore.YELLOW + "\n⚠ No hostage found.")
        cur.close()
    except ValueError:
        print(Fore.RED + "❌ Please enter a valid integer for hostage id.")
    except Error as e:
        print(Fore.RED + f"❌ Error: {e}")


def list_hostages_with_police(connection):
    """Hostages along with assigned police officer (if any)."""
    print_header("HOSTAGES WITH ASSIGNED POLICE")
    try:
        cur = connection.cursor(dictionary=True)
        query = """
        SELECT h.hostage_id,
               h.first_name AS hostage_first,
               h.last_name  AS hostage_last,
               h.status,
               h.zone,
               p.police_id,
               p.first_name AS police_first,
               p.last_name  AS police_last
        FROM HOSTAGES h
        LEFT JOIN POLICE p ON h.police_id = p.police_id
        ORDER BY h.hostage_id;
        """
        rows = _print_and_run(cur, query)
        print_rows(rows)
        cur.close()
    except Error as e:
        print(Fore.RED + f"❌ {e}")


def hostages_dependent_count(connection):
    """Hostages and how many dependents they have."""
    print_header("HOSTAGES WITH DEPENDENT COUNTS")
    try:
        cur = connection.cursor(dictionary=True)
        query = """
        SELECT h.hostage_id,
               h.first_name,
               h.last_name,
               COUNT(d.dependent_id) AS dependent_count
        FROM HOSTAGES h
        LEFT JOIN DEPENDENTS d ON h.hostage_id = d.hostage_id
        GROUP BY h.hostage_id
        ORDER BY dependent_count DESC, h.hostage_id;
        """
        rows = _print_and_run(cur, query)
        print_rows(rows)
        cur.close()
    except Error as e:
        print(Fore.RED + f"❌ {e}")


def evidence_report(connection):
    """Evidence with found dates and missions they are tied to."""
    print_header("EVIDENCE REPORT (WITH MISSIONS)")
    try:
        cur = connection.cursor(dictionary=True)
        query = """
        SELECT e.evidence_id,
               e.police_id,
               e.description,
               e.threat_level,
               efd.found_date,
               cd.mission_code
        FROM EVIDENCE e
        LEFT JOIN EVIDENCE_FOUND_DATE efd
               ON e.evidence_id = efd.evidence_id
        LEFT JOIN COLLECTED_DURING cd
               ON e.evidence_id = cd.evidence_id
              AND e.police_id  = cd.police_id
        ORDER BY efd.found_date DESC, e.evidence_id;
        """
        rows = _print_and_run(cur, query)
        print_rows(rows)
        cur.close()
    except Error as e:
        print(Fore.RED + f"❌ {e}")


def equipment_by_safehouse(connection):
    """Which equipment is currently stored in which safehouse."""
    print_header("EQUIPMENT BY SAFEHOUSE (USING curr_location_id)")
    try:
        cur = connection.cursor(dictionary=True)
        query = """
        SELECT s.safehouse_id,
               s.city,
               s.street,
               e.equipment_id,
               es.equipment_type,
               e.total_quantity,
               e.equipment_count
        FROM SAFEHOUSE s
        LEFT JOIN EQUIPMENT e
               ON e.curr_location_id = s.safehouse_id
        LEFT JOIN EQUIPMENT_SPECIFICATIONS es
               ON e.equipment_id = es.equipment_id
        ORDER BY s.safehouse_id, e.equipment_id;
        """
        rows = _print_and_run(cur, query)
        print_rows(rows)
        cur.close()
    except Error as e:
        print(Fore.RED + f"❌ {e}")


def mission_members(connection):
    """Members and equipment involved in a specific mission."""
    print_header("MISSION EXECUTION DETAILS")
    try:
        mcode = input("Enter Mission Code (e.g., M001): ").strip()
        cur = connection.cursor(dictionary=True)
        query = """
        SELECT me.mission_code,
               t.member_id,
               t.code_name,
               e.equipment_id,
               es.equipment_type,
               s.safehouse_id,
               s.city
        FROM MISSION_EXECUTION me
        JOIN TEAM_MEMBERS t
          ON me.member_id = t.member_id
        LEFT JOIN EQUIPMENT e
               ON me.equipment_id = e.equipment_id
        LEFT JOIN EQUIPMENT_SPECIFICATIONS es
               ON e.equipment_id = es.equipment_id
        LEFT JOIN SAFEHOUSE s
               ON me.safehouse_id = s.safehouse_id
        WHERE me.mission_code = %s;
        """
        rows = _print_and_run(cur, query, (mcode,))
        print_rows(rows)
        cur.close()
    except Error as e:
        print(Fore.RED + f"❌ {e}")


# ---------------------------------------------------------
# ADVANCED READ QUERIES (multi-table, realistic)
# ---------------------------------------------------------
def mission_summary(connection):
    """Summary per mission: members, safehouses, evidence count."""
    print_header("MISSION SUMMARY")
    try:
        cur = connection.cursor(dictionary=True)
        query = """
        SELECT me.mission_code,
               COUNT(DISTINCT me.member_id) AS member_count,
               GROUP_CONCAT(DISTINCT t.code_name SEPARATOR ', ') AS members,
               GROUP_CONCAT(DISTINCT CONCAT(s.safehouse_id, ':', s.city)
                            SEPARATOR ', ') AS safehouses,
               COUNT(DISTINCT cd.evidence_id) AS evidence_count
        FROM MISSION_EXECUTION me
        LEFT JOIN TEAM_MEMBERS t
               ON me.member_id = t.member_id
        LEFT JOIN SAFEHOUSE s
               ON me.safehouse_id = s.safehouse_id
        LEFT JOIN COLLECTED_DURING cd
               ON me.mission_code = cd.mission_code
        GROUP BY me.mission_code
        ORDER BY evidence_count DESC, member_count DESC;
        """
        rows = _print_and_run(cur, query)
        print_rows(rows)
        cur.close()
    except Error as e:
        print(Fore.RED + f"❌ {e}")


def police_activity_report(connection):
    """Activity per police: evidence collected, missions, hostages claimed."""
    print_header("POLICE ACTIVITY REPORT")
    try:
        cur = connection.cursor(dictionary=True)
        query = """
        SELECT p.police_id,
               p.first_name,
               p.last_name,
               COUNT(DISTINCT e.evidence_id) AS evidence_found,
               COUNT(DISTINCT cd.mission_code) AS missions_involved,
               COUNT(DISTINCT h.hostage_id) AS hostages_claimed
        FROM POLICE p
        LEFT JOIN EVIDENCE e
               ON p.police_id = e.police_id
        LEFT JOIN COLLECTED_DURING cd
               ON p.police_id = cd.police_id
        LEFT JOIN CLAIMS c
               ON p.police_id = c.police_id
        LEFT JOIN HOSTAGES h
               ON c.hostage_id = h.hostage_id
        GROUP BY p.police_id
        ORDER BY evidence_found DESC, missions_involved DESC;
        """
        rows = _print_and_run(cur, query)
        print_rows(rows)
        cur.close()
    except Error as e:
        print(Fore.RED + f"❌ {e}")


def supplier_resource_usage(connection):
    """Which suppliers supply which members and safehouses."""
    print_header("SUPPLIER → RESOURCE COORDINATION → SAFEHOUSE")
    try:
        cur = connection.cursor(dictionary=True)
        query = """
        SELECT s.supplier_id,
               s.first_name,
               s.last_name,
               rc.member_id,
               tm.code_name     AS member_code,
               rc.safehouse_id,
               sh.street        AS safehouse_street,
               sh.city
        FROM SUPPLIER s
        JOIN RESOURCE_COORDINATION rc
          ON s.supplier_id = rc.supplier_id
        LEFT JOIN TEAM_MEMBERS tm
               ON rc.member_id = tm.member_id
        LEFT JOIN SAFEHOUSE sh
               ON rc.safehouse_id = sh.safehouse_id
        ORDER BY s.supplier_id, rc.safehouse_id;
        """
        rows = _print_and_run(cur, query)
        print_rows(rows)
        cur.close()
    except Error as e:
        print(Fore.RED + f"❌ {e}")


def high_risk_hostages_and_security(connection):
    """High-risk hostages plus their ailments and monitoring systems."""
    print_header("HIGH-RISK HOSTAGES & SECURITY MONITORING")
    try:
        cur = connection.cursor(dictionary=True)
        query = """
        SELECT h.hostage_id,
               h.first_name,
               h.last_name,
               GROUP_CONCAT(DISTINCT hmc.hostage_ailment SEPARATOR '; ')
                   AS ailments,
               GROUP_CONCAT(DISTINCT ss.system_type SEPARATOR '; ')
                   AS monitoring_systems
        FROM HOSTAGES h
        LEFT JOIN HOSTAGE_MEDICAL_CONDITION hmc
               ON h.hostage_id = hmc.hostage_id
        LEFT JOIN MONITORED m
               ON h.hostage_id = m.hostage_id
        LEFT JOIN SECURITY_SYSTEM ss
               ON m.system_id = ss.system_id
        WHERE h.risk_factor = 'High'
        GROUP BY h.hostage_id
        ORDER BY h.hostage_id;
        """
        rows = _print_and_run(cur, query)
        print_rows(rows)
        cur.close()
    except Error as e:
        print(Fore.RED + f"❌ {e}")


def equipment_stock_alert(connection):
    """Aggregate equipment and flag low total stock items."""
    print_header("EQUIPMENT STOCK ALERT (by total_quantity)")
    try:
        threshold_raw = input(
            "Show equipment with total_quantity less than (default 50): "
        ).strip()
        threshold = int(threshold_raw) if threshold_raw else 50

        cur = connection.cursor(dictionary=True)
        query = """
        SELECT e.equipment_id,
               es.equipment_type,
               e.total_quantity,
               e.equipment_count,
               s.safehouse_id,
               s.city,
               s.street
        FROM EQUIPMENT e
        LEFT JOIN EQUIPMENT_SPECIFICATIONS es
               ON e.equipment_id = es.equipment_id
        LEFT JOIN SAFEHOUSE s
               ON e.curr_location_id = s.safehouse_id
        WHERE e.total_quantity < %s
        ORDER BY e.total_quantity ASC, e.equipment_id;
        """
        rows = _print_and_run(cur, query, (threshold,))
        print_rows(rows)
        cur.close()
    except ValueError:
        print(Fore.RED + "❌ Threshold must be an integer.")
    except Error as e:
        print(Fore.RED + f"❌ {e}")


# ---------------------------------------------------------
# WRITE OPERATIONS (3 INSERT, 3 UPDATE, 3 DELETE)
# ---------------------------------------------------------
# ------------ INSERT 1: HOSTAGE (also inserts into CLAIMS if police_id given)
# def add_new_hostage(connection):
#     """Insert a new hostage. If police_id is given, also create a CLAIMS row."""
#     print_header("ADD NEW HOSTAGE (INSERT)")
#     try:
#         first = input("First name: ").strip()
#         mid = input("Middle name (or press Enter): ").strip() or None
#         last = input("Last name: ").strip()
#         age = input("Age (or press Enter): ").strip()
#         age_val = int(age) if age else None
#         status = input("Status (Pending/In-Progress/Resolved) [default Pending]: ").strip() or 'Pending'
#         zone = input("Zone (e.g., ZoneA / ZoneB): ").strip() or None
#         govt_posn = input("Government position (or press Enter): ").strip() or None
#         risk = input("Risk factor (Low/Medium/High): ").strip() or 'Medium'
#         police = input("Assigned police_id (or press Enter for none): ").strip()
#         police_id = int(police) if police else None

#         cur = connection.cursor()

#         hostage_sql = """
#         INSERT INTO HOSTAGES
#         (first_name, mid_name, last_name, age, status, zone, govt_posn,
#          risk_factor, police_id)
#         VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s)
#         """
#         _print_and_exec(cur, hostage_sql,
#                         (first, mid, last, age_val, status, zone,
#                          govt_posn, risk, police_id))
#         hostage_id = cur.lastrowid

#         # If a police_id is given, reflect that in CLAIMS as well
#         if police_id is not None:
#             claims_sql = """
#             INSERT INTO CLAIMS (police_id, hostage_id)
#             VALUES (%s,%s)
#             """
#             _print_and_exec(cur, claims_sql, (police_id, hostage_id))

#         connection.commit()
#         print(Fore.GREEN + f"✔ Hostage added with id={hostage_id}.")
#         cur.close()

#     except ValueError:
#         print(Fore.RED + "❌ Age and police_id must be integers if provided.")
#     except Error as e:
#         connection.rollback()
#         print(Fore.RED + f"❌ Error adding hostage: {e}")

def add_new_hostage(connection):
    """Insert a new hostage. If police_id is given, also create a CLAIMS row (atomic)."""
    print_header("ADD NEW HOSTAGE (INSERT)")
    try:
        first = input("First name: ").strip()
        mid = input("Middle name (or press Enter): ").strip() or None
        last = input("Last name: ").strip()

        age = input("Age (or press Enter): ").strip()
        age_val = int(age) if age else None

        status = input("Status (Pending/In-Progress/Resolved) [default Pending]: ").strip() or 'Pending'
        zone = input("Zone (e.g., ZoneA / ZoneB): ").strip() or None
        govt_posn = input("Government position (or press Enter): ").strip() or None
        risk = input("Risk factor (Low/Medium/High) [default Medium]: ").strip() or 'Medium'

        police = input("Assigned police_id (or press Enter for none): ").strip()
        police_id = int(police) if police else None

        cur = connection.cursor()

        # ---------------------------
        # 1. Main insert → HOSTAGES
        # ---------------------------
        hostage_sql = """
        INSERT INTO HOSTAGES
        (first_name, mid_name, last_name, age, status, zone, govt_posn,
         risk_factor, police_id)
        VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s)
        """

        try:
            cur.execute(hostage_sql,
                (first, mid, last, age_val, status, zone,
                 govt_posn, risk, police_id))
        except Error as e:
            print(Fore.RED + f"\n❌ Hostage insert failed: {e}")
            print(Fore.RED + "❌ No data inserted. Operation cancelled.")
            connection.rollback()
            cur.close()
            return

        hostage_id = cur.lastrowid

        # ---------------------------
        # 2. Conditionally insert into CLAIMS
        # ---------------------------
        if police_id is not None:
            claims_sql = """
            INSERT INTO CLAIMS (police_id, hostage_id)
            VALUES (%s,%s)
            """
            try:
                cur.execute(claims_sql, (police_id, hostage_id))
            except Error as e:
                print(Fore.RED + f"\n❌ CLAIMS insert failed: {e}")
                print(Fore.RED + "❌ Hostage insert rolled back.")
                connection.rollback()
                cur.close()
                return

        # ---------------------------
        # 3. Commit transaction
        # ---------------------------
        connection.commit()
        print(Fore.GREEN + f"✔ Hostage added successfully with id={hostage_id}.")
        cur.close()

    except ValueError:
        print(Fore.RED + "❌ Age and police_id must be integers.")
    except Error as e:
        connection.rollback()
        print(Fore.RED + f"❌ Unexpected error: {e}")



# ------------ INSERT 2: EVIDENCE (+ EVIDENCE_FOUND_DATE + COLLECTED_DURING)
# def insert_evidence(connection):
#     print_header("INSERT NEW EVIDENCE (INSERT)")
#     try:
#         evidence_id = int(input("Evidence ID: "))
#         police_id = int(input("Police ID (collector): "))
#         description = input("Description: ")
#         threat_level = input("Threat Level (Low/Medium/High/etc.): ")
#         use_now = input("Record found date as today? (Y/n): ").strip().lower()
#         mission_code = input(
#             "Mission code for which this evidence was collected (e.g., M001, or press Enter to skip): "
#         ).strip()

#         cur = connection.cursor()

#         # Insert into EVIDENCE
#         query_e = """
#         INSERT INTO EVIDENCE
#         (evidence_id, police_id, description, threat_level)
#         VALUES (%s,%s,%s,%s)
#         """
#         _print_and_exec(cur, query_e,
#                         (evidence_id, police_id, description, threat_level))

#         # Insert into EVIDENCE_FOUND_DATE
#         if use_now == 'n':
#             fd = input(
#                 "Enter found date (YYYY-MM-DD) or press Enter to skip: "
#             ).strip()
#             if fd:
#                 date_sql = """
#                 INSERT INTO EVIDENCE_FOUND_DATE (evidence_id, found_date)
#                 VALUES (%s,%s)
#                 """
#                 _print_and_exec(cur, date_sql, (evidence_id, fd))
#         else:
#             date_sql = """
#             INSERT INTO EVIDENCE_FOUND_DATE (evidence_id, found_date)
#             VALUES (%s,CURDATE())
#             """
#             _print_and_exec(cur, date_sql, (evidence_id,))

#         # Optionally tie this evidence to a mission via COLLECTED_DURING
#         if mission_code:
#             cd_sql = """
#             INSERT INTO COLLECTED_DURING (police_id, evidence_id, mission_code)
#             VALUES (%s,%s,%s)
#             """
#             _print_and_exec(cur, cd_sql, (police_id, evidence_id, mission_code))

#         connection.commit()
#         print(Fore.GREEN + "✔ Evidence inserted and linked to date/mission if provided.")
#         cur.close()

#     except ValueError:
#         print(Fore.RED + "❌ Evidence ID and Police ID must be integers.")
#     except Error as e:
#         connection.rollback()
#         print(Fore.RED + f"❌ {e}")


def insert_evidence(connection):
    print_header("INSERT NEW EVIDENCE (INSERT)")
    try:
        evidence_id = int(input("Evidence ID: "))
        police_id = int(input("Police ID (collector): "))
        description = input("Description: ")
        threat_level = input("Threat Level (Low/Medium/High/etc.): ")
        use_now = input("Record found date as today? (Y/n): ").strip().lower()
        mission_code = input(
            "Mission code for which this evidence was collected (e.g., M001, or press Enter to skip): "
        ).strip()

        cur = connection.cursor()

        # ---------------------------
        # 1. Insert into EVIDENCE
        # ---------------------------
        query_e = """
        INSERT INTO EVIDENCE
        (evidence_id, police_id, description, threat_level)
        VALUES (%s,%s,%s,%s)
        """

        try:
            cur.execute(query_e, (evidence_id, police_id, description, threat_level))
        except Error as e:
            print(Fore.RED + f"\n❌ Evidence insert failed: {e}")
            print(Fore.RED + "❌ No data inserted. Operation cancelled.")
            connection.rollback()
            cur.close()
            return  # stop entire operation

        # ---------------------------
        # 2. Insert into EVIDENCE_FOUND_DATE
        # ---------------------------
        if use_now == "n":
            fd = input("Enter found date (YYYY-MM-DD) or press Enter to skip: ").strip()
            if fd:
                date_sql = """
                INSERT INTO EVIDENCE_FOUND_DATE (evidence_id, found_date)
                VALUES (%s,%s)
                """
                cur.execute(date_sql, (evidence_id, fd))
        else:
            date_sql = """
            INSERT INTO EVIDENCE_FOUND_DATE (evidence_id, found_date)
            VALUES (%s,CURDATE())
            """
            cur.execute(date_sql, (evidence_id,))

        # ---------------------------
        # 3. Optional: Insert into COLLECTED_DURING
        # ---------------------------
        if mission_code:
            cd_sql = """
            INSERT INTO COLLECTED_DURING (police_id, evidence_id, mission_code)
            VALUES (%s,%s,%s)
            """
            cur.execute(cd_sql, (police_id, evidence_id, mission_code))

        # ---------------------------
        # 4. All inserts succeeded → commit
        # ---------------------------
        connection.commit()
        print(Fore.GREEN + "✔ Evidence inserted successfully (with date/mission if provided).")

        cur.close()

    except ValueError:
        print(Fore.RED + "❌ Evidence ID and Police ID must be integers.")
    except Error as e:
        connection.rollback()
        print(Fore.RED + f"❌ Unexpected error: {e}")



# ------------ INSERT 3: SUPPLIER (+ SUPPLIER_CONTACT)
# def insert_supplier(connection):
#     print_header("INSERT NEW SUPPLIER (INSERT)")
#     try:
#         first = input("Supplier first name: ").strip()
#         mid = input("Middle name (or press Enter): ").strip() or None
#         last = input("Last name: ").strip()
#         reliability = input("Reliability (High/Medium/Low): ").strip() or "Medium"
#         phone = input("Contact phone: ").strip()
#         email = input("Contact email: ").strip()

#         cur = connection.cursor()

#         sup_sql = """
#         INSERT INTO SUPPLIER (first_name, mid_name, last_name, reliability_score)
#         VALUES (%s,%s,%s,%s)
#         """
#         _print_and_exec(cur, sup_sql, (first, mid, last, reliability))
#         supplier_id = cur.lastrowid

#         contact_sql = """
#         INSERT INTO SUPPLIER_CONTACT (supplier_id, phone_number, email)
#         VALUES (%s,%s,%s)
#         """
#         _print_and_exec(cur, contact_sql, (supplier_id, phone, email))

#         connection.commit()
#         print(Fore.GREEN + f"✔ Supplier inserted with id={supplier_id}.")
#         cur.close()

#     except Error as e:
#         connection.rollback()
#         print(Fore.RED + f"❌ Error inserting supplier: {e}")

def insert_supplier(connection):
    print_header("INSERT NEW SUPPLIER (INSERT)")
    try:
        first = input("Supplier first name: ").strip()
        mid = input("Middle name (or press Enter): ").strip() or None
        last = input("Last name: ").strip()
        reliability = input("Reliability (High/Medium/Low) [default Medium]: ").strip() or "Medium"

        phone = input("Contact phone: ").strip()
        email = input("Contact email: ").strip()

        cur = connection.cursor()

        # ---------------------------
        # 1. Main insert → SUPPLIER
        # ---------------------------
        sup_sql = """
        INSERT INTO SUPPLIER (first_name, mid_name, last_name, reliability_score)
        VALUES (%s,%s,%s,%s)
        """

        try:
            cur.execute(sup_sql, (first, mid, last, reliability))
        except Error as e:
            print(Fore.RED + f"\n❌ Supplier insert failed: {e}")
            print(Fore.RED + "❌ No data inserted. Operation cancelled.")
            connection.rollback()
            cur.close()
            return

        supplier_id = cur.lastrowid

        # ---------------------------
        # 2. Insert → SUPPLIER_CONTACT
        # ---------------------------
        contact_sql = """
        INSERT INTO SUPPLIER_CONTACT (supplier_id, phone_number, email)
        VALUES (%s,%s,%s)
        """

        try:
            cur.execute(contact_sql, (supplier_id, phone, email))
        except Error as e:
            print(Fore.RED + f"\n❌ SUPPLIER_CONTACT insert failed: {e}")
            print(Fore.RED + "❌ Supplier insert rolled back.")
            connection.rollback()
            cur.close()
            return

        # ---------------------------
        # 3. Commit transaction
        # ---------------------------
        connection.commit()
        print(Fore.GREEN + f"✔ Supplier inserted successfully with id={supplier_id}.")
        cur.close()

    except Error as e:
        connection.rollback()
        print(Fore.RED + f"❌ Unexpected error: {e}")


# ------------ UPDATE 1: HOSTAGE STATUS
def update_hostage_status(connection):
    """Update the status field for a hostage."""
    print_header("UPDATE HOSTAGE STATUS (UPDATE)")
    try:
        hid = int(input("Enter Hostage ID: "))
        new_status = input("New status (Pending/In-Progress/Resolved): ").strip()
        cur = connection.cursor()
        sql = "UPDATE HOSTAGES SET status=%s WHERE hostage_id=%s"
        affected = _print_and_exec(cur, sql, (new_status, hid))
        connection.commit()
        if affected:
            print(Fore.GREEN + "✔ Hostage status updated.")
        else:
            print(Fore.YELLOW + "⚠ No hostage updated (id may not exist).")
        cur.close()
    except ValueError:
        print(Fore.RED + "❌ Hostage ID must be an integer.")
    except Error as e:
        connection.rollback()
        print(Fore.RED + f"❌ Error updating hostage status: {e}")


# ------------ UPDATE 2: MISSION STAGE
def update_mission_stage(connection):
    """Update mission stage (Planned/Ongoing/Completed/Failed)."""
    print_header("UPDATE MISSION STAGE (UPDATE)")
    try:
        mcode = input("Enter Mission Code (e.g., M001): ").strip()
        new_stage = input("New stage (Planned/Ongoing/Completed/Failed): ").strip()

        cur = connection.cursor()

        # Update stage in MISSION_DETAILS via JOIN on MISSION_IDENTIFIER
        sql = """
        UPDATE MISSION_DETAILS md
        JOIN MISSION_IDENTIFIER mi
          ON md.mission_id = mi.mission_id
        SET md.stage = %s
        WHERE mi.mission_code = %s
        """
        affected = _print_and_exec(cur, sql, (new_stage, mcode))

        # If mission is completed, set end_time to NOW()
        if affected and new_stage == "Completed":
            end_sql = """
            UPDATE MISSION_DETAILS md
            JOIN MISSION_IDENTIFIER mi
              ON md.mission_id = mi.mission_id
            SET md.end_time = NOW()
            WHERE mi.mission_code = %s
            """
            _print_and_exec(cur, end_sql, (mcode,))

        connection.commit()
        if affected:
            print(Fore.GREEN + "✔ Mission stage updated.")
        else:
            print(Fore.YELLOW + "⚠ No mission updated (code may not exist).")
        cur.close()

    except Error as e:
        connection.rollback()
        print(Fore.RED + f"❌ Error updating mission stage: {e}")


# ------------ UPDATE 3: EQUIPMENT COUNTS
def update_equipment_count(connection):
    """Update equipment_count and optionally total_quantity."""
    print_header("UPDATE EQUIPMENT COUNT (UPDATE)")
    try:
        equipment_id = int(input("Equipment ID: "))
        new_count = int(input("New equipment_count value: "))
        total_input = input(
            "New total_quantity (press Enter to leave unchanged): "
        ).strip()

        cur = connection.cursor()

        if total_input:
            new_total = int(total_input)
            sql = """
            UPDATE EQUIPMENT
            SET equipment_count=%s,
                total_quantity=%s
            WHERE equipment_id=%s
            """
            params = (new_count, new_total, equipment_id)
        else:
            sql = "UPDATE EQUIPMENT SET equipment_count=%s WHERE equipment_id=%s"
            params = (new_count, equipment_id)

        affected = _print_and_exec(cur, sql, params)
        connection.commit()
        if affected:
            print(Fore.GREEN + "✔ Equipment updated.")
        else:
            print(Fore.YELLOW + "⚠ No equipment updated (id may not exist).")
        cur.close()

    except ValueError:
        print(Fore.RED + "❌ IDs and numeric fields must be integers.")
    except Error as e:
        connection.rollback()
        print(Fore.RED + f"❌ {e}")


# ------------ DELETE 1: HOSTAGE
def delete_hostage(connection):
    """Delete a hostage by id (with confirmation)."""
    print_header("DELETE HOSTAGE (DELETE)")
    try:
        hid = int(input("Enter Hostage ID to delete: "))
        confirm = input(
            Fore.RED + f"Type DELETE to confirm deletion of hostage {hid}: "
        ).strip()
        if confirm != 'DELETE':
            print(Fore.YELLOW + "Deletion cancelled.")
            return
        cur = connection.cursor()
        sql = "DELETE FROM HOSTAGES WHERE hostage_id=%s"
        affected = _print_and_exec(cur, sql, (hid,))
        connection.commit()
        if affected:
            print(Fore.GREEN + "✔ Hostage deleted (dependent rows cascaded).")
        else:
            print(Fore.YELLOW + "⚠ No hostage deleted (id may not exist).")
        cur.close()
    except ValueError:
        print(Fore.RED + "❌ Hostage ID must be an integer.")
    except Error as e:
        connection.rollback()
        print(Fore.RED + f"❌ Error deleting hostage: {e}")


# ------------ DELETE 2: EVIDENCE
def delete_evidence(connection):
    """Delete evidence by evidence_id (cascades to EVIDENCE_FOUND_DATE, COLLECTED_DURING)."""
    print_header("DELETE EVIDENCE (DELETE)")
    try:
        evid = int(input("Enter Evidence ID to delete: "))
        confirm = input(
            Fore.RED + f"Type DELETE to confirm deletion of evidence {evid}: "
        ).strip()
        if confirm != 'DELETE':
            print(Fore.YELLOW + "Deletion cancelled.")
            return
        cur = connection.cursor()
        # evidence_id is UNIQUE, even though PK is (evidence_id,police_id)
        sql = "DELETE FROM EVIDENCE WHERE evidence_id=%s"
        affected = _print_and_exec(cur, sql, (evid,))
        connection.commit()
        if affected:
            print(Fore.GREEN + "✔ Evidence deleted (linked rows cascaded).")
        else:
            print(Fore.YELLOW + "⚠ No evidence deleted (id may not exist).")
        cur.close()
    except ValueError:
        print(Fore.RED + "❌ Evidence ID must be an integer.")
    except Error as e:
        connection.rollback()
        print(Fore.RED + f"❌ Error deleting evidence: {e}")


# ------------ DELETE 3: SAFEHOUSE
def delete_safehouse(connection):
    """Delete safehouse (cascades to EQUIPMENT, LOOT, RESOURCE_COORDINATION; sets NULL in MISSION_EXECUTION)."""
    print_header("DELETE SAFEHOUSE (DELETE)")
    try:
        sid = int(input("Enter Safehouse ID to delete: "))
        confirm = input(
            Fore.RED + f"Type DELETE to confirm deletion of safehouse {sid}: "
        ).strip()
        if confirm != 'DELETE':
            print(Fore.YELLOW + "Deletion cancelled.")
            return

        cur = connection.cursor()
        sql = "DELETE FROM SAFEHOUSE WHERE safehouse_id=%s"
        affected = _print_and_exec(cur, sql, (sid,))
        connection.commit()
        if affected:
            print(Fore.GREEN + "✔ Safehouse deleted. Related rows cascaded/updated.")
        else:
            print(Fore.YELLOW + "⚠ No safehouse deleted (id may not exist).")
        cur.close()
    except ValueError:
        print(Fore.RED + "❌ Safehouse ID must be an integer.")
    except Error as e:
        connection.rollback()
        print(Fore.RED + f"❌ Error deleting safehouse: {e}")


# Backwards-compatible alias if any code expects this name
def search_hostage_by_id(connection):
    return get_hostage_by_id(connection)


# ---------------------------------------------------------
# MAIN MENU
# ---------------------------------------------------------
def main_menu(connection):
    while True:
        print(Fore.YELLOW + Style.BRIGHT + """
======================== MONEY HEIST DB MENU ========================
READ OPERATIONS
 1.  View all hostages
 2.  Search hostage by ID
 3.  Hostages with assigned police (JOIN)
 4.  Hostages with dependent counts (GROUP BY)
 5.  Equipment by Safehouse (JOIN)
 6.  Equipment stock alert (AGG + HAVING)
 7.  Mission members + equipment (JOIN)
 8.  Mission summary (complex JOIN/AGG)
 9.  Police activity report (complex JOIN/AGG)
10.  Supplier resource usage (3-table JOIN)
11.  High-risk hostages & security (multi-JOIN)
12.  Evidence report (evidence + missions + dates)

INSERT OPERATIONS (3)
13.  Add new hostage (HOSTAGES + CLAIMS)
14.  Insert new evidence (EVIDENCE + EVIDENCE_FOUND_DATE + COLLECTED_DURING)
15.  Insert new supplier (SUPPLIER + SUPPLIER_CONTACT)

UPDATE OPERATIONS (3)
16.  Update hostage status
17.  Update mission stage
18.  Update equipment count / total_quantity

DELETE OPERATIONS (3)
19.  Delete hostage
20.  Delete evidence
21.  Delete safehouse

22.  Exit
=====================================================================
""")

        ch = input(Fore.CYAN + "Enter choice: ").strip()

        # READ
        if ch == "1":  view_all_hostages(connection)
        elif ch == "2": get_hostage_by_id(connection)
        elif ch == "3": list_hostages_with_police(connection)
        elif ch == "4": hostages_dependent_count(connection)
        elif ch == "5": equipment_by_safehouse(connection)
        elif ch == "6": equipment_stock_alert(connection)
        elif ch == "7": mission_members(connection)
        elif ch == "8": mission_summary(connection)
        elif ch == "9": police_activity_report(connection)
        elif ch == "10": supplier_resource_usage(connection)
        elif ch == "11": high_risk_hostages_and_security(connection)
        elif ch == "12": evidence_report(connection)

        # INSERT (3)
        elif ch == "13": add_new_hostage(connection)
        elif ch == "14": insert_evidence(connection)
        elif ch == "15": insert_supplier(connection)

        # UPDATE (3)
        elif ch == "16": update_hostage_status(connection)
        elif ch == "17": update_mission_stage(connection)
        elif ch == "18": update_equipment_count(connection)

        # DELETE (3)
        elif ch == "19": delete_hostage(connection)
        elif ch == "20": delete_evidence(connection)
        elif ch == "21": delete_safehouse(connection)

        elif ch == "22":
            print(Fore.GREEN + "\n👋 Exiting...")
            break
        else:
            print(Fore.RED + "❌ Invalid choice. Try again.")


# ---------------------------------------------------------
# MAIN
# ---------------------------------------------------------
if __name__ == "__main__":
    conn = connect_db()
    if conn:
        main_menu(conn)
        conn.close()
