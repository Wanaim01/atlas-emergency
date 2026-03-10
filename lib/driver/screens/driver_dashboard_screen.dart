import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/app_provider.dart';
import '../widgets/driver_profile_card.dart';
import '../widgets/emergency_request_card.dart';

class DriverDashboardScreen extends StatefulWidget {
  const DriverDashboardScreen({super.key});

  @override
  State<DriverDashboardScreen> createState() => _DriverDashboardScreenState();
}

class _DriverDashboardScreenState extends State<DriverDashboardScreen> {
  bool _isOnline = false;
  bool _hasEmergencyRequest = false;
  int _selectedTab = 0;
  Hospital? _selectedHospital;

  // Sample hospitals in Taroudant, Morocco
  final List<Hospital> _hospitals = [
    Hospital(
      id: '1',
      name: 'Centre Hospitalier Provincial',
      nameAr: 'المستشفى الإقليمي',
      address: 'Boulevard Mohammed V, Taroudant',
      phone: '+212 5285-52000',
      bedsAvailable: 12,
      distance: '2.3 km',
      latitude: 30.4720,
      longitude: -8.8770,
      type: 'Public',
    ),
    Hospital(
      id: '2',
      name: 'Clinique Al Azhar',
      nameAr: 'عيادة الأزهر',
      address: 'Quartier El Boustane, Taroudant',
      phone: '+212 5285-41234',
      bedsAvailable: 5,
      distance: '3.1 km',
      latitude: 30.4680,
      longitude: -8.8850,
      type: 'Private',
    ),
    Hospital(
      id: '3',
      name: 'Hôpital Militaire',
      nameAr: 'المستشفى العسكري',
      address: 'Route de Oulad Teima, Taroudant',
      phone: '+212 5285-55000',
      bedsAvailable: 8,
      distance: '4.5 km',
      latitude: 30.4750,
      longitude: -8.8720,
      type: 'Military',
    ),
    Hospital(
      id: '4',
      name: 'Clinique Dar Al Shifa',
      nameAr: 'عيادة دار الشفاء',
      address: 'Avenue Hassan II, Taroudant',
      phone: '+212 5285-43000',
      bedsAvailable: 3,
      distance: '5.2 km',
      latitude: 30.4650,
      longitude: -8.8920,
      type: 'Private',
    ),
    Hospital(
      id: '5',
      name: 'Centre de Santé Sidi Rabat',
      nameAr: 'مركز الصحة سيدي رباط',
      address: 'Sidi Rabat, Taroudant',
      phone: '+212 5285-44111',
      bedsAvailable: 6,
      distance: '7.8 km',
      latitude: 30.4850,
      longitude: -8.9120,
      type: 'Public',
    ),
  ];

  void _toggleOnlineStatus() {
    setState(() {
      _isOnline = !_isOnline;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isOnline ? 'You are now ONLINE' : 'You are now OFFLINE'),
        backgroundColor: _isOnline ? Colors.green : Colors.grey,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _simulateEmergencyRequest() {
    setState(() {
      _hasEmergencyRequest = true;
    });
  }

  void _logout() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('You have been logged out'),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
      ),
    );
  }

  void _showHospitalDetails(Hospital hospital) {
    setState(() {
      _selectedHospital = hospital;
    });
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => HospitalDetailsSheet(
        hospital: hospital,
        onNavigate: () {
          Navigator.pop(context);
          _showNavigationDialog(hospital);
        },
      ),
    );
  }

  void _showNavigationDialog(Hospital hospital) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.navigation, color: Colors.blue),
            ),
            const SizedBox(width: 12),
            const Text('Navigation'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Destination: ${hospital.name}'),
            const SizedBox(height: 8),
            Text('Distance: ${hospital.distance}'),
            const SizedBox(height: 8),
            const Text('ETA: 5-8 minutes'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(context);
              // Start navigation logic here
            },
            icon: const Icon(Icons.directions),
            label: const Text('Start'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final isArabic = provider.isArabic;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary,
                        colorScheme.primaryContainer,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withOpacity(0.35),
                        blurRadius: 25,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Driver Central',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Live dispatch dashboard',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: _logout,
                            icon: const Icon(Icons.logout, color: Colors.white),
                            label: const Text('Logout'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.black26,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Expanded(
                            child: DriverProfileCard(),
                          ),
                          const SizedBox(width: 12),
                          _OnlineToggle(
                            isOnline: _isOnline,
                            onToggle: _toggleOnlineStatus,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Emergency Request Card
              if (_hasEmergencyRequest)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: EmergencyRequestCard(
                    onAccept: () {
                      setState(() => _hasEmergencyRequest = false);
                      _showEmergencyAcceptedDialog();
                    },
                    onDecline: () {
                      setState(() => _hasEmergencyRequest = false);
                    },
                  ),
                ),

              // Stats Overview
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _StatCard(
                      value: '12',
                      label: 'Trips Today',
                      icon: Icons.local_taxi,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    const _StatCard(
                      value: '4.8',
                      label: 'Rating',
                      icon: Icons.star,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 12),
                    const _StatCard(
                      value: '450',
                      label: 'MAD Earned',
                      icon: Icons.wallet,
                      color: Colors.green,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Tab Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      _TabButton(
                        icon: Icons.local_hospital,
                        label: 'Hospitals',
                        isSelected: _selectedTab == 0,
                        onTap: () => setState(() => _selectedTab = 0),
                      ),
                      _TabButton(
                        icon: Icons.map,
                        label: 'Map',
                        isSelected: _selectedTab == 1,
                        onTap: () => setState(() => _selectedTab = 1),
                      ),
                      _TabButton(
                        icon: Icons.history,
                        label: 'History',
                        isSelected: _selectedTab == 2,
                        onTap: () => setState(() => _selectedTab = 2),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Main Content
              Expanded(
                child: _selectedTab == 0
                    ? _HospitalsList(
                        hospitals: _hospitals,
                        onHospitalTap: _showHospitalDetails,
                      )
                    : _selectedTab == 1
                        ? _MapView(
                            hospitals: _hospitals,
                            onHospitalTap: _showHospitalDetails,
                          )
                        : _HistoryView(),
              ),
            ],
          ),
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton.small(
              heroTag: 'test',
              onPressed: _simulateEmergencyRequest,
              backgroundColor: Colors.orange,
              child: const Icon(Icons.bug_report),
            ),
            const SizedBox(height: 8),
            FloatingActionButton.extended(
              heroTag: 'emergency',
              onPressed: _simulateEmergencyRequest,
              icon: const Icon(Icons.emergency),
              label: const Text('TEST ALERT'),
              backgroundColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  void _showEmergencyAcceptedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Emergency Accepted!'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 64),
            SizedBox(height: 16),
            Text('Navigate to patient location immediately.'),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Start Navigation'),
          ),
        ],
      ),
    );
  }
}

// Hospital Model
class Hospital {
  final String id;
  final String name;
  final String nameAr;
  final String address;
  final String phone;
  final int bedsAvailable;
  final String distance;
  final double latitude;
  final double longitude;
  final String type;

  Hospital({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.address,
    required this.phone,
    required this.bedsAvailable,
    required this.distance,
    required this.latitude,
    required this.longitude,
    required this.type,
  });
}

// Online Toggle Widget
class _OnlineToggle extends StatelessWidget {
  final bool isOnline;
  final VoidCallback onToggle;

  const _OnlineToggle({
    required this.isOnline,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: isOnline
              ? const LinearGradient(colors: [Colors.green, Color(0xFF059669)])
              : const LinearGradient(colors: [Colors.grey, Color(0xFF6B7280)]),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: (isOnline ? Colors.green : Colors.grey).withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              isOnline ? 'ONLINE' : 'OFFLINE',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 12,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Stat Card Widget
class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Tab Button Widget
class _TabButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyLarge?.color,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : Theme.of(context).textTheme.bodyLarge?.color,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Hospitals List View
class _HospitalsList extends StatelessWidget {
  final List<Hospital> hospitals;
  final Function(Hospital) onHospitalTap;

  const _HospitalsList({
    required this.hospitals,
    required this.onHospitalTap,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final colorScheme = Theme.of(context).colorScheme;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: hospitals.length,
      itemBuilder: (context, index) {
        final hospital = hospitals[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
          ),
          child: InkWell(
            onTap: () => onHospitalTap(hospital),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.shade400,
                              Colors.blue.shade600,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.local_hospital,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isArabic ? hospital.nameAr : hospital.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              hospital.address,
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: hospital.type == 'Public'
                              ? Colors.green.withOpacity(0.1)
                              : Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          hospital.type,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: hospital.type == 'Public'
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _InfoChip(
                        icon: Icons.bed,
                        label: '${hospital.bedsAvailable} beds',
                        color: Colors.green,
                      ),
                      const SizedBox(width: 8),
                      _InfoChip(
                        icon: Icons.location_on,
                        label: hospital.distance,
                        color: colorScheme.primary,
                      ),
                      const Spacer(),
                      FilledButton.icon(
                        onPressed: () => onHospitalTap(hospital),
                        icon: const Icon(Icons.arrow_forward, size: 16),
                        label: const Text('View'),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(0, 36),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// Map View (Placeholder for Desktop/Web)
class _MapView extends StatelessWidget {
  final List<Hospital> hospitals;
  final Function(Hospital) onHospitalTap;

  const _MapView({
    required this.hospitals,
    required this.onHospitalTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          // Map Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.map, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Taroudant Area Map',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 14,
                        color: Colors.orange.shade700,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Desktop Mode',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Simulated Map
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [const Color(0xFF1a237e), const Color(0xFF0d47a1)]
                      : [const Color(0xFFe3f2fd), const Color(0xFFbbdefb)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  // Grid lines to simulate map
                  CustomPaint(
                    size: Size.infinite,
                    painter: _MapGridPainter(isDark: isDark),
                  ),
                  
                  // Hospital markers
                  ...hospitals.asMap().entries.map((entry) {
                    final index = entry.key;
                    final hospital = entry.value;
                    // Position markers randomly on the "map"
                    final left = 0.1 + (index * 0.18);
                    final top = 0.2 + (index % 2) * 0.4;
                    
                    return Positioned(
                      left: MediaQuery.of(context).size.width * left,
                      top: MediaQuery.of(context).size.height * top * 0.3,
                      child: GestureDetector(
                        onTap: () => onHospitalTap(hospital),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.local_hospital,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Text(
                                hospital.distance,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  
                  // Center marker (Driver location)
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.4),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.local_shipping,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: const Text(
                            'You are here',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Legend
          const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _LegendItem(
                  color: Colors.green,
                  icon: Icons.local_shipping,
                  label: 'Your Location',
                ),
                SizedBox(width: 24),
                _LegendItem(
                  color: Colors.blue,
                  icon: Icons.local_hospital,
                  label: 'Hospital',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  final bool isDark;

  _MapGridPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withOpacity(0.05)
      ..strokeWidth = 1;

    // Draw grid
    for (var i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i.toDouble(), 0), Offset(i.toDouble(), size.height), paint);
    }
    for (var i = 0; i < size.height; i += 40) {
      canvas.drawLine(Offset(0, i.toDouble()), Offset(size.width, i.toDouble()), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;

  const _LegendItem({
    required this.color,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: Colors.white, size: 12),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

// History View
class _HistoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final trips = [
      _Trip(
        id: '1',
        date: 'Today, 14:30',
        patient: 'Mohammed Alami',
        from: 'Centre Ville',
        to: 'Hospital Central',
        status: 'Completed',
        amount: 45,
        duration: '12 min',
      ),
      _Trip(
        id: '2',
        date: 'Today, 11:15',
        patient: 'Fatima Benali',
        from: 'Quartier El Boustane',
        to: 'Clinique Al Azhar',
        status: 'Completed',
        amount: 30,
        duration: '8 min',
      ),
      _Trip(
        id: '3',
        date: 'Yesterday, 18:45',
        patient: 'Ahmed Tahiri',
        from: 'Route de Oulad Teima',
        to: 'Hôpital Militaire',
        status: 'Completed',
        amount: 55,
        duration: '15 min',
      ),
      _Trip(
        id: '4',
        date: 'Yesterday, 16:20',
        patient: 'Sara Moussaoui',
        from: 'Avenue Hassan II',
        to: 'Clinique Dar Al Shifa',
        status: 'Cancelled',
        amount: 0,
        duration: '-',
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: trips.length,
      itemBuilder: (context, index) {
        final trip = trips[index];
        final isCancelled = trip.status == 'Cancelled';
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isCancelled
                  ? Colors.red.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.2),
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isCancelled
                    ? Colors.red.withOpacity(0.1)
                    : Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isCancelled ? Icons.cancel : Icons.check_circle,
                color: isCancelled ? Colors.red : Colors.green,
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    trip.patient,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                Text(
                  '${trip.amount} MAD',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: isCancelled ? Colors.grey : Colors.green,
                  ),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('${trip.from} → ${trip.to}'),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.schedule, size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(
                      trip.date,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.timer, size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(
                      trip.duration,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Trip {
  final String id;
  final String date;
  final String patient;
  final String from;
  final String to;
  final String status;
  final int amount;
  final String duration;

  _Trip({
    required this.id,
    required this.date,
    required this.patient,
    required this.from,
    required this.to,
    required this.status,
    required this.amount,
    required this.duration,
  });
}

// Hospital Details Bottom Sheet
class HospitalDetailsSheet extends StatelessWidget {
  final Hospital hospital;
  final VoidCallback onNavigate;

  const HospitalDetailsSheet({
    super.key,
    required this.hospital,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.shade400,
                      Colors.blue.shade600,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.local_hospital,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic ? hospital.nameAr : hospital.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: hospital.type == 'Public'
                            ? Colors.green.withOpacity(0.1)
                            : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        hospital.type,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: hospital.type == 'Public'
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Info Rows
          _InfoRow(
            icon: Icons.location_on,
            label: 'Address',
            value: hospital.address,
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.phone,
            label: 'Phone',
            value: hospital.phone,
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.bed,
            label: 'Available Beds',
            value: '${hospital.bedsAvailable}',
            valueColor: Colors.green,
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.navigation,
            label: 'Distance',
            value: hospital.distance,
            valueColor: colorScheme.primary,
          ),
          
          const SizedBox(height: 24),
          
          // Coordinates
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.gps_fixed, size: 16, color: Colors.grey.shade500),
                const SizedBox(width: 8),
                Text(
                  '${hospital.latitude.toStringAsFixed(4)}, ${hospital.longitude.toStringAsFixed(4)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Actions
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: onNavigate,
                  icon: const Icon(Icons.navigation),
                  label: const Text('Start Navigation'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
            label: const Text('Close'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade500),
        const SizedBox(width: 12),
        Text(
          '$label:',
          style: TextStyle(
            color: Colors.grey.shade600,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
