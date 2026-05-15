import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../models/user.dart';
import '../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  bool _isLogin = true;
  UserRole _selectedRole = UserRole.tailor;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _toggleMode() {
    setState(() => _isLogin = !_isLogin);
    _animCtrl.forward(from: 0);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthService>();
    try {
      if (_isLogin) {
        await auth.signIn(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
        );
      } else {
        await auth.signUp(
          name: _nameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
          confirmPassword: _confirmCtrl.text,
          role: _selectedRole,
        );
      }
    } catch (e) {
      if (!mounted) return;
      _showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        const Icon(Icons.error_outline, color: Colors.white, size: 18),
        const SizedBox(width: 10),
        Expanded(child: Text(msg, style: const TextStyle(fontWeight: FontWeight.w600))),
      ]),
      backgroundColor: const Color(0xFFDC2626),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppTheme.cream,
      body: Row(
        children: [
          // Left panel (decorative) - only on wide screens
          if (size.width > 700)
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1A1A1A), Color(0xFF2D2D2D)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    // Decorative circles
                    Positioned(
                      top: -60, left: -60,
                      child: Container(
                        width: 300, height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.gold.withOpacity(0.08),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -80, right: -80,
                      child: Container(
                        width: 350, height: 350,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.gold.withOpacity(0.06),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(48),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLogo(light: false),
                          const Spacer(),
                          const Text(
                            'The Premium\nTextile Exchange',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.w900,
                              height: 1.1,
                              letterSpacing: -1,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Connect artisans, tailors & crafters\nin one elegant marketplace.',
                            style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 16, height: 1.6),
                          ),
                          const SizedBox(height: 48),
                          _buildInfoBadge('🧵', 'Quick signup — no OTP required'),
                          const SizedBox(height: 12),
                          _buildInfoBadge('🪡', 'Separate dashboards for each role'),
                          const SizedBox(height: 12),
                          _buildInfoBadge('💎', 'Demo: tailor@demo.com / demo1234'),
                          const SizedBox(height: 12),
                          _buildInfoBadge('✨', 'Demo: artisan@demo.com / demo1234'),
                          const SizedBox(height: 48),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Right panel (form)
          Expanded(
            flex: size.width > 700 ? 1 : 2,
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (size.width <= 700) ...[
                          _buildLogo(light: true),
                          const SizedBox(height: 40),
                        ] else
                          const SizedBox(height: 20),

                        Text(
                          _isLogin ? 'Welcome Back' : 'Create Account',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.charcoal,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _isLogin
                            ? 'Sign in to your workshop'
                            : 'Join the textile ecosystem',
                          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 15),
                        ),
                        const SizedBox(height: 32),

                        // Role picker (signup only)
                        if (!_isLogin) ...[
                          _sectionLabel('I am a...'),
                          const SizedBox(height: 10),
                          _RoleToggle(
                            selected: _selectedRole,
                            onChanged: (r) => setState(() => _selectedRole = r),
                          ),
                          const SizedBox(height: 20),
                          _sectionLabel('Full Name'),
                          const SizedBox(height: 8),
                          _buildField(
                            controller: _nameCtrl,
                            hint: 'e.g. Ramesh Kumar',
                            icon: Icons.person_outline,
                            validator: (v) => v == null || v.trim().isEmpty ? 'Name is required' : null,
                          ),
                          const SizedBox(height: 16),
                        ],

                        _sectionLabel('Email Address'),
                        const SizedBox(height: 8),
                        _buildField(
                          controller: _emailCtrl,
                          hint: 'you@example.com',
                          icon: Icons.email_outlined,
                          keyboard: TextInputType.emailAddress,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Email is required';
                            if (!v.contains('@') || !v.contains('.')) return 'Enter a valid email';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        _sectionLabel('Password'),
                        const SizedBox(height: 8),
                        _buildField(
                          controller: _passwordCtrl,
                          hint: '••••••••',
                          icon: Icons.lock_outline,
                          obscure: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Password is required';
                            if (!_isLogin && v.length < 6) return 'Min 6 characters';
                            return null;
                          },
                        ),

                        if (!_isLogin) ...[
                          const SizedBox(height: 16),
                          _sectionLabel('Confirm Password'),
                          const SizedBox(height: 8),
                          _buildField(
                            controller: _confirmCtrl,
                            hint: '••••••••',
                            icon: Icons.lock_outline,
                            obscure: _obscureConfirm,
                            suffixIcon: IconButton(
                              icon: Icon(_obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18),
                              onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Please confirm your password';
                              if (v != _passwordCtrl.text) return 'Passwords do not match';
                              return null;
                            },
                          ),
                        ],

                        const SizedBox(height: 28),

                        // Submit button
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: auth.isLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.charcoal,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            child: auth.isLoading
                              ? const SizedBox(
                                  width: 22, height: 22,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                )
                              : Text(
                                  _isLogin ? 'Sign In' : 'Create Account',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                                ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        Center(
                          child: TextButton(
                            onPressed: _toggleMode,
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                                children: [
                                  TextSpan(text: _isLogin ? "Don't have an account? " : "Already have an account? "),
                                  TextSpan(
                                    text: _isLogin ? 'Sign Up' : 'Sign In',
                                    style: const TextStyle(
                                      color: AppTheme.gold,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        if (size.width <= 700) ...[
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.beige,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.gold.withOpacity(0.3)),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Demo accounts:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                SizedBox(height: 4),
                                Text('Tailor: tailor@demo.com / demo1234', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                                Text('Artisan: artisan@demo.com / demo1234', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo({required bool light}) {
    return Row(
      children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: light ? AppTheme.charcoal : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.texture, color: AppTheme.gold, size: 22),
        ),
        const SizedBox(width: 10),
        Text(
          'KUTIRA KONE',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 16,
            letterSpacing: 1.5,
            color: light ? AppTheme.charcoal : Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBadge(String emoji, String text) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 10),
        Text(text, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13)),
      ],
    );
  }

  Widget _sectionLabel(String text) {
    return Text(text,
      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppTheme.charcoal));
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffixIcon,
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboard,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, size: 18, color: AppTheme.textSecondary),
        suffixIcon: suffixIcon,
      ),
    );
  }
}

class _RoleToggle extends StatelessWidget {
  final UserRole selected;
  final ValueChanged<UserRole> onChanged;
  const _RoleToggle({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _tab(UserRole.tailor, Icons.content_cut_rounded, 'Tailor'),
          _tab(UserRole.artisan, Icons.storefront_rounded, 'Artisan'),
        ],
      ),
    );
  }

  Widget _tab(UserRole role, IconData icon, String label) {
    final isSelected = selected == role;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(role),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
              ? [const BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))]
              : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: isSelected ? AppTheme.gold : AppTheme.textSecondary),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: isSelected ? AppTheme.charcoal : AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
