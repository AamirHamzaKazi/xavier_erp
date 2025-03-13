import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../constants.dart';

class MyClassesScreen extends StatefulWidget {
  const MyClassesScreen({super.key});

  @override
  State<MyClassesScreen> createState() => _MyClassesScreenState();
}

class _MyClassesScreenState extends State<MyClassesScreen> {
  final List<Map<String, dynamic>> classes = [
    {
      'name': 'SE COMPS',
      'subject': 'Operating Systems',
      'students': 60,
      'attendance': 0.85,
      'resources': 12,
      'assignments': 5,
    },
    {
      'name': 'TE COMPS',
      'subject': 'OOP',
      'students': 55,
      'attendance': 0.92,
      'resources': 8,
      'assignments': 3,
    },
    {
      'name': 'FE IT',
      'subject': 'Python',
      'students': 65,
      'attendance': 0.78,
      'resources': 15,
      'assignments': 4,
    },
  ];

  // Dummy data for students
  final List<Map<String, dynamic>> students = [
    {'name': 'John Doe', 'roll': '101', 'attendance': 0.92},
    {'name': 'Jane Smith', 'roll': '102', 'attendance': 0.88},
    {'name': 'Mike Johnson', 'roll': '103', 'attendance': 0.95},
  ];

  // Dummy data for resources
  final List<Map<String, dynamic>> resources = [
    {'name': 'Chapter 1 Notes', 'type': 'PDF', 'size': '2.3 MB'},
    {'name': 'Practice Problems', 'type': 'DOC', 'size': '1.1 MB'},
    {'name': 'Tutorial Video', 'type': 'MP4', 'size': '45.6 MB'},
  ];

  // Dummy data for assignments
  final List<Map<String, dynamic>> assignments = [
    {
      'title': 'Assignment 1',
      'due_date': '2024-03-15',
      'submitted': 45,
      'total': 60,
      'status': 'Active'
    },
    {
      'title': 'Assignment 2',
      'due_date': '2024-03-10',
      'submitted': 58,
      'total': 60,
      'status': 'Completed'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kTeacherBackgroundColor,
      appBar: AppBar(
        backgroundColor: kTeacherPrimaryColor,
        title: const Text(
          'My Classes',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: classes.length,
        itemBuilder: (context, index) {
          final classInfo = classes[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: kTeacherPrimaryColor,
                width: 1,
              ),
            ),
            color: const Color(0xFF2A2A2A),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              classInfo['name'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              classInfo['subject'],
                              style: TextStyle(
                                color: kTeacherPrimaryColor,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.download,
                          color: kTeacherPrimaryColor,
                        ),
                        onPressed: () => _showAttendanceReport(context, classInfo),
                        tooltip: 'Download Attendance Report',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStat(
                        icon: Icons.people,
                        value: classInfo['students'].toString(),
                        label: 'Students',
                        onTap: () => _showStudentList(context, classInfo),
                      ),
                      _buildStat(
                        icon: Icons.timer,
                        value: '${(classInfo['attendance'] * 100).round()}%',
                        label: 'Attendance',
                        onTap: () => _showAttendanceCalendar(context, classInfo),
                      ),
                      _buildStat(
                        icon: Icons.folder,
                        value: classInfo['resources'].toString(),
                        label: 'Resources',
                        onTap: () => _showResources(context, classInfo),
                      ),
                      _buildStat(
                        icon: Icons.assignment,
                        value: classInfo['assignments'].toString(),
                        label: 'Tasks',
                        onTap: () => _showAssignments(context, classInfo),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showUploadResourceDialog(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: kTeacherPrimaryColor,
                            side: BorderSide(color: kTeacherPrimaryColor),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.upload_file, size: 20),
                          label: const Text(
                            'Upload Resources',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _showNewAssignmentDialog(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kTeacherPrimaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.assignment_add, size: 20),
                          label: const Text(
                            'New Assignment',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStat({
    required IconData icon,
    required String value,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(
              icon,
              color: kTeacherPrimaryColor,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStudentList(BuildContext context, Map<String, dynamic> classInfo) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2A2A2A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${classInfo['name']} - Students',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: kTeacherPrimaryColor.withOpacity(0.2),
                      child: Text(
                        student['name'].substring(0, 1),
                        style: TextStyle(color: kTeacherPrimaryColor),
                      ),
                    ),
                    title: Text(
                      student['name'],
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Roll No: ${student['roll']}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: Text(
                      '${(student['attendance'] * 100).round()}%',
                      style: TextStyle(
                        color: kTeacherPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAttendanceCalendar(BuildContext context, Map<String, dynamic> classInfo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: Text(
          'Attendance Report',
          style: TextStyle(color: Colors.white),
        ),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // TODO: Implement calendar widget
              Text(
                'Calendar implementation pending',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(color: kTeacherPrimaryColor),
            ),
          ),
        ],
      ),
    );
  }

  void _showResources(BuildContext context, Map<String, dynamic> classInfo) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2A2A2A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${classInfo['name']} - Resources',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: resources.length,
                itemBuilder: (context, index) {
                  final resource = resources[index];
                  return ListTile(
                    leading: Icon(
                      resource['type'] == 'PDF' ? Icons.picture_as_pdf :
                      resource['type'] == 'DOC' ? Icons.description :
                      Icons.video_library,
                      color: kTeacherPrimaryColor,
                    ),
                    title: Text(
                      resource['name'],
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      '${resource['type']} • ${resource['size']}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.download, color: kTeacherPrimaryColor),
                      onPressed: () {
                        // TODO: Implement download functionality
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAssignments(BuildContext context, Map<String, dynamic> classInfo) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2A2A2A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${classInfo['name']} - Assignments',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: assignments.length,
                itemBuilder: (context, index) {
                  final assignment = assignments[index];
                  return Card(
                    color: const Color(0xFF1A1A1A),
                    child: ListTile(
                      title: Text(
                        assignment['title'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Due: ${assignment['due_date']}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          Text(
                            'Submitted: ${assignment['submitted']}/${assignment['total']}',
                            style: TextStyle(color: kTeacherPrimaryColor),
                          ),
                        ],
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: assignment['status'] == 'Active'
                              ? kTeacherPrimaryColor.withOpacity(0.2)
                              : Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          assignment['status'],
                          style: TextStyle(
                            color: assignment['status'] == 'Active'
                                ? kTeacherPrimaryColor
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showUploadResourceDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text(
          'Upload Resource',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles();
                if (result != null) {
                  // TODO: Handle file upload
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Uploading ${result.files.single.name}'),
                      backgroundColor: kTeacherPrimaryColor,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kTeacherPrimaryColor,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.upload_file),
              label: const Text('Choose File'),
            ),
            const SizedBox(height: 16),
            DragTarget<String>(
              builder: (context, candidateData, rejectedData) {
                return Container(
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: kTeacherPrimaryColor.withOpacity(0.5),
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Drag and drop files here',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              },
              onAccept: (data) {
                // TODO: Handle dropped file
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: kTeacherPrimaryColor),
            ),
          ),
        ],
      ),
    );
  }

  void _showNewAssignmentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text(
          'New Assignment',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: const TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kTeacherPrimaryColor.withOpacity(0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kTeacherPrimaryColor),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Due Date',
                labelStyle: const TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kTeacherPrimaryColor.withOpacity(0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kTeacherPrimaryColor),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: kTeacherPrimaryColor),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement assignment creation
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Assignment created successfully'),
                  backgroundColor: kTeacherPrimaryColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kTeacherPrimaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showAttendanceReport(BuildContext context, Map<String, dynamic> classInfo) {
    // TODO: Implement attendance report generation and download
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Downloading attendance report...'),
        backgroundColor: kTeacherPrimaryColor,
      ),
    );
  }
}
