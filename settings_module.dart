import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsModuleScreen extends StatelessWidget {
  const SettingsModuleScreen({Key? key}) : super(key: key);

  Future<void> _clearData(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All local data cleared successfully.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & Profile'),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.teal,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text('Student User', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('student@university.edu'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.currency_exchange, color: Colors.teal),
            title: const Text('Default Currency'),
            trailing: const Text('PKR (Rs)'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text('Clear All Local Data'),
            onTap: () => _clearData(context),
          ),
        ],
      ),
    );
  }
}
