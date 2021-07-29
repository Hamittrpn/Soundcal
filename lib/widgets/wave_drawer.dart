import 'package:flutter/material.dart';
import 'package:soundcal/constants/color_constants.dart';
import 'package:soundcal/screens/listen_page.dart';
import 'package:soundcal/screens/wave.dart';

class WaveDrawer extends StatelessWidget {
  const WaveDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          WaveDemoHomePage(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
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
                    pauseIcon:
                        Icon(Icons.pause, color: kPrimaryColor, size: 20),
                    playIcon:
                        Icon(Icons.play_arrow, color: kPrimaryColor, size: 20),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
