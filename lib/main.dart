import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starfleet_app/screens/dashboard/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:starfleet_app/screens/login_screen.dart';
import 'package:starfleet_app/screens/util/backend_call.dart';
import 'firebase_options.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase is initialized on app Launch
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //Loads env file
  //
  // Runs the App
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recommender App',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      debugShowCheckedModeBanner: false,
      home: RepositoryProvider(
          create: (context) => APIServices(), child: LoginScreen()),
    );
  }
}
