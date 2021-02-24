import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

// ignore: must_be_immutable
class Auth extends StatelessWidget {
  LocalAuthentication localAuthentication = LocalAuthentication();
  bool canAuth = false;

  @override
  Widget build(BuildContext context) {

      List<BiometricType> list = List();
      try {
        if (canAuth) {
          list =  localAuthentication.getAvailableBiometrics() as List<BiometricType>;

          if (list.length > 0) {
            bool result =
                localAuthentication.authenticateWithBiometrics(
                localizedReason:
                'Please enter your fingerprint to unlock',
                useErrorDialogs: true,
                stickyAuth: false) as bool;

            print('resultis $result');

            if (list.contains(BiometricType.fingerprint)) {
              print('fingerprint');
            }
          }
        }
      } catch (e) {
        print(e);
      }
    }
  }

