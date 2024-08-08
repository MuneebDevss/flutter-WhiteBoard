import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:white_board/Core/Constants/Color/color_palette.dart';
import 'package:white_board/Core/Constants/Size/sizes.dart';
import 'package:white_board/Core/CustomClipper/line_clipper.dart';
import 'package:white_board/Core/DeviceUtils/device_utils.dart';
import 'package:white_board/Core/Enitity/ShapeModels/brush.dart';
import 'package:white_board/Core/Enitity/ShapeModels/circle.dart';
import 'package:white_board/Core/Enitity/ShapeModels/line.dart';
import 'package:white_board/Core/Enitity/ShapeModels/rectangle.dart';
import 'package:white_board/Core/Enitity/shape.dart';
import 'package:white_board/Feature/MainPage/Controller/main_page_controller.dart';
import 'package:white_board/Feature/MainPage/Controller/side_bar_controller.dart';
import 'package:white_board/Feature/MainPage/Presentation/Widgets/selected_shape.dart';
import 'package:white_board/Feature/MainPage/Presentation/Widgets/side_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final bool isWeb = kIsWeb;

  late MainPageController controller;
  late SideBarController _sideBarController;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _sideBarController = SideBarController();
    controller = MainPageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = TDeviceUtils.getScreenWidth(context);
    double screenHeight = TDeviceUtils.getScreenHeight(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      drawer: const Drawer(),
      body: Column(
        children: [
          const SizedBox(
            width: double.maxFinite,
          ),
          Container(
            alignment: Alignment.center,
            width: screenWidth - (screenWidth / 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 5,
                  color: TColors.grey,
                  blurStyle: BlurStyle.outer,
                  offset: Offset(0, 1),
                )
              ],
            ),
            child: Wrap(
              spacing: 12,
              children: List.generate(
                controller.selectedContainer.length,
                (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      controller.selectedContainerIndex == index
                          ? controller.selectedContainerIndex = -1
                          : controller.selectedContainerIndex = index;
                    });
                  },
                  child: SelectShape(
                    screenHeight: screenHeight,
                    button: controller.selectedContainer[index].button,
                    isSelected: controller.selectedContainerIndex == index,
                  ),
                ),
              ),
            ),
          ),
          if (controller.selectedShape != -1 &&
              controller.selectedContainerIndex != -1)
            Expanded(
              child: Listener(
                onPointerDown: (event) {
                  controller.storePointerDownPosition(
                      event, context, _sideBarController);
                  setState(() {});
                },
                onPointerMove: (event) {
                  controller.storePointerUpdatePosition(event);
                  setState(() {});
                },
                child: Container(
                  color: Colors.transparent,
                  width: screenWidth,
                  height: double.infinity,
                  child: Stack(
                    children: shapeFactory('don'),
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: Container(
                color: Colors.transparent,
                width: screenWidth,
                height: double.infinity,
                child: Stack(
                  children: [
                    Listener(
                      onPointerDown: (event) {
                        controller.storePointerDownPosition(
                            event, context, _sideBarController);
                        setState(() {});
                      },
                      onPointerMove: (event) {
                        controller.storePointerUpdatePosition(event);
                        setState(() {});
                      },
                      child: Container(
                        color: Colors.transparent,
                        width: screenWidth,
                        height: screenHeight-Sizes.appBarHeight,
                        child: Stack(
                          children: shapeFactory('wor'),
                        ),
                      ),
                    ),
                    Positioned(
                        left: 10,
                        top: 10,
                        child: MySideBar(
                          controller: _sideBarController,
                          screenWidth: screenWidth,
                        ))
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }

  List<Widget> shapeFactory(String wor) {
    return List.generate(controller.shapes.length, (index) {
      Shapes shape = controller.shapes[index];
      Offset pos = shape.lT;
      Offset rB = shape.rB;
      if (shape is Rectangle || shape is Circle) {
        return Positioned.fromRect(
          rect: Rect.fromPoints(pos, rB),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                controller.manageTap(index);
                setState(() {});
              },
              child: Container(
                decoration: BoxDecoration(
                    color: shape.backgroundColor,
                    borderRadius:
                        BorderRadius.circular(shape.borderRadius ?? 0),
                    border: Border.all(
                      width: shape.strokeWidth,
                      color: controller.selectedShape == index
                          ? Colors.blue
                          : shape.stroke,
                    )),
                child: shape.child,
              ),
            ),
          ),
        );
      } else if (shape is Line) {
        return CustomPaint(
          size: const Size(20,20),
          painter: LinePainter(endPosition: rB, startPosition: pos, stroke: shape.stroke, strokeWidth: shape.strokeWidth, isGrabAble: controller.selectedContainerIndex==3||controller.selectedContainerIndex==6,opacity: shape.opacity),
        );
      } else if (shape is Brush) {
        return CustomPaint(
          painter: BrushClipper(points: shape.points, stroke: shape.stroke, strokeWidth: shape.strokeWidth,opacity: shape.opacity),
        );
      } else {
        return Container();
      }
    });
  }
}
