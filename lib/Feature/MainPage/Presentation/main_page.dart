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
      drawer: Drawer(),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              width: screenWidth - (screenWidth / 4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 5,
                      color: TColors.grey,
                      blurStyle: BlurStyle.outer,
                      offset: Offset(0, 1),
                    )
                  ]),
              child: Wrap(
                spacing: 12,
                children: [
                  ShapeSelector(
                    screenHeight: screenHeight,
                    button: IconButton(
                      icon: const Icon(Icons.square_outlined),
                      onPressed: () {},
                    ),
                  ),
                  ShapeSelector(
                    screenHeight: screenHeight,
                    button: IconButton(
                      icon: const Icon(Icons.circle_outlined),
                      onPressed: () {},
                    ),
                  ),
                  ShapeSelector(
                    screenHeight: screenHeight,
                    button: IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {},
                    ),
                  ),
                  ShapeSelector(
                    screenHeight: screenHeight,
                    button: IconButton(
                      icon: const Text(
                        '___',
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  ShapeSelector(
                    color: TColors.primary,
                    screenHeight: screenHeight,
                    button: IconButton(
                      icon: const Icon(Icons.square_outlined),
                      onPressed: () {},
                    ),
                  ),
                  ShapeSelector(
                    screenHeight: screenHeight,
                    button: IconButton(
                      icon: const Icon(Icons.square_outlined),
                      onPressed: () {},
                    ),
                  ),
                  ShapeSelector(
                    screenHeight: screenHeight,
                    button: IconButton(
                      icon: const Icon(Icons.square_outlined),
                      onPressed: () {},
                    ),
                  ),
                  ShapeSelector(
                    screenHeight: screenHeight,
                    button: IconButton(
                      icon: const Icon(Icons.square_outlined),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ShapeSelector extends StatelessWidget {
  const ShapeSelector({
    super.key,
    required this.screenHeight,
    required this.button, this.color,
  });
  final Color? color;
  final double screenHeight;
  final IconButton button;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      height: screenHeight - (screenHeight / 1.1),
      width: 50,
      child: button,
    );
  }
}
