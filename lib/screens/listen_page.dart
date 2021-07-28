import 'package:alan_voice/alan_voice.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soundcal/constants/app_textstyle.dart';
import 'package:soundcal/constants/color_constants.dart';
import 'package:soundcal/models/radio.dart';
import 'package:soundcal/widgets/blob.dart';
import 'package:soundcal/widgets/recently_played_card.dart';
import 'package:wave/config.dart';
import 'dart:math' show pi;

class ListenPage extends StatefulWidget {
  @override
  _ListenPageState createState() => _ListenPageState();
}

class _ListenPageState extends State<ListenPage> {
  List<MyRadio> radios;
  MyRadio _selectedRadio;
  Color _selectedColor;
  bool _isPlaying = false;

  Config config;
  double height = 152.0;

  final sugg = [
    "Play",
    "Stop",
    "Play rock music",
    "Play 107 FM",
    "Play next",
    "Play 104 FM",
    "Pause",
    "Play previous",
    "Play pop music"
  ];

  final colors = [
    Colors.white70,
    Colors.white54,
    Colors.white30,
    Colors.white24,
  ];
  final durations = [
    32000,
    21000,
    18000,
    5000,
  ];

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    setupAlan();
    fetchRadios();

    _audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.PLAYING) {
        _isPlaying = true;
      } else {
        _isPlaying = false;
      }
      setState(() {});
    });
  }

  setupAlan() {
    AlanVoice.addButton(
        "ab570c932aad027c4633dc96fa33eba22e956eca572e1d8b807a3e2338fdd0dc/stage",
        buttonAlign: AlanVoice.BUTTON_ALIGN_RIGHT);
    AlanVoice.callbacks.add((command) => _handleCommand(command.data));
  }

  _handleCommand(Map<String, dynamic> response) {
    switch (response["command"]) {
      case "play":
        _playMusic(_selectedRadio.url);
        break;
      case "play_channel":
        final id = response["id"];
        _audioPlayer.pause();
        MyRadio newRadio = radios.firstWhere((element) => element.id == id);
        radios.remove(newRadio);
        radios.insert(0, newRadio);
        _playMusic(newRadio.url);
        break;
      case "stop":
        _audioPlayer.stop();
        break;
      case "next":
        final index = _selectedRadio.id;
        MyRadio newRadio;
        if (index + 1 > radios.length) {
          newRadio = radios.firstWhere((element) => element.id == 1);
          radios.remove(newRadio);
          radios.insert(0, newRadio);
        } else {
          newRadio = radios.firstWhere((element) => element.id == index + 1);
          radios.remove(newRadio);
          radios.insert(0, newRadio);
        }
        _playMusic(newRadio.url);
        break;

      case "prev":
        final index = _selectedRadio.id;
        MyRadio newRadio;
        if (index - 1 <= 0) {
          newRadio = radios.firstWhere((element) => element.id == 1);
          radios.remove(newRadio);
          radios.insert(0, newRadio);
        } else {
          newRadio = radios.firstWhere((element) => element.id == index - 1);
          radios.remove(newRadio);
          radios.insert(0, newRadio);
        }
        _playMusic(newRadio.url);
        break;
      default:
    }
  }

  fetchRadios() async {
    final radioJson = await rootBundle.loadString("lib/assets/radio.json");
    radios = MyRadioList.fromJson(radioJson).radios;
    _selectedRadio = radios[0];
    _selectedColor = Color(int.tryParse(_selectedRadio.color));
    setState(() {});
  }

  _playMusic(String url) {
    _audioPlayer.play(url);
    _selectedRadio = radios.firstWhere((element) => element.url == url);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.transparent;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "SoundCal",
          style: TextStyle(
              fontFamily: GoogleFonts.poppins().fontFamily,
              color: kSecondaryColor),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.radio,
            color: kSecondaryColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 10),
              height: 140,
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: ListTile.divideTiles(context: context, tiles: [
                  ListTile(
                    leading: Icon(
                      Icons.favorite,
                      color: kSecondaryColor,
                    ),
                    title: Text(
                      "Favorite Stations",
                      style: TextStyle(
                          color: kSecondaryColor, fontWeight: FontWeight.w500),
                    ),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      size: 30,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.qr_code_scanner_rounded,
                      color: kSecondaryColor,
                    ),
                    title: Text(
                      "Smart Scans",
                      style: TextStyle(
                          color: kSecondaryColor, fontWeight: FontWeight.w500),
                    ),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      size: 30,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ]).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Recently Played",
                style: AppTextStyle.BODY_TEXT,
              ),
            ),
            SizedBox(height: 10),
            Container(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return RecentlyPlayedCard(
                    recentlyPlayed: radios[index],
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 10);
                },
                itemCount: 5,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 50,
                width: 50,
                child: PlayButton(
                  pauseIcon: Icon(Icons.pause, color: kPrimaryColor, size: 30),
                  playIcon:
                      Icon(Icons.play_arrow, color: kPrimaryColor, size: 30),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayButton extends StatefulWidget {
  final bool initialIsPlaying;
  final Icon playIcon;
  final Icon pauseIcon;
  final VoidCallback onPressed;

  PlayButton(
      {this.initialIsPlaying = false,
      this.playIcon = const Icon(Icons.play_arrow, color: kSecondaryColor),
      this.pauseIcon = const Icon(Icons.pause, color: kPrimaryColor),
      @required this.onPressed})
      : assert(onPressed != null);

  @override
  _PlayButtonState createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> with TickerProviderStateMixin {
  static const _kToggleDuration = Duration(milliseconds: 300);
  static const _kRotationDuration = Duration(seconds: 5);
  bool isPlaying;
  double _rotation = 0;
  double _scale = 0.85;

  bool get _showWaves => !_scaleController.isDismissed;

  AnimationController _rotationController;
  AnimationController _scaleController;

  void _updateRotation() => _rotation = _rotationController.value * 2 * pi;
  void _updateScale() => _scale = (_scaleController.value * 0.2) + 0.85;

  @override
  void initState() {
    isPlaying = widget.initialIsPlaying;
    _rotationController =
        AnimationController(vsync: this, duration: _kRotationDuration)
          ..addListener(() => setState(_updateRotation))
          ..repeat();

    _scaleController =
        AnimationController(vsync: this, duration: _kToggleDuration)
          ..addListener(() => setState(_updateScale));
    super.initState();
  }

  void _onToggle() {
    setState(() => isPlaying = !isPlaying);
    if (_scaleController.isCompleted) {
      _scaleController.reverse();
    } else {
      _scaleController.forward();
    }
    widget.onPressed();
  }

  Widget _buildIcon(bool isPlaying) {
    return SizedBox.expand(
      key: ValueKey<bool>(isPlaying),
      child: IconButton(
        icon: isPlaying ? widget.pauseIcon : widget.playIcon,
        onPressed: _onToggle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 48, minHeight: 48),
      child: Stack(
        children: [
          if (_showWaves) ...[
            Blob(
              color: Color(0xff0092ff),
              scale: _scale,
              rotation: _rotation,
            ),
            Blob(
                color: Color(0xff4ac7b7),
                scale: _scale,
                rotation: _rotation * 2 - 30),
            Blob(
                color: Color(0xffa4a6f6),
                scale: _scale,
                rotation: _rotation * 3 - 45),
          ],
          Container(
            constraints: BoxConstraints.expand(),
            child: AnimatedSwitcher(
              child: _buildIcon(isPlaying),
              duration: _kToggleDuration,
            ),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: kSecondaryColor),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }
}
