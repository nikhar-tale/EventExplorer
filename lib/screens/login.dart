import 'package:event_explorer/bloc/event_bloc.dart';
import 'package:event_explorer/bloc/event_event.dart';
import 'package:event_explorer/bloc/event_state.dart';
import 'package:event_explorer/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  final EventBloc eventBloc = EventBloc();

  @override
  void initState() {
    // TODO: implement initState
    autoLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Animated logo
            Hero(
              tag: 'logo',
              child: Image.asset(
                'assets/google_logo.png',
                height: 120,
                width: 120,
              ),
            ),
            const SizedBox(height: 20),
            // Animated welcome text
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOut,
              builder: (BuildContext context, double value, Widget? child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, value * 50),
                    child: child,
                  ),
                );
              },
              child: const Text(
                'Welcome to Event Explorer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 100),
            // Sign in button
            BlocConsumer(
                bloc: eventBloc,
                listener: (context, state) {
                  if (state is SignInWithGoogleSucess &&
                      state.userCredential != null) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ));
                    setState(() {
                      _isLoading = false;
                    });
                  } else if (state is EventLoading) {
                    setState(() {
                      _isLoading = true;
                    });
                  } else if (state is EventError) {
                    setState(() {
                      _isLoading = false;
                    });
                    Utils.showInSnackBar(state.errorMessage, context);
                  }
                },
                builder: (context, state) {
                  return ElevatedButton.icon(
                    onPressed: () async {
                      if (_isLoading) return;
                      eventBloc.add(SignInWithGoogle());
                    },
                    icon: Image.asset(
                      'assets/google_logo.png',
                      height: 0,
                      width: 0,
                    ),
                    label: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.deepPurple,
                              ),
                            ),
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  Future<void> autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? _isNewUser = prefs.getBool(Utils.isNewUser);

    if (_isNewUser == false) {
      eventBloc.add(SignInWithGoogle());
    }
    ;
  }
}
