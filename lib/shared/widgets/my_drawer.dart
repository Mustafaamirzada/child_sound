import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String userName = '';
  String userImage = "assets/userImage.png";

  @override
  void initState() {
    _loadUserName();
    super.initState();
  }

  Future<void> _loadUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString("userName");

    if (savedName != null) {
      setState(() {
        userName = savedName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      // elevation: 8,
      child: Column(
        children: [
          // 🔷 HEADER
          _buildHeader(),

          // 🔹 MENU ITEMS
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _drawerItem(
                  context,
                  icon: Icons.privacy_tip_outlined,
                  title: "Privacy Policy",
                  onTap: () {},
                ),

                _drawerItem(
                  context,
                  icon: Icons.help_outline,
                  title: "Help",
                  onTap: () {},
                ),

                _drawerItem(
                  context,
                  icon: Icons.description_outlined,
                  title: "Terms & Conditions",
                  onTap: () {},
                ),

                _drawerItem(
                  context,
                  icon: Icons.info_outline,
                  title: "About Us",
                  onTap: () {},
                ),
              ],
            ),
          ),

          // 🔻 Footer
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Version 1.0.0",
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }

  void _editProfile() {
    TextEditingController controller = TextEditingController(text: userName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Name'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter Your Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setString("userName", controller.text);

                setState(() {
                  userImage = controller.text;
                });
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          // 🖼 App Logo / Image
          GestureDetector(
            onTap: _editProfile,
            child: CircleAvatar(
              radius: 45,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage("assets/userImage.png"),
            ),
          ),

          const SizedBox(height: 15),

          // 👤 user Name
          GestureDetector(
            onTap: _editProfile,
            child: const Text(
              "Hi! ✋ Mustafa",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Tap to edit profile',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),

          const SizedBox(height: 25),

          const Text(
            "Learn Alphabets & Words",
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue.shade700),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
