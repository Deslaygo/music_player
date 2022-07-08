import 'package:animate_do/animate_do.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_player/helpers/helpers.dart';
import 'package:music_player/models/audio_player.dart';
import 'package:music_player/widgets/custom_widgets.dart';
import 'package:provider/provider.dart';

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({Key? key}) : super(key: key);

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        const Background(),
        Column(
          children: const [
            CustomAppbar(),
            DiscoDuracion(),
            TituloPlay(),
            Lyrics()
          ],
        ),
      ],
    ));
  }
}

class Background extends StatelessWidget {
  const Background({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: screenSize.height * 0.8,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100)),
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.center,
              colors: [
                Color(0xff33333E),
                Color(0xff201E28),
              ])),
    );
  }
}

class Lyrics extends StatelessWidget {
  const Lyrics({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lyrics = getLyrics();
    return Expanded(
        child: ListWheelScrollView(
      physics: const BouncingScrollPhysics(),
      itemExtent: 42,
      diameterRatio: 1.5,
      children: lyrics
          .map(
            (ln) => Text(
              ln,
              style:
                  TextStyle(fontSize: 20, color: Colors.white.withOpacity(0.5)),
            ),
          )
          .toList(),
    ));
  }
}

class DiscoDuracion extends StatelessWidget {
  const DiscoDuracion({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 80, left: 16, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const ImagenDisco(),
            BarraProgreso(),
          ],
        ));
  }
}

class TituloPlay extends StatefulWidget {
  const TituloPlay({
    Key? key,
  }) : super(key: key);

  @override
  State<TituloPlay> createState() => _TituloPlayState();
}

class _TituloPlayState extends State<TituloPlay>
    with SingleTickerProviderStateMixin {
  bool isPlaying = false;
  bool isFirstTime = true;
  final estiloTexto = TextStyle(color: Colors.white.withOpacity(0.5));
  AnimationController? playAnimation;
  final assetsAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    playAnimation = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    playAnimation!.dispose();
  }

  void open() {
    final audioPlayer = Provider.of<AudioPlayer>(context, listen: false);

    assetsAudioPlayer.open(
      Audio('assets/audio/Breaking-Benjamin-Far-Away.mp3'),
      showNotification: true,
    );

    assetsAudioPlayer.currentPosition.listen((duration) {
      audioPlayer.current = duration;
    });

    assetsAudioPlayer.current.listen((playingAudio) {
      audioPlayer.songDuration = playingAudio!.audio.duration;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
        child: Row(
          children: [
            Column(
              children: [
                Text('Far Away', style: estiloTexto),
                Text('-Breaking Benjamin-', style: estiloTexto),
              ],
            ),
            const Spacer(),
            FloatingActionButton(
              onPressed: () {
                final audioPlayer =
                    Provider.of<AudioPlayer>(context, listen: false);
                if (isPlaying) {
                  playAnimation?.reverse();
                  isPlaying = false;
                  audioPlayer.controller.stop();
                } else {
                  playAnimation?.forward();
                  isPlaying = true;
                  audioPlayer.controller.repeat();
                }

                if (isFirstTime) {
                  open();
                  isFirstTime = false;
                } else {
                  assetsAudioPlayer.playOrPause();
                }
                setState(() {});
              },
              backgroundColor: const Color(0xffF8CB51),
              child: AnimatedIcon(
                  icon: AnimatedIcons.play_pause, progress: playAnimation!),
            ),
          ],
        ));
  }
}

class BarraProgreso extends StatelessWidget {
  BarraProgreso({
    Key? key,
  }) : super(key: key);

  final estiloTexto = TextStyle(color: Colors.white.withOpacity(0.5));

  @override
  Widget build(BuildContext context) {
    final audioPlayer = Provider.of<AudioPlayer>(context);
    final porcentaje = audioPlayer.porcentaje;
    return Container(
        child: Column(
      children: [
        Text(
          audioPlayer.totalDuration,
          style: estiloTexto,
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              width: 3,
              height: 250,
              color: Colors.white.withOpacity(0.2),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: 3,
                height: 250 * porcentaje,
                color: Colors.white.withOpacity(0.8),
              ),
            )
          ],
        ),
        const SizedBox(height: 8),
        Text(
          audioPlayer.currentDuration,
          style: estiloTexto,
        ),
      ],
    ));
  }
}

class ImagenDisco extends StatelessWidget {
  const ImagenDisco({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioPlayer = Provider.of<AudioPlayer>(context);
    return Container(
        padding: const EdgeInsets.all(16),
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(200),
          gradient: const LinearGradient(
            colors: [
              Color(0xff484750),
              Color(0xff1E1C24),
            ],
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(200),
          child: Stack(
            alignment: Alignment.center,
            children: [
              SpinPerfect(
                  duration: const Duration(seconds: 10),
                  infinite: true,
                  animate: false,
                  manualTrigger: true,
                  controller: (animationController) =>
                      audioPlayer.controller = animationController,
                  child: Image.asset('assets/img/aurora.jpg')),
              Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(50)),
              ),
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                    color: const Color(0xff1c1c25),
                    borderRadius: BorderRadius.circular(50)),
              )
            ],
          ),
        ));
  }
}
