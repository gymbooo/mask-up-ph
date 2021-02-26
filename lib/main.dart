/// -----------------------------------
///          External Packages
/// -----------------------------------

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:mask_up_ph/widgets/consts.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mask_up_ph/pages/ProfilePage.dart';
import 'package:local_auth/local_auth.dart';

final FlutterAppAuth appAuth = FlutterAppAuth();
final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

/// -----------------------------------
///           Auth0 Variables
/// -----------------------------------

const AUTH0_DOMAIN = 'dev-4hrsa1vu.us.auth0.com';
const AUTH0_CLIENT_ID = 'aGLkyywaQVlvDSwPLbusX9skHYltO0vi';

const AUTH0_REDIRECT_URI = 'com.auth0.flutterauth0://login-callback';
const AUTH0_ISSUER = 'https://$AUTH0_DOMAIN';

/// -----------------------------------
///           Profile Widget
/// -----------------------------------

class Profile extends StatelessWidget {
  final String name;
  final String givenName;
  final String email;
  final String picture;
  final logoutAction;

  Profile(
      this.name, this.givenName, this.email, this.picture, this.logoutAction);

  @override
  Widget build(BuildContext context) {
    print('name $name');
    print('givenName $givenName');
    print('email $email');
    print('picture $picture');
    print('logoutAction $logoutAction');
    return ProfilePage(name, givenName, email, picture, logoutAction);
    /*Text('Name: $name'),
        RaisedButton(
          onPressed: () {
            logoutAction();
          },
          child: Text('Logout'),
        ),*/
  }
}

/// -----------------------------------
///            Login Widget
/// -----------------------------------

class Login extends StatelessWidget {
  final loginAction;
  final String loginError;

  const Login(this.loginAction, this.loginError);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('lib/assets/images/background.png'),
                fit: BoxFit.cover)),
        child: Stack(
          children: <Widget>[
            _buildHeader(),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: MediaQuery.of(context).size.width * .75,
                child: Image.asset("lib/assets/images/virus.png"),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * .28,
              right: 25,
              child: Container(
                width: MediaQuery.of(context).size.width * .4,
                child: Image.asset("lib/assets/images/person.png"),
              ),
            ),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Padding _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Align(
        alignment: Alignment.topCenter,
        child: Image.asset("lib/assets/images/logo.png", height: 200),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    LocalAuthentication localAuthentication = LocalAuthentication();
    bool canAuth = false;
    return Positioned(
      bottom: 70,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Coronavirus disease (COVID-19)",
              style: GoogleFonts.montserrat(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "is an infectious disease caused by a new\nvirus.",
              style: GoogleFonts.gentiumBookBasic(
                fontSize: 18,
                color: Colors.white,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 25),
            ElevatedButton(
                onPressed: () {
                  loginAction();
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
                },
                style: ElevatedButton.styleFrom(
                    minimumSize:
                        Size(MediaQuery.of(context).size.width * .75, 45),
                    primary: Colors.white,
                    onPrimary: Colors.green,
                    onSurface: Colors.purple,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18))),
                child: Text('Sign in with Google',
                    style: GoogleFonts.montserrat(
                      color: AppColors.mainColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 25,
                    ))),

            ElevatedButton(
                onPressed: () async {
                  List<BiometricType> list = List();
                  canAuth = await localAuthentication.canCheckBiometrics;
                  try {
                    if (canAuth) {
                      list = await localAuthentication.getAvailableBiometrics();

                      if (list.length > 0) {
                        bool result =
                            await localAuthentication.authenticateWithBiometrics(
                                localizedReason:
                                    'Please enter your fingerprint to unlock',
                                useErrorDialogs: true,
                                stickyAuth: false);

                        print('resultis $result');

                        if (list.contains(BiometricType.fingerprint)) {
                          print('fingerprint');
                        }
                      }
                    }
                  } catch (e) {
                    print(e);
                  }
                },
                style: ElevatedButton.styleFrom(
                    minimumSize:
                        Size(MediaQuery.of(context).size.width * .75, 45),
                    primary: Colors.white,
                    onPrimary: Colors.green,
                    onSurface: Colors.purple,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18))),
                child: Text('Use Fingerprint',
                    style: GoogleFonts.montserrat(
                      color: AppColors.mainColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 25,
                    ))),
            // Text(loginError ?? ''),
          ],
        ),
      ),
    );
  }
}

/// -----------------------------------
///                 App
/// -----------------------------------

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

/// -----------------------------------
///              App State
/// -----------------------------------

class _MyAppState extends State<MyApp> {
  bool isBusy = false;
  bool isLoggedIn = false;
  String errorMessage;
  String name;
  String givenName;
  String email;
  String picture;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mask Up PH',
      home: Scaffold(
        body: Center(
          child: isBusy
              ? CircularProgressIndicator()
              : isLoggedIn
                  ? Profile(name, givenName, email, picture, logoutAction)
                  : Login(loginAction, errorMessage),
        ),
      ),
    );
  }

  Map<String, dynamic> parseIdToken(String idToken) {
    final parts = idToken.split(r'.');
    assert(parts.length == 3);

    return jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
  }

  Future<Map> getUserDetails(String accessToken) async {
    final url = 'https://$AUTH0_DOMAIN/userinfo';
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user details');
    }
  }

  Future<void> loginAction() async {
    setState(() {
      isBusy = true;
      errorMessage = '';
    });

    try {
      final AuthorizationTokenResponse result =
          await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(AUTH0_CLIENT_ID, AUTH0_REDIRECT_URI,
            issuer: 'https://$AUTH0_DOMAIN',
            scopes: ['openid', 'profile', 'offline_access', 'email'],
            promptValues: ['login']),
      );

      final idToken = parseIdToken(result.idToken);
      final profile = await getUserDetails(result.accessToken);

      await secureStorage.write(
          key: 'refresh_token', value: result.refreshToken);

      setState(() {
        isBusy = false;
        isLoggedIn = true;
        name = idToken['name'];
        givenName = idToken['given_name'];
        email = idToken['email'];
        picture = profile['picture'];
      });
    } catch (e, s) {
      print('login error: $e - stack: $s');

      setState(() {
        isBusy = false;
        isLoggedIn = false;
        errorMessage = e.toString();
      });
    }
  }

  void logoutAction() async {
    await secureStorage.delete(key: 'refresh_token');
    setState(() {
      isLoggedIn = false;
      isBusy = false;
    });
  }

  @override
  void initState() {
    initAction();
    super.initState();
  }

  void initAction() async {
    final storedRefreshToken = await secureStorage.read(key: 'refresh_token');
    if (storedRefreshToken == null) return;

    setState(() {
      isBusy = true;
    });

    try {
      final response = await appAuth.token(TokenRequest(
        AUTH0_CLIENT_ID,
        AUTH0_REDIRECT_URI,
        issuer: AUTH0_ISSUER,
        refreshToken: storedRefreshToken,
      ));

      final idToken = parseIdToken(response.idToken);
      final profile = await getUserDetails(response.accessToken);

      secureStorage.write(key: 'refresh_token', value: response.refreshToken);

      setState(() {
        isBusy = false;
        isLoggedIn = true;
        name = idToken['name'];
        givenName = idToken['given_name'];
        email = idToken['email'];
        picture = profile['picture'];
      });
    } catch (e, s) {
      print('error on refresh token: $e - stack: $s');
      logoutAction();
    }
  }
}
