import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tutor_finder_app/config/api.dart';
import 'package:tutor_finder_app/features/tutors/tutors_list_page.dart';
import 'package:tutor_finder_app/features/tutors/tutor_dashboard_page.dart';

class LoginRegisterPage extends StatefulWidget {
  const LoginRegisterPage({super.key});
  @override
  State<LoginRegisterPage> createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  final _dio = Dio(
    BaseOptions(
      baseUrl: apiBaseUrl(),
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
    ),
  );
  final _storage = const FlutterSecureStorage();

  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  String _role = 'student';
  bool _isRegister = true;
  bool _loading = false;

  Future<void> _register() async {
    await _dio.post(
      '/auth/register/',
      data: {
        'username': _usernameCtrl.text.trim(),
        if (_emailCtrl.text.trim().isNotEmpty) 'email': _emailCtrl.text.trim(),
        'password': _passwordCtrl.text,
        'role': _role,
      },
    );
  }

  Future<void> _login() async {
    final res = await _dio.post(
      '/token/',
      data: {
        'username': _usernameCtrl.text.trim(),
        'password': _passwordCtrl.text,
      },
    );
    await _storage.write(key: 'access', value: res.data['access']);
    await _storage.write(key: 'refresh', value: res.data['refresh']);
    // Ensure subsequent requests (e.g., /me) are authenticated
    _dio.options.headers['Authorization'] = 'Bearer ${res.data['access']}';
  }

  Future<String?> _fetchRole() async {
    try {
      final res = await _dio.get('/me/');
      final dynamic user = res.data['user'];
      if (user is Map<String, dynamic>) {
        return user['role'] as String?;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> _submit() async {
    if (_usernameCtrl.text.isEmpty || _passwordCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username/password required')),
      );
      return;
    }
    setState(() => _loading = true);
    try {
      if (_isRegister) {
        await _register();
      }
      await _login();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Success')));
      await Future<void>.delayed(const Duration(milliseconds: 200));
      if (!mounted) return;
      final role = await _fetchRole();
      if (!mounted) return;
      final Widget home = (role == 'tutor')
          ? const TutorDashboardPage()
          : const TutorsListPage();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => home),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TutorFinder')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ToggleButtons(
              isSelected: [_isRegister, !_isRegister],
              onPressed: (i) => setState(() => _isRegister = (i == 0)),
              children: const [
                Padding(padding: EdgeInsets.all(8), child: Text('Register')),
                Padding(padding: EdgeInsets.all(8), child: Text('Login')),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _usernameCtrl,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            if (_isRegister)
              TextField(
                controller: _emailCtrl,
                decoration: const InputDecoration(
                  labelText: 'Email (optional)',
                ),
              ),
            TextField(
              controller: _passwordCtrl,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            if (_isRegister)
              DropdownButtonFormField<String>(
                initialValue: _role,
                items: const [
                  DropdownMenuItem(value: 'student', child: Text('Student')),
                  DropdownMenuItem(value: 'tutor', child: Text('Tutor')),
                ],
                onChanged: (v) => setState(() => _role = v ?? 'student'),
                decoration: const InputDecoration(labelText: 'Role'),
              ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const CircularProgressIndicator()
                    : Text(_isRegister ? 'Register & Login' : 'Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
