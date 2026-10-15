import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/employee_model.dart';
import '../../theme/app_colors.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/resqgo_logo.dart';
import '../onboarding/instructions_screen.dart';

class EmployeeAuthScreen extends StatefulWidget {
  const EmployeeAuthScreen({super.key});

  @override
  State<EmployeeAuthScreen> createState() => _EmployeeAuthScreenState();
}

class _EmployeeAuthScreenState extends State<EmployeeAuthScreen> {
  bool _isSignUp = true;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Rohan Sharma');
  final _emailController = TextEditingController(text: 'rohan.sharma@resqgo.com');
  final _phoneController = TextEditingController(text: '9876543210');
  final _vehicleController = TextEditingController(text: 'ResQGo Response Van (DL-03-EV-1920)');
  final _passwordController = TextEditingController(text: 'password123');

  late String _generatedEmployeeId;
  String? _selectedAvatarUrl;
  final Set<ServiceRoleType> _selectedRoles = {
    ServiceRoleType.evSupport,
    ServiceRoleType.mechanic,
    ServiceRoleType.petrolSupply,
  };

  final List<String> _avatarPresets = [
    'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
    'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=150',
    'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=150',
    'https://images.unsplash.com/photo-1527980965255-d3b416303d12?w=150',
  ];

  @override
  void initState() {
    super.initState();
    _generatedEmployeeId = _generateId();
    _selectedAvatarUrl = _avatarPresets[0];
  }

  String _generateId() {
    final rand = Random();
    return 'RSQ-EMP-${1000 + rand.nextInt(9000)}';
  }

  void _regenerateId() {
    setState(() {
      _generatedEmployeeId = _generateId();
    });
  }

  void _pickAvatar() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose Profile Photo',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _avatarPresets.map((url) {
                  final isSelected = _selectedAvatarUrl == url;
                  return InkWell(
                    onTap: () {
                      setState(() => _selectedAvatarUrl = url);
                      Navigator.pop(ctx);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? AppColors.primaryRed : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 32,
                        backgroundImage: NetworkImage(url),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ResQButton(
                text: 'Upload Custom Photo',
                icon: Icons.camera_alt_rounded,
                onPressed: () {
                  setState(() {
                    _selectedAvatarUrl = 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150';
                  });
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile photo attached!')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _submit() {
    if (_isSignUp) {
      if (_selectedRoles.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.primaryRed,
            content: Text('Please select at least one service role.'),
          ),
        );
        return;
      }
    }

    if (_formKey.currentState?.validate() ?? false) {
      // Proceed to instructions / onboarding
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => InstructionsScreen(
            userRole: 'employee',
            employeeName: _nameController.text.trim(),
            employeeId: _generatedEmployeeId,
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
            roles: _selectedRoles.toList(),
            avatarUrl: _selectedAvatarUrl,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: AppColors.textLight),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _isSignUp ? 'Employee Registration' : 'Employee Login',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textLight,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Tab Switcher (Sign Up vs Login)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.borderDark),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => setState(() => _isSignUp = true),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: _isSignUp ? AppColors.primaryRed : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                'Sign Up / Register',
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w700,
                                  color: _isSignUp ? Colors.black : AppColors.textLightSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => setState(() => _isSignUp = false),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: !_isSignUp ? AppColors.primaryRed : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                'Sign In',
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w700,
                                  color: !_isSignUp ? Colors.black : AppColors.textLightSecondary,
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
                const SizedBox(height: 24),

                if (_isSignUp) ...[
                  // 1. Photo Upload & Unique ID Generator Card
                  _buildPhotoAndIdCard(),
                  const SizedBox(height: 20),

                  // 2. Personal & Contact Details
                  _buildSectionHeader('Employee Details', Icons.person_rounded),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.badge_rounded, color: AppColors.primaryRed),
                    ),
                    validator: (val) => val == null || val.isEmpty ? 'Enter your full name' : null,
                  ),
                  const SizedBox(height: 14),

                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Official Email',
                      prefixIcon: Icon(Icons.email_rounded, color: AppColors.primaryRed),
                    ),
                    validator: (val) => val == null || !val.contains('@') ? 'Enter a valid email' : null,
                  ),
                  const SizedBox(height: 14),

                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Mobile Number',
                      prefixIcon: const Icon(Icons.phone_rounded, color: AppColors.primaryRed),
                      prefixText: '+91 ',
                      prefixStyle: GoogleFonts.outfit(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textLight,
                      ),
                    ),
                    validator: (val) => val == null || val.length < 10 ? 'Enter 10-digit phone number' : null,
                  ),
                  const SizedBox(height: 14),

                  TextFormField(
                    controller: _vehicleController,
                    decoration: const InputDecoration(
                      labelText: 'Assigned Vehicle & Registration',
                      prefixIcon: Icon(Icons.airport_shuttle_rounded, color: AppColors.primaryRed),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 3. Service Roles Selection
                  _buildSectionHeader(
                    'Select Service Capabilities / Roles',
                    Icons.military_tech_rounded,
                    subtitle: 'Choose one or multiple roles you are certified for',
                  ),
                  const SizedBox(height: 12),
                  _buildRolesSelector(),
                  const SizedBox(height: 24),
                ] else ...[
                  // Sign In Mode
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        const ResQGoLogo(size: 40, showTagline: false),
                        const SizedBox(height: 20),
                        Text(
                          'Welcome Back, Specialist',
                          style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textLight,
                          ),
                        ),
                        Text(
                          'Log in to activate your radar and start accepting roadside requests.',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: AppColors.textLightSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 28),
                      ],
                    ),
                  ),

                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Employee Email or Unique ID',
                      prefixIcon: Icon(Icons.person_pin_rounded, color: AppColors.primaryRed),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_rounded, color: AppColors.primaryRed),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Action Red Button
                ResQButton(
                  text: _isSignUp ? 'Generate ID & Continue' : 'Log In to Radar',
                  icon: _isSignUp ? Icons.arrow_forward_rounded : Icons.login_rounded,
                  onPressed: _submit,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, {String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: AppColors.primaryRed),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: GoogleFonts.outfit(
              fontSize: 12.5,
              color: AppColors.textLightSecondary,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPhotoAndIdCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Photo Avatar with Upload Icon
              Stack(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.surfaceDark,
                    backgroundImage: _selectedAvatarUrl != null ? NetworkImage(_selectedAvatarUrl!) : null,
                    child: _selectedAvatarUrl == null
                        ? const Icon(Icons.person, size: 36, color: Colors.white70)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: _pickAvatar,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryRed,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profile Photo',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textLight,
                      ),
                    ),
                    Text(
                      'Shown to stranded motorists when you accept a request',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: AppColors.textLightSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: _pickAvatar,
                      child: Text(
                        'Change Photo →',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryRed,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.borderDark, height: 1),
          const SizedBox(height: 14),

          // Auto-Generated Unique ID
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'UNIQUE EMPLOYEE ID (AUTO-GENERATED)',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: AppColors.textLightSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDark,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.primaryRed.withValues(alpha: 0.5)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.fingerprint_rounded, size: 18, color: AppColors.primaryRed),
                          const SizedBox(width: 8),
                          Text(
                            _generatedEmployeeId,
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textLight,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _regenerateId,
                tooltip: 'Regenerate ID',
                icon: const Icon(Icons.refresh_rounded, color: AppColors.primaryRed),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRolesSelector() {
    return Column(
      children: ServiceRole.allRoles.map((role) {
        final isSelected = _selectedRoles.contains(role.type);
        final isEv = role.isEvRelated;

        return InkWell(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedRoles.remove(role.type);
              } else {
                _selectedRoles.add(role.type);
              }
            });
          },
          borderRadius: BorderRadius.circular(14),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? (isEv ? AppColors.evGreen.withValues(alpha: 0.12) : AppColors.primaryRed.withValues(alpha: 0.12))
                  : AppColors.cardDark,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected
                    ? (isEv ? AppColors.evGreen : AppColors.primaryRed)
                    : AppColors.borderDark,
                width: isSelected ? 1.8 : 1.0,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (isEv ? AppColors.evGreen : role.accentColor).withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    role.icon,
                    color: isEv ? AppColors.evGreen : role.accentColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              role.title,
                              style: GoogleFonts.outfit(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textLight,
                              ),
                            ),
                          ),
                          if (isEv) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.evGreen,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'EV GREEN',
                                style: GoogleFonts.outfit(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        role.subtitle,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: AppColors.textLightSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Checkbox(
                  value: isSelected,
                  activeColor: isEv ? AppColors.evGreen : AppColors.primaryRed,
                  onChanged: (val) {
                    setState(() {
                      if (val == true) {
                        _selectedRoles.add(role.type);
                      } else {
                        _selectedRoles.remove(role.type);
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
