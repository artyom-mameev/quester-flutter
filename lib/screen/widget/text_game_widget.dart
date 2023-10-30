import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:quester_flutter/domain/text_game.dart';

class TextGameWidget extends StatelessWidget {
  final TextGame textGame;

  final List<List<Widget>> ratingIcons = const [
    [
      Icon(Icons.star_border, color: Colors.amber),
      Icon(Icons.star_border, color: Colors.amber),
      Icon(Icons.star_border, color: Colors.amber),
      Icon(Icons.star_border, color: Colors.amber),
      Icon(Icons.star_border, color: Colors.amber),
    ],
    [
      Icon(Icons.star, color: Colors.amber),
      Icon(Icons.star_border, color: Colors.amber),
      Icon(Icons.star_border, color: Colors.amber),
      Icon(Icons.star_border, color: Colors.amber),
      Icon(Icons.star_border, color: Colors.amber)
    ],
    [
      Icon(Icons.star, color: Colors.amber),
      Icon(Icons.star, color: Colors.amber),
      Icon(Icons.star_border, color: Colors.amber),
      Icon(Icons.star_border, color: Colors.amber),
      Icon(Icons.star_border, color: Colors.amber),
    ],
    [
      Icon(Icons.star, color: Colors.amber),
      Icon(Icons.star, color: Colors.amber),
      Icon(Icons.star, color: Colors.amber),
      Icon(Icons.star_border, color: Colors.amber),
      Icon(Icons.star_border, color: Colors.amber),
    ],
    [
      Icon(Icons.star, color: Colors.amber),
      Icon(Icons.star, color: Colors.amber),
      Icon(Icons.star, color: Colors.amber),
      Icon(Icons.star, color: Colors.amber),
      Icon(Icons.star_border, color: Colors.amber),
    ],
    [
      Icon(Icons.star, color: Colors.amber),
      Icon(Icons.star, color: Colors.amber),
      Icon(Icons.star, color: Colors.amber),
      Icon(Icons.star, color: Colors.amber),
      Icon(Icons.star, color: Colors.amber)
    ],
  ];

  const TextGameWidget({super.key, required this.textGame});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              textGame.name,
              style: const TextStyle(fontSize: 18),
            ),
            Row(children: [
              CountryFlag.fromCountryCode(
                getCountryCodeByLanguage(textGame.language),
                height: 28,
                width: 32,
                borderRadius: 8,
              ),
            ]),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Text(
            textGame.description,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  for (final ratingIcon in ratingIcons[textGame.rating])
                    ratingIcon
                ],
              ),
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 10, right: 10, bottom: 10),
            child: Align(
              alignment: Alignment.topRight,
              child: Text(
                textGame.date,
                style: const TextStyle(fontSize: 12),
              ),
            )),
      ],
    );
  }

  String getCountryCodeByLanguage(String language) {
    if (language == "Русский") {
      return "RU";
    }
    return "GB";
  }
}
