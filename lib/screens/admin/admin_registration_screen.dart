import 'package:flutter/material.dart';
import 'admin_registration_payment_screen.dart';
import '../role_selection_screen.dart';
import '../../constants.dart';

class CollegeInfo {
  final String name;
  final String location;

  CollegeInfo({required this.name, required this.location});
}

class ClassroomType {
  final String name;
  final int teachers;
  final int students;
  final double price;
  int quantity;

  ClassroomType({
    required this.name,
    required this.teachers,
    required this.students,
    required this.price,
    this.quantity = 0,
  });
}

class AdminRegistrationScreen extends StatefulWidget {
  const AdminRegistrationScreen({super.key});

  @override
  State<AdminRegistrationScreen> createState() => _AdminRegistrationScreenState();
}

class _AdminRegistrationScreenState extends State<AdminRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCollege;
  final _otherCollegeController = TextEditingController();
  final _locationController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _securityCodeController = TextEditingController();
  bool _obscurePassword = true;

  // Predefined college list
  final List<CollegeInfo> _colleges = [
    CollegeInfo(
      name: 'MH Saboo Siddik College of Engineering',
      location: 'Mumbai, Maharashtra',
    ),
    CollegeInfo(
      name: 'Vidyalankar Institute of Engineering',
      location: 'Mumbai, Maharashtra',
    ),
    CollegeInfo(
      name: 'Xavier Institute of Engineering',
      location: 'Mumbai, Maharashtra',
    ),
    CollegeInfo(
      name: 'DJ Sanghvi',
      location: 'Mumbai, Maharashtra',
    ),
    CollegeInfo(
      name: 'Don Bosco Institute of Engineering',
      location: 'Mumbai, Maharashtra',
    ),
    CollegeInfo(
      name: 'VJTI',
      location: 'Mumbai, Maharashtra',
    ),
    CollegeInfo(
      name: 'SPIT',
      location: 'Mumbai, Maharashtra',
    ),
    CollegeInfo(
      name: 'KJ Somaiya College of Engineering',
      location: 'Mumbai, Maharashtra',
    ),
    CollegeInfo(
      name: 'Fr. Conceicao Rodrigues College of Engineering',
      location: 'Mumbai, Maharashtra',
    ),
    CollegeInfo(
      name: 'Thadomal Shahani Engineering College',
      location: 'Mumbai, Maharashtra',
    ),
  ];

  // Predefined classroom types
  final List<ClassroomType> _classroomTypes = [
    ClassroomType(
      name: 'Small Classroom',
      teachers: 2,
      students: 30,
      price: 499.0,
    ),
    ClassroomType(
      name: 'Medium Classroom',
      teachers: 3,
      students: 60,
      price: 799.0,
    ),
    ClassroomType(
      name: 'Large Classroom',
      teachers: 4,
      students: 120,
      price: 1299.0,
    ),
  ];

  int get totalTeachers {
    return _classroomTypes.fold(0, (sum, classroom) => 
      sum + (classroom.teachers * classroom.quantity));
  }

  int get totalStudents {
    return _classroomTypes.fold(0, (sum, classroom) => 
      sum + (classroom.students * classroom.quantity));
  }

  @override
  void dispose() {
    _otherCollegeController.dispose();
    _locationController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _securityCodeController.dispose();
    super.dispose();
  }

  void _updateLocation() {
    if (_selectedCollege != 'Others') {
      final college = _colleges.firstWhere(
        (c) => c.name == _selectedCollege,
        orElse: () => CollegeInfo(name: '', location: ''),
      );
      _locationController.text = college.location;
    } else {
      _locationController.text = '';
    }
  }

  void _fillTestData() {
    setState(() {
      _selectedCollege = 'Xavier Institute of Engineering';
      _updateLocation();
      
      // Set classroom quantities to match the image
      _classroomTypes[0].quantity = 4;  // 4 Small Classrooms (₹499 each)
      _classroomTypes[1].quantity = 3;  // 3 Medium Classrooms (₹799 each)
      _classroomTypes[2].quantity = 2;  // 2 Large Classrooms (₹1299 each)
      
      // Fill admin details
      _usernameController.text = 'testadmin';
      _passwordController.text = 'Test@123';
      _mobileController.text = '9876543210';
      _emailController.text = 'testadmin@xavier.edu';
      _securityCodeController.text = 'SEC123';
    });
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(0xFF2A2A2A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: kAdminPrimaryColor,
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundColor: kAdminPrimaryColor,
                  radius: 30,
                  child: const Icon(
                    Icons.check,
                    color: Colors.black,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Payment Successful',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Your college has been successfully registered.\nYou can now log in to your admin account.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RoleSelectionScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kAdminPrimaryColor,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Go to Login',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;

    return Scaffold(
      backgroundColor: kAdminBackgroundColor,
      appBar: AppBar(
        backgroundColor: kAdminPrimaryColor,
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'College Registration',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: isSmallScreen ? 18 : 20,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.data_array, color: Colors.black),
            tooltip: 'Fill Test Data',
            onPressed: _fillTestData,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // College Selection
              DropdownButtonFormField<String>(
                value: _selectedCollege,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: 'Select College',
                  labelStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: kAdminPrimaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: kAdminPrimaryColor, width: 2),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF2A2A2A),
                  prefixIcon: Icon(Icons.school, color: kAdminPrimaryColor),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                dropdownColor: const Color(0xFF2A2A2A),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                icon: Icon(Icons.arrow_drop_down, color: kAdminPrimaryColor),
                items: [
                  ..._colleges.map((college) => DropdownMenuItem(
                        value: college.name,
                        child: Text(
                          college.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      )),
                  const DropdownMenuItem(
                    value: 'Others',
                    child: Text('Others'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedCollege = value;
                    _updateLocation();
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a college';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Other College Name
              if (_selectedCollege == 'Others')
                TextFormField(
                  controller: _otherCollegeController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'College Name',
                    labelStyle: const TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: kAdminPrimaryColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: kAdminPrimaryColor, width: 2),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF2A2A2A),
                    prefixIcon: Icon(Icons.business, color: kAdminPrimaryColor),
                  ),
                  validator: (value) {
                    if (_selectedCollege == 'Others' &&
                        (value == null || value.isEmpty)) {
                      return 'Please enter college name';
                    }
                    return null;
                  },
                ),
              if (_selectedCollege == 'Others') const SizedBox(height: 16),

              // Location
              TextFormField(
                controller: _locationController,
                style: const TextStyle(color: Colors.white),
                enabled: _selectedCollege == 'Others',
                decoration: InputDecoration(
                  labelText: 'College Location',
                  labelStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: kAdminPrimaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: kAdminPrimaryColor, width: 2),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF2A2A2A),
                  prefixIcon: Icon(Icons.location_on, color: kAdminPrimaryColor),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter college location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              const SizedBox(height: 24),
              const Text(
                'Classroom Requirements',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Select the number of classrooms needed for each type:',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),

              // Classroom Selection with Quantity
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _classroomTypes.length,
                itemBuilder: (context, index) {
                  final classroom = _classroomTypes[index];
                  return Card(
                    color: const Color(0xFF2A2A2A),
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            classroom.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${classroom.teachers} Teachers per class',
                                      style: const TextStyle(color: Colors.white70),
                                    ),
                                    Text(
                                      '${classroom.students} Students per class',
                                      style: const TextStyle(color: Colors.white70),
                                    ),
                                    Text(
                                      '₹${classroom.price} per classroom',
                                      style: TextStyle(
                                        color: kAdminPrimaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2A2A2A),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove, color: Colors.white),
                                      onPressed: classroom.quantity > 0
                                          ? () => setState(() => classroom.quantity--)
                                          : null,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      child: Text(
                                        '${classroom.quantity}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add, color: Colors.white),
                                      onPressed: () => setState(() => classroom.quantity++),
                                    ),
                                  ],
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

              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kAdminPrimaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: kAdminPrimaryColor,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Total Capacity',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Teachers: $totalTeachers',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Students: $totalStudents',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Admin Details
              const Text(
                'Admin Details',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Username
              TextFormField(
                controller: _usernameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: kAdminPrimaryColor),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF2A2A2A),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Password
              TextFormField(
                controller: _passwordController,
                style: const TextStyle(color: Colors.white),
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: kAdminPrimaryColor),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF2A2A2A),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Mobile Number
              TextFormField(
                controller: _mobileController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  labelStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: kAdminPrimaryColor),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF2A2A2A),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter mobile number';
                  }
                  if (value.length != 10) {
                    return 'Please enter a valid 10-digit mobile number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: kAdminPrimaryColor),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF2A2A2A),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Security Code
              TextFormField(
                controller: _securityCodeController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Security Code',
                  labelStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: kAdminPrimaryColor),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF2A2A2A),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter security code';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Next Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        _classroomTypes.any((c) => c.quantity > 0)) {
                      final registrationData = {
                        'collegeName': _selectedCollege == 'Others'
                            ? _otherCollegeController.text
                            : _selectedCollege,
                        'location': _locationController.text,
                        'classrooms': _classroomTypes
                            .where((c) => c.quantity > 0)
                            .map((c) => {
                                  'type': c.name,
                                  'teachers': c.teachers,
                                  'students': c.students,
                                  'price': c.price,
                                  'quantity': c.quantity,
                                })
                            .toList(),
                        'totalTeachers': totalTeachers,
                        'totalStudents': totalStudents,
                        'username': _usernameController.text,
                        'password': _passwordController.text,
                        'mobile': _mobileController.text,
                        'email': _emailController.text,
                        'securityCode': _securityCodeController.text,
                      };

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminRegistrationPaymentScreen(
                            registrationData: registrationData,
                            onPaymentSuccess: () => _showSuccessDialog(context),
                          ),
                        ),
                      );
                    } else if (!_classroomTypes.any((c) => c.quantity > 0)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select at least one classroom'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAdminPrimaryColor,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 