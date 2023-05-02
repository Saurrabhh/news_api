import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:quantum_assignment/models/person.dart';
import 'package:quantum_assignment/ui/auth/auth_utils.dart';
import 'package:quantum_assignment/ui/auth/components/buttons.dart';
import '../../constants.dart';
import '../../services/firebase_auth_service.dart';
import '../home/home_screen.dart';
import 'components/info_header.dart';
import 'components/text_fields.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key, required this.goToPage}) : super(key: key);
  final Function(int) goToPage;

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final nameController = TextEditingController();

  final phNoController = TextEditingController();

  bool agreeTerms = false;
  String countryCode = "+91";

  signUp(BuildContext context) async {
    if (emailController.text.isEmpty ||
        nameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        phNoController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please fill all the fields.");
      return;
    }

    if (!agreeTerms) {
      Fluttertoast.showToast(msg: "Accept Terms & Conditions.");
      return;
    }
    AuthUtils.showLoadingDialog(context);
    final authService =
        Provider.of<FirebaseAuthService>(context, listen: false);
    final user =
        await authService.signUp(emailController.text, passwordController.text);
    if (user == null && context.mounted) {
      Navigator.pop(context);
      return;
    }
    Person person = Person(
        uid: user!.uid.toString(),
        name: nameController.text,
        email: emailController.text,
        phoneNo: phNoController.text);
    await person.updatePerson();
    await user.sendEmailVerification();
    if (context.mounted) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("Account Created."),
                content:
                    const Text("Please verify your email and login again."),
                actions: [
                  TextButton(
                      onPressed: () {
                        widget.goToPage(0);
                        Navigator.pop(context);
                      },
                      child: const Text("OK"))
                ],
              ));
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(
      //         builder: (_) => MultiProvider(providers: [
      //               Provider<Person>(create: (_) => person),
      //             ], child: HomeScreen())),
      //     (route) => false);
    }
  }

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
                  const InfoHeader(info: "Create an\nAccount"),
                  AuthTextField(
                    controller: nameController,
                    labelText: 'Name',
                    hintText: "John Doe",
                    suffixIcon: Icons.account_box,
                  ),
                  AuthTextField(
                      controller: emailController,
                      labelText: 'Email',
                      hintText: "johndoe@gmail.com",
                      suffixIcon: Icons.mail),
                  addVerticalSpace(10),
                  PhoneNoTextField(
                      controller: phNoController,
                      onChanged: (code) {
                        setState(() {
                          countryCode = code.dialCode!;
                        });
                      }),
                  AuthTextField(
                      controller: passwordController,
                      labelText: 'Password',
                      hintText: "********",
                      suffixIcon: Icons.lock),
                  addVerticalSpace(15),
                  _buildAcceptTerms(),
                  addVerticalSpace(15),
                  _buildAlreadyAccount()
                ],
              ),
            ),
          ),
          BottomAuthButton(text: 'REGISTER', onPressed: () => signUp(context))
        ],
      ),
    );
  }

  Widget _buildAlreadyAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have an Account?",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        CustomTextButton(text: "Sign In!", onPressed: () => widget.goToPage(0)),
      ],
    );
  }

  Widget _buildAcceptTerms() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
            value: agreeTerms,
            onChanged: (value) {
              setState(() {
                agreeTerms = value!;
              });
            }),
        const Text(
          "I agree with",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextButton(
            onPressed: () {},
            child: const Text(
              "terms & conditions",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ))
      ],
    );
  }
}
