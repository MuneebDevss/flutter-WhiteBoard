import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:white_board/Feature/MainPage/Presentation/TextFieldBloc/textfield_bloc.dart';
import 'package:white_board/Feature/MainPage/Presentation/main_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
  MultiBlocProvider(providers: [BlocProvider(create: (context)=>TextfieldBloc())], child: const MyApp()));
  }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return const MaterialApp(
      home: MainPage(),
    );
  }
}




