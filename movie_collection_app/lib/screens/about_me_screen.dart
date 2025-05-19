import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutMeScreen extends StatelessWidget {
  const AboutMeScreen({super.key});

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        title: const Text('About Me'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/images/him.jpg'),
            ),
            const SizedBox(height: 20),
            const Text(
              'นาย อับดุลรอฮีม จิเตะ',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const Text(
              'รหัสนักศึกษา : 406659018',
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
            const SizedBox(height: 10),
            const Text(
              'สวัสดี! ผมชอบดูหนังมากๆ',
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
            const SizedBox(height: 5),
            const Text(
              '🎬 หนังที่ชอบ: Inception',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.amberAccent),
            ),
            const SizedBox(height: 20),
            Divider(color: Colors.white38, thickness: 0.5),
            const SizedBox(height: 10),
            const Text(
              '📞 ติดต่อฉันได้ที่',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(FontAwesomeIcons.facebook, color: Colors.blueAccent),
                  onPressed: () => _launchURL('https://www.facebook.com/profile.php?id=100076696356779'),
                ),
                IconButton(
                  icon: const Icon(FontAwesomeIcons.instagram, color: Colors.pinkAccent),
                  onPressed: () => _launchURL('https://www.instagram.com/yourprofile'),
                ),
                IconButton(
                  icon: const Icon(FontAwesomeIcons.github, color: Colors.white),
                  onPressed: () => _launchURL('https://github.com/yourprofile'),
                ),
                IconButton(
                  icon: const Icon(FontAwesomeIcons.envelope, color: Colors.redAccent),
                  onPressed: () => _launchURL('mailto:your_email@example.com'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              label: const Text('Back'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
