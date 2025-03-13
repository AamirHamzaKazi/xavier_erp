import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/classroom.dart';
import '../../models/timetable.dart';
import '../../providers/classroom_provider.dart';
import '../../providers/timetable_provider.dart';
import '../../constants.dart';

class ManageTimeTablesScreen extends StatefulWidget {
  static const routeName = '/manage-timetables';

  const ManageTimeTablesScreen({Key? key}) : super(key: key);

  @override
  State<ManageTimeTablesScreen> createState() => _ManageTimeTablesScreenState();
}

class _ManageTimeTablesScreenState extends State<ManageTimeTablesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final classroomProvider = Provider.of<ClassroomProvider>(context, listen: false);
      classroomProvider.fetchClassrooms();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAdminPrimaryColor,
        title: const Text(
          'Manage Timetables',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<ClassroomProvider>(
        builder: (context, classroomProvider, child) {
          final classrooms = classroomProvider.classrooms;
          
          return ListView.builder(
            itemCount: classrooms.length,
            itemBuilder: (context, index) {
              final classroom = classrooms[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ExpansionTile(
                  title: Text(classroom.className),
                  subtitle: Text('Class Teacher: ${classroom.classTeacher.teacherName}'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Subject Teachers:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          ...classroom.subjectTeachers.map((teacher) => 
                            ListTile(
                              title: Text(teacher.teacherName),
                              subtitle: Text('Subject: ${teacher.subject}'),
                              dense: true,
                            ),
                          ),
                          if (classroom.practicalTeachers.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            const Text(
                              'Practical Teachers:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            ...classroom.practicalTeachers.map((teacher) => 
                              ListTile(
                                title: Text(teacher.teacherName),
                                subtitle: Text('Subject: ${teacher.subject}'),
                                dense: true,
                              ),
                            ),
                          ],
                          const SizedBox(height: 16),
                          _buildTimeTableSection(classroom),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTimeTableSection(Classroom classroom) {
    return Consumer<TimeTableProvider>(
      builder: (context, timeTableProvider, child) {
        final timeTable = timeTableProvider.getTimeTableForClassroom(classroom.id);

        if (timeTable == null) {
          return Center(
            child: Column(
              children: [
                const Text('No timetable exists for this classroom'),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () => _showCreateTimeTableDialog(context, classroom),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAdminPrimaryColor,
                    foregroundColor: Colors.black,
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Create Timetable'),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Timetable',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditTimeTableDialog(context, classroom, timeTable),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  const DataColumn(label: Text('Time')),
                  ...timeTable.days.map((day) => 
                    DataColumn(label: Text(day.dayName)),
                  ),
                ],
                rows: List.generate(
                  timeTable.timeSlots.length,
                  (slotIndex) {
                    final timeSlot = timeTable.timeSlots[slotIndex];
                    return DataRow(
                      cells: [
                        DataCell(Text('${timeSlot.startTime}\n${timeSlot.endTime}')),
                        ...List.generate(
                          timeTable.days.length,
                          (dayIndex) {
                            final cell = timeTable.cells[dayIndex][slotIndex];
                            return DataCell(
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    cell.subject,
                                    style: TextStyle(
                                      fontWeight: cell.isPractical ? FontWeight.bold : null,
                                    ),
                                  ),
                                  Text(
                                    cell.teacherName,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              onTap: () => _showEditCellDialog(
                                context,
                                classroom,
                                timeTable,
                                dayIndex,
                                slotIndex,
                                cell,
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showCreateTimeTableDialog(BuildContext context, Classroom classroom) async {
    int rows = 6;
    int columns = 6;

    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Create Timetable'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select the number of periods and days:'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Number of Periods',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => rows = int.tryParse(value) ?? 6,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Number of Days',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => columns = int.tryParse(value) ?? 6,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _createTimeTable(classroom, rows, columns);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _createTimeTable(Classroom classroom, int periods, int days) {
    final timeSlots = List.generate(
      periods,
      (i) => TimeSlot(
        startTime: '${9 + (i ~/ 2)}:${i % 2 == 0 ? "00" : "30"}',
        endTime: '${9 + ((i + 1) ~/ 2)}:${(i + 1) % 2 == 0 ? "00" : "30"}',
      ),
    );

    final selectedDays = TimeTableDay.defaultDays.take(days).toList();

    Provider.of<TimeTableProvider>(context, listen: false).createTimeTable(
      classroomId: classroom.id,
      days: selectedDays,
      timeSlots: timeSlots,
    );
  }

  Future<void> _showEditTimeTableDialog(
    BuildContext context,
    Classroom classroom,
    TimeTable timeTable,
  ) async {
    // TODO: Implement edit timetable dialog
    // This will allow editing the structure of the timetable
    // (adding/removing periods, changing times, etc.)
  }

  Future<void> _showEditCellDialog(
    BuildContext context,
    Classroom classroom,
    TimeTable timeTable,
    int dayIndex,
    int slotIndex,
    TimeTableCell currentCell,
  ) async {
    String subject = currentCell.subject;
    String teacherName = currentCell.teacherName;
    bool isPractical = currentCell.isPractical;

    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Edit ${timeTable.days[dayIndex].dayName} - ${timeTable.timeSlots[slotIndex].startTime}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: subject.isEmpty ? null : subject,
              decoration: const InputDecoration(labelText: 'Subject'),
              items: [
                ...classroom.subjectTeachers.map((teacher) =>
                  DropdownMenuItem(
                    value: teacher.subject,
                    child: Text(teacher.subject),
                  ),
                ),
                ...classroom.practicalTeachers.map((teacher) =>
                  DropdownMenuItem(
                    value: teacher.subject,
                    child: Text('${teacher.subject} (Practical)'),
                  ),
                ),
              ],
              onChanged: (value) {
                subject = value ?? '';
                // Find matching teacher and determine if it's practical
                final isPracticalSubject = classroom.practicalTeachers
                    .any((t) => t.subject == value);
                
                if (isPracticalSubject) {
                  final practicalTeacher = classroom.practicalTeachers
                      .firstWhere((t) => t.subject == value);
                  teacherName = practicalTeacher.teacherName;
                  isPractical = true;
                } else {
                  final regularTeacher = classroom.subjectTeachers
                      .firstWhere((t) => t.subject == value,
                          orElse: () => SubjectTeacher(
                              teacherId: '',
                              teacherName: '',
                              subject: ''));
                  teacherName = regularTeacher.teacherName;
                  isPractical = false;
                }
              },
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('Is Practical'),
              value: isPractical,
              onChanged: (value) {
                isPractical = value ?? false;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Provider.of<TimeTableProvider>(context, listen: false)
                  .updateTimeTableCell(
                classroomId: classroom.id,
                dayIndex: dayIndex,
                timeSlotIndex: slotIndex,
                cell: TimeTableCell(
                  subject: subject,
                  teacherName: teacherName,
                  isPractical: isPractical,
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
} 