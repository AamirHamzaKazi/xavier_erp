import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../constants.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  MobileScannerController controller = MobileScannerController();
  String? lastScanned;
  
  // Dummy student data - Replace with actual data from your backend
  final List<Map<String, dynamic>> students = [
    {'id': '1', 'name': 'John Doe', 'roll': '101', 'isPresent': false},
    {'id': '2', 'name': 'Jane Smith', 'roll': '102', 'isPresent': false},
    {'id': '3', 'name': 'Mike Johnson', 'roll': '103', 'isPresent': false},
    // Add more students
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kTeacherBackgroundColor,
      appBar: AppBar(
        backgroundColor: kTeacherPrimaryColor,
        title: const Text(
          'Mark Attendance',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: controller.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.white);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            onPressed: () => controller.toggleTorch(),
          ),
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: controller.cameraFacingState,
              builder: (context, state, child) {
                switch (state) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front, color: Colors.white);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear, color: Colors.white);
                }
              },
            ),
            onPressed: () => controller.switchCamera(),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 300,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kTeacherPrimaryColor, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  MobileScanner(
                    controller: controller,
                    onDetect: (capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      for (final barcode in barcodes) {
                        if (barcode.rawValue != lastScanned) {
                          lastScanned = barcode.rawValue;
                          _handleScannedCode(barcode.rawValue ?? '');
                        }
                      }
                    },
                  ),
                  CustomPaint(
                    painter: ScannerOverlay(borderColor: kTeacherPrimaryColor),
                    child: Container(),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Students (${students.where((s) => s['isPresent']).length}/${students.length})',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final student = students[index];
                        return Card(
                          color: const Color(0xFF2A2A2A),
                          margin: const EdgeInsets.only(bottom: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: student['isPresent'] 
                                  ? kTeacherPrimaryColor.withOpacity(0.2)
                                  : Colors.grey.withOpacity(0.2),
                              child: Icon(
                                Icons.person,
                                color: student['isPresent']
                                    ? kTeacherPrimaryColor
                                    : Colors.grey,
                              ),
                            ),
                            title: Text(
                              student['name'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              'Roll No: ${student['roll']}',
                              style: TextStyle(
                                color: Colors.grey[400],
                              ),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: student['isPresent']
                                    ? kTeacherPrimaryColor.withOpacity(0.2)
                                    : Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                student['isPresent'] ? 'Present' : 'Absent',
                                style: TextStyle(
                                  color: student['isPresent']
                                      ? kTeacherPrimaryColor
                                      : Colors.grey,
                                  fontWeight: FontWeight.w500,
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
          ),
        ],
      ),
    );
  }

  void _handleScannedCode(String code) {
    // Parse the QR code data
    try {
      final studentId = code.split('&')[0].split('=')[1];
      setState(() {
        final studentIndex = students.indexWhere((s) => s['id'] == studentId);
        if (studentIndex != -1) {
          students[studentIndex]['isPresent'] = true;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Marked ${students[studentIndex]['name']} as present'),
              backgroundColor: kTeacherPrimaryColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Invalid QR Code'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class ScannerOverlay extends CustomPainter {
  final Color borderColor;

  ScannerOverlay({this.borderColor = Colors.white});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final double scanAreaSize = size.width * 0.7;
    final Rect scanArea = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: scanAreaSize,
      height: scanAreaSize,
    );

    canvas.drawPath(
      Path()
        ..addRect(scanArea)
        ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
        ..fillType = PathFillType.evenOdd,
      Paint()
        ..color = Colors.black.withOpacity(0.5)
        ..style = PaintingStyle.fill,
    );

    canvas.drawRect(scanArea, paint);

    // Draw corner markers
    final double markerLength = 20.0;

    // Top left corner
    canvas.drawLine(
      scanArea.topLeft,
      scanArea.topLeft.translate(markerLength, 0),
      paint,
    );
    canvas.drawLine(
      scanArea.topLeft,
      scanArea.topLeft.translate(0, markerLength),
      paint,
    );

    // Top right corner
    canvas.drawLine(
      scanArea.topRight,
      scanArea.topRight.translate(-markerLength, 0),
      paint,
    );
    canvas.drawLine(
      scanArea.topRight,
      scanArea.topRight.translate(0, markerLength),
      paint,
    );

    // Bottom left corner
    canvas.drawLine(
      scanArea.bottomLeft,
      scanArea.bottomLeft.translate(markerLength, 0),
      paint,
    );
    canvas.drawLine(
      scanArea.bottomLeft,
      scanArea.bottomLeft.translate(0, -markerLength),
      paint,
    );

    // Bottom right corner
    canvas.drawLine(
      scanArea.bottomRight,
      scanArea.bottomRight.translate(-markerLength, 0),
      paint,
    );
    canvas.drawLine(
      scanArea.bottomRight,
      scanArea.bottomRight.translate(0, -markerLength),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
