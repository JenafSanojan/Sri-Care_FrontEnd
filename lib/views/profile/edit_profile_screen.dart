import 'package:flutter/material.dart';
import '../../Global/global_configs.dart';
import '../../utils/colors.dart';
import '../../widget_common/responsive-layout.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final user = GlobalAuthData.instance.user;

    // Initialize controllers with current data
    _nameController = TextEditingController(text: user.displayName ?? "");
    _phoneController = TextEditingController(text: user.mobileNumber ?? "");
    _emailController = TextEditingController(text: user.email); // Read-only
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Simulating a backend update
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // TODO: Replace this delay with your actual Firebase/API update call
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Logic to update local state would go here
    // e.g., GlobalAuthData.instance.updateUser(...);

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profile Updated Successfully!"),
        backgroundColor: darkGreen,
      ),
    );

    Navigator.pop(context); // Go back to Profile View
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: _buildContent(isWeb: false),
      webBody: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: _buildContent(isWeb: true),
        ),
      ),
    );
  }

  Widget _buildContent({required bool isWeb}) {
    return Scaffold(
      backgroundColor: lightYellow,
      appBar: AppBar(
        backgroundColor: lightYellow,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: textColorOne),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Edit Profile", style: TextStyle(color: textColorOne, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: _isLoading
                ? const SizedBox(width: 15, height: 15, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text("Save", style: TextStyle(color: orangeColor, fontWeight: FontWeight.bold, fontSize: 16)),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // --- PROFILE IMAGE EDIT ---
              Stack(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: white,
                    child: Icon(Icons.person, size: 50, color: orangeColor),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: orangeColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, color: white, size: 18),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30),

              // --- FORM FIELDS ---

              // 1. Name Field
              _buildTextField(
                label: "Full Name",
                controller: _nameController,
                icon: Icons.person_outline,
                validator: (val) => val!.isEmpty ? "Name cannot be empty" : null,
              ),

              const SizedBox(height: 20),

              // 2. Mobile Field
              _buildTextField(
                label: "Mobile Number",
                controller: _phoneController,
                icon: Icons.phone_android,
                keyboardType: TextInputType.phone,
                validator: (val) {
                  if (val!.isEmpty) return "Phone number is required";
                  if (val.length < 9) return "Enter a valid phone number";
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // 3. Email Field (Read Only)
              _buildTextField(
                label: "Email Address",
                controller: _emailController,
                icon: Icons.email_outlined,
                isReadOnly: true,
              ),

              const SizedBox(height: 10),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Email cannot be changed manually. Contact support.",
                  style: TextStyle(color: greyColor, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool isReadOnly = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: isReadOnly,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(color: isReadOnly ? greyColor : textColorOne),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: isReadOnly ? greyColor : orangeColor),
        filled: true,
        fillColor: isReadOnly ? Colors.grey.withValues(alpha: 0.1) : white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: orangeColor, width: 1.5),
        ),
      ),
    );
  }
}