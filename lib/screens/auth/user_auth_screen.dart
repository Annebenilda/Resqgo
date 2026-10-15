import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/resqgo_logo.dart';
import '../onboarding/instructions_screen.dart';

class UserAuthScreen extends StatefulWidget {
  const UserAuthScreen({super.key});

  @override
  State<UserAuthScreen> createState() => _UserAuthScreenState();
}

class _UserAuthScreenState extends State<UserAuthScreen> {
  bool _isSignUp = true;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Priya Sharma');
  final _phoneController = TextEditingController(text: '9811234567');
  final _vehicleController = TextEditingController(text: 'Tesla Model 3 Long Range');
  final _plateController = TextEditingController(text: 'DL-01-EV-4421');

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => InstructionsScreen(
            userRole: 'user',
            employeeName: _nameController.text.trim(),
            employeeId: 'USR-2024',
            phone: _phoneController.text.trim(),
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
          _isSignUp ? 'Motorist Registration' : 'Motorist Login',
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(child: ResQGoLogo(size: 40, showTagline: false)),
                const SizedBox(height: 20),

                // Switcher
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
                              color: _isSignUp ? AppColors.evGreen : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                'Register Vehicle',
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
                              color: !_isSignUp ? AppColors.evGreen : Colors.transparent,
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

                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person_rounded, color: AppColors.evGreen),
                  ),
                  validator: (val) => val == null || val.isEmpty ? 'Enter your name' : null,
                ),
                const SizedBox(height: 14),

                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    prefixIcon: const Icon(Icons.phone_rounded, color: AppColors.evGreen),
                    prefixText: '+91 ',
                    prefixStyle: GoogleFonts.outfit(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textLight,
                    ),
                  ),
                  validator: (val) => val == null || val.length < 10 ? 'Enter phone number' : null,
                ),
                const SizedBox(height: 14),

                if (_isSignUp) ...[
                  TextFormField(
                    controller: _vehicleController,
                    decoration: const InputDecoration(
                      labelText: 'Primary Vehicle Make & Model',
                      prefixIcon: Icon(Icons.directions_car_rounded, color: AppColors.evGreen),
                      hintText: 'e.g. Tesla Model 3 / Tata Nexon EV',
                    ),
                  ),
                  const SizedBox(height: 14),

                  TextFormField(
                    controller: _plateController,
                    decoration: const InputDecoration(
                      labelText: 'License Plate Number',
                      prefixIcon: Icon(Icons.pin_rounded, color: AppColors.evGreen),
                    ),
                  ),
                  const SizedBox(height: 24),
                ] else ...[
                  const SizedBox(height: 16),
                ],

                ResQButton(
                  text: _isSignUp ? 'Register & Continue' : 'Sign In',
                  icon: Icons.arrow_forward_rounded,
                  color: AppColors.evGreen,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
