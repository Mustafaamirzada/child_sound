import 'package:child_sound/features/profile/presentation/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String userName = '';
  String userAvatar = "🧒";

  @override
  void initState() {
    _loadUser();
    super.initState();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString("userName") ?? "";
      userAvatar = prefs.getString("userAvatar") ?? "🧒";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _drawerItem(
                  icon: Icons.person,
                  title: "پروفایل",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
                  },
                ),
                _drawerItem(
                  icon: Icons.privacy_tip_outlined,
                  title: "حریم خصوصی",
                  onTap: () => _showInfoDialog(
                    context,
                    title: "حریم خصوصی",
                    message: "همه اطلاعات شما (پیشرفت، نام و تنظیمات) فقط روی همین دستگاه ذخیره می‌شود و هیچ‌جا ارسال نمی‌شود.",
                  ),
                ),
                _drawerItem(
                  icon: Icons.help_outline,
                  title: "راهنما",
                  onTap: () => _showInfoDialog(
                    context,
                    title: "راهنما",
                    message: "برای یادگیری، روی هر حرف یا کلمه بزنید. با سه بار پخش صدا، آن مورد کامل می‌شود و از دستاوردها به شما جایزه می‌دهیم.",
                  ),
                ),
                _drawerItem(
                  icon: Icons.info_outline,
                  title: "درباره ما",
                  onTap: () => _showInfoDialog(
                    context,
                    title: "درباره ما",
                    message: "Child Sound — برنامه آموزش الفبا و کلمات دری به کودکان.\nنسخه ۱.۰.۰",
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text("نسخه ۱.۰.۰", style: TextStyle(color: Colors.grey.shade600)),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 42,
              backgroundColor: Colors.white,
              child: Text(userAvatar, style: const TextStyle(fontSize: 40)),
            ),
            const SizedBox(height: 12),
            Text(
              userName.isNotEmpty ? userName : "مصطفی",
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text("مشاهده پروفایل", style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Future<void> _showInfoDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    Navigator.pop(context);
    return showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title),
        content: Text(message, textAlign: TextAlign.center),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
            child: const Text("باشه"),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple.shade300),
      title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      trailing: Icon(
        Directionality.of(context) == TextDirection.rtl
            ? Icons.arrow_back_ios_new
            : Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }
}
