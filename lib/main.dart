import 'package:flutter/material.dart';
import 'package:music_player/models/audio_player.dart';
import 'package:music_player/screens/music_player_screen.dart';
import 'package:music_player/theme/theme.dart';
import 'package:provider/provider.dart';

void main() {
  return runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AudioPlayer()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music player',
      debugShowCheckedModeBanner: false,
      theme: miTema,
      home: const MusicPlayerScreen(),
    );
  }
}
