class Teacher {
  final String id;
  final String name;
  final String gender;
  final String qualification;
  final String teachingExperience;
  final String phone;
  final String email;
  final String department;
  final String designation;
  final String username;
  final String password;
  final ClassTeacherInfo? classTeacherInfo;
  final List<SubjectTeachingInfo> subjectTeachingInfo;

  Teacher({
    required this.id,
    required this.name,
    required this.gender,
    required this.qualification,
    required this.teachingExperience,
    required this.phone,
    required this.email,
    required this.department,
    required this.designation,
    required this.username,
    required this.password,
    this.classTeacherInfo,
    this.subjectTeachingInfo = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'qualification': qualification,
      'teachingExperience': teachingExperience,
      'phone': phone,
      'email': email,
      'department': department,
      'designation': designation,
      'username': username,
      'password': password,
      'classTeacherInfo': classTeacherInfo?.toJson(),
      'subjectTeachingInfo': subjectTeachingInfo.map((info) => info.toJson()).toList(),
    };
  }

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      name: json['name'],
      gender: json['gender'],
      qualification: json['qualification'],
      teachingExperience: json['teachingExperience'],
      phone: json['phone'],
      email: json['email'],
      department: json['department'],
      designation: json['designation'],
      username: json['username'],
      password: json['password'],
      classTeacherInfo: json['classTeacherInfo'] != null
          ? ClassTeacherInfo.fromJson(json['classTeacherInfo'])
          : null,
      subjectTeachingInfo: (json['subjectTeachingInfo'] as List?)
          ?.map((info) => SubjectTeachingInfo.fromJson(info))
          .toList() ?? [],
    );
  }
}

class ClassTeacherInfo {
  final String classroomId;
  final String className;
  final String subject;

  ClassTeacherInfo({
    required this.classroomId,
    required this.className,
    required this.subject,
  });

  Map<String, dynamic> toJson() {
    return {
      'classroomId': classroomId,
      'className': className,
      'subject': subject,
    };
  }

  factory ClassTeacherInfo.fromJson(Map<String, dynamic> json) {
    return ClassTeacherInfo(
      classroomId: json['classroomId'],
      className: json['className'],
      subject: json['subject'],
    );
  }
}

class SubjectTeachingInfo {
  final String classroomId;
  final String className;
  final String subject;
  final bool isPractical;

  SubjectTeachingInfo({
    required this.classroomId,
    required this.className,
    required this.subject,
    this.isPractical = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'classroomId': classroomId,
      'className': className,
      'subject': subject,
      'isPractical': isPractical,
    };
  }

  factory SubjectTeachingInfo.fromJson(Map<String, dynamic> json) {
    return SubjectTeachingInfo(
      classroomId: json['classroomId'],
      className: json['className'],
      subject: json['subject'],
      isPractical: json['isPractical'] ?? false,
    );
  }
}
