import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';
import 'package:ozapay/core/extension.dart';

class LocalAuth {
  static final instance = LocalAuth._();

  LocalAuth._();

  factory LocalAuth() => instance;

  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> get canAuthenticate async {
    final LocalAuthentication auth = LocalAuthentication();
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    return canAuthenticateWithBiometrics || await auth.isDeviceSupported();
  }

  Future<List<BiometricType>> get availableBiometrics async =>
      await _auth.getAvailableBiometrics();

  Future<bool> authenticate() async {
    if (await canAuthenticate) {
      try {
        return await _auth.authenticate(
          localizedReason: 'Authentifiez-vous',
          authMessages: [
            AndroidAuthMessages(
              signInTitle: 'Authentication',
              cancelButton: 'Non merci',
              biometricNotRecognized: 'Empreinte non reconnue!',
              biometricHint: 'Vérification d\'identité',
              biometricRequiredTitle: 'Empreinte requise',
              goToSettingsButton:
                  "L’authentification biométrique n’est pas configurée sur votre appareil. Accédez à"
                  "Paramètres > Sécurité » pour ajouter l’authentification biométrique.",
            ),
            IOSAuthMessages(cancelButton: 'Non merci'),
          ],
          options:
              AuthenticationOptions(biometricOnly: false, stickyAuth: true),
        );
      } on PlatformException catch (e) {
        e.code.log();

        if (e.code == notAvailable) {
          return true;
        }

        return false;
      }
    } else {
      return false;
    }
  }
}
