import 'package:flutter/material.dart';
import '../../constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: kAdminPrimaryColor,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingCard(
            title: 'Account Settings',
            icon: Icons.person_outline,
            onTap: () {
              // TODO: Implement account settings
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account settings coming soon!')),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildSettingCard(
            title: 'Notifications',
            icon: Icons.notifications_outlined,
            onTap: () {
              // TODO: Implement notification settings
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notification settings coming soon!')),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildSettingCard(
            title: 'App Theme',
            icon: Icons.palette_outlined,
            onTap: () {
              // TODO: Implement theme settings
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Theme settings coming soon!')),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildSettingCard(
            title: 'About',
            icon: Icons.info_outline,
            onTap: () {
              // TODO: Implement about section
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('About section coming soon!')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(
          icon,
          color: kAdminPrimaryColor,
          size: 28,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
          size: 20,
        ),
        onTap: onTap,
      ),
    );
  }
}
