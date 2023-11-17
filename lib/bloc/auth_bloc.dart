import 'package:bloc/bloc.dart';
import 'package:sdsolution_onboarding/api/auth_api.dart';
import 'package:sdsolution_onboarding/service/shared_pref/user_shared_pref.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is CheckUserEvent) {
        await _checkCurrentUser(emit);
      }

      if (event is LoginEvent) {
        await _login(emit, username: event.userName, password: event.password);
      }

      if (event is RegisterEvent) {
        await _register(emit,
            username: event.username,
            password: event.password,
            name: event.name,
            email: event.email);
      }

      if (event is LogoutEvent) {
        await _logOut(emit);
      }
    });
  }

  Future _login(Emitter<AuthState> emit,
      {required String username, required String password}) async {
    try {
      emit(const LoadingAuthState());
      final bearerToken =
          await AuthRepository().login(username: username, password: password);
      if (bearerToken != null) {
        await UserStoredPref().storeBearerToken(bearerToken);
        emit(const AuthenticatedState());
      } else {
        emit(const AuthError("No bearer token"));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future _register(Emitter<AuthState> emit,
      {required String username,
      required String password,
      required String name,
      required String email}) async {
    try {
      emit(const LoadingAuthState());
      String? bearerToken =
          await AuthRepository().login(username: "Admin", password: "admin");
      if (bearerToken != null) {
        await AuthRepository().register(bearerToken,
            username: username, password: password, name: name, email: email);
        emit(const RegisterSuccessState());
      } else {
        throw Exception("No bearer token");
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future _checkCurrentUser(Emitter<AuthState> emit) async {
    String? bearerToken = await UserStoredPref().getBearerToken();

    if (bearerToken == null || bearerToken.isEmpty) {
      emit(const UnauthenticatedState());
    } else {
      emit(const AuthenticatedState());
    }
  }

  Future _logOut(Emitter<AuthState> emit) async {
    try {
      await UserStoredPref().removeBearerToken();
      emit(const UnauthenticatedState());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
