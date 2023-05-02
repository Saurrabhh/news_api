import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:quantum_assignment/models/person.dart';
import 'package:quantum_assignment/ui/auth/components/buttons.dart';
import 'package:quantum_assignment/ui/home/home_screen.dart';
import '../../constants.dart';
import '../../services/firebase_auth_service.dart';
import 'auth_utils.dart';
import 'components/info_header.dart';
import 'components/text_fields.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key, required this.goToPage}) : super(key: key);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final Function(int) goToPage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30.0),
                  ),
                  color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const InfoHeader(info: "SignIn into your\nAccount"),
                  AuthTextField(
                      controller: emailController,
                      labelText: 'Email',
                      hintText: "johndoe@gmail.com",
                      suffixIcon:
                        Icons.mail),
                  AuthTextField(
                      controller: passwordController,
                      labelText: 'Password',
                      hintText: "********",
                      suffixIcon:
                        Icons.lock),
                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomTextButton(
                        text: "Forgot Password?", onPressed: () => sendResetLink(context)),
                  ),
                  addVerticalSpace(20),
                  _buildSocialLogin(context),
                  addVerticalSpace(20),
                  _buildRegisterAccount()
                ],
              ),
            ),
          ),
          BottomAuthButton(text: 'LOGIN', onPressed: () => signInWithEmail(context))
        ],
      ),
    );
  }

  Row _buildRegisterAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an Account?",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        CustomTextButton(text: "Register Now", onPressed: () => goToPage(1)),
      ],
    );
  }

  Column _buildSocialLogin(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Login with",
          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Image.asset('assets/google_icon.png'),
              iconSize: 50,
              onPressed: () => signInWithGoogle(context),
            ),
            IconButton(
              icon: Image.asset('assets/facebook_icon.png'),
              iconSize: 50,
              onPressed: () => signInWithFacebook(context),
            ),
          ],
        )
      ],
    );
  }

  signInWithEmail(BuildContext context) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please fill all the fields.");
      return;
    }
    AuthUtils.showLoadingDialog(context);
    final user = await Provider.of<FirebaseAuthService>(context, listen: false)
        .signInWithEmail(emailController.text, passwordController.text);
    if (user == null && context.mounted) {
      Navigator.pop(context);
      return;
    }
    if(!user!.emailVerified){
      await user.sendEmailVerification();
      Fluttertoast.showToast(msg: "Please verify your account");
      Navigator.pop(context);
      return;
    }
    Person? person = await Person.fromUid(user.uid);
    if(person == null && context.mounted){
      Navigator.pop(context);
      return;
    }
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (_) => MultiProvider(providers: [
                Provider<Person>(create: (_) => person!),
              ], child: HomeScreen())),
              (route) => false);
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    AuthUtils.showLoadingDialog(context);
    final user = await Provider.of<FirebaseAuthService>(context,listen: false).signInWithGoogle();
    if (user == null && context.mounted) {
      Navigator.pop(context);
      return;
    }
    if(!user!.emailVerified){
      await user.sendEmailVerification();
      Fluttertoast.showToast(msg: "Please verify your account");
      Navigator.pop(context);
      return;
    }

    Map<String, dynamic> json = {
      "uid": user.uid,
      "name": user.displayName ?? "",
      "email": user.email ?? "",
      "phoneNo": user.phoneNumber ?? "",
    };
    Person person = Person.fromJson(json);
    await person.updatePerson();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (_) => MultiProvider(providers: [
                Provider<Person>(create: (_) => person),
              ], child: HomeScreen())),
              (route) => false);
    }
  }

  Future<void> signInWithFacebook(BuildContext context) async {
    AuthUtils.showLoadingDialog(context);
    final user = await Provider.of<FirebaseAuthService>(context,listen: false).signInWithFacebook();
    if (user == null && context.mounted) {
      Navigator.pop(context);
      return;
    }
    if(!user!.emailVerified){
      await user.sendEmailVerification();
      Fluttertoast.showToast(msg: "Please verify your account");
      Navigator.pop(context);
      return;
    }

    Map<String, dynamic> json = {
      "uid": user!.uid,
      "name": user.displayName ?? "",
      "email": user.email ?? "",
      "phoneNo": user.phoneNumber ?? "",
    };
    Person person = Person.fromJson(json);
    await person.updatePerson();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (_) => MultiProvider(providers: [
                Provider<Person>(create: (_) => person),
              ], child: HomeScreen())),
              (route) => false);
    }
  }

  sendResetLink(BuildContext context) async {
    if(emailController.text.isEmpty){
      Fluttertoast.showToast(msg: "Enter email.");
      return;
    }
    bool success = await Provider.of<FirebaseAuthService>(context,listen: false).resetPassword(emailController.text);
    if(success){
      Fluttertoast.showToast(msg: "Reset email sent.");
      return;
    }
    Fluttertoast.showToast(msg: "Failed to send email");
    return;
  }
}
