class TimeTable {
  final String id;
  final String classroomId;
  final List<TimeTableDay> days;
  final List<TimeSlot> timeSlots;
  final List<List<TimeTableCell>> cells; // 2D array of cells [day][timeSlot]

  TimeTable({
    required this.id,
    required this.classroomId,
    required this.days,
    required this.timeSlots,
    required this.cells,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'classroomId': classroomId,
      'days': days.map((day) => day.toJson()).toList(),
      'timeSlots': timeSlots.map((slot) => slot.toJson()).toList(),
      'cells': cells.map(
        (row) => row.map((cell) => cell.toJson()).toList()
      ).toList(),
    };
  }

  factory TimeTable.fromJson(Map<String, dynamic> json) {
    return TimeTable(
      id: json['id'],
      classroomId: json['classroomId'],
      days: (json['days'] as List).map((d) => TimeTableDay.fromJson(d)).toList(),
      timeSlots: (json['timeSlots'] as List).map((t) => TimeSlot.fromJson(t)).toList(),
      cells: (json['cells'] as List).map(
        (row) => (row as List).map((cell) => TimeTableCell.fromJson(cell)).toList()
      ).toList(),
    );
  }
}

class TimeTableDay {
  final int dayIndex; // 0 = Monday, 1 = Tuesday, etc.
  final String dayName;

  TimeTableDay({
    required this.dayIndex,
    required this.dayName,
  });

  Map<String, dynamic> toJson() {
    return {
      'dayIndex': dayIndex,
      'dayName': dayName,
    };
  }

  factory TimeTableDay.fromJson(Map<String, dynamic> json) {
    return TimeTableDay(
      dayIndex: json['dayIndex'],
      dayName: json['dayName'],
    );
  }

  static List<TimeTableDay> defaultDays = [
    TimeTableDay(dayIndex: 0, dayName: 'Monday'),
    TimeTableDay(dayIndex: 1, dayName: 'Tuesday'),
    TimeTableDay(dayIndex: 2, dayName: 'Wednesday'),
    TimeTableDay(dayIndex: 3, dayName: 'Thursday'),
    TimeTableDay(dayIndex: 4, dayName: 'Friday'),
    TimeTableDay(dayIndex: 5, dayName: 'Saturday'),
  ];
}

class TimeSlot {
  final String startTime;
  final String endTime;

  TimeSlot({
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }
}

class TimeTableCell {
  final String subject;
  final String teacherName;
  final bool isPractical;

  TimeTableCell({
    required this.subject,
    required this.teacherName,
    this.isPractical = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'teacherName': teacherName,
      'isPractical': isPractical,
    };
  }

  factory TimeTableCell.fromJson(Map<String, dynamic> json) {
    return TimeTableCell(
      subject: json['subject'],
      teacherName: json['teacherName'],
      isPractical: json['isPractical'] ?? false,
    );
  }
}
