import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  User? _user;
  bool _isLoading = false;
  bool _hasSeenOnboarding = false;
  bool _isDevBypass = false;

  User? get user => _user;
  bool get isAuthenticated => _user != null || _isDevBypass;
  bool get isLoading => _isLoading;
  bool get hasSeenOnboarding => _hasSeenOnboarding;

  AuthProvider() {
    _loadAuthState();
  }

  void _loadAuthState() async {
    _user = _supabase.auth.currentUser;
    final prefs = await SharedPreferences.getInstance();
    _hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;
    notifyListeners();

    _supabase.auth.onAuthStateChange.listen((data) {
      _user = data.session?.user;
      notifyListeners();
    });
  }

  Future<void> signUp(String email, String password, String fullName) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );
      
      if (response.user != null) {
        await _supabase.from('profiles').insert({
          'id': response.user!.id,
          'full_name': fullName,
          'role': 'farmer',
        });
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    
    final cleanEmail = email.trim().toLowerCase();
    final cleanPassword = password.trim();

    // DEBUG PRINTS
    debugPrint('Attempting login with: [$cleanEmail] / [$cleanPassword]');

    try {
      // Developer Bypass
      if (cleanEmail == 'test@app.com' && cleanPassword == 'password') {
        debugPrint('Developer Bypass Triggered!');
        _isDevBypass = true;
        await Future.delayed(const Duration(seconds: 1));
        notifyListeners();
        return;
      }

      await _supabase.auth.signInWithPassword(
        email: cleanEmail,
        password: cleanPassword,
      );
      _isDevBypass = false;
    } catch (e) {
      debugPrint('Supabase Auth Error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
    _isDevBypass = false;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _hasSeenOnboarding = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);
    notifyListeners();
  }
}
