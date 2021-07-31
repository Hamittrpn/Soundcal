import 'package:alan_voice/alan_voice.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soundcal/constants/app_textstyle.dart';
import 'package:soundcal/constants/color_constants.dart';
import 'package:soundcal/models/radio.dart';
import 'package:soundcal/widgets/recently_played_card.dart';
import 'package:soundcal/widgets/wave_drawer.dart';
import 'package:wave/config.dart';

class ListenPage extends StatefulWidget {
  @override
  _ListenPageState createState() => _ListenPageState();
}

class _ListenPageState extends State<ListenPage> {
  List<MyRadio> radios;
  MyRadio _selectedRadio;
  Color _selectedColor;
  bool _isPlaying;

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
    fetchRadios();
    setupAlan();

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView(
              shrinkWrap: true,
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
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Text(
                "Recently Played",
                style: AppTextStyle.BODY_TEXT,
              ),
            ),
            SizedBox(height: 10),
            ListView.separated(
              itemBuilder: (context, index) {
                return RecentlyPlayedCard(
                  recentlyPlayed: radios[index],
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 15);
              },
              itemCount: 5,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
            ),
            WaveDrawer(),
          ],
        ),
      ),
    );
  }
}
