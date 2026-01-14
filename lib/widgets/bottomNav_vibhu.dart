import 'package:flutter/material.dart';

class BottomNavCustom extends StatefulWidget {
  const BottomNavCustom({super.key});

  @override
  State<BottomNavCustom> createState() => _BottomNavCustomState();
}

class _BottomNavCustomState extends State<BottomNavCustom> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _AppConfig.backgroundColor,
      // CRITICAL: extendBody MUST be true for the nav bar to float over the gradient
      extendBody: true, 
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeTab(),
          _buildMenuTab(),
          _buildProfileTab(),
        ],
      ),
      bottomNavigationBar: _buildUnifiedNavBar(),
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 3: PROFILE (FIXED: AGGRESSIVE MARGIN)
  // ---------------------------------------------------------------------------
  Widget _buildProfileTab() {
    return Container(
      decoration: BoxDecoration(
        gradient: _AppConfig.goldenGradient, 
      ),
      child: SafeArea(
        bottom: false, 
        child: Column(
          children: [
            const SizedBox(height: 30),
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 50, color: _AppConfig.mainBrandColor),
            ),
            const SizedBox(height: 15),
            const Text("User Profile", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            
            // THE WHITE SHEET
            Expanded(
              child: Container(
                width: double.infinity,
                // FIXED: Increased margin to 120. This FORCES the white sheet to stop 
                // well above the nav bar, revealing the golden gradient at the bottom.
                margin: const EdgeInsets.only(bottom: 120), 
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(40)), 
                ),
                child: ListView(
                  padding: const EdgeInsets.all(30),
                  children: [
                    _buildProfileItem(Icons.settings, "Settings"),
                    _buildProfileItem(Icons.lock, "Privacy"),
                    _buildProfileItem(Icons.help_outline, "Help & Support"),
                    _buildProfileItem(Icons.info_outline, "About Us"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // THE NAV BAR (With Visible Border)
  // ---------------------------------------------------------------------------
  Widget _buildUnifiedNavBar() {
    return Container(
      margin: _AppConfig.navBarMargin,
      padding: _AppConfig.navBarPadding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        // FIXED: Added a distinct border so it doesn't blend into white backgrounds
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1.5),
        boxShadow: _AppConfig.softShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _AppConfig.navItems.map((item) {
          int index = _AppConfig.navItems.indexOf(item);
          bool isSelected = _selectedIndex == index;

          return GestureDetector(
            onTap: () => setState(() => _selectedIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.symmetric(
                horizontal: isSelected ? 20 : 12,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: isSelected ? _AppConfig.mainBrandColor : Colors.transparent,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Icon(
                    item.icon,
                    color: isSelected ? Colors.white : Colors.grey[400],
                    size: 26,
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: isSelected ? 60 : 0, 
                    child: ClipRect(
                      child: AnimatedOpacity(
                        opacity: isSelected ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            item.label,
                            maxLines: 1,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 1: HOME
  // ---------------------------------------------------------------------------
  Widget _buildHomeTab() {
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Good Morning,", style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                  const Text("Explorer", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: _AppConfig.softShadow),
                child: const Icon(Icons.notifications_none_rounded),
              )
            ],
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              gradient: _AppConfig.goldenGradient,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(color: _AppConfig.mainBrandColor.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10))
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Daily Goal", style: TextStyle(color: Colors.white70)),
                SizedBox(height: 10),
                Text("85% Done", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                SizedBox(height: 15),
                LinearProgressIndicator(value: 0.85, color: Colors.white, backgroundColor: Colors.white24),
              ],
            ),
          ),
          const SizedBox(height: 100), 
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 2: MENU
  // ---------------------------------------------------------------------------
  Widget _buildMenuTab() {
    return SafeArea(
      child: GridView.builder(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: _AppConfig.softShadow,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.widgets_rounded, size: 40, color: _AppConfig.mainBrandColor.withOpacity(0.7)),
                const SizedBox(height: 10),
                Text("Feature ${index + 1}", style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, size: 22, color: Colors.black87),
          ),
          const SizedBox(width: 20),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// DATA & CONFIGURATION
// ---------------------------------------------------------------------------
class _AppConfig {
  static const Color backgroundColor = Color(0xFFF4F6FA);
  static const Color mainBrandColor = Color(0xFFFFA000); 

  static const LinearGradient goldenGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFB300), 
      Color(0xFFFF6F00), 
    ],
  );

  static const EdgeInsets navBarMargin = EdgeInsets.only(left: 20, right: 20, bottom: 30);
  static const EdgeInsets navBarPadding = EdgeInsets.symmetric(horizontal: 25, vertical: 15);

  static final List<BoxShadow> softShadow = [
    BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 5))
  ];

  static final List<_NavItemData> navItems = [
    _NavItemData(icon: Icons.home_rounded, label: "Home"),
    _NavItemData(icon: Icons.grid_view_rounded, label: "Menu"),
    _NavItemData(icon: Icons.person_rounded, label: "Profile"),
  ];
}

class _NavItemData {
  final IconData icon;
  final String label;
  _NavItemData({required this.icon, required this.label});
}