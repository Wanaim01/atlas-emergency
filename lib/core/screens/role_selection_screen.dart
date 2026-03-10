import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/generated/app_localizations.dart';
import '../providers/app_provider.dart';
import '../widgets/settings_sheet.dart';
import '../../patient/screens/patient_auth_screen.dart';
import '../../driver/screens/driver_auth_screen.dart';
import '../../hospital/screens/hospital_auth_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<AppProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isArabic = provider.isArabic;
    final colorScheme = Theme.of(context).colorScheme;

    final roles = [
      _RoleData(
        title: l10n.patient,
        subtitle: l10n.patientSubtitle,
        icon: Icons.emergency_outlined,
        color: isDark ? const Color(0xFFEF4444) : const Color(0xFFDC2626),
        lightGradient: const [Color(0xFFFEE2E2), Color(0xFFFECACA)],
        darkGradient: const [Color(0xFF7F1D1D), Color(0xFF991B1B)],
      ),
      _RoleData(
        title: l10n.driver,
        subtitle: l10n.driverSubtitle,
        icon: Icons.local_shipping_outlined,
        color: isDark ? const Color(0xFF10B981) : const Color(0xFF059669),
        lightGradient: const [Color(0xFFD1FAE5), Color(0xFFA7F3D0)],
        darkGradient: const [Color(0xFF064E3B), Color(0xFF065F46)],
      ),
      _RoleData(
        title: l10n.hospital,
        subtitle: l10n.hospitalSubtitle,
        icon: Icons.local_hospital_outlined,
        color: isDark ? const Color(0xFF3B82F6) : const Color(0xFF2563EB),
        lightGradient: const [Color(0xFFDBEAFE), Color(0xFFBFDBFE)],
        darkGradient: const [Color(0xFF1E3A8A), Color(0xFF1E40AF)],
      ),
    ];

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Bar with Logo and Settings
                Row(
                  children: [
                    // Logo
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDark 
                            ? [colorScheme.primary, colorScheme.primary.withOpacity(0.8)]
                            : [const Color(0xFF0F766E), const Color(0xFF115E59)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.health_and_safety,
                        color: colorScheme.onPrimary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ATLAS',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: colorScheme.onSurface,
                            letterSpacing: 2,
                          ),
                        ),
                        Text(
                          'EMERGENCY',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.primary,
                            letterSpacing: 3,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Settings Button
                    _IconButton(
                      icon: Icons.settings_outlined,
                      onTap: () => _showSettings(context),
                      isDark: isDark,
                    ),
                    const SizedBox(width: 8),
                    // Language Toggle
                    _IconButton(
                      icon: Icons.language,
                      onTap: () => provider.toggleLanguage(),
                      label: provider.languageCode.toUpperCase(),
                      isDark: isDark,
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                const SizedBox(height: 32),

                // Role Cards
                Expanded(
                  child: ListView.separated(
                    itemCount: roles.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final role = roles[index];
                      final isSelected = selectedIndex == index;
                      final gradient = isDark ? role.darkGradient : role.lightGradient;

                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 1.0, end: isSelected ? 0.98 : 1.0),
                        duration: const Duration(milliseconds: 200),
                        builder: (context, scale, child) {
                          return Transform.scale(
                            scale: scale,
                            child: GestureDetector(
                              onTapDown: (_) => setState(() => selectedIndex = index),
                              onTapUp: (_) => setState(() => selectedIndex = null),
                              onTapCancel: () => setState(() => selectedIndex = null),
                              onTap: () => _navigateToRole(context, index),
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: colorScheme.surface,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: isSelected 
                                      ? role.color 
                                      : colorScheme.outline.withOpacity(0.5),
                                    width: isSelected ? 2 : 1,
                                  ),
                                  boxShadow: isSelected ? [
                                    BoxShadow(
                                      color: role.color.withOpacity(0.2),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ] : isDark ? [] : [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.03),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 64,
                                      height: 64,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: gradient,
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Icon(
                                        role.icon,
                                        color: role.color,
                                        size: 32,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            role.title,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: colorScheme.onSurface,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            role.subtitle,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: colorScheme.onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: role.color.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Icon(
                                        isArabic ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
                                        color: role.color,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Emergency Button
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFDC2626).withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _showEmergencyDialog(context),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: double.infinity,
                        height: 64,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.emergency,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              l10n.emergencyCall,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToRole(BuildContext context, int index) {
    final screens = [
      const PatientAuthScreen(),
      const DriverAuthScreen(),
      const HospitalAuthScreen(),
    ];
    
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screens[index]),
    );
  }

  void _showEmergencyDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFDC2626).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.emergency, color: Color(0xFFDC2626)),
            ),
            const SizedBox(width: 12),
            Text(
              l10n.emergencyDialogTitle,
              style: TextStyle(color: colorScheme.onSurface),
            ),
          ],
        ),
        content: Text(
          l10n.emergencyDialogContent,
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
            ),
            child: Text(l10n.callNow),
          ),
        ],
      ),
    );
  }

  void _showSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const SettingsSheet(),
    );
  }
}

class _RoleData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<Color> lightGradient;
  final List<Color> darkGradient;

  _RoleData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.lightGradient,
    required this.darkGradient,
  });
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String? label;
  final bool isDark;

  const _IconButton({
    required this.icon,
    required this.onTap,
    this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? colorScheme.surface : colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outline.withOpacity(0.5),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: colorScheme.onSurface),
            if (label != null) ...[
              const SizedBox(width: 4),
              Text(
                label!,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}