import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:super_pagination_example/app/bootstrap/firebase_options.dart';
import 'package:super_pagination_example/app/presentation/pagination_example_app.dart';

abstract final class AppBootstrap {
  static Future<void> run() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(PaginationExampleApp(key: PaginationExampleApp.appKey));
  }
}
