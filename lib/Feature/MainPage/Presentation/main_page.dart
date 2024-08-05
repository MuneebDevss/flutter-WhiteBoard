import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:white_board/Core/Constants/Color/color_palette.dart';
import 'package:white_board/Core/CustomClipper/line_clipper.dart';
import 'package:white_board/Core/DeviceUtils/device_utils.dart';
import 'package:white_board/Core/Enitity/ShapeModels/circle.dart';
import 'package:white_board/Core/Enitity/ShapeModels/line.dart';
import 'package:white_board/Core/Enitity/ShapeModels/rectangle.dart';
import 'package:white_board/Core/Enitity/shape.dart';
import 'package:white_board/Feature/MainPage/Controller/main_page_controller.dart';
import 'package:white_board/Feature/MainPage/Presentation/Widgets/selected_shape.dart';
import 'dart:io' show platform;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final bool isWeb = kIsWeb;

  late MainPageController controller;
  @override
  void dispose() {
    super.dispose();
  }

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
          const SizedBox(
            width: double.maxFinite,
          ),
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
          Expanded(
            child: Listener(
              onPointerDown: (event) {
                controller.storePointerDownPosition(event, context);

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
                  children: shapeFactory(),
                ),
              ),
            ),
          )
          // if (isWeb)

          //   Listener(
          //     onPointerDown: (details) {
          //       controller.storePointerDownPosition(details, context);
          //       setState(() {});
          //     },
          //     child: Container(
          //       width: screenWidth,
          //       height: 320,
          //        color: Colors.transparent,
          //       child: Stack(
          //         children: List.generate(controller.shapes.length, (index) {
          //           Shapes shape = controller.shapes[index];
          //           if (shape is Line) {
          //             return Positioned(
          //               top: shape.position.dy,

          //               left: shape.position.dx,
          //               child: GestureDetector(
          //                 onTap: () {
          //                   controller.storeTap(index);
          //                   setState(() {});
          //                 },
          //                 child: LineItem(
          //                   shape: shape,
          //                   controller: controller,
          //                   index: index,
          //                 ),
          //               ),
          //             );
          //           } else {
          //             return Positioned(
          //               top: screenHeight > screenWidth
          //                   ? shape.position.dy
          //                   : shape.position.dx - 100,
          //               left: screenHeight > screenWidth
          //                   ? shape.position.dx
          //                   : shape.position.dy,
          //               child: GestureDetector(
          //                 onTap: () {
          //                   controller.storeTap(index);
          //                   setState(() {});
          //                 },
          //                 child: Align(
          //                   alignment: Alignment.centerLeft,
          //                   child: ShapeItem(
          //                     shape: shape,
          //                     controller: controller,
          //                     index: index,
          //                   ),
          //                 ),
          //               ),
          //             );
          //           }
          //         }),
          //       ),
          //     ),
          //   ),
          // if (!isWeb)
          //   Expanded(
          //     child: GestureDetector(
          //       onTapDown: (details) {
          //         controller.storeTapDownPosition(details);
          //         setState(() {});
          //       },
          //       onPanUpdate: (details) {
          //         controller.storePanUpdatePosition(details);
          //         setState(() {});
          //       },
          //       child: Container(
          //         width: double.infinity,
          //         height: double.infinity,
          //         color: Colors.transparent,
          //         child: Stack(
          //           children: List.generate(controller.shapes.length, (index) {
          //             Shapes shape = controller.shapes[index];
          //             if (shape is Line) {
          //               return Positioned(
          //                 top: screenHeight > screenWidth
          //                     ? shape.position.dy
          //                     : shape.position.dx - 100,
          //                 left: screenHeight > screenWidth
          //                     ? shape.position.dx
          //                     : shape.position.dy,
          //                 child: GestureDetector(
          //                   onTap: () {
          //                     controller.storeTap(index);
          //                     setState(() {});
          //                   },
          //                   child: LineItem(
          //                     shape: shape,
          //                     controller: controller,
          //                     index: index,
          //                   ),
          //                 ),
          //               );
          //             } else {
          //               return Positioned(
          //                 top: screenHeight > screenWidth
          //                     ? shape.position.dy
          //                     : shape.position.dx - 100,
          //                 left: screenHeight > screenWidth
          //                     ? shape.position.dx
          //                     : shape.position.dy,
          //                 child: GestureDetector(
          //                   onTap: () {
          //                     controller.storeTap(index);
          //                     setState(() {});
          //                   },
          //                   child: Align(
          //                     alignment: Alignment.centerLeft,
          //                     child: ShapeItem(
          //                       shape: shape,
          //                       controller: controller,
          //                       index: index,
          //                     ),
          //                   ),
          //                 ),
          //               );
          //             }
          //           }),
          //         ),
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }

  List<Widget> shapeFactory() {
    return List.generate(controller.shapes.length, (index) {
      Shapes shape = controller.shapes[index];
      Offset pos = shape.lT;
      Offset rB = shape.rB;
      if (shape is Rectangle) {
        return Positioned.fromRect(
          rect: Rect.fromLTRB(pos.dx, pos.dy, rB.dx, rB.dy),
          child: Container(
            color: Colors.amber,
          ),
        );
      } else if (shape is Circle) {
        return Positioned.fromRect(
          rect: Rect.fromLTRB(pos.dx, pos.dy, rB.dx, rB.dy),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(shape.borderRadius ?? 0),
            ),
          ),
        );
      } else if (shape is Line) {
        return CustomPaint(
          painter: LinePainter(startposition: shape.lT, endPosition: shape.rB),
        );
      } else {
        return Container();
      }
    });
  }
}

class ShapeItem extends StatelessWidget {
  const ShapeItem({
    super.key,
    required this.shape,
    required this.controller,
    required this.index,
  });

  final Shapes shape;
  final int index;
  final MainPageController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      decoration: BoxDecoration(
          color: shape.backgroundColor,
          borderRadius: shape.borderRadius == null
              ? null
              : BorderRadius.circular(shape.borderRadius!),
          border: Border.all(
              color:
                  controller.selectedShape == index ? Colors.blue : Colors.grey,
              width: 2)),
      duration: const Duration(milliseconds: 100),
      child: shape.child,
    );
  }
}

class LineItem extends StatelessWidget {
  const LineItem({
    super.key,
    required this.shape,
    required this.controller,
    required this.index,
  });

  final Shapes shape;
  final int index;
  final MainPageController controller;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LinePainter(startposition: shape.lT, endPosition: shape.rB),
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: shape.lT.dx > shape.rB.dx
              ? shape.lT.dx - shape.rB.dx
              : shape.rB.dx - shape.lT.dx,
          height: shape.lT.dy > shape.rB.dy
              ? shape.lT.dy - shape.rB.dy
              : shape.rB.dy - shape.lT.dy,
          child: Container(
            color: Colors.blue.withOpacity(0.3), // Optional: visual indication
          ),
        ),
      ),
    );
  }
}
