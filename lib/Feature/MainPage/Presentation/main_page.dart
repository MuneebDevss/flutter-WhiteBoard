import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:screenshot/screenshot.dart';
import 'package:white_board/Core/Constants/Color/color_palette.dart';
import 'package:white_board/Core/Constants/Size/sizes.dart';
import 'package:white_board/Core/Constants/enum.dart';
import 'package:white_board/Core/CustomClipper/line_clipper.dart';
import 'package:white_board/Core/DeviceUtils/device_utils.dart';
import 'package:white_board/Core/Enitity/ShapeModels/brush.dart';
import 'package:white_board/Core/Enitity/ShapeModels/circle.dart';
import 'package:white_board/Core/Enitity/ShapeModels/line.dart';
import 'package:white_board/Core/Enitity/ShapeModels/rectangle.dart';
import 'package:white_board/Core/Enitity/ShapeModels/text_field_rect.dart';
import 'package:white_board/Core/Enitity/my_stack.dart';
import 'package:white_board/Core/Enitity/shape.dart';
import 'package:white_board/Feature/MainPage/Controller/main_page_controller.dart';
import 'package:white_board/Feature/MainPage/Controller/side_bar_controller.dart';
import 'package:white_board/Feature/MainPage/Presentation/TextFieldBloc/textfield_bloc.dart';
import 'package:white_board/Feature/MainPage/Presentation/Widgets/my_textfield.dart';
import 'package:white_board/Feature/MainPage/Presentation/Widgets/selected_tool.dart';
import 'package:white_board/Feature/MainPage/Presentation/Widgets/selection_rectangle.dart';
import 'package:white_board/Feature/MainPage/Presentation/Widgets/textfield_side_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> with TickerProviderStateMixin {
  final bool isWeb = kIsWeb;
  // final bool isWindows = Platform.isWindows;
  late MainPageController controller;
  late SideBarController _sideBarController;
  Shapes? selectedShape;
  @override
  void dispose() {
    controller.disposeFocusNodes();
    super.dispose();
  }

  @override
  void initState() {
    _sideBarController = SideBarController();
    controller = MainPageController();
    controller.controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = TDeviceUtils.getScreenWidth(context);
    double screenHeight = TDeviceUtils.getScreenHeight(context);
    controller.animation = Tween<Offset>(
            end: Offset(0, isWeb ? screenWidth / 5 : screenWidth / 2),
            begin: Offset(isWeb ? screenWidth / 5 : screenWidth / 2,
                isWeb ? screenWidth / 5 : screenWidth / 2))
        .animate(controller.controller);
    if (controller.selectedShape == -1) {
      selectedShape = null;
    } else {
      selectedShape = controller.shapes[controller.selectedShape];
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(child: Image.asset('assets/Icon/CommicSans.png')),
            TextButton(
              child: const Text('Fork on Github'),
              onPressed: () => controller.launchRepository(),
            ),

            const SizedBox(height: 20),
            const Text(
              'Export',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Row(
              children: [
                SizedBox(
                  width: 140,
                  child: TextButton(
                    child: const Text('Export PNG'),
                    onPressed: () async {
                      Uint8List? pngBytes = await controller.getBytes(context);
                      if (pngBytes != null) {
                        controller.saveFile(pngBytes, 'png', isWeb);
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: 140,
                  child: TextButton(
                    child: const Text('Export JPEG'),
                    onPressed: () async {
                      Uint8List? pngBytes = await controller.getBytes(context);
                      if (pngBytes != null) {
                        controller.saveFile(pngBytes, 'jpeg', isWeb);
                      }
                    },
                  ),
                ),
              ],
            ),
            // add about me button or follow buttons
            const Divider(),
            Center(
              child: GestureDetector(
                onTap: () => controller.launchMyGitHub(),
                child: const Text(
                  'Made by Muneeb Ur Rehman',
                  style: TextStyle(fontSize: 12, color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SizedBox(
        width: double.maxFinite,
        height: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.transparent,
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  children: [
                    GestureDetector(
                      onTapDown: (event) {
                        controller.storeTapDownPosition(
                            event, context, _sideBarController);
                        setState(() {});
                      },
                      onPanStart: (event) {
                        controller.storePanDownPosition(
                            event, context, _sideBarController);
                        setState(() {});
                      },
                      onPanUpdate: (event) {
                        controller.storePointerUpdatePosition(event);
                        setState(() {});
                      },
                      onPanEnd: (DragEndDetails det) {
                        controller.managePanEnd(det);
                        setState(() {});
                      },
                      child: BlocBuilder<TextfieldBloc, TextFieldState>(
                        builder: (BuildContext context, TextFieldState state) {
                          if (state is LoadingState) {
                            return const CircularProgressIndicator();
                          }
                          if (state is ChangedState) {
                            if (controller.selectedShape != -1) {
                              controller.shapes[controller.selectedShape].node!
                                  .requestFocus();
                            }
                            return Screenshot(
                              controller: controller.screenShotController,
                              child: Transform.scale(
                                scale: controller.currentScale,
                                child: Container(
                                  color: Colors.white,
                                  width: screenWidth,
                                  height: screenHeight - Sizes.appBarHeight,
                                  child: Stack(
                                    children: shapeFactory(),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Screenshot(
                              controller: controller.screenShotController,
                              child: Transform.scale(
                                scale: controller.currentScale,
                                child: Container(
                                  color: Colors.white,
                                  width: screenWidth,
                                  height: screenHeight - Sizes.appBarHeight,
                                  child: Stack(
                                    children: shapeFactory(),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    if (
                        !controller
                            .isDrawing) //do not show while grabing or reshaping
                      Positioned(
                          left: 10,
                          top: 10,
                          child: controller.selectedContainerIndex != 4
                              ? controller.selectedShape == -1
                                  ? shapesSideBar(screenWidth, screenHeight)
                                  : selectedShape is TextFieldRect
                                      ? TextFieldSideBar(
                                          controller: controller,
                                          screenWidth: screenWidth,
                                          sideBarController: _sideBarController,
                                          screenHeight: screenHeight,
                                          isWeb: isWeb,
                                        )
                                      : shapesSideBar(screenWidth, screenHeight)
                              : TextFieldSideBar(
                                  screenHeight: screenHeight,
                                  isWeb: isWeb,
                                  controller: controller,
                                  screenWidth: screenWidth,
                                  sideBarController: _sideBarController,
                                )),
                    if ((controller.selectedContainerIndex != 3 ||
                            controller.selectedShape == -1) &&
                        !controller
                            .isDrawing) //do not show while grabing or reshaping
                      Positioned(
                          child: AnimatedBuilder(
                        animation: controller.animation,
                        builder: (BuildContext context, Widget? child) {
                          return Transform.translate(
                            offset: controller.animation.value,
                            child: IconButton(
                              color: Colors.black,
                              iconSize: Sizes.iconLg,
                              icon: controller.animation.value ==
                                      Offset(
                                          0,
                                          isWeb
                                              ? screenWidth / 5
                                              : screenWidth / 2)
                                  ? const Icon(Icons.arrow_forward_ios)
                                  : const Icon(Icons.arrow_back_ios),
                              onPressed: () {
                                if (controller.animation.value ==
                                    Offset(
                                        0,
                                        isWeb
                                            ? screenWidth / 5
                                            : screenWidth / 2)) {
                                  controller.controller.reverse();
                                } else {
                                  controller.controller.forward();
                                }
                              },
                            ),
                          );
                        },
                      )),
                    //zoom
                    zoom(screenWidth, screenHeight),
                    undoRedo(screenWidth, screenHeight),
                    //Undo Redo
                  ],
                ),
              ),
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
                  )
                ],
              ),
              child: Wrap(
                spacing: 12,
                children: List.generate(
                  controller.selectedContainer.length,
                  (index) => GestureDetector(
                    onTap: () async {
                      controller.manageToolBarTaps(index, isWeb);
                      setState(() {});
                    },
                    child: SelectedTool(
                      screenHeight: screenHeight,
                      button: controller.selectedContainer[index].button,
                      isSelected: controller.selectedContainerIndex == index,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: Sizes.sm,
            ),
          ],
        ),
      ),
    );
  }

  AnimatedBuilder shapesSideBar(double screenWidth, double screenheigth) {
    return AnimatedBuilder(
      animation: controller.animation,
      builder: (BuildContext context, Widget? child) {
        return Container(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
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
          width: controller.animation.value.dx,
          height: isWeb ? screenheigth / 1.4 : screenheigth / 2,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Stroke', style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(
                  height: Sizes.sm,
                ),
                strokeColorPicker(context),
                const SizedBox(
                  height: Sizes.md,
                ),
                Text('Background Color',
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(
                  height: Sizes.sm,
                ),
                backGroundColorPicker(context),
                const SizedBox(
                  height: Sizes.md,
                ),
                Text('Opacity', style: Theme.of(context).textTheme.bodySmall),
                SizedBox(
                  width: double.maxFinite,
                  child: Slider(
                      label: '${_sideBarController.opacity}',
                      mouseCursor: SystemMouseCursors.grab,
                      activeColor: Colors.blue,
                      value: controller.selectedShape == -1
                          ? _sideBarController.opacity
                          : selectedShape!.opacity,
                      onChangeStart: (value) {
                        controller.stack.add(MyStack(
                            opacity: value,
                            shape: controller.getShapeType(selectedShape!),
                            id: selectedShape!.id));
                      },
                      onChanged: (val) {
                        if (controller.selectedShape != -1) {
                          controller.shapes[controller.selectedShape].opacity =
                              val;
                        } else {
                          _sideBarController.opacity = val;
                        }
                        setState(() {});
                      }),
                ),
                const SizedBox(
                  height: Sizes.sm,
                ),
                Text('Stroke width',
                    style: Theme.of(context).textTheme.bodySmall),
                Slider(
                    min: 1,
                    max: 20,
                    label: '${_sideBarController.opacity}',
                    mouseCursor: SystemMouseCursors.grab,
                    activeColor: Colors.blue,
                    value: controller.selectedShape == -1
                        ? _sideBarController.strokeWidth
                        : selectedShape!.strokeWidth,
                    onChangeStart: (value) {
                      controller.stack.add(MyStack(
                          strokeWidth: value,
                          shape: controller.getShapeType(selectedShape!),
                          id: selectedShape!.id));
                    },
                    onChanged: (val) {
                      if (controller.selectedShape != -1) {
                        controller
                            .shapes[controller.selectedShape].strokeWidth = val;
                      } else {
                        _sideBarController.strokeWidth = val;
                      }
                      setState(() {});
                    }),
                const SizedBox(
                  height: Sizes.sm,
                ),
                Text(
                  'Stroke Style',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(
                  height: Sizes.sm,
                ),
                Wrap(
                  spacing: Sizes.sm,
                  children: [
                    GestureDetector(
                        onTap: () {
                          if (controller.selectedShape != -1) {
                            controller.stack.add(MyStack(
                                strokeStyle: StrokeStyle.solid,
                                shape: controller.getShapeType(selectedShape!),
                                id: selectedShape!.id));
                            controller.shapes[controller.selectedShape]
                                .strokeStyle = StrokeStyle.solid;
                          } else {
                            _sideBarController.strokeStyle = StrokeStyle.solid;
                          }
                          setState(() {});
                        },
                        child: MySelectionRectangle(
                          iconData: const Icon(Icons.horizontal_rule),
                          isSelected: selectedShape == null
                              ? _sideBarController.strokeStyle ==
                                  StrokeStyle.solid
                              : selectedShape!.strokeStyle == StrokeStyle.solid,
                        )),
                    GestureDetector(
                        onTap: () {
                          if (controller.selectedShape != -1) {
                            controller.stack.add(MyStack(
                                strokeStyle: StrokeStyle.dashedBorder,
                                shape: controller.getShapeType(selectedShape!),
                                id: selectedShape!.id));
                            controller.shapes[controller.selectedShape]
                                .strokeStyle = StrokeStyle.dashedBorder;
                          } else {
                            _sideBarController.strokeStyle =
                                StrokeStyle.dashedBorder;
                          }
                          setState(() {});
                        },
                        child: MySelectionRectangle(
                          iconData: const Text(
                            ' ---',
                            style: TextStyle(fontSize: Sizes.md),
                          ),
                          isSelected: selectedShape == null
                              ? _sideBarController.strokeStyle ==
                                  StrokeStyle.dashedBorder
                              : selectedShape!.strokeStyle ==
                                  StrokeStyle.dashedBorder,
                        )),
                  ],
                ),
                const SizedBox(
                  height: Sizes.sm,
                ),
                Text(
                  'Layers',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(
                  height: Sizes.sm,
                ),
                Wrap(
                  spacing: Sizes.spaceBtwItems,
                  runSpacing: Sizes.spaceBtwInputFields,
                  children: [
                    IconButton.filled(
                        onPressed: () {
                          controller.shapes =
                              _sideBarController.moveDownOneLayer(
                                  controller.shapes,
                                  controller.selectedShape,
                                  controller);
                          setState(() {});
                        },
                        icon: MySelectionRectangle(
                          iconData: Image.asset('assets/Icon/LayerDown.png'),
                          isSelected: false,
                        )),
                    IconButton.filled(
                        onPressed: () {
                          controller.shapes = _sideBarController.moveToBottom(
                              controller.shapes,
                              controller.selectedShape,
                              controller);
                          setState(() {});
                        },
                        icon: MySelectionRectangle(
                          iconData: Image.asset('assets/Icon/BottomLayer.png'),
                          isSelected: false,
                        )),
                    IconButton.filled(
                        onPressed: () {
                          controller.shapes = _sideBarController.moveToTop(
                              controller.shapes,
                              controller.selectedShape,
                              controller);
                          setState(() {});
                        },
                        icon: MySelectionRectangle(
                          iconData: Image.asset('assets/Icon/TopLayer.png'),
                          isSelected: false,
                        )),
                    IconButton.filled(
                        onPressed: () {
                          controller.shapes = _sideBarController.moveUpOneLayer(
                              controller.shapes,
                              controller.selectedShape,
                              controller);
                          setState(() {});
                        },
                        icon: MySelectionRectangle(
                          iconData: Image.asset('assets/Icon/LayerUp.png'),
                          isSelected: false,
                        )),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  backGroundColorPicker(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      runAlignment: WrapAlignment.start,
      spacing: 5,
      children: List.generate(5, (strokeIndex) {
        if (strokeIndex <= 3) {
          Color constantColor =
              _sideBarController.backGroundConstantColors[strokeIndex];
          return InkWell(
              onTap: () {
                if (controller.selectedShape != -1) {
                  Shapes shape = selectedShape!;
                  if (shape is Circle) {
                    final MyStack stack = MyStack(
                        id: shape.id,
                        backgroundColor: shape.backgroundColor,
                        shape: ShapeTypes.circle);
                    controller.stack.add(stack);
                    (controller.shapes[controller.selectedShape] as Circle)
                        .backgroundColor = constantColor;
                  } else if (shape is Rectangle) {
                    final MyStack stack = MyStack(
                        id: shape.id,
                        backgroundColor: shape.backgroundColor,
                        shape: ShapeTypes.rectangle);
                    controller.stack.add(stack);
                    (controller.shapes[controller.selectedShape] as Rectangle)
                        .backgroundColor = constantColor;
                  }
                } else {
                  _sideBarController.backgroundColor = constantColor;
                }
                setState(() {});
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(
                      color: controller.selectedShape == -1
                          ? constantColor == _sideBarController.backgroundColor
                              ? constantColor
                              : Colors.transparent
                          : selectedShape is Rectangle
                              ? (selectedShape as Rectangle).backgroundColor ==
                                      constantColor
                                  ? constantColor
                                  : Colors.transparent
                              : selectedShape is Circle
                                  ? (selectedShape as Circle).backgroundColor ==
                                          constantColor
                                      ? constantColor
                                      : Colors.transparent
                                  : Colors.transparent,
                    )),
                child: Container(
                  width: 25,
                  height: 25,
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: constantColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ));
        } else {
          return InkWell(
              onTap: () async {
                if (controller.selectedShape != -1) {
                  if (selectedShape is Circle) {
                    final MyStack stack = MyStack(
                        id: selectedShape!.id,
                        backgroundColor:
                            (selectedShape as Circle).backgroundColor,
                        shape: controller.getShapeType(selectedShape!));
                    controller.stack.add(stack);
                    (controller.shapes[controller.selectedShape] as Circle)
                            .backgroundColor =
                        await showColorPickerDialog(
                            context, (selectedShape as Circle).backgroundColor,
                            showColorCode: true);
                  } else if (selectedShape is Rectangle) {
                    final MyStack stack = MyStack(
                        id: selectedShape!.id,
                        backgroundColor:
                            (selectedShape as Rectangle).backgroundColor,
                        shape: controller.getShapeType(selectedShape!));
                    controller.stack.add(stack);
                    (controller.shapes[controller.selectedShape] as Rectangle)
                            .backgroundColor =
                        await showColorPickerDialog(context,
                            (selectedShape as Rectangle).backgroundColor,
                            showColorCode: true);
                  }
                } else {
                  _sideBarController.backgroundColor =
                      await showColorPickerDialog(
                          context, _sideBarController.backgroundColor,
                          showColorCode: true);
                }
                setState(() {});
              },
              child: Container(
                width: 25,
                height: 25,
                margin: const EdgeInsets.only(left: 10, top: 3),
                decoration: BoxDecoration(
                  color: controller.selectedShape == -1
                      ? _sideBarController.backgroundColor
                      : selectedShape is Rectangle
                          ? (selectedShape as Rectangle).backgroundColor
                          : selectedShape is Circle
                              ? (selectedShape as Circle).backgroundColor
                              : Colors.transparent,
                  borderRadius: BorderRadius.circular(5),
                ),
              ));
        }
      }),
    );
  }

  Wrap strokeColorPicker(BuildContext context) {
    return Wrap(
      spacing: 3,
      direction: Axis.horizontal,
      runAlignment: WrapAlignment.start,
      children: List.generate(5, (strokeIndex) {
        if (strokeIndex <= 3) {
          Color constantColor = _sideBarController.constantColors[strokeIndex];

          return InkWell(
              onTap: () {
                if (controller.selectedShape != -1) {
                  final MyStack stack = MyStack(
                      id: selectedShape!.id,
                      stroke: selectedShape!.stroke,
                      shape: controller.getShapeType(selectedShape!));
                  controller.stack.add(stack);
                  controller.shapes[controller.selectedShape].stroke =
                      constantColor;
                } else {
                  _sideBarController.strokeColor = constantColor;
                }
                setState(() {});
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(
                      color: controller.selectedShape == -1
                          ? constantColor == _sideBarController.strokeColor
                              ? constantColor
                              : Colors.transparent
                          : constantColor == selectedShape!.stroke
                              ? constantColor
                              : Colors.transparent,
                    )),
                child: Container(
                  width: 25,
                  height: 25,
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: constantColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ));
        } else {
          return InkWell(
              onTap: () async {
                if (selectedShape != null) {
                  final MyStack stack = MyStack(
                      id: selectedShape!.id,
                      stroke: selectedShape!.stroke,
                      shape: controller.getShapeType(selectedShape!));
                  controller.stack.add(stack);
                  controller.shapes[controller.selectedShape].stroke =
                      await showColorPickerDialog(
                          context, selectedShape!.stroke,
                          showColorCode: true);
                } else {
                  _sideBarController.strokeColor = await showColorPickerDialog(
                      context, _sideBarController.strokeColor,
                      showColorCode: true);
                }
                setState(() {});
              },
              child: Container(
                width: 25,
                height: 25,
                margin: const EdgeInsets.only(left: 10, top: 3),
                decoration: BoxDecoration(
                  color: controller.selectedShape == -1
                      ? _sideBarController.strokeColor
                      : selectedShape!.stroke,
                  borderRadius: BorderRadius.circular(5),
                ),
              ));
        }
      }),
    );
  }

  Positioned zoom(double screenWidth, double screenHeight) {
    return Positioned(
        left: 10,
        bottom: 5,
        child: Row(
          children: [
            InkWell(
                onTap: () {
                  setState(() {
                    controller.zoomOut();
                  });
                },
                child: Container(
                  width: isWeb ? screenWidth / 30 : screenWidth / 10,
                  height: isWeb ? screenHeight / 20 : screenHeight / 30,
                  decoration: const BoxDecoration(
                      color: Color(0xFFECECF4),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10))),
                  child: const Icon(Icons.remove),
                )),
            InkWell(
                child: Container(
                    width: isWeb ? screenWidth / 25 : screenWidth / 5,
                    height: isWeb ? screenHeight / 20 : screenHeight / 30,
                    color: const Color(0xFFECECF4),
                    child: Center(
                        child: Text(
                            '${(controller.currentScale * 100).toStringAsFixed(0)}%')))),
            InkWell(
                onTap: () {
                  setState(() {
                    controller.zoomIn();
                  });
                },
                child: Container(
                  width: isWeb ? screenWidth / 30 : screenWidth / 10,
                  height: isWeb ? screenHeight / 20 : screenHeight / 30,
                  decoration: const BoxDecoration(
                      color: Color(0xFFECECF4),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  child: const Icon(Icons.add),
                )),
          ],
        ));
  }

  List<Widget> shapeFactory() {
    return List.generate(controller.shapes.length, (index) {
      Shapes shape = controller.shapes[index];
      Offset pos = shape.lT;
      Offset rB = shape.rB;
      if (shape is Rectangle) {
        if (controller.selectedShape == index) {
          return buildSelectedRectangle(pos, rB, index, shape);
        } else {
          return buildRectangle(pos, rB, index, shape);
        }
      } else if (shape is Circle) {
        if (controller.selectedShape == index) {
          return buildSelectedCircle(pos, rB, index, shape);
        } else {
          return buildCircle(pos, rB, index, shape);
        }
      } else if (shape is TextFieldRect) {
        if (shape.child is MyTextfield) {
          return buildTextField(pos, rB, index, shape);
        } else {
          return buildSelectedText(pos, rB, index, shape);
        }
      } else if (shape is Line) {
        return KeyboardListener(
          focusNode: shape.node!,
          onKeyEvent: (event) {
            shape.node!.requestFocus();
            if (event is KeyDownEvent) controller.handleKeyEvents(event);
            setState(() {});
          },
          child: Transform.translate(
            offset: controller.translation,
            child: CustomPaint(
              painter: LinePainter(
                  endPosition: rB,
                  startPosition: pos,
                  stroke: shape.stroke,
                  strokeWidth: shape.strokeWidth - 1 / shape.scale,
                  curvePoint: shape.curve,
                  isGrabAble: controller.selectedShape == index,
                  opacity: shape.opacity,
                  isDashed: shape.strokeStyle == StrokeStyle.dashedBorder,
                  context: context,
                  controller: controller,
                  index: index,
                  hasArrowEnd: shape.hasArrowEnd),
            ),
          ),
        );
      } else if (shape is Brush) {
        return Transform.translate(
          offset: controller.translation,
          child: CustomPaint(
            painter: BrushClipper(
                points: shape.points,
                stroke: shape.stroke,
                strokeWidth: shape.strokeWidth - 1 / shape.scale,
                opacity: shape.opacity),
          ),
        );
      } else {
        return Container();
      }
    });
  }

  Positioned buildRectangle(Offset pos, Offset rB, int index, Rectangle shape) {
    return Positioned.fromRect(
      rect: Rect.fromPoints(pos, rB),
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..rotateZ(shape.rotationAngle)
          ..translate(controller.translation.dx, controller.translation.dy),
        child: MouseRegion(
          onHover: (event) {
            controller.setMouseHover(event);
            setState(() {});
          },
          cursor: SystemMouseCursors.click,
          child: shape.strokeStyle == StrokeStyle.solid
              ? GestureDetector(
                  onTapDown: (TapDownDetails details) {
                    controller.manageTap(index, details.localPosition);
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: shape.backgroundColor.withOpacity(
                          shape.backgroundColor == Colors.transparent
                              ? 0
                              : shape.opacity),
                      border: Border.all(
                        color: shape.stroke.withOpacity(shape.opacity),
                        width: shape.strokeWidth - shape.scale > 0
                            ? shape.strokeWidth - shape.scale
                            : shape.strokeWidth - 1 / shape.scale,
                      ),
                      borderRadius: BorderRadius.circular(shape.borderRadius),
                    ),
                    child: shape.child,
                  ),
                )
              : GestureDetector(
                  onTapDown: (TapDownDetails details) {
                    controller.manageTap(index, details.localPosition);
                    setState(() {});
                  },
                  child: DottedBorder(
                    color: shape.stroke.withOpacity(shape.opacity),
                    strokeWidth: shape.strokeWidth - 1 / shape.scale,
                    dashPattern: const [8, 4],
                    radius: Radius.circular(shape.borderRadius),
                    child: Container(
                      decoration: BoxDecoration(
                        color: shape.backgroundColor.withOpacity(
                            shape.backgroundColor == Colors.transparent
                                ? 0
                                : shape.opacity),
                        borderRadius: BorderRadius.circular(shape.borderRadius),
                      ),
                      child: shape.child,
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Positioned buildCircle(Offset pos, Offset rB, int index, Circle shape) {
    return Positioned.fromRect(
      rect: Rect.fromPoints(pos, rB),
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..rotateZ(shape.rotationAngle)
          ..translate(controller.translation.dx, controller.translation.dy),
        child: MouseRegion(
          onHover: (event) {
            controller.setMouseHover(event);
            setState(() {});
          },
          cursor: SystemMouseCursors.click,
          child: shape.strokeStyle == StrokeStyle.solid
              ? GestureDetector(
                  onTapDown: (TapDownDetails details) {
                    controller.manageTap(index, details.localPosition);
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: shape.backgroundColor.withOpacity(
                          shape.backgroundColor == Colors.transparent
                              ? 0
                              : shape.opacity),
                      border: Border.all(
                        color: shape.stroke.withOpacity(shape.opacity),
                        width: shape.strokeWidth - shape.scale > 0
                            ? shape.strokeWidth - shape.scale
                            : shape.strokeWidth - 1 / shape.scale,
                      ),
                      borderRadius: BorderRadius.circular(shape.borderRadius),
                    ),
                    child: shape.child,
                  ),
                )
              : GestureDetector(
                  onTapDown: (TapDownDetails details) {
                    controller.manageTap(index, details.localPosition);
                    setState(() {});
                  },
                  child: DottedBorder(
                    color: shape.stroke.withOpacity(shape.opacity),
                    strokeWidth: shape.strokeWidth - 1 / shape.scale,
                    dashPattern: const [8, 4],
                    radius: Radius.circular(shape.borderRadius),
                    child: Container(
                      decoration: BoxDecoration(
                        color: shape.backgroundColor.withOpacity(
                            shape.backgroundColor == Colors.transparent
                                ? 0
                                : shape.opacity),
                        borderRadius: BorderRadius.circular(shape.borderRadius),
                      ),
                      child: shape.child,
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Positioned buildTextField(
      Offset pos, Offset rB, int index, TextFieldRect shape) {
    return Positioned(
      left: pos.dx,
      top: pos.dy,
      child: Transform.translate(
        offset: controller.translation,
        child: GestureDetector(
          onTap: () {
            controller.manageTap(index, pos);
            setState(() {});
          },
          child: IntrinsicWidth(child: shape.child),
        ),
      ),
    );
  }

  Widget buildSelectedRectangle(
      Offset pos, Offset rB, int index, Rectangle shape) {
    return Positioned.fromRect(
      rect: Rect.fromPoints(pos, rB - const Offset(10, 10)),
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..rotateZ(shape.rotationAngle)
          ..translate(controller.translation.dx, controller.translation.dy),
        child: MouseRegion(
          onHover: (event) {
            controller.setMouseHover(event);
            setState(() {});
          },
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTapDown: (TapDownDetails details) {
              controller.manageTap(index, details.localPosition);
              setState(() {});
            },
            child: DottedBorder(
              padding: const EdgeInsets.all(10),
              color: Colors.blue,
              strokeWidth: 2,
              dashPattern: const [8, 4],
              child: KeyboardListener(
                focusNode: shape.node!,
                onKeyEvent: (event) {
                  if (event is KeyRepeatEvent) {
                    controller.handleKeyholdEvents(event);
                  } else if (event is KeyDownEvent) {
                    controller.handleKeyEvents(event);
                  } else if (event is KeyUpEvent) {
                    controller.shiftPressed = false;
                  }
                  setState(() {});
                },
                child: shape.strokeStyle == StrokeStyle.solid
                    ? Container(
                        decoration: BoxDecoration(
                          color: shape.backgroundColor.withOpacity(
                              shape.backgroundColor == Colors.transparent
                                  ? 0
                                  : shape.opacity),
                          border: Border.all(
                            color: shape.stroke.withOpacity(shape.opacity),
                            width: shape.strokeWidth - shape.scale > 0
                                ? shape.strokeWidth - shape.scale
                                : shape.strokeWidth - shape.scale > 0
                                    ? shape.strokeWidth - shape.scale
                                    : shape.strokeWidth - 1 / shape.scale,
                          ),
                          borderRadius:
                              BorderRadius.circular(shape.borderRadius),
                        ),
                        child: shape.child,
                      )
                    : DottedBorder(
                        color: shape.stroke.withOpacity(shape.opacity),
                        strokeWidth: shape.strokeWidth - 1 / shape.scale,
                        dashPattern: const [8, 4],
                        radius: Radius.circular(shape.borderRadius),
                        child: Container(
                          decoration: BoxDecoration(
                            color: shape.backgroundColor.withOpacity(
                                shape.backgroundColor == Colors.transparent
                                    ? 0
                                    : shape.opacity),
                            borderRadius:
                                BorderRadius.circular(shape.borderRadius),
                          ),
                          child: shape.child,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSelectedCircle(Offset pos, Offset rB, int index, Circle shape) {
    return Positioned.fromRect(
      rect: Rect.fromPoints(pos, rB - const Offset(10, 10)),
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..rotateZ(shape.rotationAngle)
          ..translate(controller.translation.dx, controller.translation.dy),
        child: MouseRegion(
          onHover: (event) {
            controller.setMouseHover(event);
            setState(() {});
          },
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTapDown: (TapDownDetails details) {
              controller.manageTap(index, details.localPosition);
              setState(() {});
            },
            child: DottedBorder(
              padding: const EdgeInsets.all(10),
              color: Colors.blue,
              strokeWidth: 2,
              dashPattern: const [8, 4],
              child: KeyboardListener(
                focusNode: shape.node!,
                onKeyEvent: (event) {
                  if (event is KeyRepeatEvent) {
                    controller.handleKeyholdEvents(event);
                  } else if (event is KeyDownEvent) {
                    controller.handleKeyEvents(event);
                  } else if (event is KeyUpEvent) {
                    controller.shiftPressed = false;
                  }
                  setState(() {});
                },
                child: shape.strokeStyle == StrokeStyle.solid
                    ? Container(
                        decoration: BoxDecoration(
                          color: shape.backgroundColor.withOpacity(
                              shape.backgroundColor == Colors.transparent
                                  ? 0
                                  : shape.opacity),
                          border: Border.all(
                            color: shape.stroke.withOpacity(shape.opacity),
                            width: shape.strokeWidth - shape.scale > 0
                                ? shape.strokeWidth - shape.scale
                                : shape.strokeWidth - 1 / shape.scale,
                          ),
                          borderRadius:
                              BorderRadius.circular(shape.borderRadius),
                        ),
                        child: shape.child,
                      )
                    : DottedBorder(
                        color: shape.stroke.withOpacity(shape.opacity),
                        strokeWidth: shape.strokeWidth - 1 / shape.scale,
                        radius: Radius.circular(shape.borderRadius),
                        dashPattern: const [8, 4],
                        borderType: BorderType.RRect,
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(shape.borderRadius),
                          child: Container(
                            decoration: BoxDecoration(
                              color: shape.backgroundColor.withOpacity(
                                  shape.backgroundColor == Colors.transparent
                                      ? 0
                                      : shape.opacity),
                              borderRadius:
                                  BorderRadius.circular(shape.borderRadius),
                            ),
                            child: shape.child,
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Positioned undoRedo(double screenWidth, double screenHeight) {
    return Positioned(
        left: isWeb ? screenWidth / 9 + 20 : screenWidth / 2.5 + 20,
        bottom: 5,
        child: Row(
          children: [
            InkWell(
                onTap: () {
                  controller.undo();
                  setState(() {});
                },
                child: Container(
                  width: isWeb ? screenWidth / 30 : screenWidth / 10,
                  height: isWeb ? screenHeight / 20 : screenHeight / 30,
                  decoration: const BoxDecoration(
                      color: Color(0xFFECECF4),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10))),
                  child: const Icon(Iconsax.undo),
                )),
            InkWell(
                onTap: () {
                  controller.redo();
                  setState(() {});
                },
                child: Container(
                  width: isWeb ? screenWidth / 30 : screenWidth / 10,
                  height: isWeb ? screenHeight / 20 : screenHeight / 30,
                  decoration: const BoxDecoration(
                      color: Color(0xFFECECF4),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  child: const Icon(Iconsax.redo),
                )),
          ],
        ));
  }

  Widget buildSelectedText(
      Offset pos, Offset rB, int index, TextFieldRect shape) {
    return Positioned(
      left: pos.dx,
      top: pos.dy,
      child: KeyboardListener(
        focusNode: shape.node!,
        onKeyEvent: (event) {
          if (event is KeyDownEvent) {
            controller.handleKeyEvents(event,
                func: () => _sideBarController.convertTextToTextField(
                    index, shape, controller));
          }
          setState(() {});
        },
        child: Transform(
          alignment: Alignment.topLeft,
          transform: Matrix4.translationValues(
              controller.translation.dx, controller.translation.dy, 0.0),
          transformHitTests: true,
          child: MouseRegion(
            cursor: SystemMouseCursors.grab,
            child: Container(
              decoration: BoxDecoration(
                border: index == controller.selectedShape
                    ? Border.all(color: Colors.blue, width: 2)
                    : Border.all(color: Colors.transparent, width: 2),
              ),
              child: shape.child,
            ),
          ),
        ),
      ),
    );
  }
}
