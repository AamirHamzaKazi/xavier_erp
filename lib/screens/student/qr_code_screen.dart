import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../constants.dart';

class QRCodeScreen extends StatefulWidget {
  const QRCodeScreen({super.key});

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  bool _isQRGenerated = false;
  int _remainingSeconds = 15;
  int _remainingAttempts = 3;
  bool _isTimerRunning = false;
  String _qrData = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCurrentLecture(),
          const SizedBox(height: 32),
          _buildQRSection(),
        ],
      ),
    );
  }

  Widget _buildCurrentLecture() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kStudentPrimaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Current Lecture',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.laptop,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data Structures',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '11:15 - 12:15',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQRSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 400;
        final qrSize = isSmallScreen ? 160.0 : 200.0;
        
        return Container(
          padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'QR Code Generator',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 8 : 12,
                      vertical: isSmallScreen ? 4 : 6
                    ),
                    decoration: BoxDecoration(
                      color: _remainingAttempts > 0 ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Attempts left: $_remainingAttempts',
                      style: TextStyle(
                        color: _remainingAttempts > 0 ? Colors.green : Colors.red,
                        fontSize: isSmallScreen ? 12 : 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: isSmallScreen ? 16 : 20),
              if (_isQRGenerated) ...[
                Container(
                  width: qrSize + 32,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: QrImageView(
                    data: _qrData,
                    version: QrVersions.auto,
                    size: qrSize,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'QR Code will expire in $_remainingSeconds seconds',
                  style: TextStyle(
                    color: _remainingSeconds <= 5 ? Colors.red : Colors.white70,
                    fontSize: isSmallScreen ? 12 : 14,
                    fontWeight: _remainingSeconds <= 5 ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ] else
                Container(
                  height: qrSize,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.qr_code_2,
                          size: isSmallScreen ? 36 : 48,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        SizedBox(height: isSmallScreen ? 8 : 12),
                        Text(
                          _remainingAttempts > 0
                              ? 'Click generate to create QR code'
                              : 'No attempts remaining',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: isSmallScreen ? 12 : 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: isSmallScreen ? 20 : 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _remainingAttempts > 0 && !_isTimerRunning
                      ? () {
                          setState(() {
                            _isQRGenerated = true;
                            _remainingSeconds = 15;
                            _remainingAttempts--;
                            _isTimerRunning = true;
                          });
                          _startTimer();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kStudentPrimaryColor,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(
                      vertical: isSmallScreen ? 12 : 16
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor: Colors.grey.withOpacity(0.3),
                    disabledForegroundColor: Colors.white30,
                  ),
                  child: Text(
                    _remainingAttempts > 0
                        ? _isTimerRunning
                            ? 'Wait for QR to expire'
                            : 'Generate QR Code'
                        : 'No attempts remaining',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  void _startTimer() {
    setState(() {
      _qrData = 'student_id=12345&lecture_id=DS101&timestamp=${DateTime.now().millisecondsSinceEpoch}';
    });
    
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      
      setState(() {
        _remainingSeconds--;
      });
      
      if (_remainingSeconds <= 0) {
        setState(() {
          _isQRGenerated = false;
          _isTimerRunning = false;
        });
        return false;
      }
      return true;
    });
  }
}
