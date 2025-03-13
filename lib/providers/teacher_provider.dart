import 'package:flutter/foundation.dart';
import '../models/teacher.dart';

class TeacherProvider with ChangeNotifier {
  List<Teacher> _teachers = [];
  String _searchQuery = '';
  String _filterDepartment = '';
  String _filterGender = '';
  
  List<Teacher> get teachers {
    if (_searchQuery.isEmpty && _filterDepartment.isEmpty && _filterGender.isEmpty) {
      return [..._teachers];
    }

    return _teachers.where((teacher) {
      final matchesSearch = _searchQuery.isEmpty ||
          teacher.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          teacher.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          teacher.phone.contains(_searchQuery);

      final matchesDepartment = _filterDepartment.isEmpty ||
          teacher.department == _filterDepartment;

      final matchesGender = _filterGender.isEmpty ||
          teacher.gender == _filterGender;

      return matchesSearch && matchesDepartment && matchesGender;
    }).toList();
  }

  List<String> get departments {
    return _teachers
        .map((teacher) => teacher.department)
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

  void setFilterGender(String gender) {
    _filterGender = gender;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _filterDepartment = '';
    _filterGender = '';
    notifyListeners();
  }

  Teacher? getTeacherById(String id) {
    try {
      return _teachers.firstWhere((teacher) => teacher.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> addTeacher(Teacher teacher) async {
    // TODO: Implement API call to add teacher
    _teachers.add(teacher);
    notifyListeners();
  }

  Future<void> updateTeacher(Teacher updatedTeacher) async {
    // TODO: Implement API call to update teacher
    final teacherIndex = _teachers.indexWhere((t) => t.id == updatedTeacher.id);
    if (teacherIndex >= 0) {
      _teachers[teacherIndex] = updatedTeacher;
      notifyListeners();
    }
  }

  Future<void> deleteTeacher(String teacherId) async {
    // TODO: Implement API call to delete teacher
    _teachers.removeWhere((teacher) => teacher.id == teacherId);
    notifyListeners();
  }

  Future<void> fetchTeachers() async {
    // TODO: Implement API call to fetch teachers
    // For now, using dummy data
    _teachers = [
      Teacher(
        id: '1',
        name: 'John Doe',
        gender: 'Male',
        qualification: 'Ph.D. in Computer Science',
        teachingExperience: '5 years',
        phone: '1234567890',
        email: 'john.doe@example.com',
        department: 'Computer Science',
        designation: 'Assistant Professor',
        username: 'johndoe',
        password: 'password123',
        classTeacherInfo: ClassTeacherInfo(
          classroomId: 'CS101',
          className: 'Computer Science Year 1 Division A',
          subject: 'Programming Fundamentals',
        ),
        subjectTeachingInfo: [
          SubjectTeachingInfo(
            classroomId: 'CS102',
            className: 'Computer Science Year 1 Division B',
            subject: 'Programming Fundamentals',
          ),
          SubjectTeachingInfo(
            classroomId: 'CS201',
            className: 'Computer Science Year 2 Division A',
            subject: 'Data Structures',
            isPractical: true,
          ),
        ],
      ),
      Teacher(
        id: '2',
        name: 'Jane Smith',
        gender: 'Female',
        qualification: 'Ph.D. in Mathematics',
        teachingExperience: '8 years',
        phone: '9876543210',
        email: 'jane.smith@example.com',
        department: 'Mathematics',
        designation: 'Associate Professor',
        username: 'janesmith',
        password: 'password456',
        subjectTeachingInfo: [
          SubjectTeachingInfo(
            classroomId: 'MT101',
            className: 'Mathematics Year 1 Division A',
            subject: 'Calculus',
          ),
          SubjectTeachingInfo(
            classroomId: 'MT201',
            className: 'Mathematics Year 2 Division A',
            subject: 'Linear Algebra',
          ),
        ],
      ),
    ];
    notifyListeners();
  }
} 