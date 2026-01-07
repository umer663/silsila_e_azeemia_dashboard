import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  User? get currentUser => _supabase.auth.currentUser;

  Future<AuthResponse> signInWithEmailPassword({required String email, required String password}) async {
    print('DEBUG: AuthService.signInWithEmailPassword called for $email'); // Debug Log
    final response = await _supabase.auth.signInWithPassword(email: email, password: password);
    print('DEBUG: AuthService received response: ${response.user?.email}'); // Debug Log
    return response;
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
