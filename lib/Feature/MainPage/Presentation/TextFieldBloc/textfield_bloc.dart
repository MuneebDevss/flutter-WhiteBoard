import 'dart:async';

import 'package:flutter/material.dart';
import 'package:white_board/Core/Constants/enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'text_bloc_states.dart';
part 'text_bloc_events.dart';

class TextfieldBloc extends Bloc<TextFieldEvent, TextFieldState> {
  TextfieldBloc() : super(InitialState()) {
    on<TextFieldEvent>((event, emitter) => emitter(TextFieldState()));
    on<TextColorChangedEvent>(_handleTextColorChangeEvent);
    on<TextSizeChangedEvent>(_handleSizeChangeEvent);
    on<TextOpacityChangedEvent>(_handleTextOpacityChangeEvent);
    on<FontFamilyChangedEvent>(_handleFontFamilyChangeEvent);
    on<TextAlignmentChangedEvent>(_handleTextAlignmentChangeEvent);
    on<ChangeEvent>(_handleChangeEvent);
  }

  FutureOr<void> _handleTextColorChangeEvent(
      TextColorChangedEvent event, Emitter<TextFieldState> emit) {
    emit(TextColorChangedState(color: event.color));
  }

  FutureOr<void> _handleSizeChangeEvent(
      TextSizeChangedEvent event, Emitter<TextFieldState> emit) {
    emit(TextSizeChangedState(size: event.size));
  }

  FutureOr<void> _handleTextOpacityChangeEvent(
      TextOpacityChangedEvent event, Emitter<TextFieldState> emit) {
    emit(TextOpacityChangedState(opacity: event.opacity));
  }

  FutureOr<void> _handleFontFamilyChangeEvent(
      FontFamilyChangedEvent event, Emitter<TextFieldState> emit) {
    emit(FontFamilyChangedState(fontFamily: event.fontFamily));
  }

  FutureOr<void> _handleTextAlignmentChangeEvent(
      TextAlignmentChangedEvent event, Emitter<TextFieldState> emit) {
    emit(FontAlignmentChangedState(alignment: event.alignment));
  }

  FutureOr<void> _handleChangeEvent(
      ChangeEvent event, Emitter<TextFieldState> emit) {
    
    emit(ChangedState());
  }
}
