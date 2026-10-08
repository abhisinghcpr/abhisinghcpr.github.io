import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';


class AppColors {
  static const darkBg = Color(0xFF020617);
  static const surface = Color(0xFF0B1121);
  static const cardBg = Color(0xFF111A2E);


  static const border = Color(0xFF1E293B);
  static const highlight = Color(
    0xFF2E3A59,
  );


  static const primary = Color(0xFF6366F1);

  static const primaryLight = Color(0xFF818CF8);
  static const secondary = Color(0xFF10B981);
  static const accent = Color(0xFFF43F5E);

  static const textPrimary = Color(0xFFF8FAFC);
  static const textSecondary = Color(0xFF94A3B8);
  static const textMuted = Color(0xFF64748B);


  static const success = Color(0xFF22C55E);
  static const error = Color(0xFFEF4444);
  static const warning = Color(0xFFF59E0B);

  static const primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme {
  static TextStyle outfit({
    double? fontSize,
    Color? color,
    FontWeight? fontWeight,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.outfit(
      fontSize: fontSize,
      color: color ?? AppColors.textPrimary,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle jakarta({
    double? fontSize,
    Color? color,
    FontWeight? fontWeight,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: fontSize,
      color: color ?? AppColors.textSecondary,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static BoxDecoration glassDecoration({
    Color? borderCol,
    Color? fillCol,
    double radius = 16,
    bool showGlow = false,
  }) {
    return BoxDecoration(
      color: fillCol ?? AppColors.cardBg.withOpacity(0.55),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: borderCol ?? AppColors.border.withOpacity(0.5),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
        if (showGlow)
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 25,
            spreadRadius: 1,
          ),
      ],
    );
  }
}

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome> {
  final Map<String, GlobalKey> sectionKeys = {
    "Home": GlobalKey(),
    "About": GlobalKey(),
    "Experience": GlobalKey(),
    "Skills": GlobalKey(),
    "Projects": GlobalKey(),
    "Education": GlobalKey(),
    "Contact": GlobalKey(),
  };

  late ScrollController _scrollController;
  bool _showBackToTop = false;
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {

      if (_scrollController.offset > 400) {
        if (!_showBackToTop) {
          setState(() {
            _showBackToTop = true;
          });
        }
      } else {
        if (_showBackToTop) {
          setState(() {
            _showBackToTop = false;
          });
        }
      }

      if (_scrollController.offset > 50) {
        if (!_isScrolled) {
          setState(() {
            _isScrolled = true;
          });
        }
      } else {
        if (_isScrolled) {
          setState(() {
            _isScrolled = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void scrollTo(GlobalKey key) {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 800),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      drawer: const MobileDrawer(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;

          return Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    HeroSection(
                      key: sectionKeys["Home"]!,
                      screenWidth: screenWidth,
                      onProjectTap: () => scrollTo(sectionKeys["Projects"]!),
                    ),

                    // Stats Section - Responsive
                    StatsSection(screenWidth: screenWidth),

                    // About Section
                    AboutSection(
                      key: sectionKeys["About"]!,
                      screenWidth: screenWidth,
                    ),

                    // Experience Section
                    ExperienceSection(
                      key: sectionKeys["Experience"]!,
                      screenWidth: screenWidth,
                    ),

                    // Skills Section
                    SkillsSection(
                      key: sectionKeys["Skills"]!,
                      screenWidth: screenWidth,
                    ),

                    // Projects Section
                    ProjectsSection(
                      key: sectionKeys["Projects"]!,
                      screenWidth: screenWidth,
                    ),

                    // Education Section
                    EducationSection(
                      key: sectionKeys["Education"]!,
                      screenWidth: screenWidth,
                    ),

                    // Resume Banner - Responsive
                    ResumeBanner(screenWidth: screenWidth),

                    // Contact Section
                    ContactSection(
                      key: sectionKeys["Contact"]!,
                      screenWidth: screenWidth,
                    ),

                    // Footer
                    Footer(screenWidth: screenWidth),
                  ],
                ),
              ),

              // Fixed Navigation - Responsive
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: ResponsiveNavbar(
                  screenWidth: screenWidth,
                  onTap: scrollTo,
                  keys: sectionKeys,
                  isScrolled: _isScrolled,
                ),
              ),

              Positioned(
                bottom: 30,
                right: 30,
                child: AnimatedScale(
                  scale: _showBackToTop ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: FloatingActionButton(
                    onPressed: () {
                      _scrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.fastOutSlowIn,
                      );
                    },
                    backgroundColor: AppColors.primary,
                    child: const Icon(Icons.arrow_upward, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/* ================= RESPONSIVE NAVIGATION ================= */
class ResponsiveNavbar extends StatelessWidget {
  final double screenWidth;
  final Function(GlobalKey) onTap;
  final Map<String, GlobalKey> keys;
  final bool isScrolled;

  const ResponsiveNavbar({
    super.key,
    required this.screenWidth,
    required this.onTap,
    required this.keys,
    required this.isScrolled,
  });

  @override
  Widget build(BuildContext context) {
    if (screenWidth < 768) {
      return MobileNavbar(onTap: onTap, keys: keys, isScrolled: isScrolled);
    } else {
      return DesktopNavbar(onTap: onTap, keys: keys, isScrolled: isScrolled);
    }
  }
}

class DesktopNavbar extends StatelessWidget {
  final Function(GlobalKey) onTap;
  final Map<String, GlobalKey> keys;
  final bool isScrolled;

  const DesktopNavbar({
    super.key,
    required this.onTap,
    required this.keys,
    required this.isScrolled,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
        vertical: isScrolled ? 12 : 22,
      ),
      decoration: BoxDecoration(
        color: isScrolled ? AppColors.darkBg.withOpacity(0.85) : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: isScrolled ? AppColors.border.withOpacity(0.5) : Colors.transparent,
            width: 1,
          ),
        ),
        boxShadow: isScrolled
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ]
            : [],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.code, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                "Abhishek Singh",
                style: AppTheme.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          Row(
            children: keys.entries
                .map((e) => HoverText(text: e.key, onTap: () => onTap(e.value)))
                .toList(),
          ),
          IconButton(
            onPressed: () => html.window.open(
              "https://www.linkedin.com/in/abhishek-singh-flutter/",
              "_blank",
            ),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primary.withOpacity(0.5)),
              ),
              child: CachedNetworkImage(
                imageUrl:
                    "https://cdn-icons-png.flaticon.com/512/174/174857.png",
                width: 20,
                height: 20,
                color: AppColors.primary,
                placeholder: (context, url) =>
                    const CupertinoActivityIndicator(radius: 2),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.image_not_supported, size: 20),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MobileNavbar extends StatelessWidget {
  final Function(GlobalKey) onTap;
  final Map<String, GlobalKey> keys;
  final bool isScrolled;

  const MobileNavbar({
    super.key,
    required this.onTap,
    required this.keys,
    required this.isScrolled,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      decoration: BoxDecoration(
        color: isScrolled ? AppColors.darkBg.withOpacity(0.9) : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: isScrolled ? AppColors.border.withOpacity(0.5) : Colors.transparent,
            width: 1,
          ),
        ),
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Abhishek Singh",
          style: AppTheme.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: CachedNetworkImage(
              imageUrl: "https://cdn-icons-png.flaticon.com/512/174/174857.png",
              width: 20,
              height: 20,
              color: AppColors.primary,
              placeholder: (context, url) =>
                  const CupertinoActivityIndicator(radius: 2),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.image_not_supported, size: 20),
              fit: BoxFit.cover,
            ),
            onPressed: () => html.window.open(
              "https://www.linkedin.com/in/abhishek-singh-flutter/",
              "_blank",
            ),
          ),
        ],
      ),
    );
  }
}


class MobileDrawer extends StatelessWidget {
  const MobileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.cardBg,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: AppColors.darkBg),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                SizedBox(height: 10),
                Text(
                  "Abhishek Singh",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Flutter Developer",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ...[
                "Home",
                "About",
                "Experience",
                "Skills",
                "Projects",
                "Education",
                "Contact",
              ]
              .map(
                (item) => ListTile(
                  title: Text(
                    item,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // Scroll to section would be implemented here
                  },
                ),
              )
              .toList(),
          const Divider(color: AppColors.border),
          ListTile(
            leading: Icon(Icons.person, color: AppColors.primary),
            title: const Text(
              "LinkedIn Profile",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pop(context);
              html.window.open(
                "https://www.linkedin.com/in/abhishek-singh-flutter/",
                "_blank",
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.email, color: AppColors.primary),
            title: const Text(
              "Email Me",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pop(context);
              html.window.open("mailto:abhisingh852161@gmail.com", "_blank");
            },
          ),
          ListTile(
            leading: Icon(Icons.phone, color: AppColors.primary),
            title: const Text(
              "Call/WhatsApp",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pop(context);
              html.window.open("https://wa.me/918521616449", "_blank");
            },
          ),
        ],
      ),
    );
  }
}

/* ================= HERO SECTION ================= */
class HeroSection extends StatelessWidget {
  final VoidCallback onProjectTap;
  final double screenWidth;

  const HeroSection({
    super.key,
    required this.onProjectTap,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;
    final isDesktop = screenWidth >= 1024;

    final Widget textContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isMobile) const SizedBox(height: 40),

        /// 🔥 ROLE BADGE (SEO SIGNAL + GRADIENT BORDER)
        Semantics(
          label: "Senior Flutter Developer India",
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary.withOpacity(0.15), AppColors.secondary.withOpacity(0.15)],
              ),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AppColors.primary.withOpacity(0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.secondary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "🚀 Open to Work | Flutter Developer India",
                  style: AppTheme.jakarta(
                    color: AppColors.textPrimary,
                    fontSize: isMobile ? 11 : 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),

        const SizedBox(height: 25),

        /// 🔥 MAIN H1 (GRADIENT TEXT + PREMIUM OUTFIT FONT)
        Semantics(
          header: true,
          label: "Flutter Developer India building mobile and web applications",
          child: RichText(
            text: TextSpan(
              style: AppTheme.outfit(
                fontSize: isMobile ? 36 : (isTablet ? 48 : 64),
                fontWeight: FontWeight.bold,
                height: 1.1,
                letterSpacing: -1.5,
              ),
              children: [
                const TextSpan(text: "Building Premium\n"),
                TextSpan(
                  text: "Mobile & Web Apps",
                  style: TextStyle(
                    foreground: Paint()
                      ..shader = AppColors.primaryGradient.createShader(
                        const Rect.fromLTWH(0.0, 0.0, 400.0, 70.0),
                      ),
                  ),
                ),
                const TextSpan(text: "\nwith Flutter"),
              ],
            ),
          ),
        ).animate().fadeIn(delay: 150.ms, duration: 600.ms).slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),

        const SizedBox(height: 15),

        /// 🔹 NAME
        Semantics(
          label: "Abhishek Singh Flutter Developer India",
          child: Text(
            "Abhishek Singh",
            style: AppTheme.outfit(
              color: AppColors.primaryLight,
              fontSize: isMobile ? 22 : 30,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
        ).animate().fadeIn(delay: 300.ms, duration: 600.ms).slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),

        const SizedBox(height: 25),

        /// 🔹 DESCRIPTION
        Semantics(
          label: "Flutter Developer from India with expertise in Firebase REST APIs Clean Architecture",
          child: Text(
            "I transform ideas into high-performance, polished cross-platform applications with 2+ years of expertise. Specializing in Clean Architecture, state management (GetX, Provider), and scalable backends.",
            style: AppTheme.jakarta(
              color: AppColors.textSecondary,
              fontSize: isMobile ? 15 : 18,
              height: 1.6,
            ),
          ),
        ).animate().fadeIn(delay: 450.ms, duration: 600.ms).slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),

        const SizedBox(height: 40),

        /// 🔹 CTA BUTTONS
        Wrap(
          spacing: 15,
          runSpacing: 15,
          children: [
            ElevatedButton(
              onPressed: onProjectTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shadowColor: AppColors.primary.withOpacity(0.4),
                elevation: 10,
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 24 : 32,
                  vertical: isMobile ? 18 : 22,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "View My Work",
                    style: AppTheme.jakarta(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 16),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: () => html.window.open(
                "mailto:abhisingh852161@gmail.com",
                "_blank",
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.border, width: 1.5),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 24 : 32,
                  vertical: isMobile ? 18 : 22,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Hire Developer",
                style: AppTheme.jakarta(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 600.ms, duration: 600.ms).slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),
      ],
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
        vertical: isMobile ? 80 : 130,
      ),
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 7, child: textContent),
                const SizedBox(width: 40),
                Expanded(flex: 5, child: HeroImage(screenWidth: screenWidth)),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textContent,
                const SizedBox(height: 60),
                Center(child: HeroImage(screenWidth: screenWidth)),
              ],
            ),
    );
  }
}

class HeroImage extends StatelessWidget {
  final double screenWidth;

  const HeroImage({super.key, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;
    final size = isMobile ? 280.0 : (isTablet ? 340.0 : 400.0);

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Glow Orbits
          Container(
            width: size + 20,
            height: size + 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary.withOpacity(0.15), width: 1.5),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
           .scale(begin: const Offset(0.96, 0.96), end: const Offset(1.04, 1.04), duration: 3.seconds, curve: Curves.easeInOut),

          Container(
            width: size - 20,
            height: size - 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.secondary.withOpacity(0.1), width: 1),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
           .scale(begin: const Offset(1.03, 1.03), end: const Offset(0.97, 0.97), duration: 2.5.seconds, curve: Curves.easeInOut),

          // Main Avatar Card
          Container(
            width: size,
            height: size,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppColors.primary.withOpacity(0.3), AppColors.secondary.withOpacity(0.15)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.cardBg,
                image: const DecorationImage(
                  image: AssetImage("assets/images/flutter_developer_image.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // floating visual indicators (Flutter chip)
          Positioned(
            left: 10,
            top: size * 0.2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: AppTheme.glassDecoration(radius: 12),
              child: Row(
                children: [
                  const Icon(Icons.flash_on, color: Color(0xFF02569B), size: 16),
                  const SizedBox(width: 4),
                  Text("Flutter", style: AppTheme.jakarta(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
           .slideY(begin: 0, end: -0.15, duration: 1.8.seconds, curve: Curves.easeInOut),

          // floating Firebase Chip
          Positioned(
            right: 0,
            bottom: size * 0.25,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: AppTheme.glassDecoration(radius: 12),
              child: Row(
                children: [
                  const Icon(Icons.cloud, color: Color(0xFFFFCA28), size: 16),
                  const SizedBox(width: 4),
                  Text("Firebase", style: AppTheme.jakarta(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
           .slideY(begin: -0.1, end: 0.1, duration: 2.2.seconds, curve: Curves.easeInOut),
        ],
      ).animate(onPlay: (c) => c.repeat(reverse: true))
       .slideY(begin: 0, end: -0.03, duration: 3.seconds, curve: Curves.easeInOut),
    );
  }
}

/* ================= RESPONSIVE SECTIONS ================= */
class StatsSection extends StatelessWidget {
  final double screenWidth;

  const StatsSection({super.key, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    final isMobile = screenWidth < 768;

    return Container(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 40 : 60),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.darkBg, const Color(0xFF030A1C)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: const Border.symmetric(
          horizontal: BorderSide(color: AppColors.border),
        ),
      ),
      child: isMobile
          ? Column(
              children: const [
                AnimatedStatBox("2+", "Years Experience"),
                SizedBox(height: 30),
                AnimatedStatBox("12+", "Projects Delivered"),
                SizedBox(height: 30),
                AnimatedStatBox("5+", "Live Applications"),
                SizedBox(height: 30),
                AnimatedStatBox("100%", "Client Satisfaction"),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                AnimatedStatBox("2+", "Years Experience"),
                AnimatedStatBox("12+", "Projects Delivered"),
                AnimatedStatBox("5+", "Live Applications"),
                AnimatedStatBox("100%", "Client Satisfaction"),
              ],
            ),
    );
  }
}

class AboutSection extends StatelessWidget {
  final double screenWidth;

  const AboutSection({super.key, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return ResponsiveSection(
      title: "About Me",
      screenWidth: screenWidth,
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "As a passionate Flutter Developer with over 2 years of hands-on experience, "
                  "I specialize in creating robust, scalable mobile applications that solve real-world problems.",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                    height: 1.8,
                  ),
                ),
                const SizedBox(height: 30),
                QuickFactsCard(screenWidth: screenWidth),
                const SizedBox(height: 30),
                const Text(
                  "What sets me apart:",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    FeatureItem(
                      icon: Icons.bolt,
                      title: "Performance Focus",
                      description:
                          "Optimized apps with 60fps animations and minimal memory usage",
                      isMobile: isMobile,
                    ),
                    FeatureItem(
                      icon: Icons.architecture,
                      title: "Clean Code",
                      description:
                          "Following SOLID principles and Clean Architecture patterns",
                      isMobile: isMobile,
                    ),
                    FeatureItem(
                      icon: Icons.group,
                      title: "Team Collaboration",
                      description:
                          "Experience in Agile teams and cross-functional collaboration",
                      isMobile: isMobile,
                    ),
                  ],
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "As a passionate Flutter Developer with over 2 years of hands-on experience, "
                        "I specialize in creating robust, scalable mobile applications that solve real-world problems. "
                        "My expertise spans across the entire development lifecycle - from concept and design to deployment and maintenance.",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 18,
                          height: 1.8,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "What sets me apart:",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          FeatureItem(
                            icon: Icons.bolt,
                            title: "Performance Focus",
                            description:
                                "Optimized apps with 60fps animations and minimal memory usage",
                            isMobile: isMobile,
                          ),
                          FeatureItem(
                            icon: Icons.architecture,
                            title: "Clean Code",
                            description:
                                "Following SOLID principles and Clean Architecture patterns",
                            isMobile: isMobile,
                          ),
                          FeatureItem(
                            icon: Icons.group,
                            title: "Team Collaboration",
                            description:
                                "Experience in Agile teams and cross-functional collaboration",
                            isMobile: isMobile,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: isTablet ? 30 : 60),
                QuickFactsCard(screenWidth: screenWidth),
              ],
            ),
    );
  }
}

class QuickFactsCard extends StatelessWidget {
  final double screenWidth;

  const QuickFactsCard({super.key, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return Container(
      width: isMobile ? double.infinity : (isTablet ? 300 : 400),
      padding: EdgeInsets.all(isMobile ? 20 : 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.secondary.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: isMobile ? 60 : 80,
            backgroundColor: AppColors.primary,
            child: Icon(
              Icons.person,
              size: isMobile ? 70 : 100,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Quick Facts",
            style: TextStyle(
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          const InfoRow(icon: Icons.location_on, text: "Based in Lucknow, UP"),
          const InfoRow(icon: Icons.work, text: "2+ Years Experience"),
          const InfoRow(
            icon: Icons.language,
            text: "Cross-Platform Development",
          ),
          const InfoRow(icon: Icons.star, text: "Clean Architecture Expert"),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.person, size: 20),
            label: Text(
              "Connect on LinkedIn",
              style: TextStyle(fontSize: isMobile ? 14 : 16),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 30,
                vertical: isMobile ? 12 : 15,
              ),
            ),
            onPressed: () => html.window.open(
              "https://www.linkedin.com/in/abhishek-singh-flutter/",
              "_blank",
            ),
          ),
        ],
      ),
    );
  }
}
class ExperienceSection extends StatelessWidget {
  final double screenWidth;

  const ExperienceSection({super.key, required this.screenWidth});

  Widget _buildTimelineItem({
    required Widget card,
    required bool isFirst,
    required bool isLast,
    required bool isMobile,
  }) {
    if (isMobile) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: card,
      );
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left timeline line
          SizedBox(
            width: 40,
            child: Column(
              children: [
                // Line segment above dot
                Container(
                  width: 2,
                  height: 15,
                  color: isFirst ? Colors.transparent : AppColors.border.withOpacity(0.5),
                ),
                // Glowing circular node
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.darkBg,
                    border: Border.all(color: AppColors.primary, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.35),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                // Line segment below dot
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast ? Colors.transparent : AppColors.border.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: card,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = screenWidth < 768;

    return ResponsiveSection(
      title: "Professional Journey",
      screenWidth: screenWidth,
      child: Column(
        children: [
          _buildTimelineItem(
            isFirst: true,
            isLast: false,
            isMobile: isMobile,
            card: ExperienceCard(
              company: "Digital Brain Media",
              position: "Flutter Developer",
              duration: "08/2024 – 09/2026",
              location: "Lucknow, Uttar Pradesh",
              description:
                  "Leading development of enterprise-grade mobile applications using Flutter and modern architecture patterns.",
              achievements: [
                "Developed OOohApp - a comprehensive hoarding advertising platform with real-time features",
                "Implemented advanced state management solutions using GetX and Provider",
                "Integrated complex payment systems and real-time chat functionality",
                "Optimized app performance, reducing load times by 40%",
                "Mentored junior developers and established coding standards",
              ],
              screenWidth: screenWidth,
            ),
          ),
          _buildTimelineItem(
            isFirst: false,
            isLast: true,
            isMobile: isMobile,
            card: ExperienceCard(
              company: "Freelance Projects",
              position: "Mobile App Developer",
              duration: "2024 – Current",
              location: "Remote",
              description:
                  "Worked with various clients to deliver custom mobile solutions across different industries.",
              achievements: [
                "Developed 10+ production-ready applications for diverse business needs",
                "Specialized in Firebase backend integration and REST API development",
                "Created responsive UIs that work seamlessly across all device sizes",
                "Implemented secure authentication and data storage solutions",
                "Provided ongoing maintenance and feature enhancements",
              ],
              screenWidth: screenWidth,
            ),
          ),
        ],
      ),
    );
  }
}
class SkillsSection extends StatelessWidget {
  final double screenWidth;

  const SkillsSection({super.key, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    final isMobile = screenWidth < 768;

    return ResponsiveSection(
      title: "Technical Expertise",
      screenWidth: screenWidth,
      child: Column(
        children: [
          const Text(
            "I bring a comprehensive skill set to every project, combining technical expertise with practical experience.",
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 18,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 50),
          isMobile
              ? Column(
                  children: [
                    SkillCategory(
                      title: "Core Technologies",
                      skills: [
                        SkillItem(name: "Flutter", level: 0.95),
                        SkillItem(name: "Dart", level: 0.9),
                        SkillItem(name: "Firebase", level: 0.85),
                        SkillItem(name: "REST APIs", level: 0.9),
                      ],
                    ),
                    const SizedBox(height: 30),
                    SkillCategory(
                      title: "State Management",
                      skills: [
                        SkillItem(name: "GetX", level: 0.95),
                        SkillItem(name: "Provider", level: 0.85),
                        SkillItem(name: "Bloc", level: 0.75),
                      ],
                    ),
                    const SizedBox(height: 30),
                    SkillCategory(
                      title: "Architecture & Tools",
                      skills: [
                        SkillItem(name: "Clean Architecture", level: 0.9),
                        SkillItem(name: "MVVM", level: 0.85),
                        SkillItem(name: "Git/GitHub", level: 0.95),
                        SkillItem(name: "CI/CD", level: 0.8),
                      ],
                    ),
                    const SizedBox(height: 30),
                    SkillCategory(
                      title: "Soft Skills",
                      skills: [
                        SkillItem(name: "Problem Solving", level: 0.95),
                        SkillItem(name: "Team Collaboration", level: 0.9),
                        SkillItem(name: "Communication", level: 0.85),
                        SkillItem(name: "Project Management", level: 0.8),
                      ],
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          SkillCategory(
                            title: "Core Technologies",
                            skills: [
                              SkillItem(name: "Flutter", level: 0.95),
                              SkillItem(name: "Dart", level: 0.9),
                              SkillItem(name: "Firebase", level: 0.85),
                              SkillItem(name: "REST APIs", level: 0.9),
                            ],
                          ),
                          const SizedBox(height: 30),
                          SkillCategory(
                            title: "State Management",
                            skills: [
                              SkillItem(name: "GetX", level: 0.95),
                              SkillItem(name: "Provider", level: 0.85),
                              SkillItem(name: "Bloc", level: 0.75),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      child: Column(
                        children: [
                          SkillCategory(
                            title: "Architecture & Tools",
                            skills: [
                              SkillItem(name: "Clean Architecture", level: 0.9),
                              SkillItem(name: "MVVM", level: 0.85),
                              SkillItem(name: "Git/GitHub", level: 0.95),
                              SkillItem(name: "CI/CD", level: 0.8),
                            ],
                          ),
                          const SizedBox(height: 30),
                          SkillCategory(
                            title: "Soft Skills",
                            skills: [
                              SkillItem(name: "Problem Solving", level: 0.95),
                              SkillItem(name: "Team Collaboration", level: 0.9),
                              SkillItem(name: "Communication", level: 0.85),
                              SkillItem(name: "Project Management", level: 0.8),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

class ProjectsSection extends StatelessWidget {
  final double screenWidth;

  const ProjectsSection({super.key, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    final List<Map<String, dynamic>> projects = [
      {
        'title': "OohApp",
        'desc':
            "Users can discover hoardings, book ad slots instantly, chat with vendors, and make secure online payments in real time.",
        'image':
            "https://media.licdn.com/dms/image/v2/C4D0BAQGyw7yMGZiCeA/company-logo_200_200/company-logo_200_200/0/1670391601134?e=2147483647&v=beta&t=63jZbHgdX3bCQvXsa--AsJ6QN23dsK3MPPoqh7EO6wc",
        'link':
            "https://drive.google.com/file/d/1krfre-SkYHgV_KXwwPBbGYxIGklfemFu/view",
        'technologies': ["Flutter", "Firebase", "Stripe", "REST APIs"],
      },
      {
        'title': "OohApp Vendor",
        'desc':
            "Vendors can manage hoardings, accept bookings, chat with clients, track payments, and control ad inventory from one place.",
        'image':
            "data:image/png;base64,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",
        'link':
            "https://drive.google.com/file/d/1PyvWJI1T_Ypb4iijGKZNyiMkSUYdpnAQ/view",
        'technologies': ["Flutter", "Firebase", "Stripe", "REST APIs"],
      },
      {
        'title': "X-EED Education",
        'desc':
            "Students can prepare for exams using offline video lessons, downloadable PDFs, and structured learning content anytime.",
        'image': "https://images.unsplash.com/photo-1563013544-824ae1b704d3",
        'link':
            "https://play.google.com/store/apps/details?id=com.elkuzn.vnrjxk",
        'technologies': ["Flutter", "Firebase", "SQLite", "REST APIs"],
      },
      {
        'title': "TaskCheck Pro",
        'desc':
            "Organizations can track staff attendance, monitor field employees via GPS, and manage workforce tasks efficiently.",
        'image':
            "https://play-lh.googleusercontent.com/4LAgxwF9FmigsSjdDNIuzIub3FWH7KeTyUlfNsAVX7C1dnjR2p134gFDKWmMf7zM2_s=w5120-h2880-rw",
        'link': "https://play.google.com/store/apps/details?id=com.dbm.sgt",
        'technologies': ["Flutter", "Google Maps", "Provider", "REST APIs"],
      },
      {
        'title': "Veernai Business",
        'desc':
            "Users can find nearby services, book professionals instantly, and get reliable hyperlocal solutions at their doorstep.",
        'image':
            "https://play-lh.googleusercontent.com/-CXehrHeTrEyeIhVx-3k16GyKT7CXD6jJmtqZ41J7EtTLmyGp9XnGhULjzJ19by6lug=w240-h480-rw",
        'link':
            "https://play.google.com/store/apps/details?id=com.veernaic.customer",
        'technologies': ["Flutter", "Firebase", "REST APIs"],
      },
      {
        'title': "Veernai : Say Goodbye to Crowd",
        'desc':
            "Customers can avoid long queues by booking local services in advance and accessing hassle-free service experiences.",
        'image':
            "https://play-lh.googleusercontent.com/6v4U8ezRuSsoHdLetw3UUvfiQdBHS1Rd05npzjkIadrhPxEOSrtzpSgC8bZwHrQbUQ=w480-h960-rw",
        'link':
            "https://play.google.com/store/apps/details?id=com.veernaic.customer",
        'technologies': ["Flutter", "Firebase", "REST APIs"],
      },
      {
        'title': "Giftaras",
        'desc':
            "Giftaras is a digital gift voucher application that allows users to purchase and share gift vouchers securely. The app provides a seamless shopping experience with wishlist, cart, secure payments, and user profile management.",
        'image': "https://play-lh.googleusercontent.com/0MbMD-xtoHGFIN5mNw_jv_S47y7ofqCj4y8Y7Q22pverDszXIGdVh-ofnZrb0hz_CToIcUsfDVnlAiP2SW4lRg",
        'link':
            "https://play.google.com/store/apps/details?id=com.giftaras.voucher",
        'technologies': ["Flutter", "Firebase", "REST APIs", "Payment Gateway"],
      },
      {
        'title': "Sudo Messenger – Web3 Messaging Platform",
        'desc':
            "Built a cross-platform Web3 messaging application with Signal Protocol based end-to-end encryption, real-time 1:1 chat and calling using WebSockets, and passwordless Web3 wallet authentication.",
        'image':
            "https://play-lh.googleusercontent.com/_uhhyEzdXtMYnK6NvObY6Ml_M8PrB2fK-kEQeNEqZmbIsm0tN2UgdPcfm0-OMHLximyKcskrd0exXOCk14k_dA",
        'link': "https://web.sudochat.app/",
        'technologies': [
          "Flutter",
          "Dart",
          "REST APIs",
          "WebSockets",
          "Web3",
          "WalletConnect",
          "Signal Protocol",
          "GetX",
          "Secure Storage"
        ],
      },
      {
        'title': "Adgon – E-commerce App",
        'desc':
            "Developed a complete e-commerce shopping journey with dynamic product catalogs, search and filtering, cart management, and payment gateway integration.",
        'image':
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRNWKGQGrzb3TAC7J7wXJTr50TekZwru1vFBcj9Suo2vPiuVr79qE46cBU&s=10",
        'link':
            "https://play.google.com/store/apps/details?id=com.adgon.app&pcampaignid=web_share",
        'technologies': [
          "Flutter",
          "Dart",
          "REST APIs",
          "Provider/GetX",
          "Firebase"
        ],
      },
      {
        'title': "Metro Disha – Metro Routes",
        'desc':
            "Engineered multi-city route navigation for 7 metro networks featuring fare calculation, travel time, interchange paths, and route guidance.",
        'image':
            "https://thumbs.dreamstime.com/b/isolated-modern-metro-train-transparent-png-background-realistic-city-design-illustration-projects-stunning-perfect-385303626.jpg",
        'link':
            "https://play.google.com/store/apps/details?id=com.metro.disha&pcampaignid=web_share",
        'technologies': ["Flutter", "Dart", "Firebase", "Google Maps API"],
      },
    ];

    return ResponsiveSection(
      title: "Featured Projects",
      screenWidth: screenWidth,
      child: Column(
        children: [
          const Text(
            "Each project represents a unique challenge and learning opportunity. Here are some of my most impactful works.",
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 18,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 50),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: _calculateAspectRatio(screenWidth),
            ),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];

              return AnimatedProjectCard(
                title: project['title'],
                desc: project['desc'],
                image: project['image'],
                link: project['link'],
                technologies: (project['technologies'] as List).cast<String>(),
                screenWidth: screenWidth,
              );
            },
          ),
        ],
      ),
    );
  }

  static double _calculateAspectRatio(double screenWidth) {
    if (screenWidth < 480) return 1.7;
    if (screenWidth < 768) return 1.5;
    if (screenWidth < 1024) return 0.85;
    return 0.75;
  }
}

class EducationSection extends StatelessWidget {
  final double screenWidth;

  const EducationSection({super.key, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSection(
      title: "Education & Certifications",
      screenWidth: screenWidth,
      child: Column(
        children: [
          EducationCard(
            institution: "Maulana Mazharul Haque Arabic & Persian University",
            degree: "Bachelor of Computer Applications (BCA)",
            duration: "2021 – 2024",
            location: "Patna, Bihar",
            description:
                "Specialized in software development, algorithms, and database management. Graduated with honors.",
            icon: Icons.school,
            screenWidth: screenWidth,
          ),
          const SizedBox(height: 20),
          EducationCard(
            institution: "Flutter & Dart Certification",
            degree: "Advanced Mobile Development",
            duration: "2023",
            location: "Online",
            description:
                "Certified in advanced Flutter concepts, Clean Architecture, and state management patterns.",
            icon: Icons.verified,
            screenWidth: screenWidth,
          ),
          const SizedBox(height: 20),
          EducationCard(
            institution: "Google Firebase Certification",
            degree: "Backend Development",
            duration: "2023",
            location: "Online",
            description:
                "Expertise in Firebase services including Authentication, Firestore, Cloud Functions, and FCM.",
            icon: Icons.cloud,
            screenWidth: screenWidth,
          ),
        ],
      ),
    );
  }
}

class ResumeBanner extends StatelessWidget {
  final double screenWidth;

  const ResumeBanner({super.key, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    final isMobile = screenWidth < 768;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 40 : 80),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.05),
            AppColors.secondary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Text(
            textAlign: TextAlign.center,

            "Ready to Build Something Amazing?",
            style: TextStyle(
              fontSize: isMobile ? 28 : 42,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            textAlign: TextAlign.center,

            "Let's collaborate to create innovative mobile solutions that drive business success.",
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: isMobile ? 16 : 20,
            ),
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 15,
            runSpacing: 15,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.download, size: 20),
                label: Text(
                  "Download Resume",
                  style: TextStyle(fontSize: isMobile ? 14 : 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 30 : 40,
                    vertical: isMobile ? 18 : 25,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () => html.window.open(
                  "https://drive.google.com/file/d/1zOnpW-b6TpTgGxu4vkicfleNfqBiix1R/view",
                  "_blank",
                ),
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.video_call, size: 20),
                label: Text(
                  "Schedule a Call",
                  style: TextStyle(fontSize: isMobile ? 14 : 16),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 30 : 40,
                    vertical: isMobile ? 18 : 25,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () =>
                    html.window.open("https://calendly.com", "_blank"),
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.code, size: 20),
                label: Text(
                  "View GitHub",
                  style: TextStyle(fontSize: isMobile ? 14 : 16),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 30 : 40,
                    vertical: isMobile ? 18 : 25,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () => html.window.open(
                  "https://github.com/abhisinghcpr",
                  "_blank",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ContactSection extends StatelessWidget {
  final double screenWidth;

  const ContactSection({super.key, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    final isMobile = screenWidth < 768;

    return ResponsiveSection(
      title: "Let's Connect",
      screenWidth: screenWidth,
      child: isMobile
          ? Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    ContactCard(
                      icon: Icons.email,
                      title: "Email",
                      value: "abhisingh852161@gmail.com",
                    ),
                    SizedBox(height: 15),
                    ContactCard(
                      icon: Icons.phone,
                      title: "Phone/WhatsApp",
                      value: "+91 8521616449",
                    ),
                    SizedBox(height: 15),
                    ContactCard(
                      icon: Icons.location_on,
                      title: "Location",
                      value: "Lucknow, Uttar Pradesh, India",
                    ),
                    SizedBox(height: 15),
                    ContactCard(
                      icon: Icons.person,
                      title: "LinkedIn",
                      value: "@abhishek-singh-flutter",
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                ContactForm(screenWidth: screenWidth),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      ContactCard(
                        icon: Icons.email,
                        title: "Email",
                        value: "abhisingh852161@gmail.com",
                      ),
                      SizedBox(height: 20),
                      ContactCard(
                        icon: Icons.phone,
                        title: "Phone/WhatsApp",
                        value: "+91 8521616449",
                      ),
                      SizedBox(height: 20),
                      ContactCard(
                        icon: Icons.location_on,
                        title: "Location",
                        value: "Lucknow, Uttar Pradesh, India",
                      ),
                      SizedBox(height: 20),
                      ContactCard(
                        icon: Icons.person,
                        title: "LinkedIn",
                        value: "@abhishek-singh-flutter",
                      ),
                    ],
                  ),
                ),
                SizedBox(width: isMobile ? 0 : 60),
                Expanded(child: ContactForm(screenWidth: screenWidth)),
              ],
            ),
    );
  }
}

class ContactForm extends StatelessWidget {
  final double screenWidth;

  const ContactForm({super.key, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    final isMobile = screenWidth < 768;

    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.secondary.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(
            "Send me a message",
            style: TextStyle(
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(
              labelText: "Your Name",
              labelStyle: const TextStyle(color: AppColors.textSecondary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),
          const SizedBox(height: 15),
          TextFormField(
            decoration: InputDecoration(
              labelText: "Your Email",
              labelStyle: const TextStyle(color: AppColors.textSecondary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),
          const SizedBox(height: 15),
          TextFormField(
            maxLines: 5,
            decoration: InputDecoration(
              labelText: "Your Message",
              labelStyle: const TextStyle(color: AppColors.textSecondary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () =>
                html.window.open("mailto:abhisingh852161@gmail.com", "_blank"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 30 : 40,
                vertical: isMobile ? 16 : 20,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              "Send Message",
              style: TextStyle(fontSize: isMobile ? 14 : 16),
            ),
          ),
        ],
      ),
    );
  }
}

class Footer extends StatelessWidget {
  final double screenWidth;

  const Footer({super.key, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    final isMobile = screenWidth < 768;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 30 : 40,
        horizontal: isMobile ? 20 : 40,
      ),
      decoration: BoxDecoration(
        border: const Border(top: BorderSide(color: AppColors.border)),
        gradient: LinearGradient(colors: [AppColors.darkBg, Colors.black]),
      ),
      child: Column(
        children: [
          /// 🔥 AUTHOR ENTITY
          const Text(
            "Abhishek Singh",
            semanticsLabel:
                "Abhishek Singh Flutter Developer India Portfolio Website",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 10),

          /// 🔥 KEYWORD STACK (NO SPAM)
          Text(
            "Flutter Developer India",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: isMobile ? 14 : 16,
            ),
          ),

          const SizedBox(height: 20),

          /// 🔹 TRUST LINKS
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SocialIcon(
                icon: Icons.code,
                tooltip: "Abhishek Singh GitHub",
                onTap: () => html.window.open(
                  "https://github.com/abhisinghcpr",
                  "_blank",
                ),
              ),
              const SizedBox(width: 15),
              SocialIcon(
                icon: Icons.person,
                tooltip: "Abhishek Singh LinkedIn",
                onTap: () => html.window.open(
                  "https://www.linkedin.com/in/abhishek-singh-flutter/",
                  "_blank",
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// 🔹 COPYRIGHT
          Text(
            "© 2024 Abhishek Singh – Flutter Developer Portfolio",
            style: TextStyle(
              color: Colors.white24,
              fontSize: isMobile ? 10 : 12,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            "Built with Flutter • Hosted on GitHub Pages",
            style: TextStyle(
              color: Colors.white24,
              fontSize: isMobile ? 10 : 12,
            ),
          ),
        ],
      ),
    );
  }
}

/* ================= RESPONSIVE COMPONENTS ================= */
class ResponsiveSection extends StatelessWidget {
  final String title;
  final Widget child;
  final double screenWidth;

  const ResponsiveSection({
    super.key,
    required this.title,
    required this.child,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = screenWidth < 768;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: screenWidth > 1200 ? 1200 : screenWidth,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : (screenWidth < 1024 ? 40 : 80),
        vertical: isMobile ? 60 : 100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: AppColors.secondary,
              fontSize: isMobile ? 12 : 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 10),
          Container(height: 4, width: 50, color: AppColors.primary),
          SizedBox(height: isMobile ? 30 : 50),
          child,
        ],
      ),
    );
  }
}

/* ================= ENHANCED COMPONENTS ================= */

class AnimatedStatBox extends StatefulWidget {
  final String value;
  final String label;

  const AnimatedStatBox(this.value, this.label, {super.key});

  @override
  State<AnimatedStatBox> createState() => _AnimatedStatBoxState();
}

class _AnimatedStatBoxState extends State<AnimatedStatBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: 1 + (_animation.value * 0.1),
          child: Opacity(
            opacity: _animation.value,
            child: Column(
              children: [
                Text(
                  widget.value,
                  style: TextStyle(
                    fontSize: 32 + (_animation.value * 10),
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.label,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isMobile;

  const FeatureItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(isMobile ? 15 : 20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isMobile ? 10 : 12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: isMobile ? 20 : 24,
            ),
          ),
          SizedBox(width: isMobile ? 15 : 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: isMobile ? 12 : 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class ExperienceCard extends StatefulWidget {
  final String company;
  final String position;
  final String duration;
  final String location;
  final String description;
  final List<String> achievements;
  final double screenWidth;

  const ExperienceCard({
    super.key,
    required this.company,
    required this.position,
    required this.duration,
    required this.location,
    required this.description,
    required this.achievements,
    required this.screenWidth,
  });

  @override
  State<ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<ExperienceCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = widget.screenWidth < 768;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        transform: Matrix4.translationValues(_isHovered ? 6 : 0, 0, 0),
        padding: EdgeInsets.all(isMobile ? 20 : 30),
        decoration: AppTheme.glassDecoration(
          radius: 20,
          showGlow: _isHovered,
          fillCol: _isHovered 
              ? AppColors.cardBg.withOpacity(0.7) 
              : AppColors.cardBg.withOpacity(0.4),
          borderCol: _isHovered 
              ? AppColors.primary.withOpacity(0.6) 
              : AppColors.border.withOpacity(0.3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.company,
                        style: AppTheme.outfit(
                          fontSize: isMobile ? 18 : 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.position,
                        style: AppTheme.jakarta(
                          fontSize: isMobile ? 15 : 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryLight,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.duration,
                        style: AppTheme.jakarta(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.location,
                        style: AppTheme.jakarta(
                          color: AppColors.textMuted,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.company,
                            style: AppTheme.outfit(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.position,
                            style: AppTheme.jakarta(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryLight,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            widget.duration,
                            style: AppTheme.jakarta(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.location,
                            style: AppTheme.jakarta(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
            const SizedBox(height: 20),
            Text(
              widget.description,
              style: AppTheme.jakarta(
                color: AppColors.textSecondary,
                fontSize: isMobile ? 14 : 16,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Key Achievements:",
              style: AppTheme.outfit(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            ...widget.achievements
                .map(
                  (achievement) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            achievement,
                            style: AppTheme.jakarta(
                              color: AppColors.textSecondary,
                              fontSize: isMobile ? 14 : 15,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}

class SkillCategory extends StatelessWidget {
  final String title;
  final List<SkillItem> skills;

  const SkillCategory({super.key, required this.title, required this.skills});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: AppTheme.glassDecoration(
        radius: 20,
        fillCol: AppColors.cardBg.withOpacity(0.4),
        borderCol: AppColors.border.withOpacity(0.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          ...skills
              .map(
                (skill) => Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          skill.name,
                          style: AppTheme.jakarta(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "${(skill.level * 100).toInt()}%",
                          style: AppTheme.jakarta(
                            color: AppColors.primaryLight,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: skill.level,
                        minHeight: 6,
                        backgroundColor: AppColors.border.withOpacity(0.5),
                        color: AppColors.primaryLight,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}

class SkillItem {
  final String name;
  final double level;

  SkillItem({required this.name, required this.level});
}

class AnimatedProjectCard extends StatefulWidget {
  final String title;
  final String desc;
  final String image;
  final String link;
  final List<String> technologies;
  final double screenWidth;

  const AnimatedProjectCard({
    super.key,
    required this.title,
    required this.desc,
    required this.image,
    required this.link,
    required this.technologies,
    required this.screenWidth,
  });

  @override
  State<AnimatedProjectCard> createState() => _AnimatedProjectCardState();
}

class _AnimatedProjectCardState extends State<AnimatedProjectCard> {
  bool _isHovered = false;

  bool get _isNetworkImage {
    return widget.image.startsWith('http') ||
        widget.image.startsWith('https') ||
        widget.image.startsWith('data:image');
  }

  /// 🔹 Handles Network + Base64 + Asset images with CORS proxy support
  Widget _buildImage() {
    if (_isNetworkImage) {
      String imageUrl = widget.image;
      if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
        imageUrl = 'https://images.weserv.nl/?url=${Uri.encodeComponent(imageUrl)}';
      }
      return CachedNetworkImage(
        imageUrl: imageUrl,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) =>
            const CupertinoActivityIndicator(radius: 2),
        errorWidget: (context, url, error) => CachedNetworkImage(
          imageUrl: widget.image,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => Container(
            color: AppColors.cardBg,
            child: const Center(
              child: Icon(
                Icons.image_outlined,
                size: 40,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
      );
    }

    // Asset Image
    return Image.asset(
      widget.image,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSmallMobile = widget.screenWidth < 480;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => html.window.open(widget.link, "_blank"),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered ? AppColors.primary : AppColors.border,
              width: 1,
            ),
            boxShadow: [
              if (_isHovered)
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🖼 Image
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      _buildImage(),
                      if (_isHovered)
                        Container(
                          color: AppColors.primary.withOpacity(0.2),
                          child: const Center(
                            child: Icon(
                              Icons.visibility,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              /// 📄 Content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(isSmallMobile ? 12 : 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Title
                          Text(
                            widget.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: isSmallMobile ? 16 : 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 6),

                          /// Description
                          SizedBox(
                            height: isSmallMobile ? 40 : 50,
                            child: Text(
                              widget.desc,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: isSmallMobile ? 12 : 14,
                                color: AppColors.textSecondary,
                                height: 1.4,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          /// Technologies
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: widget.technologies
                                .take(3)
                                .map(
                                  (tech) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: AppColors.primary.withOpacity(
                                          0.3,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      tech,
                                      style: TextStyle(
                                        fontSize: isSmallMobile ? 10 : 11,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),

                      /// 🔗 View Details Button
                      Container(
                        margin: const EdgeInsets.only(top: 12),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.primary),
                          color: _isHovered
                              ? AppColors.primary.withOpacity(0.1)
                              : Colors.transparent,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "View Details",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: isSmallMobile ? 12 : 13,
                              ),
                            ),
                            const SizedBox(width: 6),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              transform: Matrix4.translationValues(
                                _isHovered ? 3 : 0,
                                0,
                                0,
                              ),
                              child: Icon(
                                Icons.arrow_forward,
                                size: isSmallMobile ? 12 : 14,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EducationCard extends StatelessWidget {
  final String institution;
  final String degree;
  final String duration;
  final String location;
  final String description;
  final IconData icon;
  final double screenWidth;

  const EducationCard({
    super.key,
    required this.institution,
    required this.degree,
    required this.duration,
    required this.location,
    required this.description,
    required this.icon,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = screenWidth < 768;

    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 30),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isMobile ? 15 : 20),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              size: isMobile ? 30 : 40,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: isMobile ? 15 : 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  institution,
                  style: TextStyle(
                    fontSize: isMobile ? 18 : 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  degree,
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: isMobile ? 14 : 16,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      location,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    if (duration.isNotEmpty)
                      Text(
                        duration,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;

  const ContactCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class SocialIcon extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const SocialIcon({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  State<SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<SocialIcon> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _isHovered
                  ? AppColors.primary.withOpacity(0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _isHovered ? AppColors.primary : AppColors.border,
                width: _isHovered ? 2 : 1,
              ),
            ),
            child: Icon(
              widget.icon,
              color: _isHovered ? AppColors.primary : Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}

/* ================= EXISTING COMPONENTS ================= */

class HoverText extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const HoverText({super.key, required this.text, required this.onTap});

  @override
  State<HoverText> createState() => _HoverTextState();
}

class _HoverTextState extends State<HoverText> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHover = true),
      onExit: (_) => setState(() => isHover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            widget.text,
            style: TextStyle(
              color: isHover ? AppColors.primary : Colors.white,
              fontWeight: isHover ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
