import 'package:flutter/material.dart';
import 'router.dart';

class FishingSnsApp extends StatelessWidget {
  const FishingSnsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '釣りSNS',
      home: AppRouter.buildHome(),
    );
  }
}
