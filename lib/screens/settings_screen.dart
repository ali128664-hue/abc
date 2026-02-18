import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../utils/theme.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          _buildSectionHeader(context, 'Appearance'),
          SwitchListTile(
            title: const Text('Dark Mode'),
            secondary: const Icon(Icons.dark_mode),
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (value) {
              themeProvider.toggleTheme(value);
            },
            activeColor: AppTheme.primaryColor,
          ),
          
          const Divider(),
          
          _buildSectionHeader(context, 'Account'),
           ListTile(
            leading: const Icon(Icons.login),
            title: const Text('Login to Instagram'),
            subtitle: const Text('For accessing private content'),
            onTap: () {
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => const LoginScreen()),
               );
            },
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
          
          const Divider(),
          
          _buildSectionHeader(context, 'Storage'),
          ListTile(
            leading: const Icon(Icons.folder_open),
            title: const Text('Clear Download History'),
             onTap: () {
               // Clear history logic
            },
          ),
          
          const Divider(),
           _buildSectionHeader(context, 'About'),
           const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Version'),
            trailing: Text('1.0.0'),
          ),
           ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
