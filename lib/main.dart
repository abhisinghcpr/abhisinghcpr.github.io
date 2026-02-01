import 'package:flutter/material.dart';
import 'package:port_polio_abhi/port_polio/port_plio.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Abhishek Singh | Flutter Developer',
      theme: ThemeData.dark(),
      home: const PortfolioHome(),
    );
  }
}



