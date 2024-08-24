part of 'textfield_bloc.dart';

class TextFieldState {}

class InitialState extends TextFieldState {}

class ChangedState extends TextFieldState {}

class LoadingState extends TextFieldState {}

class TextColorChangedState extends TextFieldState {
  final Color color;

  TextColorChangedState({required this.color});
}

class TextSizeChangedState extends TextFieldState {
  final FontSize size;

  TextSizeChangedState({required this.size});
}

class TextOpacityChangedState extends TextFieldState {
  final double opacity;

  TextOpacityChangedState({required this.opacity});
}

class FontFamilyChangedState extends TextFieldState {
  final FontFamily fontFamily;

  FontFamilyChangedState({required this.fontFamily});
}

class FontAlignmentChangedState extends TextFieldState {
  final TextAlignment alignment;

  FontAlignmentChangedState({required this.alignment});
}

class TextLayerChangedState extends TextFieldState {
  //TODO
}
