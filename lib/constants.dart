import 'package:flutter/material.dart';

const mainColor = Color.fromARGB(255, 102, 204, 153);
const standardTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 15,
);
final mainShadow = BoxShadow(
  color: Colors.black.withOpacity(0.5),
  offset: const Offset(-3, 4),
);
const cguTitle = TextStyle(fontWeight: FontWeight.bold);

final possibleRecurrences = <String>[
  '1 fois par jour',
  '2 fois par jour',
  '3 fois par jour',
];

final possibleDuration = <String>[
  '1 jours',
  '2 jours',
  '3 jours',
  '4 jours',
  '5 jours',
  '6 jours',
  '7 jours',
];

final possibleHours = <String>[
  '4h00',
  '4h30',
  '5h00',
  '5h30',
  '6h00',
  '6h30',
  '7h00',
  '7h30',
  '8h00',
  '8h30',
  '9h00',
  '9h30',
  '10h00',
  '10h30',
  '11h00',
  '11h30',
  '12h00',
  '12h30',
  '13h00',
  '13h30',
  '14h00',
  '14h30',
  '15h00',
  '15h30',
  '16h00',
  '16h30',
  '17h00',
  '17h30',
  '18h00',
  '18h30',
  '19h00',
  '19h30',
  '20h00',
  '20h30',
  '21h00',
  '21h30',
  '22h00',
  '22h30',
  '23h00',
  '23h30',
  '23h59',
];
