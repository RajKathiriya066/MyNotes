import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    test("Should not be initialized to begin with ", () {
      expect(provider.isInitialized, false);
    });
    test("Cannot log out if not initialized", () {
      expect(provider.logout(),
          throwsA(const TypeMatcher<NotInitializedException>()));
    });
    test('Should be able to be initialized', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });
    test('User should be null', () {
      expect(provider.currentUser, null);
    });
    test("Should be able to initialize in less than 2 seconds ", () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    }, timeout: const Timeout(const Duration(seconds: 2)));
    test("Create user should delegate to login function", () async {
      final badEmailUser =
          provider.createUser(email: "foo@bar.com", password: "scaeljsa");
      expect(badEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));
      final badPassUser =
          provider.createUser(email: 'acafal@vaeec.com', password: 'foobar');
      expect(badPassUser, throwsA(const TypeMatcher<WrongPassAuthException>()));
      final user = await provider.createUser(
          email: 'cafaacm@aca.com', password: 'acsljflva');
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });
    test('logged in user should be able to get  verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });
    test('Should be able to log out and log in again', () async {
      await provider.logout();
      await provider.login(email: 'email', password: 'password');
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser(
      {required String email, required String password}) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return login(email: email, password: password);
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> login({required String email, required String password}) {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'foo@bar.com') throw UserNotFoundAuthException();
    if (password == "foobar") throw WrongPassAuthException();
    const user = AuthUser(
      isEmailVerified: false,
      email: "email@email.com",
      id: "llcsoidonsinonavjoj42oj90f",
    );
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logout() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(
      isEmailVerified: true,
      email: "email@email.com",
      id: "llcsoidonsinonavjoj42oj90f",
    );
    _user = newUser;
  }
}
