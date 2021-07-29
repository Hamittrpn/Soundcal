import 'package:flutter/material.dart';
import 'package:soundcal/constants/app_textstyle.dart';
import 'package:soundcal/constants/color_constants.dart';
import 'package:soundcal/models/radio.dart';

class RecentlyPlayedCard extends StatelessWidget {
  final MyRadio recentlyPlayed;
  const RecentlyPlayedCard({Key key, this.recentlyPlayed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            Container(
              width: 60,
              height: 60,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(recentlyPlayed.image, fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recentlyPlayed.tagline,
                    style: AppTextStyle.LISTTILE_TITLE,
                  ),
                  Text(
                    recentlyPlayed.category,
                    style: AppTextStyle.LISTTILE_SUB_TITLE,
                  ),
                  Text(
                    recentlyPlayed.name,
                    style: AppTextStyle.LISTTILE_SUB_TITLE2,
                  ),
                ],
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.play_arrow,
                    color: kSecondaryColor,
                    size: 26,
                  )
                ],
              ),
            )
          ],
        )
      ]),
    );
  }
}
