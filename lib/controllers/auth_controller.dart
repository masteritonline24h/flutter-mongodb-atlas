import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../models/user_model.dart';

class AuthController {
  final AuthService _authService = AuthService();
  final StorageService _storageService = StorageService();

  bool isLoading = false;
  UserModel? currentUser;

  Future<bool> handleLogin({
    required String email,
    required String password,
    required Function(String errorMsg) onError,
    required Function(String successMsg) onSuccess,
  }) async {
    isLoading = true;

    final AuthResult result = await _authService.login(email, password);

    isLoading = false;

    // ប្រើ Dot Notation (.success, .user, .token, .message)
    if (result.success && result.user != null) {
      currentUser = result.user;

      await _storageService.saveUserSession(
        token: result.token ?? '',
        userId: currentUser!.id,
        email: currentUser!.email,
      );

      onSuccess(result.message);
      return true;
    } else {
      onError(result.message);
      return false;
    }
  }

  Future<bool> handleRegister({
    required String email,
    required String password,
    required Function(String errorMsg) onError,
    required Function(String successMsg) onSuccess,
  }) async {
    isLoading = true;

    final AuthResult result = await _authService.register(email, password);

    isLoading = false;

    if (result.success && result.user != null) {
      currentUser = result.user;

      // រក្សាទុក Session (Auto Login ក្រោយ Sign Up)
      await _storageService.saveUserSession(
        token: result.token ?? '',
        userId: currentUser!.id,
        email: currentUser!.email,
      );

      onSuccess(result.message);
      return true;
    } else {
      onError(result.message);
      return false;
    }
  }

  Future<bool> checkAuthStatus() async {
    return await _storageService.isLoggedIn();
  }

  Future<void> handleLogout() async {
    await _storageService.clearSession();
    currentUser = null;
  }
}