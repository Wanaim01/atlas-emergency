import 'dart:ui';

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
    final isArabic = provider.isArabic;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final roles = [
      _RoleData(
        title: l10n.patient,
        subtitle: l10n.patientSubtitle,
        icon: Icons.emergency_outlined,
        color: isDark ? const Color(0xFFEF4444) : const Color(0xFFDC2626),
        lightGradient: const [Color(0xFFfee2e2), Color(0xFFfecaca)],
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

    final backgroundGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white,
        Colors.white,
        Colors.white,
      ],
    );
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned.fill(
              child: Container(decoration: BoxDecoration(gradient: backgroundGradient)),
            ),
            Positioned(
              top: -100,
              right: -60,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    colors: [Colors.white70, Colors.transparent],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -140,
              left: -80,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    colors: [Colors.white60, Colors.transparent],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeaderBar(
                      isArabic: isArabic,
                      provider: provider,
                      onSettingsTap: () => _showSettings(context),
                    ),
                    const SizedBox(height: 28),
                    Expanded(
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount: roles.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final role = roles[index];
                          final isSelected = selectedIndex == index;
                          return _RoleCard(
                            role: role,
                            isSelected: isSelected,
                            isArabic: isArabic,
                            onTap: () {
                              setState(() => selectedIndex = index);
                              _navigateToRole(context, index);
                            },
                            onHighlightChanged: (pressed) {
                              setState(() => selectedIndex = pressed ? index : null);
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    _EmergencyButton(onTap: () => _showEmergencyDialog(context)),
                  ],
                ),
              ),
            ),
          ],
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
            onPressed: () => Navigator.pop(context),
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

class _HeaderBar extends StatelessWidget {
  final bool isArabic;
  final AppProvider provider;
  final VoidCallback onSettingsTap;

  const _HeaderBar({
    required this.isArabic,
    required this.provider,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primary.withOpacity(0.95),
                colorScheme.primaryContainer.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.25),
                blurRadius: 16,
                offset: const Offset(0, 8),
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
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
                color: colorScheme.onSurface,
              ),
            ),
            Text(
              'EMERGENCY',
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 2,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const Spacer(),
        _IconButton(
          icon: Icons.settings_outlined,
          onTap: onSettingsTap,
        ),
        const SizedBox(width: 12),
        _IconButton(
          icon: Icons.language,
          onTap: () => provider.toggleLanguage(),
          label: provider.languageCode.toUpperCase(),
        ),
      ],
    );
  }
}

class _RoleCard extends StatelessWidget {
  final _RoleData role;
  final bool isSelected;
  final bool isArabic;
  final VoidCallback onTap;
  final ValueChanged<bool>? onHighlightChanged;

  const _RoleCard({
    required this.role,
    required this.isSelected,
    required this.isArabic,
    required this.onTap,
    this.onHighlightChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final gradient = isSelected ? role.darkGradient : role.lightGradient;
    final baseColor = isSelected ? role.color.withOpacity(0.85) : Colors.white.withOpacity(0.15);

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradient,
            ),
            border: Border.all(
              color: isSelected ? role.color : Colors.white.withOpacity(0.2),
              width: isSelected ? 2.2 : 1,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: baseColor.withOpacity(isSelected ? 0.35 : 0.25),
                blurRadius: isSelected ? 30 : 18,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: onTap,
              onHighlightChanged: onHighlightChanged,
              borderRadius: BorderRadius.circular(24),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: gradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Icon(role.icon, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            role.title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: colorScheme.onBackground,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            role.subtitle,
                            style: TextStyle(
                              fontSize: 14,
                              color: colorScheme.onBackground.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      isArabic ? Icons.keyboard_arrow_left : Icons.keyboard_arrow_right,
                      color: Colors.white,
                      size: 32,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmergencyButton extends StatelessWidget {
  final VoidCallback onTap;

  const _EmergencyButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDC2626).withOpacity(0.4),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.emergency, color: Colors.white, size: 26),
                const SizedBox(width: 12),
                Text(
                  AppLocalizations.of(context)!.emergencyCall,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String? label;

  const _IconButton({
    required this.icon,
    required this.onTap,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: colorScheme.surface.withOpacity(0.7),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: colorScheme.onSurface),
              if (label != null) ...[
                const SizedBox(width: 6),
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
      ),
    );
  }
}
