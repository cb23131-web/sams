import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Subject {
  int? id;
  String code;
  String name;
  String description;
  String schedule;
  int credits;
  int maxSlots;
  int enrolled;
  String status;

  Subject({
    this.id,
    required this.code,
    required this.name,
    this.description = '',
    this.schedule = '',
    this.credits = 3,
    this.maxSlots = 30,
    this.enrolled = 0,
    this.status = 'Open',
  });

  factory Subject.fromMap(Map<String, dynamic> m) => Subject(
    id: m['id'] as int?,
    code: m['code'] as String,
    name: m['name'] as String,
    description: m['description'] as String? ?? '',
    schedule: m['schedule'] as String? ?? '',
    credits: m['credits'] as int? ?? 3,
    maxSlots: m['max_slots'] as int? ?? 30,
    enrolled: m['enrolled'] as int? ?? 0,
    status: m['status'] as String? ?? 'Open',
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'code': code,
    'name': name,
    'description': description,
    'schedule': schedule,
    'credits': credits,
    'max_slots': maxSlots,
    'enrolled': enrolled,
    'status': status,
  };
}

class CoCurriculum {
  int? id;
  String code;
  String name;
  String description;
  String schedule;
  int maxSlots;
  int enrolled;
  String status;

  CoCurriculum({
    this.id,
    required this.code,
    required this.name,
    this.description = '',
    this.schedule = '',
    this.maxSlots = 30,
    this.enrolled = 0,
    this.status = 'Open',
  });

  factory CoCurriculum.fromMap(Map<String, dynamic> m) => CoCurriculum(
    id: m['id'] as int?,
    code: m['code'] as String,
    name: m['name'] as String,
    description: m['description'] as String? ?? '',
    schedule: m['schedule'] as String? ?? '',
    maxSlots: m['max_slots'] as int? ?? 30,
    enrolled: m['enrolled'] as int? ?? 0,
    status: m['status'] as String? ?? 'Open',
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'code': code,
    'name': name,
    'description': description,
    'schedule': schedule,
    'max_slots': maxSlots,
    'enrolled': enrolled,
    'status': status,
  };
}

class AttendanceSession {
  int? sessionId;
  int subjectId;
  String date;
  String startTime;
  String endTime;
  String code;
  String status;
  String createdAt;

  AttendanceSession({
    this.sessionId,
    required this.subjectId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.code,
    this.status = 'Open',
    required this.createdAt,
  });

  factory AttendanceSession.fromMap(Map<String, dynamic> m) =>
      AttendanceSession(
        sessionId: m['session_id'] as int?,
        subjectId: m['subject_id'] as int,
        date: m['date'] as String? ?? '',
        startTime: m['start_time'] as String? ?? '',
        endTime: m['end_time'] as String? ?? '',
        code: m['code'] as String? ?? '',
        status: m['status'] as String? ?? 'Open',
        createdAt: m['created_at'] as String? ?? '',
      );

  Map<String, dynamic> toMap() => {
    'session_id': sessionId,
    'subject_id': subjectId,
    'date': date,
    'start_time': startTime,
    'end_time': endTime,
    'code': code,
    'status': status,
    'created_at': createdAt,
  };
}

class AttendanceRecord {
  int? recordId;
  int sessionId;
  String studentName;
  int present;
  String markedAt;

  AttendanceRecord({
    this.recordId,
    required this.sessionId,
    required this.studentName,
    this.present = 1,
    required this.markedAt,
  });

  factory AttendanceRecord.fromMap(Map<String, dynamic> m) => AttendanceRecord(
    recordId: m['record_id'] as int?,
    sessionId: m['session_id'] as int,
    studentName: m['student_name'] as String,
    present: m['present'] as int? ?? 1,
    markedAt: m['marked_at'] as String? ?? '',
  );

  Map<String, dynamic> toMap() => {
    'record_id': recordId,
    'session_id': sessionId,
    'student_name': studentName,
    'present': present,
    'marked_at': markedAt,
  };
}

class TuitionFeeStatus {
  int? statusId;
  String statusName;
  int triggersBlock;

  TuitionFeeStatus({
    this.statusId,
    required this.statusName,
    this.triggersBlock = 0,
  });

  factory TuitionFeeStatus.fromMap(Map<String, dynamic> m) => TuitionFeeStatus(
    statusId: m['status_id'] as int?,
    statusName: m['status_name'] as String,
    triggersBlock: m['triggers_block'] as int? ?? 0,
  );

  Map<String, dynamic> toMap() => {
    'status_id': statusId,
    'status_name': statusName,
    'triggers_block': triggersBlock,
  };
}

class TuitionFee {
  int? feeId;
  String studentId;
  int statusId;
  String semester;
  double amount;
  double amountPaid;
  String dueDate;

  TuitionFee({
    this.feeId,
    required this.studentId,
    required this.statusId,
    required this.semester,
    required this.amount,
    required this.amountPaid,
    required this.dueDate,
  });

  factory TuitionFee.fromMap(Map<String, dynamic> m) => TuitionFee(
    feeId: m['fee_id'] as int?,
    studentId: m['student_id'] as String,
    statusId: m['status_id'] as int,
    semester: m['semester'] as String,
    amount: (m['amount'] as num).toDouble(),
    amountPaid: (m['amount_paid'] as num).toDouble(),
    dueDate: m['due_date'] as String,
  );

  Map<String, dynamic> toMap() => {
    'fee_id': feeId,
    'student_id': studentId,
    'status_id': statusId,
    'semester': semester,
    'amount': amount,
    'amount_paid': amountPaid,
    'due_date': dueDate,
  };
}

class PaymentTransaction {
  int? transactionId;
  int feeId;
  double amount;
  String paidAt;
  String method;
  String receiptNo;

  PaymentTransaction({
    this.transactionId,
    required this.feeId,
    required this.amount,
    required this.paidAt,
    required this.method,
    required this.receiptNo,
  });

  factory PaymentTransaction.fromMap(Map<String, dynamic> m) =>
      PaymentTransaction(
        transactionId: m['transaction_id'] as int?,
        feeId: m['fee_id'] as int,
        amount: (m['amount'] as num).toDouble(),
        paidAt: m['paid_at'] as String,
        method: m['method'] as String,
        receiptNo: m['receipt_no'] as String,
      );

  Map<String, dynamic> toMap() => {
    'transaction_id': transactionId,
    'fee_id': feeId,
    'amount': amount,
    'paid_at': paidAt,
    'method': method,
    'receipt_no': receiptNo,
  };
}

class ClaimActivity {
  int? id;
  String title;
  String category;
  int hours;
  int credit;
  String notes;

  ClaimActivity({
    this.id,
    required this.title,
    required this.category,
    required this.hours,
    required this.credit,
    this.notes = '',
  });

  factory ClaimActivity.fromMap(Map<String, dynamic> m) => ClaimActivity(
    id: m['id'] as int?,
    title: m['title'] as String,
    category: m['category'] as String? ?? '',
    hours: m['hours'] as int? ?? 0,
    credit: m['credit'] as int? ?? 0,
    notes: m['notes'] as String? ?? '',
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'category': category,
    'hours': hours,
    'credit': credit,
    'notes': notes,
  };
}

class Claim {
  int? claimId;
  int activityId;
  String studentName;
  String status;
  String submissionDate;
  int verifiedHours;
  int creditEquivalent;
  String? rejectionReason;

  Claim({
    this.claimId,
    required this.activityId,
    required this.studentName,
    this.status = 'Pending',
    required this.submissionDate,
    this.verifiedHours = 0,
    required this.creditEquivalent,
    this.rejectionReason,
  });

  factory Claim.fromMap(Map<String, dynamic> m) => Claim(
    claimId: m['claim_id'] as int?,
    activityId: m['activity_id'] as int,
    studentName: m['student_name'] as String,
    status: m['status'] as String? ?? 'Pending',
    submissionDate: m['submission_date'] as String? ?? '',
    verifiedHours: m['verified_hours'] as int? ?? 0,
    creditEquivalent: m['credit_equivalent'] as int? ?? 0,
    rejectionReason: m['rejection_reason'] as String?,
  );

  Map<String, dynamic> toMap() => {
    'claim_id': claimId,
    'activity_id': activityId,
    'student_name': studentName,
    'status': status,
    'submission_date': submissionDate,
    'verified_hours': verifiedHours,
    'credit_equivalent': creditEquivalent,
    'rejection_reason': rejectionReason,
  };
}

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  factory AppDatabase() => _instance;
  AppDatabase._internal();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _init();
    return _db!;
  }

  Future<Database> _init() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'SAMS.db');
    return openDatabase(
      path,
      version: 7,
      onCreate: (db, version) async {
        await _createSchema(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _createTreasurySchema(db);
        }
        if (oldVersion < 3) {
          await _createAttendanceSchema(db);
        }
        if (oldVersion < 4) {
          await db.execute('''
            ALTER TABLE attendance_sessions ADD COLUMN date TEXT DEFAULT ''
          ''');
        }
        if (oldVersion < 5) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS grades (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              registration_id INTEGER,
              grade TEXT,
              updated_at TEXT,
              FOREIGN KEY(registration_id) REFERENCES registrations(id)
            )
          ''');
        }
        if (oldVersion < 6) {
          // create cocurriculums and registrations for older DBs
          await db.execute('''
            CREATE TABLE IF NOT EXISTS cocurriculums (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              code TEXT,
              name TEXT,
              description TEXT,
              schedule TEXT,
              max_slots INTEGER,
              enrolled INTEGER,
              status TEXT
            )
          ''');
          await db.execute('''
            CREATE TABLE IF NOT EXISTS cocurriculum_registrations (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              cocurriculum_id INTEGER,
              student_name TEXT,
              FOREIGN KEY(cocurriculum_id) REFERENCES cocurriculums(id)
            )
          ''');
        }
        if (oldVersion < 7) {
          await _createClaimSchema(db);
        }
      },
    );
  }

  Future<void> _createAttendanceSchema(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS attendance_sessions (
        session_id INTEGER PRIMARY KEY AUTOINCREMENT,
        subject_id INTEGER,
        date TEXT,
        start_time TEXT,
        end_time TEXT,
        code TEXT,
        status TEXT,
        created_at TEXT,
        FOREIGN KEY(subject_id) REFERENCES subjects(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS attendance_records (
        record_id INTEGER PRIMARY KEY AUTOINCREMENT,
        session_id INTEGER,
        student_name TEXT,
        present INTEGER,
        marked_at TEXT,
        FOREIGN KEY(session_id) REFERENCES attendance_sessions(session_id)
      )
    ''');
  }

  Future<void> _createTreasurySchema(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS tuition_fee_status (
        status_id INTEGER PRIMARY KEY AUTOINCREMENT,
        status_name TEXT,
        triggers_block INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS tuition_fee (
        fee_id INTEGER PRIMARY KEY AUTOINCREMENT,
        student_id TEXT,
        status_id INTEGER,
        semester TEXT,
        amount REAL,
        amount_paid REAL,
        due_date TEXT,
        FOREIGN KEY(status_id) REFERENCES tuition_fee_status(status_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS payment_transaction (
        transaction_id INTEGER PRIMARY KEY AUTOINCREMENT,
        fee_id INTEGER,
        amount REAL,
        paid_at TEXT,
        method TEXT,
        receipt_no TEXT,
        FOREIGN KEY(fee_id) REFERENCES tuition_fee(fee_id)
      )
    ''');

    final statusCount = await db.query('tuition_fee_status');
    if (statusCount.isEmpty) {
      await db.insert('tuition_fee_status', {
        'status_name': 'PAID',
        'triggers_block': 0,
      });
      await db.insert('tuition_fee_status', {
        'status_name': 'PENDING',
        'triggers_block': 0,
      });
      await db.insert('tuition_fee_status', {
        'status_name': 'BLOCKED',
        'triggers_block': 1,
      });
    }
  }

  Future<void> _createSchema(Database db) async {
    await db.execute('''
        CREATE TABLE subjects (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          code TEXT,
          name TEXT,
          description TEXT,
          schedule TEXT,
          credits INTEGER,
          max_slots INTEGER,
          enrolled INTEGER,
          status TEXT
        )
      ''');

    await db.execute('''
        CREATE TABLE IF NOT EXISTS cocurriculums (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          code TEXT,
          name TEXT,
          description TEXT,
          schedule TEXT,
          max_slots INTEGER,
          enrolled INTEGER,
          status TEXT
        )
      ''');

    await db.execute('''
        CREATE TABLE registrations (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          subject_id INTEGER,
          student_name TEXT,
          FOREIGN KEY(subject_id) REFERENCES subjects(id)
        )
      ''');

    await db.execute('''
        CREATE TABLE IF NOT EXISTS grades (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          registration_id INTEGER,
          grade TEXT,
          updated_at TEXT,
          FOREIGN KEY(registration_id) REFERENCES registrations(id)
        )
      ''');

    // co-curriculum registrations
    await db.execute('''
      CREATE TABLE IF NOT EXISTS cocurriculum_registrations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cocurriculum_id INTEGER,
        student_name TEXT,
        FOREIGN KEY(cocurriculum_id) REFERENCES cocurriculums(id)
      )
    ''');

    await _createAttendanceSchema(db);
    await _createClaimSchema(db);
    await _createTreasurySchema(db);
  }

  Future<void> _createClaimSchema(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS claim_activities (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        category TEXT,
        hours INTEGER,
        credit INTEGER,
        notes TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS claims (
        claim_id INTEGER PRIMARY KEY AUTOINCREMENT,
        activity_id INTEGER,
        student_name TEXT,
        status TEXT,
        submission_date TEXT,
        verified_hours INTEGER,
        credit_equivalent INTEGER,
        rejection_reason TEXT,
        FOREIGN KEY(activity_id) REFERENCES claim_activities(id)
      )
    ''');

    final existing = await db.query('claim_activities');
    if (existing.isEmpty) {
      await db.insert('claim_activities', {
        'title': 'Futsal Tournament',
        'category': 'Sports',
        'hours': 3,
        'credit': 1,
        'notes': 'A competitive futsal event.',
      });
      await db.insert('claim_activities', {
        'title': 'Badminton',
        'category': 'Sports',
        'hours': 2,
        'credit': 1,
        'notes': 'Participation in badminton competition.',
      });
      await db.insert('claim_activities', {
        'title': 'Kayak',
        'category': 'Sports',
        'hours': 2,
        'credit': 1,
        'notes': 'Kayak activity verification pending.',
      });
    }
  }

  Future<List<ClaimActivity>> getClaimActivities() async {
    final database = await db;
    final maps = await database.query('claim_activities', orderBy: 'id ASC');
    return maps.map((m) => ClaimActivity.fromMap(m)).toList();
  }

  Future<List<Map<String, dynamic>>> getClaimActivitiesForStudent(
    String student,
  ) async {
    final database = await db;
    return database.rawQuery(
      '''
      SELECT a.id AS activity_id, a.title, a.category, a.hours, a.credit,
        c.claim_id, c.status, c.submission_date, c.verified_hours,
        c.credit_equivalent, c.rejection_reason
      FROM claim_activities a
      LEFT JOIN claims c ON a.id = c.activity_id AND c.student_name = ?
      ORDER BY a.id ASC
      ''',
      [student],
    );
  }

  Future<List<Map<String, dynamic>>> getClaimsForReview() async {
    final database = await db;
    return database.rawQuery('''
      SELECT c.claim_id, c.activity_id, c.student_name, c.status, c.submission_date,
        c.verified_hours, c.credit_equivalent, c.rejection_reason,
        a.title AS activity_title, a.category, a.hours, a.credit
      FROM claims c
      JOIN claim_activities a ON a.id = c.activity_id
      ORDER BY c.claim_id DESC
      ''', []);
  }

  Future<List<Claim>> getClaims({String? studentName}) async {
    final database = await db;
    final maps = await database.query(
      'claims',
      where: studentName != null ? 'student_name = ?' : null,
      whereArgs: studentName != null ? [studentName] : null,
      orderBy: 'claim_id DESC',
    );
    return maps.map((m) => Claim.fromMap(m)).toList();
  }

  Future<Map<String, dynamic>?> getClaimDetailById(int claimId) async {
    final database = await db;
    final maps = await database.rawQuery(
      '''
      SELECT c.claim_id, c.activity_id, c.student_name, c.status, c.submission_date,
        c.verified_hours, c.credit_equivalent, c.rejection_reason,
        a.title AS activity_title, a.category, a.hours, a.credit
      FROM claims c
      JOIN claim_activities a ON c.activity_id = a.id
      WHERE c.claim_id = ?
      ''',
      [claimId],
    );
    return maps.isEmpty ? null : maps.first;
  }

  Future<Claim?> getClaimById(int claimId) async {
    final database = await db;
    final maps = await database.query(
      'claims',
      where: 'claim_id = ?',
      whereArgs: [claimId],
    );
    return maps.isEmpty ? null : Claim.fromMap(maps.first);
  }

  Future<int> insertClaim(Claim claim) async {
    final database = await db;
    return database.insert('claims', claim.toMap());
  }

  Future<int> updateClaimStatus(
    int claimId,
    String status, {
    int? verifiedHours,
    int? creditEquivalent,
    String? rejectionReason,
  }) async {
    final database = await db;
    final values = <String, dynamic>{'status': status};
    if (verifiedHours != null) values['verified_hours'] = verifiedHours;
    if (creditEquivalent != null)
      values['credit_equivalent'] = creditEquivalent;
    if (rejectionReason != null) values['rejection_reason'] = rejectionReason;
    return database.update(
      'claims',
      values,
      where: 'claim_id = ?',
      whereArgs: [claimId],
    );
  }

  Future<int> getApprovedCreditTotalForStudent(String student) async {
    final database = await db;
    final result = await database.rawQuery(
      '''
      SELECT IFNULL(SUM(credit_equivalent), 0) AS total
      FROM claims
      WHERE student_name = ? AND status = 'Approved'
      ''',
      [student],
    );
    return (result.first['total'] as num?)?.toInt() ?? 0;
  }

  Future<List<Subject>> getSubjects() async {
    final database = await db;
    final maps = await database.query('subjects', orderBy: 'id DESC');
    return maps.map((m) => Subject.fromMap(m)).toList();
  }

  Future<List<CoCurriculum>> getCoCurriculums() async {
    final database = await db;
    final maps = await database.query('cocurriculums', orderBy: 'id DESC');
    return maps.map((m) => CoCurriculum.fromMap(m)).toList();
  }

  Future<int> insertSubject(Subject s) async {
    final database = await db;
    return database.insert('subjects', s.toMap());
  }

  Future<int> insertCoCurriculum(CoCurriculum c) async {
    final database = await db;
    return database.insert('cocurriculums', c.toMap());
  }

  Future<int> updateSubject(Subject s) async {
    final database = await db;
    return database.update(
      'subjects',
      s.toMap(),
      where: 'id = ?',
      whereArgs: [s.id],
    );
  }

  Future<int> updateCoCurriculum(CoCurriculum c) async {
    final database = await db;
    return database.update(
      'cocurriculums',
      c.toMap(),
      where: 'id = ?',
      whereArgs: [c.id],
    );
  }

  Future<int> deleteSubject(int id) async {
    final database = await db;
    return database.delete('subjects', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteCoCurriculum(int id) async {
    final database = await db;
    return database.delete('cocurriculums', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> registerSubject(String student, int subjectId) async {
    final database = await db;
    // check existing
    final exists = await database.query(
      'registrations',
      where: 'subject_id = ? AND student_name = ?',
      whereArgs: [subjectId, student],
    );
    if (exists.isNotEmpty) return 0;

    final res = await database.insert('registrations', {
      'subject_id': subjectId,
      'student_name': student,
    });
    // update enrolled count
    final subj = await database.query(
      'subjects',
      where: 'id = ?',
      whereArgs: [subjectId],
    );
    if (subj.isNotEmpty) {
      final enrolled = (subj.first['enrolled'] as int? ?? 0) + 1;
      final max = subj.first['max_slots'] as int? ?? 30;
      final status = enrolled >= max ? 'Full' : 'Open';
      await database.update(
        'subjects',
        {'enrolled': enrolled, 'status': status},
        where: 'id = ?',
        whereArgs: [subjectId],
      );
    }
    return res;
  }

  Future<int> registerCoCurriculum(String student, int cocurriculumId) async {
    final database = await db;
    return database.transaction<int>((txn) async {
      final exists = await txn.query(
        'cocurriculum_registrations',
        where: 'cocurriculum_id = ? AND student_name = ?',
        whereArgs: [cocurriculumId, student],
      );
      if (exists.isNotEmpty) return 0;

      final res = await txn.insert('cocurriculum_registrations', {
        'cocurriculum_id': cocurriculumId,
        'student_name': student,
      });

      final curr = await txn.query(
        'cocurriculums',
        where: 'id = ?',
        whereArgs: [cocurriculumId],
      );
      if (curr.isNotEmpty) {
        final enrolled = (curr.first['enrolled'] as int? ?? 0) + 1;
        final max = curr.first['max_slots'] as int? ?? 30;
        final status = enrolled >= max ? 'Full' : 'Open';
        await txn.update(
          'cocurriculums',
          {'enrolled': enrolled, 'status': status},
          where: 'id = ?',
          whereArgs: [cocurriculumId],
        );
      }
      return res;
    });
  }

  Future<int> unregisterCoCurriculum(String student, int cocurriculumId) async {
    final database = await db;
    final res = await database.delete(
      'cocurriculum_registrations',
      where: 'cocurriculum_id = ? AND student_name = ?',
      whereArgs: [cocurriculumId, student],
    );

    final curr = await database.query(
      'cocurriculums',
      where: 'id = ?',
      whereArgs: [cocurriculumId],
    );
    if (curr.isNotEmpty) {
      final enrolled = (curr.first['enrolled'] as int? ?? 1) - 1;
      final status = 'Open';
      await database.update(
        'cocurriculums',
        {'enrolled': enrolled, 'status': status},
        where: 'id = ?',
        whereArgs: [cocurriculumId],
      );
    }
    return res;
  }

  Future<int> unregisterSubject(String student, int subjectId) async {
    final database = await db;
    final res = await database.delete(
      'registrations',
      where: 'subject_id = ? AND student_name = ?',
      whereArgs: [subjectId, student],
    );
    // decrement enrolled
    final subj = await database.query(
      'subjects',
      where: 'id = ?',
      whereArgs: [subjectId],
    );
    if (subj.isNotEmpty) {
      final enrolled = (subj.first['enrolled'] as int? ?? 1) - 1;
      final status = 'Open';
      await database.update(
        'subjects',
        {'enrolled': enrolled, 'status': status},
        where: 'id = ?',
        whereArgs: [subjectId],
      );
    }
    return res;
  }

  Future<List<Map<String, dynamic>>> getRegistrationsFor(String student) async {
    final database = await db;
    return database.rawQuery(
      '''
      SELECT r.id as reg_id, s.* FROM registrations r
      JOIN subjects s ON s.id = r.subject_id
      WHERE r.student_name = ?
    ''',
      [student],
    );
  }

  Future<void> ensureProgrammingRegistrationFor(String student) async {
    final database = await db;
    await database.transaction((txn) async {
      final subjects = await txn.query(
        'subjects',
        where: 'code = ?',
        whereArgs: ['BCS101'],
        limit: 1,
      );

      late final int subjectId;
      final subjectValues = {
        'code': 'BCS101',
        'name': 'Programming',
        'description': 'Programming language subject',
        'schedule': 'Monday 9:00 AM',
        'credits': 3,
        'max_slots': 30,
        'enrolled': 24,
        'status': 'Open',
      };

      if (subjects.isEmpty) {
        subjectId = await txn.insert('subjects', subjectValues);
      } else {
        subjectId = subjects.first['id'] as int;
        await txn.update(
          'subjects',
          subjectValues,
          where: 'id = ?',
          whereArgs: [subjectId],
        );
      }

      final availableSubjects = [
        {
          'code': 'BCS102',
          'name': 'Database Systems',
          'description': 'Database design and SQL subject',
          'schedule': 'Tuesday 10:00 AM',
          'credits': 3,
          'max_slots': 30,
          'enrolled': 18,
          'status': 'Open',
        },
        {
          'code': 'BCS103',
          'name': 'Web Development',
          'description': 'Frontend and backend web development subject',
          'schedule': 'Wednesday 2:00 PM',
          'credits': 3,
          'max_slots': 30,
          'enrolled': 21,
          'status': 'Open',
        },
      ];

      for (final subject in availableSubjects) {
        final existing = await txn.query(
          'subjects',
          where: 'code = ?',
          whereArgs: [subject['code']],
          limit: 1,
        );

        if (existing.isEmpty) {
          await txn.insert('subjects', subject);
        }
      }

      final registrations = await txn.query(
        'registrations',
        where: 'student_name = ? AND subject_id = ?',
        whereArgs: [student, subjectId],
        limit: 1,
      );

      late final int registrationId;
      if (registrations.isEmpty) {
        registrationId = await txn.insert('registrations', {
          'subject_id': subjectId,
          'student_name': student,
        });
      } else {
        registrationId = registrations.first['id'] as int;
      }

      final grades = await txn.query(
        'grades',
        where: 'registration_id = ?',
        whereArgs: [registrationId],
        limit: 1,
      );

      final gradeValues = {
        'registration_id': registrationId,
        'grade': 'A-',
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (grades.isEmpty) {
        await txn.insert('grades', gradeValues);
      } else {
        await txn.update(
          'grades',
          gradeValues,
          where: 'registration_id = ?',
          whereArgs: [registrationId],
        );
      }
    });
  }

  Future<Map<String, dynamic>?> getRegisteredSubjectDetailsFor(
    String student,
    int subjectId,
  ) async {
    final database = await db;
    final rows = await database.rawQuery(
      '''
      SELECT r.id AS reg_id, s.*, IFNULL(g.grade, 'N/A') AS grade
      FROM registrations r
      JOIN subjects s ON s.id = r.subject_id
      LEFT JOIN grades g ON g.registration_id = r.id
      WHERE r.student_name = ? AND s.id = ?
      LIMIT 1
      ''',
      [student, subjectId],
    );

    return rows.isEmpty ? null : rows.first;
  }

  Future<int> insertAttendanceSession(AttendanceSession session) async {
    final database = await db;
    return database.insert('attendance_sessions', session.toMap());
  }

  Future<int> closeAttendanceSession(int sessionId) async {
    final database = await db;
    return database.update(
      'attendance_sessions',
      {'status': 'Closed'},
      where: 'session_id = ?',
      whereArgs: [sessionId],
    );
  }

  Future<AttendanceSession?> getAttendanceSessionById(int sessionId) async {
    final database = await db;
    final maps = await database.query(
      'attendance_sessions',
      where: 'session_id = ?',
      whereArgs: [sessionId],
    );
    return maps.isEmpty ? null : AttendanceSession.fromMap(maps.first);
  }

  Future<AttendanceSession?> getLatestAttendanceSessionForSubject(
    int subjectId,
  ) async {
    final database = await db;
    final maps = await database.query(
      'attendance_sessions',
      where: 'subject_id = ?',
      whereArgs: [subjectId],
      orderBy: 'session_id DESC',
      limit: 1,
    );
    return maps.isEmpty ? null : AttendanceSession.fromMap(maps.first);
  }

  Future<List<AttendanceSession>> getAttendanceSessionsForSubject(
    int subjectId,
  ) async {
    final database = await db;
    final maps = await database.query(
      'attendance_sessions',
      where: 'subject_id = ?',
      whereArgs: [subjectId],
      orderBy: 'session_id DESC',
    );
    return maps.map((m) => AttendanceSession.fromMap(m)).toList();
  }

  Future<List<Map<String, dynamic>>> getAttendanceRecordsForSession(
    int sessionId,
  ) async {
    final database = await db;
    return database.rawQuery(
      '''
      SELECT reg.student_name, IFNULL(ar.present, 0) AS present, ar.marked_at
      FROM registrations reg
      JOIN attendance_sessions sess ON sess.subject_id = reg.subject_id
      LEFT JOIN attendance_records ar ON ar.session_id = sess.session_id AND ar.student_name = reg.student_name
      WHERE sess.session_id = ?
      ORDER BY reg.id ASC
      ''',
      [sessionId],
    );
  }

  Future<List<Map<String, dynamic>>> getOpenAttendanceSessionsForStudent(
    String student,
  ) async {
    final database = await db;
    return database.rawQuery(
      '''
      SELECT a.session_id, a.subject_id, a.start_time, a.end_time, a.code, a.status, s.name AS subject_name,
        CASE WHEN r.student_name IS NOT NULL THEN 1 ELSE 0 END AS is_registered,
        IFNULL(ar.present, 0) AS present
      FROM attendance_sessions a
      JOIN subjects s ON s.id = a.subject_id
      LEFT JOIN registrations r ON r.subject_id = a.subject_id AND r.student_name = ?
      LEFT JOIN attendance_records ar ON ar.session_id = a.session_id AND ar.student_name = ?
      WHERE a.status = 'Open'
      ORDER BY a.session_id DESC
      ''',
      [student, student],
    );
  }

  Future<List<Map<String, dynamic>>> getAttendanceHistoryForStudent(
    String student,
  ) async {
    final database = await db;
    return database.rawQuery(
      '''
      SELECT a.session_id, a.subject_id, a.start_time, a.end_time, a.code, a.status, s.name AS subject_name,
        IFNULL(ar.present, 0) AS present, ar.marked_at
      FROM registrations r
      JOIN attendance_sessions a ON a.subject_id = r.subject_id
      JOIN subjects s ON s.id = a.subject_id
      LEFT JOIN attendance_records ar ON ar.session_id = a.session_id AND ar.student_name = r.student_name
      WHERE r.student_name = ?
      ORDER BY a.session_id DESC
      ''',
      [student],
    );
  }

  Future<int> markAttendance(int sessionId, String student, String code) async {
    final database = await db;
    final sessions = await database.query(
      'attendance_sessions',
      where: 'session_id = ?',
      whereArgs: [sessionId],
    );
    if (sessions.isEmpty) return 0;
    final session = AttendanceSession.fromMap(sessions.first);
    if (session.status != 'Open') return 0;
    if (session.code != code.trim()) return -1;

    final registered = await database.query(
      'registrations',
      where: 'subject_id = ? AND student_name = ?',
      whereArgs: [session.subjectId, student],
    );
    if (registered.isEmpty) return 0;

    final exists = await database.query(
      'attendance_records',
      where: 'session_id = ? AND student_name = ?',
      whereArgs: [sessionId, student],
    );
    if (exists.isNotEmpty) return 0;

    return database.insert('attendance_records', {
      'session_id': sessionId,
      'student_name': student,
      'present': 1,
      'marked_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<TuitionFeeStatus>> getTuitionFeeStatuses() async {
    final database = await db;
    final maps = await database.query(
      'tuition_fee_status',
      orderBy: 'status_id',
    );
    return maps.map((m) => TuitionFeeStatus.fromMap(m)).toList();
  }

  Future<List<TuitionFee>> getTuitionFees({String? search}) async {
    final database = await db;
    if (search == null || search.trim().isEmpty) {
      final maps = await database.query('tuition_fee', orderBy: 'fee_id DESC');
      return maps.map((m) => TuitionFee.fromMap(m)).toList();
    }
    final maps = await database.query(
      'tuition_fee',
      where: 'student_id LIKE ? OR semester LIKE ?',
      whereArgs: ['%${search.trim()}%', '%${search.trim()}%'],
      orderBy: 'fee_id DESC',
    );
    return maps.map((m) => TuitionFee.fromMap(m)).toList();
  }

  Future<TuitionFee?> getTuitionFeeById(int feeId) async {
    final database = await db;
    final maps = await database.query(
      'tuition_fee',
      where: 'fee_id = ?',
      whereArgs: [feeId],
    );
    return maps.isEmpty ? null : TuitionFee.fromMap(maps.first);
  }

  Future<int> insertTuitionFee(TuitionFee fee) async {
    final database = await db;
    return database.insert('tuition_fee', fee.toMap());
  }

  Future<int> updateTuitionFee(TuitionFee fee) async {
    final database = await db;
    return database.update(
      'tuition_fee',
      fee.toMap(),
      where: 'fee_id = ?',
      whereArgs: [fee.feeId],
    );
  }

  Future<int> insertPaymentTransaction(PaymentTransaction transaction) async {
    final database = await db;
    return database.insert('payment_transaction', transaction.toMap());
  }

  Future<List<PaymentTransaction>> getPaymentTransactionsForFee(
    int feeId,
  ) async {
    final database = await db;
    final maps = await database.query(
      'payment_transaction',
      where: 'fee_id = ?',
      whereArgs: [feeId],
      orderBy: 'paid_at DESC',
    );
    return maps.map((m) => PaymentTransaction.fromMap(m)).toList();
  }

  Future<List<Map<String, dynamic>>> getEnrolledStudentsForSubject(
    int subjectId,
  ) async {
    final database = await db;
    // First, get all registrations for this subject
    final registrations = await database.query(
      'registrations',
      where: 'subject_id = ?',
      whereArgs: [subjectId],
      orderBy: 'student_name ASC',
    );

    // For each registration, get the grade if it exists
    List<Map<String, dynamic>> result = [];
    for (var reg in registrations) {
      final regId = reg['id'] as int?;
      final grades = await database.query(
        'grades',
        where: 'registration_id = ?',
        whereArgs: [regId],
      );

      result.add({
        'student_id': regId,
        'student_name': reg['student_name'] ?? 'Unknown',
        'grade': grades.isNotEmpty
            ? '${grades.first['grade'] ?? 'N/A'}'
            : 'N/A',
      });
    }

    return result;
  }

  Future<int> getEnrolledStudentsCount(int subjectId) async {
    final database = await db;
    final res = await database.rawQuery(
      'SELECT COUNT(*) as cnt FROM registrations WHERE subject_id = ?',
      [subjectId],
    );
    if (res.isNotEmpty) {
      return (res.first['cnt'] as int?) ?? 0;
    }
    return 0;
  }

  Future<int> getCoCurriculumEnrolledCount(int cocurriculumId) async {
    final database = await db;
    final res = await database.rawQuery(
      'SELECT COUNT(*) as cnt FROM cocurriculum_registrations WHERE cocurriculum_id = ?',
      [cocurriculumId],
    );
    if (res.isNotEmpty) {
      return (res.first['cnt'] as int?) ?? 0;
    }
    return 0;
  }

  Future<int> updateStudentGrade(int registrationId, String grade) async {
    final database = await db;
    final existing = await database.query(
      'grades',
      where: 'registration_id = ?',
      whereArgs: [registrationId],
    );

    if (existing.isEmpty) {
      return database.insert('grades', {
        'registration_id': registrationId,
        'grade': grade,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } else {
      return database.update(
        'grades',
        {'grade': grade, 'updated_at': DateTime.now().toIso8601String()},
        where: 'registration_id = ?',
        whereArgs: [registrationId],
      );
    }
  }
}
