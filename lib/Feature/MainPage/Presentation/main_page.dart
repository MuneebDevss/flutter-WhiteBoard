import 'package:flutter/material.dart';
import 'package:white_board/Core/Constants/Color/color_palette.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      
      body: Column(
        children: [
          Container(
          width: 120,
          decoration: BoxDecoration(
            color: TColors.light,
          ),
          child: Row(
            children: [Container()],
          ),
        )
        ],
      ),
    );
  }
}
