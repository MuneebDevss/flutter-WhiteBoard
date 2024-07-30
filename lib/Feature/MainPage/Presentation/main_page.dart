import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:white_board/Core/Constants/Color/color_palette.dart';
import 'package:white_board/Core/DeviceUtils/device_utils.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = TDeviceUtils.getScreenWidth(context);
    double screenHeight = TDeviceUtils.getScreenHeight(context);
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(

      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              width: screenWidth - (screenWidth / 4),
              height: screenHeight - (screenHeight / 1.1),
              decoration:  BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: TColors.grey,
              ),
              child: Row(
                children: [
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: IconButton(
                      icon: const Icon(Icons.square),
                      onPressed: () {},
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
