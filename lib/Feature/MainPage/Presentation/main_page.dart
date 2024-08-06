import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:white_board/Core/Constants/Color/color_palette.dart';
import 'package:white_board/Core/CustomClipper/line_clipper.dart';
import 'package:white_board/Core/DeviceUtils/device_utils.dart';
import 'package:white_board/Core/Enitity/ShapeModels/brush.dart';
import 'package:white_board/Core/Enitity/ShapeModels/circle.dart';
import 'package:white_board/Core/Enitity/ShapeModels/line.dart';
import 'package:white_board/Core/Enitity/ShapeModels/rectangle.dart';
import 'package:white_board/Core/Enitity/shape.dart';
import 'package:white_board/Feature/MainPage/Controller/main_page_controller.dart';
import 'package:white_board/Feature/MainPage/Presentation/Widgets/selected_shape.dart';

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
        ],
      ),
    );
  }

  List<Widget> shapeFactory() {
    return List.generate(controller.shapes.length, (index) {
      Shapes shape = controller.shapes[index];
      Offset pos = shape.lT;
      Offset rB = shape.rB;
      if (shape is Rectangle || shape is Circle) {
        return Positioned.fromRect(
          rect: Rect.fromLTRB(pos.dx, pos.dy, rB.dx, rB.dy),
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
                      color: controller.selectedShape == index
                          ? Colors.blue
                          : shape.backgroundColor ?? Colors.grey,
                    )),
                child: shape.child,
              ),
            ),
          ),
        );
      } else if (shape is Line) {
        return CustomPaint(
          painter: LinePainter(endPosition: rB, startPosition: pos),
        );
      } else if (shape is Brush) {
        return CustomPaint(
          painter: BrushClipper(points: shape.points),
        );
      } else {
        return Container();
      }
    });
  }
}
