import 'package:flutter/material.dart';
import 'package:soundcal/constants/color_constants.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class WaveDemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WaveDemoHomePage();
  }
}

class WaveDemoHomePage extends StatefulWidget {
  WaveDemoHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WaveDemoHomePageState createState() => _WaveDemoHomePageState();
}

class _WaveDemoHomePageState extends State<WaveDemoHomePage> {
  _buildCard({
    Config config,
    Color backgroundColor = Colors.transparent,
    double height = 100.0,
  }) {
    return Container(
      width: double.infinity,
      height: height,
      child: Card(
        margin: EdgeInsets.all(0),
        elevation: 0,
        child: WaveWidget(
          config: config,
          backgroundColor: backgroundColor,
          size: Size(double.infinity, double.infinity),
          waveAmplitude: 0,
        ),
      ),
    );
  }

  MaskFilter _blur;
  final List<MaskFilter> _blurs = [
    null,
    MaskFilter.blur(BlurStyle.normal, 10.0),
    MaskFilter.blur(BlurStyle.inner, 10.0),
    MaskFilter.blur(BlurStyle.outer, 10.0),
    MaskFilter.blur(BlurStyle.solid, 16.0),
  ];
  int _blurIndex = 0;
  MaskFilter _nextBlur() {
    if (_blurIndex == _blurs.length - 1) {
      _blurIndex = 0;
    } else {
      _blurIndex = _blurIndex + 1;
    }
    _blur = _blurs[_blurIndex];
    return _blurs[_blurIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildCard(
        backgroundColor: kPrimaryColor,
        height: 95,
        config: CustomConfig(
          colors: [kWaveColor4, kWaveColor3, kWaveColor2, kWaveColor1],
          durations: [18000, 8000, 5000, 12000],
          heightPercentages: [0.15, 0.16, 0.18, 0.21],
          blur: _blur,
        ),
      ),
    );
  }
}
