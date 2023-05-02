import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:quantum_assignment/models/news.dart';
import 'package:quantum_assignment/models/person.dart';
import 'package:quantum_assignment/services/firebase_auth_service.dart';
import 'package:quantum_assignment/services/new_service.dart';
import 'package:quantum_assignment/ui/auth/auth_page.dart';
import 'package:quantum_assignment/ui/home/home_screen.dart';
import 'constants.dart';
import 'firebase_options.dart';

Future<void> initialiseHive() async {
  await Hive.initFlutter();
  try {
    Hive.registerAdapter(NewsAdapter());
  } catch (e) {
    print(e);
  }
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initialiseHive();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthService>(create: (_) => FirebaseAuthService()),
        ChangeNotifierProvider<NewsService>(create: (_) => NewsService())
      ],
      builder: (context, _) {
        return MaterialApp(
            theme: ThemeData(
              primarySwatch: kPrimaryColor,
            ),
            home: Provider.of<FirebaseAuthService>(context, listen: false)
                        .auth
                        .currentUser ==
                    null
                ? const AuthPage()
                : FutureBuilder<Person?>(
                    future: Person.fromUid(
                        Provider.of<FirebaseAuthService>(context, listen: false)
                            .auth
                            .currentUser!
                            .uid),
                    builder: (BuildContext context,
                        AsyncSnapshot<Person?> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Scaffold(
                          body: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      if(snapshot.data == null){
                        Provider.of<FirebaseAuthService>(context, listen: false).signOut();
                        return const AuthPage();
                      }
                      return MultiProvider(providers: [
                        Provider<Person>(create: (_) => snapshot.data!),
                      ], child: HomeScreen());
                    },
                  ));
      },
    );
  }
}
