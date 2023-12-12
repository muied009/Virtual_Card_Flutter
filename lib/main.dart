import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visiting_card/pages/contact_details_page.dart';
import 'package:visiting_card/pages/from_page.dart';
import 'package:visiting_card/pages/home_page.dart';
import 'package:visiting_card/pages/scan_page.dart';
import 'package:visiting_card/providers/contact_provider.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (context) => ContactProvider(),
  child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName : (context) => const HomePage(),
        ScanPage.routeName : (context) => const ScanPage(),
        FormPage.routeName : (context) => const FormPage(),
        ContactDetailsPage.routeName : (context) => const ContactDetailsPage(),
      },
    );
  }
}
