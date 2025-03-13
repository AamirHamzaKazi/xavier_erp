import 'package:flutter/foundation.dart';
import '../models/classroom.dart';

class ClassroomProvider with ChangeNotifier {
  List<Classroom> _classrooms = [];
  String _searchQuery = '';
  String _filterDepartment = '';
  String _filterYear = '';
  
  // Classroom limit from subscription
  final int maxClassrooms = 10;
  int get totalClassrooms => _classrooms.length;
  int get availableSlots => maxClassrooms - _classrooms.length;
  bool get canAddClassroom => _classrooms.length < maxClassrooms;

  List<Classroom> get classrooms {
    if (_searchQuery.isEmpty && _filterDepartment.isEmpty && _filterYear.isEmpty) {
      return [..._classrooms];
    }

    return _classrooms.where((classroom) {
      final matchesSearch = _searchQuery.isEmpty ||
          classroom.className.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesDepartment = _filterDepartment.isEmpty ||
          classroom.department == _filterDepartment;

      final matchesYear = _filterYear.isEmpty ||
          classroom.year == _filterYear;

      return matchesSearch && matchesDepartment && matchesYear;
    }).toList();
  }

  List<String> get departments {
    return _classrooms
        .map((classroom) => classroom.department)
        .toSet()
        .toList()
      ..sort();
  }

  List<String> get years {
    return _classrooms
        .map((classroom) => classroom.year)
        .toSet()
        .toList()
      ..sort();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilterDepartment(String department) {
    _filterDepartment = department;
    notifyListeners();
  }

  void setFilterYear(String year) {
    _filterYear = year;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _filterDepartment = '';
    _filterYear = '';
    notifyListeners();
  }

  Classroom? getClassroomById(String id) {
    try {
      return _classrooms.firstWhere((classroom) => classroom.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> addClassroom(Classroom classroom) async {
    if (!canAddClassroom) {
      throw Exception('Maximum classroom limit reached');
    }
    // TODO: Implement API call to add classroom
    _classrooms.add(classroom);
    notifyListeners();
  }

  Future<void> updateClassroom(Classroom updatedClassroom) async {
    // TODO: Implement API call to update classroom
    final classroomIndex = _classrooms.indexWhere((c) => c.id == updatedClassroom.id);
    if (classroomIndex >= 0) {
      _classrooms[classroomIndex] = updatedClassroom;
      notifyListeners();
    }
  }

  Future<void> deleteClassroom(String classroomId) async {
    // TODO: Implement API call to delete classroom
    _classrooms.removeWhere((classroom) => classroom.id == classroomId);
    notifyListeners();
  }

  Future<void> fetchClassrooms() async {
    // TODO: Implement API call to fetch classrooms
    // For now, using dummy data
    _classrooms = [
      Classroom(
        id: '1',
        department: 'Computer Science',
        year: '1',
        division: 'A',
        classTeacher: ClassTeacher(
          teacherId: '1',
          teacherName: 'John Doe',
          subject: 'Programming Fundamentals',
        ),
        subjectTeachers: [
          SubjectTeacher(
            teacherId: '2',
            teacherName: 'Jane Smith',
            subject: 'Mathematics',
          ),
          SubjectTeacher(
            teacherId: '3',
            teacherName: 'Bob Wilson',
            subject: 'Digital Logic',
          ),
        ],
        practicalTeachers: [
          PracticalTeacher(
            teacherId: '1',
            teacherName: 'John Doe',
            subject: 'Programming Lab',
          ),
        ],
        students: [
          Student(
            id: '1',
            name: 'Alice Johnson',
            collegeId: 'CS101',
            phone: '1234567890',
            rollNumber: "1",
          ),
          Student(
            id: '2',
            name: 'Bob Brown',
            collegeId: 'CS102',
            phone: '9876543210',
            rollNumber: "2",
          ),
        ],
      ),
    ];
    notifyListeners();
  }
} 