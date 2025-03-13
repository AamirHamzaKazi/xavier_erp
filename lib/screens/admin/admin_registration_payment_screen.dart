import 'package:flutter/material.dart';
import 'admin_home_screen.dart';
import '../role_selection_screen.dart';
import '../../constants.dart';

class AdminRegistrationPaymentScreen extends StatefulWidget {
  final Map<String, dynamic> registrationData;
  final VoidCallback onPaymentSuccess;

  const AdminRegistrationPaymentScreen({
    super.key,
    required this.registrationData,
    required this.onPaymentSuccess,
  });

  @override
  State<AdminRegistrationPaymentScreen> createState() =>
      _AdminRegistrationPaymentScreenState();
}

class _AdminRegistrationPaymentScreenState
    extends State<AdminRegistrationPaymentScreen> {
  bool _isProcessing = false;
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();

  // Fixed costs
  static const double _accountCreationFee = 3999.0;
  static const double _teacherAccountFee = 299.0;
  static const double _studentAccountFee = 149.0;

  double get _calculateOneTimeSetupCost {
    double cost = _accountCreationFee;

    // Add cost for teacher accounts
    final totalTeachers = widget.registrationData['totalTeachers'] as int;
    cost += totalTeachers * _teacherAccountFee;

    // Add cost for student accounts
    final totalStudents = widget.registrationData['totalStudents'] as int;
    cost += totalStudents * _studentAccountFee;

    // Add cost for classrooms
    final classrooms = widget.registrationData['classrooms'] as List;
    for (final classroom in classrooms) {
      cost += (classroom['price'] as double) * (classroom['quantity'] as int);
    }

    return cost;
  }

  double get _calculateMonthlyCost {
    double cost = 0;

    // Monthly maintenance cost per teacher
    final totalTeachers = widget.registrationData['totalTeachers'] as int;
    cost += totalTeachers * 50.0;

    // Monthly maintenance cost per student
    final totalStudents = widget.registrationData['totalStudents'] as int;
    cost += totalStudents * 30.0;

    // Monthly maintenance cost per classroom
    final classrooms = widget.registrationData['classrooms'] as List;
    for (final classroom in classrooms) {
      cost += 100.0 * (classroom['quantity'] as int);
    }

    return cost;
  }

  void _processPayment() {
    setState(() {
      _isProcessing = true;
    });

    // Simulate payment processing
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        widget.onPaymentSuccess();
      }
    });
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
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
            'Payment Details',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: isSmallScreen ? 18 : 20,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cost Breakdown
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 12 : 20),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cost Breakdown',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmallScreen ? 18 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 12 : 16),
                  // One-time costs
                  _buildCostRow(
                    'Account Creation Fee',
                    _accountCreationFee,
                    isSmallScreen: isSmallScreen,
                  ),
                  const Divider(color: Colors.grey),
                  _buildCostRow(
                    'Teacher Accounts\n(${widget.registrationData['totalTeachers']} × ₹$_teacherAccountFee)',
                    widget.registrationData['totalTeachers'] * _teacherAccountFee,
                    isSmallScreen: isSmallScreen,
                  ),
                  _buildCostRow(
                    'Student Accounts\n(${widget.registrationData['totalStudents']} × ₹$_studentAccountFee)',
                    widget.registrationData['totalStudents'] * _studentAccountFee,
                    isSmallScreen: isSmallScreen,
                  ),
                  const Divider(color: Colors.grey),
                  Text(
                    'Classroom Costs',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: isSmallScreen ? 14 : 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 6 : 8),
                  ...(widget.registrationData['classrooms'] as List).map((classroom) =>
                      _buildCostRow(
                        '${classroom['type']}\n(${classroom['quantity']} × ₹${classroom['price']})',
                        (classroom['price'] as double) * (classroom['quantity'] as int),
                        isSmallScreen: isSmallScreen,
                      ),
                  ),
                  const Divider(color: Colors.grey),
                  _buildCostRow(
                    'Total One-time Cost',
                    _calculateOneTimeSetupCost,
                    isTotal: true,
                    isSmallScreen: isSmallScreen,
                  ),
                  SizedBox(height: isSmallScreen ? 16 : 24),
                  // Monthly costs
                  Text(
                    'Monthly Subscription',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmallScreen ? 18 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 12 : 16),
                  _buildCostRow(
                    'Teacher Accounts\n(${widget.registrationData['totalTeachers']} × ₹50)',
                    widget.registrationData['totalTeachers'] * 50.0,
                    isSmallScreen: isSmallScreen,
                  ),
                  _buildCostRow(
                    'Student Accounts\n(${widget.registrationData['totalStudents']} × ₹30)',
                    widget.registrationData['totalStudents'] * 30.0,
                    isSmallScreen: isSmallScreen,
                  ),
                  const Divider(color: Colors.grey),
                  Text(
                    'Classroom Maintenance',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: isSmallScreen ? 14 : 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 6 : 8),
                  ...(widget.registrationData['classrooms'] as List).map((classroom) =>
                      _buildCostRow(
                        '${classroom['type']}\n(${classroom['quantity']} × ₹100)',
                        (classroom['quantity'] as int) * 100.0,
                        isSmallScreen: isSmallScreen,
                      ),
                  ),
                  const Divider(color: Colors.grey),
                  _buildCostRow(
                    'Total Monthly Cost',
                    _calculateMonthlyCost,
                    isTotal: true,
                    isSmallScreen: isSmallScreen,
                  ),
                  SizedBox(height: isSmallScreen ? 12 : 16),
                  Text(
                    'Note: Monthly subscription includes maintenance costs for accounts and classrooms',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: isSmallScreen ? 10 : 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: isSmallScreen ? 24 : 32),

            // Payment Form
            Text(
              'Payment Method',
              style: TextStyle(
                color: Colors.white,
                fontSize: isSmallScreen ? 18 : 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: isSmallScreen ? 12 : 16),

            // Card Number
            _buildTextField(
              controller: _cardNumberController,
              label: 'Card Number',
              icon: Icons.credit_card,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: isSmallScreen ? 12 : 16),

            // Expiry and CVV
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _expiryController,
                    label: 'MM/YY',
                  ),
                ),
                SizedBox(width: isSmallScreen ? 12 : 16),
                Expanded(
                  child: _buildTextField(
                    controller: _cvvController,
                    label: 'CVV',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(height: isSmallScreen ? 12 : 16),

            // Card Holder Name
            _buildTextField(
              controller: _nameController,
              label: 'Card Holder Name',
              icon: Icons.person,
            ),
            SizedBox(height: isSmallScreen ? 24 : 32),

            // Pay Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAdminPrimaryColor,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(
                    vertical: isSmallScreen ? 12 : 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isProcessing
                    ? SizedBox(
                  height: isSmallScreen ? 16 : 20,
                  width: isSmallScreen ? 16 : 20,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                )
                    : FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Pay ₹${_calculateOneTimeSetupCost.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: isSmallScreen ? 12 : 16),
            Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Monthly subscription of ₹${_calculateMonthlyCost.toStringAsFixed(2)} will start from next month',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: isSmallScreen ? 10 : 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    TextInputType? keyboardType,
  }) {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.white70,
          fontSize: isSmallScreen ? 12 : 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kAdminPrimaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kAdminPrimaryColor),
        ),
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        prefixIcon: icon != null
            ? Icon(icon, color: kAdminPrimaryColor, size: isSmallScreen ? 20 : 24)
            : null,
        contentPadding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 12 : 16,
          vertical: isSmallScreen ? 12 : 16,
        ),
      ),
    );
  }

  Widget _buildCostRow(
      String label,
      double amount, {
        bool isTotal = false,
        bool isSmallScreen = false,
      }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 6 : 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: isTotal ? Colors.white : Colors.white70,
                fontSize: isTotal
                    ? (isSmallScreen ? 16 : 18)
                    : (isSmallScreen ? 14 : 16),
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Text(
            '₹${amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: kAdminPrimaryColor,
              fontSize: isTotal
                  ? (isSmallScreen ? 18 : 20)
                  : (isSmallScreen ? 16 : 18),
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
} 