import 'package:flutter/material.dart';
import 'package:quantum_assignment/ui/auth/signup_screen.dart';
import '../../constants.dart';
import 'components/buttons.dart';
import 'login_screen.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: _currentIndex);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("SocialX"),
        elevation: 0,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildNavigationBar(),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: [
                LoginScreen(goToPage: _goToPage,),
                SignupScreen(goToPage: _goToPage,),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
        border: Border.all(
          color: kPrimaryColor,
          width: 1.5,
        ),
        color: Colors.white
      ),
      child: Row(
        children: [
          Expanded(
            child : CustomButton(
                childText: "LOGIN",
                onPressed: () => _goToPage(0),
                roundBottom: true,
                roundTop: false,
                backgroundColor: _currentIndex == 0 ? kPrimaryColor : Colors.white),
          ),
          Expanded(
            child: CustomButton(
                childText: "SIGN UP",
                onPressed: () => _goToPage(1),
                roundBottom: true,
                roundTop: false,
                backgroundColor: _currentIndex == 1 ? kPrimaryColor : Colors.white),
          ),
        ],
      ),
    );
  }


}


