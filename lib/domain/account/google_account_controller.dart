import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum GoogleAccountStatus {
  notConfigured,
  initializing,
  guest,
  signedIn,
  unsupported,
  error,
}

class GoogleAccountSnapshot {
  const GoogleAccountSnapshot({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
  });

  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
}

class GoogleAccountController extends ChangeNotifier {
  GoogleAccountController({
    GoogleSignIn? signIn,
    String clientId = const String.fromEnvironment(
      'TASTEAI_GOOGLE_CLIENT_ID',
    ),
    String serverClientId = const String.fromEnvironment(
      'TASTEAI_GOOGLE_SERVER_CLIENT_ID',
    ),
  })  : _signIn = signIn ?? GoogleSignIn.instance,
        _clientId = clientId,
        _serverClientId = serverClientId;

  static const List<String> driveScopes = <String>[
    'https://www.googleapis.com/auth/drive.appdata',
  ];

  final GoogleSignIn _signIn;
  final String _clientId;
  final String _serverClientId;

  StreamSubscription<GoogleSignInAuthenticationEvent>? _subscription;
  GoogleSignInAccount? _account;
  GoogleAccountStatus _status = GoogleAccountStatus.notConfigured;
  String _errorCode = '';
  bool _initialized = false;

  bool get configured =>
      _clientId.trim().isNotEmpty || _serverClientId.trim().isNotEmpty;
  bool get signedIn => _account != null;
  bool get canAuthenticate =>
      _initialized && _signIn.supportsAuthenticate();
  GoogleAccountStatus get status => _status;
  String get errorCode => _errorCode;

  GoogleAccountSnapshot? get account {
    final GoogleSignInAccount? value = _account;
    if (value == null) return null;
    return GoogleAccountSnapshot(
      id: value.id,
      email: value.email,
      displayName: value.displayName,
      photoUrl: value.photoUrl,
    );
  }

  Future<void> initialize() async {
    if (_initialized) return;
    if (!configured) {
      _status = GoogleAccountStatus.notConfigured;
      notifyListeners();
      return;
    }

    _status = GoogleAccountStatus.initializing;
    _errorCode = '';
    notifyListeners();

    try {
      await _signIn.initialize(
        clientId: _clientId.trim().isEmpty ? null : _clientId.trim(),
        serverClientId:
            _serverClientId.trim().isEmpty ? null : _serverClientId.trim(),
      );
      _subscription = _signIn.authenticationEvents.listen(
        _handleAuthenticationEvent,
        onError: _handleAuthenticationError,
      );
      _initialized = true;
      _status = GoogleAccountStatus.guest;
      notifyListeners();
      await _signIn.attemptLightweightAuthentication();
    } on GoogleSignInException catch (error) {
      _status = GoogleAccountStatus.error;
      _errorCode = error.code.name;
      notifyListeners();
    } catch (_) {
      _status = GoogleAccountStatus.error;
      _errorCode = 'initialization_failed';
      notifyListeners();
    }
  }

  Future<bool> signInInteractively() async {
    if (!_initialized) await initialize();
    if (!configured) return false;
    if (!_signIn.supportsAuthenticate()) {
      _status = GoogleAccountStatus.unsupported;
      _errorCode = 'interactive_auth_unsupported';
      notifyListeners();
      return false;
    }

    _errorCode = '';
    try {
      final GoogleSignInAccount account = await _signIn.authenticate();
      _account = account;
      _status = GoogleAccountStatus.signedIn;
      notifyListeners();
      return true;
    } on GoogleSignInException catch (error) {
      _errorCode = error.code.name;
      if (error.code != GoogleSignInExceptionCode.canceled) {
        _status = GoogleAccountStatus.error;
      }
      notifyListeners();
      return false;
    } catch (_) {
      _status = GoogleAccountStatus.error;
      _errorCode = 'authentication_failed';
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    if (!_initialized) return;
    try {
      await _signIn.signOut();
    } finally {
      _account = null;
      _status = GoogleAccountStatus.guest;
      _errorCode = '';
      notifyListeners();
    }
  }

  Future<Map<String, String>?> authorizeDriveHeaders() async {
    final GoogleSignInAccount? account = _account;
    if (account == null) return null;

    try {
      Map<String, String>? headers =
          await account.authorizationClient.authorizationHeaders(driveScopes);
      if (headers != null) return headers;

      await account.authorizationClient.authorizeScopes(driveScopes);
      headers =
          await account.authorizationClient.authorizationHeaders(driveScopes);
      return headers;
    } on GoogleSignInException catch (error) {
      _errorCode = error.code.name;
      notifyListeners();
      return null;
    } catch (_) {
      _errorCode = 'drive_authorization_failed';
      notifyListeners();
      return null;
    }
  }

  void _handleAuthenticationEvent(
    GoogleSignInAuthenticationEvent event,
  ) {
    if (event is GoogleSignInAuthenticationEventSignIn) {
      _account = event.user;
      _status = GoogleAccountStatus.signedIn;
    } else if (event is GoogleSignInAuthenticationEventSignOut) {
      _account = null;
      _status = GoogleAccountStatus.guest;
    }
    _errorCode = '';
    notifyListeners();
  }

  void _handleAuthenticationError(Object error) {
    _account = null;
    _status = GoogleAccountStatus.error;
    _errorCode = error is GoogleSignInException
        ? error.code.name
        : 'authentication_event_failed';
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
