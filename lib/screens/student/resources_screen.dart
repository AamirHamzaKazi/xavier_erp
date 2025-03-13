import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../constants.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> _subjects = [
    {
      'name': 'Data Structures',
      'color': kStudentPrimaryColor,
      'icon': Icons.code,
      'theory': [
        {'name': 'Unit 1 Notes', 'type': 'pdf'},
        {'name': 'Unit 2 Notes', 'type': 'pdf'},
        {'name': 'Assignment 1', 'type': 'doc'},
      ],
      'practical': [
        {'name': 'Lab Manual', 'type': 'pdf'},
        {'name': 'Practical 1', 'type': 'doc'},
        {'name': 'Practical 2', 'type': 'doc'},
      ],
    },
    {
      'name': 'Database Management',
      'color': kStudentPrimaryColor,
      'icon': Icons.storage,
      'theory': [
        {'name': 'Unit 1 Notes', 'type': 'pdf'},
        {'name': 'Unit 2 Notes', 'type': 'pdf'},
        {'name': 'Assignment 1', 'type': 'doc'},
      ],
      'practical': [
        {'name': 'Lab Manual', 'type': 'pdf'},
        {'name': 'Practical 1', 'type': 'doc'},
        {'name': 'Practical 2', 'type': 'doc'},
      ],
    },
  ];

  int _selectedSubjectIndex = 0;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedSubject = _subjects[_selectedSubjectIndex];
    final theme = Theme.of(context);
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _subjects.length,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemBuilder: (context, index) {
                final subject = _subjects[index];
                final isSelected = index == _selectedSubjectIndex;
                
                return GestureDetector(
                  onTap: () {
                    if (_selectedSubjectIndex != index) {
                      setState(() {
                        _selectedSubjectIndex = index;
                      });
                      _controller.reset();
                      _controller.forward();
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: MediaQuery.of(context).size.width * 0.45,
                    margin: const EdgeInsets.only(right: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? kStudentPrimaryColor : const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: (isSelected ? kStudentPrimaryColor : Colors.black).withOpacity(0.3),
                          blurRadius: isSelected ? 8 : 0,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.black.withOpacity(0.1) : Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            subject['icon'] as IconData,
                            color: isSelected ? Colors.black : Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Tooltip(
                            message: subject['name'] as String,
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              subject['name'] as String,
                              style: TextStyle(
                                color: isSelected ? Colors.black : Colors.white,
                                fontSize: MediaQuery.of(context).size.width * 0.04,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.05, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: Padding(
              key: ValueKey<int>(_selectedSubjectIndex),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Theory',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...(selectedSubject['theory'] as List).map((resource) => _buildResourceItem(
                    resource['name'] as String,
                    resource['type'] as String,
                    kStudentPrimaryColor,
                  )),
                  const SizedBox(height: 24),
                  Text(
                    'Practical',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...(selectedSubject['practical'] as List).map((resource) => _buildResourceItem(
                    resource['name'] as String,
                    resource['type'] as String,
                    kStudentPrimaryColor,
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceItem(String name, String type, Color color) {
    final theme = Theme.of(context);
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 400;

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: size.height * 0.01,
        horizontal: size.width * 0.02,
      ),
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              type == 'pdf' ? Icons.picture_as_pdf : Icons.description,
              color: isDark ? color : Colors.black,
              size: isSmallScreen ? 20 : 24,
            ),
          ),
          SizedBox(width: size.width * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  type.toUpperCase(),
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black54,
                    fontSize: isSmallScreen ? 10 : 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.download,
              color: isDark ? color : Colors.black,
              size: isSmallScreen ? 20 : 24,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Downloading $name',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: isSmallScreen ? 12 : 14,
                    ),
                  ),
                  backgroundColor: color,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
