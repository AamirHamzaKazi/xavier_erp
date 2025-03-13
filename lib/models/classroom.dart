import 'teacher.dart';

class Classroom {
  final String id;
  final String department;
  final String year;
  final String division;
  final ClassTeacher classTeacher;
  final List<SubjectTeacher> subjectTeachers;
  final List<PracticalTeacher> practicalTeachers;
  final List<Student> students;
  final String? timeTableId;

  Classroom({
    required this.id,
    required this.department,
    required this.year,
    required this.division,
    required this.classTeacher,
    required this.subjectTeachers,
    required this.practicalTeachers,
    this.students = const [],
    this.timeTableId,
  });

  String get className => '$department Year $year Division $division';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'department': department,
      'year': year,
      'division': division,
      'classTeacher': classTeacher.toJson(),
      'subjectTeachers': subjectTeachers.map((t) => t.toJson()).toList(),
      'practicalTeachers': practicalTeachers.map((t) => t.toJson()).toList(),
      'students': students.map((s) => s.toJson()).toList(),
      'timeTableId': timeTableId,
    };
  }

  factory Classroom.fromJson(Map<String, dynamic> json) {
    return Classroom(
      id: json['id'],
      department: json['department'],
      year: json['year'],
      division: json['division'],
      classTeacher: ClassTeacher.fromJson(json['classTeacher']),
      subjectTeachers: (json['subjectTeachers'] as List)
          .map((t) => SubjectTeacher.fromJson(t))
          .toList(),
      practicalTeachers: (json['practicalTeachers'] as List)
          .map((t) => PracticalTeacher.fromJson(t))
          .toList(),
      students: (json['students'] as List?)
          ?.map((s) => Student.fromJson(s))
          .toList() ?? [],
      timeTableId: json['timeTableId'],
    );
  }
}

class ClassTeacher {
  final String teacherId;
  final String teacherName;
  final String subject;

  ClassTeacher({
    required this.teacherId,
    required this.teacherName,
    required this.subject,
  });

  Map<String, dynamic> toJson() {
    return {
      'teacherId': teacherId,
      'teacherName': teacherName,
      'subject': subject,
    };
  }

  factory ClassTeacher.fromJson(Map<String, dynamic> json) {
    return ClassTeacher(
      teacherId: json['teacherId'],
      teacherName: json['teacherName'],
      subject: json['subject'],
    );
  }
}

class SubjectTeacher {
  final String teacherId;
  final String teacherName;
  final String subject;

  SubjectTeacher({
    required this.teacherId,
    required this.teacherName,
    required this.subject,
  });

  Map<String, dynamic> toJson() {
    return {
      'teacherId': teacherId,
      'teacherName': teacherName,
      'subject': subject,
    };
  }

  factory SubjectTeacher.fromJson(Map<String, dynamic> json) {
    return SubjectTeacher(
      teacherId: json['teacherId'],
      teacherName: json['teacherName'],
      subject: json['subject'],
    );
  }
}

class PracticalTeacher {
  final String teacherId;
  final String teacherName;
  final String subject;

  PracticalTeacher({
    required this.teacherId,
    required this.teacherName,
    required this.subject,
  });

  Map<String, dynamic> toJson() {
    return {
      'teacherId': teacherId,
      'teacherName': teacherName,
      'subject': subject,
    };
  }

  factory PracticalTeacher.fromJson(Map<String, dynamic> json) {
    return PracticalTeacher(
      teacherId: json['teacherId'],
      teacherName: json['teacherName'],
      subject: json['subject'],
    );
  }
}

class Student {
  final String id;
  final String name;
  final String collegeId;
  final String phone;
  final String rollNumber;

  Student({
    required this.id,
    required this.name,
    required this.collegeId,
    required this.phone,
    required this.rollNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'collegeId': collegeId,
      'phone': phone,
      'rollNumber': rollNumber,
    };
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      collegeId: json['collegeId'],
      phone: json['phone'],
      rollNumber: json['rollNumber'],
    );
  }
}
