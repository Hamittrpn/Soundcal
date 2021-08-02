import 'package:flutter/material.dart';

import 'package:soundcal/constants/color_constants.dart';
import 'package:soundcal/screens/wave.dart';
import 'package:soundcal/widgets/play_button.dart';

class WaveDrawer extends StatefulWidget {
  final bool isPlaying;
  WaveDrawer({
    Key key,
    @required this.isPlaying,
  }) : super(key: key);

  @override
  _WaveDrawerState createState() => _WaveDrawerState();
}

class _WaveDrawerState extends State<WaveDrawer> {
  bool showWaveDrawer = true;
  @override
  Widget build(BuildContext context) {
    return showWaveDrawer
        ? Container(
            height: 150,
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: <Widget>[
                WaveDemoHomePage(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          "lib/assets/Images/virginRadio.png",
                          fit: BoxFit.cover,
                          height: 40,
                          width: 40,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          "Kbuk 99.3",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                      Spacer(),
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: PlayButton(
                          initialIsPlaying: widget.isPlaying,
                          pauseIcon:
                              Icon(Icons.pause, color: kPrimaryColor, size: 20),
                          playIcon: Icon(Icons.play_arrow,
                              color: kPrimaryColor, size: 20),
                          onPressed: () {
                            setState(() {
                              // if (showWaveDrawer == false) {
                              //   showWaveDrawer = true;
                              // } else {
                              //   showWaveDrawer = false;
                              // }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Center();
  }
}
