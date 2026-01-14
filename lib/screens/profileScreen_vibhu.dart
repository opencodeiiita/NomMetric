import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/database_service.dart';
import 'login_screen.dart';

class ProfileScreenVibhu extends StatelessWidget {
  const ProfileScreenVibhu({super.key});

  @override
  Widget build(BuildContext context) {
    final User? authUser = FirebaseAuth.instance.currentUser;
    final DatabaseService dbService = DatabaseService();

    void handleLogout() async {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    }

    if (authUser == null) {
      return const Scaffold(body: Center(child: Text("No User Logged In")));
    }

    return StreamBuilder<UserModel>(
      stream: dbService.getUserData(authUser.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final userProfile = snapshot.data;
        
        final displayName = userProfile?.name ?? authUser.displayName ?? "Student";
        final displayEmail = userProfile?.email ?? authUser.email ?? "No Email";
        final displayHostel = userProfile?.hostel ?? "--";
        final displayRoom = userProfile?.roomNumber ?? "--";
        final displayRoll = userProfile?.rollNumber ?? "--";

        return Scaffold(
          backgroundColor: _AppColors.backgroundGrey,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  clipBehavior: Clip.none,
                  children: [
                    _buildHeaderBackground(displayName, displayEmail),
                    Positioned(
                      bottom: -30, 
                      child: _buildStatsRow(displayHostel, displayRoom, displayRoll)
                    ),
                  ],
                ),

                const SizedBox(height: 50),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionLabel(_AppStrings.accountSection),
                      Container(
                        decoration: _boxDecoration(),
                        child: Column(
                          children: [
                            _buildListTile(
                              icon: Icons.person_outline_rounded,
                              title: _AppStrings.editProfile,
                              showDivider: true,
                              onTap: () { /* Add Edit Logic Later */ },
                            ),
                            _buildListTile(
                              icon: Icons.settings_outlined,
                              title: _AppStrings.settings,
                              showDivider: false,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),
                      _buildSectionLabel(_AppStrings.dangerSection),

                      Container(
                        decoration: _boxDecoration(),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 5,
                          ),
                          leading: const Icon(
                            Icons.logout_rounded,
                            color: _AppColors.iconRed,
                          ),
                          title: const Text(
                            _AppStrings.logout,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _AppColors.iconRed,
                            ),
                          ),
                          onTap: handleLogout, 
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderBackground(String name, String email) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 60),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _AppColors.gradientYellow,
            _AppColors.gradientOrange,
            _AppColors.gradientPink,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.3),
            ),
            child: const CircleAvatar(
              radius: 55,
              backgroundImage: NetworkImage(_AppStrings.avatarUrl),
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            name, // Dynamic Name
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
              shadows: [
                Shadow(
                  offset: Offset(0, 1),
                  blurRadius: 3,
                  color: Colors.black12,
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              email,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(String hostel, String room, String roll) {
    return Container(
      width: 320,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(hostel, "Hostel"), // Mapped to Hostel
          Container(height: 25, width: 1, color: Colors.grey[300]),
          _buildStatItem(room, "Room No"), // Mapped to Room
          Container(height: 25, width: 1, color: Colors.grey[300]),
          _buildStatItem(roll, "Roll No"), // Mapped to Roll Number
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: _AppColors.textDark,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required bool showDivider,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 5,
          ),
          leading: Icon(icon, color: _AppColors.iconDark),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: _AppColors.textDark,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: Colors.grey,
          ),
          onTap: onTap,
        ),
        if (showDivider)
          const Divider(
            height: 1,
            indent: 60,
            endIndent: 0,
            color: _AppColors.dividerColor,
          ),
      ],
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.03),
          blurRadius: 5,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}

// CONSTANTS (Cleaned up)
class _AppStrings {
  static const String editProfile = "Edit Profile";
  static const String settings = "Settings";
  static const String logout = "Logout";
  static const String accountSection = "ACCOUNT";
  static const String dangerSection = "OTHER";
  static const String avatarUrl = "https://i.pravatar.cc/300?img=11";
}

class _AppColors {
  static const Color gradientYellow = Color(0xFFFFD200);
  static const Color gradientOrange = Color(0xFFF7971E);
  static const Color gradientPink = Color(0xFFFF0099);
  static const Color backgroundGrey = Color(0xFFF5F7FA);
  static const Color textDark = Color(0xFF2D3142);
  static const Color iconDark = Color(0xFF4A5568);
  static const Color iconRed = Color(0xFFE02020);
  static const Color dividerColor = Color(0xFFEEEEEE);
}