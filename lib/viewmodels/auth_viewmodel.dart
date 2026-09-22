import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_profile.dart';
import '../repositories/user_repository.dart';
import '../services/image_picker_service.dart';

class AuthState {
  final bool isAuthenticated;
  final UserProfile? user;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({
    this.isAuthenticated = true, // Default to logged-in user for ease of testing
    this.user,
    this.isLoading = false,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    UserProfile? user,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class AuthViewModel extends StateNotifier<AuthState> {
  final UserRepository _userRepo;
  final ImagePickerService _imagePicker = ImagePickerService();

  AuthViewModel(this._userRepo) : super(const AuthState()) {
    loadUser();
  }

  Future<void> loadUser() async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await _userRepo.getUser();
      state = state.copyWith(
        isLoading: false,
        user: user ??
            const UserProfile(
              id: 'usr_1',
              name: 'Ankita Shelke',
              email: 'ankita.shelke@example.com',
              phone: '+1 555-0199',
            ),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    await Future.delayed(const Duration(milliseconds: 600)); // Simulate auth
    if (email.isEmpty || password.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Email and password are required',
      );
      return false;
    }

    final user = UserProfile(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: email.split('@').first,
      email: email,
      phone: '+1 555-0199',
    );
    await _userRepo.saveUser(user);

    state = state.copyWith(
      isAuthenticated: true,
      user: user,
      isLoading: false,
    );
    return true;
  }

  Future<bool> register(
    String name,
    String email,
    String phone,
    String password,
  ) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    await Future.delayed(const Duration(milliseconds: 600)); // Simulate auth
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'All fields are required',
      );
      return false;
    }

    final user = UserProfile(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      phone: phone,
    );
    await _userRepo.saveUser(user);

    state = state.copyWith(
      isAuthenticated: true,
      user: user,
      isLoading: false,
    );
    return true;
  }

  Future<void> logout() async {
    state = state.copyWith(isAuthenticated: false);
  }

  Future<bool> pickAndUploadAvatar(ImageSource source) async {
    final imagePath = await _imagePicker.pickImage(source);
    if (imagePath != null && state.user != null) {
      final updatedUser = state.user!.copyWith(avatarPath: imagePath);
      await _userRepo.updateUserAvatar(imagePath);
      state = state.copyWith(user: updatedUser);
      return true;
    }
    return false;
  }
}

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return AuthViewModel(repo);
});

