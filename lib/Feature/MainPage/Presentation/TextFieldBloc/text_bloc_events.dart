part of 'textfield_bloc.dart';

class TextFieldEvent {}

class InitialEvent extends TextFieldEvent {}

class ChangeEvent extends TextFieldEvent {
  final VoidCallback func;

  ChangeEvent({required this.func});
}

class TextColorChangedEvent extends TextFieldEvent {
  final Color color;

  TextColorChangedEvent({required this.color});
}

class TextSizeChangedEvent extends TextFieldEvent {
  final FontSize size;

  TextSizeChangedEvent({required this.size});
}

class TextOpacityChangedEvent extends TextFieldEvent {
  final double opacity;

  TextOpacityChangedEvent({required this.opacity});
}

class FontFamilyChangedEvent extends TextFieldEvent {
  final FontFamily fontFamily;

  FontFamilyChangedEvent({required this.fontFamily});
}

class TextAlignmentChangedEvent extends TextFieldEvent {
  final TextAlignment alignment;

  TextAlignmentChangedEvent({required this.alignment});
}

class TextLayerChangedEvent extends TextFieldEvent {
  //TODO
}
