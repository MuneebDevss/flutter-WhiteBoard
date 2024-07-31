import 'package:flutter/material.dart';
import 'package:white_board/Core/Constants/Color/color_palette.dart';
import 'package:white_board/Core/DeviceUtils/device_utils.dart';
import 'package:white_board/Core/Enitity/shape.dart';
import 'package:white_board/Feature/MainPage/Controller/main_page_controller.dart';
import 'package:white_board/Feature/MainPage/Presentation/Widgets/selected_shape.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late MainPageController controller;
  @override
  void initState() {
    controller = MainPageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = TDeviceUtils.getScreenWidth(context);
    double screenHeight = TDeviceUtils.getScreenHeight(context);
    return Scaffold(
      appBar: AppBar(),
      drawer: const Drawer(),
      body: Column(

        children: [
          const SizedBox(width: double.infinity,),
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
              children: List.generate(
                  controller.selectedContainer.length,
                  (index) => GestureDetector(
                        onTap: () {
                          controller.selectedContainerIndex == index
                              ? controller.selectedContainerIndex = -1
                              : controller.selectedContainerIndex = index;
                          setState(() {});
                        },
                        child: SelectedShape(
                            screenHeight: screenHeight,
                            button:
                                controller.selectedContainer[index].button,
                            isSelected:
                                controller.selectedContainerIndex == index),
                      )),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTapDown: (details) {
                controller.storeTapDownPosition(details);
              setState(() {
                
              });
              },
              onPanUpdate: (details) {
                controller.storePanUpdatePosition(details);
              setState(() {
                
              });
              },
              child: Stack(
                children: List.generate(controller.shapes.length, (index) {
                  Shapes shape = controller.shapes[index];
                  return Positioned(
                      top: shape.position.dx,
                      left: shape.position.dy,
                      child: AnimatedContainer(
                        decoration: BoxDecoration(
                          borderRadius: shape.borderRadius == null
                              ? BorderRadius.circular(shape.borderRadius!)
                              : null,
                        ),
                        width: shape.width,
                        height: shape.height,
                        duration: const Duration(milliseconds: 100),
                      ));
                }),
              ),
            ),
          )
        ],
      ),
    );
  }
}
