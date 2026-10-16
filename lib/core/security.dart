import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

/// PIN (salted SHA-256 in the Android keystore-backed secure storage) and biometrics.
class SecurityService {
  SecurityService([FlutterSecureStorage? storage, LocalAuthentication? auth])
      : _storage = storage ?? const FlutterSecureStorage(),
        _auth = auth ?? LocalAuthentication();

  final FlutterSecureStorage _storage;
  final LocalAuthentication _auth;

  static const _hashKey = 'pin_hash';
  static const _saltKey = 'pin_salt';
  static const _revealHashKey = 'reveal_hash';
  static const _revealSaltKey = 'reveal_salt';

  String _hash(String pin, String salt) => sha256.convert(utf8.encode('$salt:$pin')).toString();

  String _newSalt() {
    final rnd = Random.secure();
    return base64Encode(List<int>.generate(16, (_) => rnd.nextInt(256)));
  }

  Future<bool> hasPin() async => (await _storage.read(key: _hashKey)) != null;

  Future<void> setPin(String pin) async {
    final salt = _newSalt();
    await _storage.write(key: _saltKey, value: salt);
    await _storage.write(key: _hashKey, value: _hash(pin, salt));
  }

  Future<bool> verifyPin(String pin) async {
    final salt = await _storage.read(key: _saltKey);
    final hash = await _storage.read(key: _hashKey);
    if (salt == null || hash == null) return false;
    return _hash(pin, salt) == hash;
  }

  Future<void> clearPin() async {
    await _storage.delete(key: _hashKey);
    await _storage.delete(key: _saltKey);
  }

  // ---- Discreet-mode reveal code (opens the real app from the decoy notepad) ----

  Future<bool> hasRevealCode() async => (await _storage.read(key: _revealHashKey)) != null;

  Future<void> setRevealCode(String code) async {
    final salt = _newSalt();
    await _storage.write(key: _revealSaltKey, value: salt);
    await _storage.write(key: _revealHashKey, value: _hash(code, salt));
  }

  Future<bool> verifyRevealCode(String code) async {
    final salt = await _storage.read(key: _revealSaltKey);
    final hash = await _storage.read(key: _revealHashKey);
    if (salt == null || hash == null) return false;
    return _hash(code, salt) == hash;
  }

  Future<void> clearRevealCode() async {
    await _storage.delete(key: _revealHashKey);
    await _storage.delete(key: _revealSaltKey);
  }

  Future<bool> canUseBiometrics() async {
    try {
      return await _auth.canCheckBiometrics && await _auth.isDeviceSupported();
    } catch (e) {
      debugPrint('biometrics unavailable: $e');
      return false;
    }
  }

  Future<bool> authenticateBiometric(String reason) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: true,
      );
    } catch (e) {
      debugPrint('biometric auth failed: $e');
      return false;
    }
  }
}

final securityProvider = Provider<SecurityService>((ref) => SecurityService());

/// Whether the app is currently unlocked (only meaningful when the lock is enabled).
class LockController extends Notifier<bool> {
  @override
  bool build() => false;

  void unlock() => state = true;
  void lock() => state = false;
}

final unlockedProvider = NotifierProvider<LockController, bool>(LockController.new);

/// Whether the decoy notepad has been unlocked with the reveal code this session.
/// Only meaningful when [Profile.discreetMode] is on. Resets when the app is
/// backgrounded, so it always reopens disguised.
class RevealController extends Notifier<bool> {
  @override
  bool build() => false;

  void reveal() => state = true;
  void hide() => state = false;
}

final revealedProvider = NotifierProvider<RevealController, bool>(RevealController.new);
