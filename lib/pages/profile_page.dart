import 'package:flutter/material.dart';
import '../widgets/flicktv_logo.dart';
import '../util/strings.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _notificationsEnabled = true;
  bool _autoPlayEnabled = true;
  bool _downloadOnWifiOnly = true;
  String _selectedVideoQuality = Strings.qualityAuto;
  String _selectedLanguage = Strings.english;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Back button
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      Strings.profile,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Profile Header
              Container(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Profile Avatar
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE50914), Color(0xFFB20710)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFE50914).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      Strings.flickTVUser,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      Strings.premiumMember,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              // Profile Options
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    // Account Section
                    _buildSectionHeader(Strings.account),
                    _buildProfileOption(
                      icon: Icons.edit,
                      title: Strings.editProfile,
                      subtitle: Strings.editProfileDesc,
                      onTap: () => _showEditProfileDialog(),
                    ),
                    _buildProfileOption(
                      icon: Icons.subscriptions,
                      title: Strings.manageSubscription,
                      subtitle: Strings.manageSubscriptionDesc,
                      onTap: () => _showSubscriptionDialog(),
                    ),
                    _buildProfileOption(
                      icon: Icons.download,
                      title: Strings.downloads,
                      subtitle: Strings.downloadsDesc,
                      onTap: () => _showDownloadsDialog(),
                    ),

                    const SizedBox(height: 24),

                    // Preferences Section
                    _buildSectionHeader(Strings.preferences),
                    _buildSwitchOption(
                      icon: Icons.notifications,
                      title: Strings.notifications,
                      subtitle: Strings.notificationsDesc,
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                      },
                    ),
                    _buildSwitchOption(
                      icon: Icons.play_circle,
                      title: Strings.autoPlay,
                      subtitle: Strings.autoPlayDesc,
                      value: _autoPlayEnabled,
                      onChanged: (value) {
                        setState(() {
                          _autoPlayEnabled = value;
                        });
                      },
                    ),
                    _buildSwitchOption(
                      icon: Icons.wifi,
                      title: Strings.downloadOnWifiOnly,
                      subtitle: Strings.downloadOnWifiOnlyDesc,
                      value: _downloadOnWifiOnly,
                      onChanged: (value) {
                        setState(() {
                          _downloadOnWifiOnly = value;
                        });
                      },
                    ),
                    _buildDropdownOption(
                      icon: Icons.high_quality,
                      title: Strings.videoQuality,
                      subtitle: Strings.videoQualityDesc,
                      value: _selectedVideoQuality,
                      options: [
                        Strings.qualityAuto,
                        Strings.qualityHigh,
                        Strings.qualityMedium,
                        Strings.qualityLow
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedVideoQuality = value!;
                        });
                      },
                    ),
                    _buildDropdownOption(
                      icon: Icons.language,
                      title: Strings.language,
                      subtitle: Strings.languageDesc,
                      value: _selectedLanguage,
                      options: [
                        Strings.english,
                        Strings.spanish,
                        Strings.french,
                        Strings.german
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedLanguage = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 24),

                    // Support Section
                    _buildSectionHeader(Strings.support),
                    _buildProfileOption(
                      icon: Icons.help,
                      title: Strings.helpCenter,
                      subtitle: Strings.helpCenterDesc,
                      onTap: () => _showHelpDialog(),
                    ),
                    _buildProfileOption(
                      icon: Icons.feedback,
                      title: Strings.sendFeedback,
                      subtitle: Strings.sendFeedbackDesc,
                      onTap: () => _showFeedbackDialog(),
                    ),
                    _buildProfileOption(
                      icon: Icons.info,
                      title: Strings.aboutFlickTV,
                      subtitle: 'Version ${Strings.appVersion}',
                      onTap: () => _showAboutDialog(),
                    ),

                    const SizedBox(height: 24),

                    // Sign Out Button
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ElevatedButton(
                        onPressed: () => _showSignOutDialog(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE50914),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          Strings.signOut,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFFE50914),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: const Color(0xFF2F2F2F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFE50914).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFE50914),
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: const Color(0xFF2F2F2F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFE50914).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFE50914),
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFFE50914),
          activeTrackColor: const Color(0xFFE50914).withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _buildDropdownOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: const Color(0xFF2F2F2F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFE50914).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFE50914),
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
        trailing: DropdownButton<String>(
          value: value,
          onChanged: onChanged,
          dropdownColor: const Color(0xFF2F2F2F),
          style: const TextStyle(color: Colors.white),
          underline: Container(),
          items: options.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2F2F2F),
        title: const Text(
          Strings.editProfile,
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          Strings.editProfileDialog,
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              Strings.close,
              style: TextStyle(color: Color(0xFFE50914)),
            ),
          ),
        ],
      ),
    );
  }

  void _showSubscriptionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2F2F2F),
        title: const Text(
          Strings.manageSubscription,
          style: TextStyle(color: Colors.white),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Strings.currentPlan,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              Strings.nextBilling,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 8),
            Text(
              Strings.planFeatures,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              Strings.close,
              style: TextStyle(color: Color(0xFFE50914)),
            ),
          ),
        ],
      ),
    );
  }

  void _showDownloadsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2F2F2F),
        title: const Text(
          Strings.downloads,
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          Strings.noDownloads,
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              Strings.close,
              style: TextStyle(color: Color(0xFFE50914)),
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2F2F2F),
        title: const Text(
          Strings.helpCenter,
          style: TextStyle(color: Colors.white),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Strings.faqTitle,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              Strings.faqDownload,
              style: TextStyle(color: Colors.white),
            ),
            Text(
              Strings.faqQuality,
              style: TextStyle(color: Colors.white),
            ),
            Text(
              Strings.faqSubscription,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              Strings.contactSupport,
              style: TextStyle(color: Color(0xFFE50914)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              Strings.close,
              style: TextStyle(color: Color(0xFFE50914)),
            ),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2F2F2F),
        title: const Text(
          Strings.sendFeedback,
          style: TextStyle(color: Colors.white),
        ),
        content: const TextField(
          maxLines: 4,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: Strings.feedbackHint,
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              Strings.cancel,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(Strings.feedbackThankYou),
                  backgroundColor: Color(0xFFE50914),
                ),
              );
            },
            child: const Text(
              Strings.send,
              style: TextStyle(color: Color(0xFFE50914)),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2F2F2F),
        title: Row(
          children: [
            const FlickTVLogo(fontSize: 20, style: LogoStyle.gradient),
            const SizedBox(width: 8),
            const Text(
              Strings.appName,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Version: ${Strings.appVersion}',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 8),
            Text(
              Strings.appDescription,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              Strings.copyright,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              Strings.close,
              style: TextStyle(color: Color(0xFFE50914)),
            ),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2F2F2F),
        title: const Text(
          Strings.signOut,
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          Strings.signOutConfirm,
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              Strings.cancel,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to home
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(Strings.signedOutSuccess),
                  backgroundColor: Color(0xFFE50914),
                ),
              );
            },
            child: const Text(
              'Sign Out',
              style: TextStyle(color: Color(0xFFE50914)),
            ),
          ),
        ],
      ),
    );
  }
}
