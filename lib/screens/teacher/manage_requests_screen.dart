import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../constants.dart';

class ManageRequestsScreen extends StatelessWidget {
  const ManageRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: kTeacherBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Manage Requests',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Pending'),
              Tab(text: 'Approved'),
              Tab(text: 'Rejected'),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            indicatorColor: Colors.white,
          ),
        ),
        body: TabBarView(
          children: [
            _buildRequestList(context, 'Pending'),
            _buildRequestList(context, 'Approved'),
            _buildRequestList(context, 'Rejected'),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestList(BuildContext context, String status) {
    final requests = _getFilteredRequests(status);
    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              status == 'Pending'
                  ? Icons.hourglass_empty
                  : status == 'Approved'
                      ? Icons.check_circle_outline
                      : Icons.cancel_outlined,
              color: Colors.white,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'No $status Requests',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return _buildRequestCard(context, request);
      },
    );
  }

  Widget _buildRequestCard(BuildContext context, Map<String, dynamic> request) {
    final Color statusColor = request['status'] == 'Pending'
        ? Colors.orange
        : request['status'] == 'Approved'
            ? Colors.green
            : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: kTeacherPrimaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: kTeacherPrimaryColor.withOpacity(0.2),
                  child: Text(
                    request['name'].toString().split(' ').map((e) => e[0]).join(),
                    style: TextStyle(
                      color: kTeacherPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        request['rollNo'],
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        request['status'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (request['date'] != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        request['date'],
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF7FE1F5).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                    icon: Icons.school,
                    label: 'Class',
                    value: request['class'],
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    icon: Icons.email,
                    label: 'Email',
                    value: request['email'],
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    icon: Icons.phone,
                    label: 'Phone',
                    value: request['phone'],
                  ),
                ],
              ),
            ),
            if (request['status'] == 'Pending') ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: Handle reject
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Reject'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Handle approve
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kTeacherPrimaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Approve',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getFilteredRequests(String status) {
    // Get current date for filtering
    final now = DateTime.now();
    final oneWeekAgo = now.subtract(const Duration(days: 7));

    return _getLoginRequests().where((request) {
      // First filter by status
      if (request['status'] != status) return false;

      // For Approved and Rejected, only show requests from the last week
      if (status != 'Pending') {
        final requestDate = DateTime.parse(request['requestDate']);
        return requestDate.isAfter(oneWeekAgo);
      }

      return true;
    }).toList();
  }

  List<Map<String, dynamic>> _getLoginRequests() {
    final now = DateTime.now();
    return [
      {
        'name': 'John Doe',
        'rollNo': 'SE COMPS 001',
        'class': 'SE COMPS',
        'email': 'john.doe@example.com',
        'phone': '+91 98765 43210',
        'status': 'Pending',
        'date': '6 Feb 2025',
        'requestDate': '2025-02-06',
      },
      {
        'name': 'Jane Smith',
        'rollNo': 'SE COMPS 002',
        'class': 'SE COMPS',
        'email': 'jane.smith@example.com',
        'phone': '+91 98765 43211',
        'status': 'Pending',
        'date': '6 Feb 2025',
        'requestDate': '2025-02-06',
      },
      {
        'name': 'Mike Johnson',
        'rollNo': 'SE COMPS 003',
        'class': 'SE COMPS',
        'email': 'mike.j@example.com',
        'phone': '+91 98765 43212',
        'status': 'Approved',
        'date': '5 Feb 2025',
        'requestDate': '2025-02-05',
      },
      {
        'name': 'Sarah Williams',
        'rollNo': 'SE COMPS 004',
        'class': 'SE COMPS',
        'email': 'sarah.w@example.com',
        'phone': '+91 98765 43213',
        'status': 'Rejected',
        'date': '4 Feb 2025',
        'requestDate': '2025-02-04',
      },
      {
        'name': 'Alex Brown',
        'rollNo': 'SE COMPS 005',
        'class': 'SE COMPS',
        'email': 'alex.b@example.com',
        'phone': '+91 98765 43214',
        'status': 'Approved',
        'date': '30 Jan 2025',
        'requestDate': '2025-01-30',
      },
    ];
  }
}
