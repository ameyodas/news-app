import 'package:flutter/material.dart';

class INChip extends Chip {
  INChip(
      {super.key,
      required String text,
      super.padding =
          const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
      super.labelPadding = const EdgeInsets.all(0.0),
      super.backgroundColor = Colors.white,
      super.side = const BorderSide(color: Colors.black26)})
      : super(
            label: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            visualDensity: VisualDensity.compact);
}

class INFilterChip extends FilterChip {
  INFilterChip(
      {super.key,
      required super.onSelected,
      super.selected,
      required String text,
      TextStyle textStyle = const TextStyle(fontSize: 14),
      super.padding =
          const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
      super.labelPadding = const EdgeInsets.all(0.0),
      super.backgroundColor = Colors.white,
      super.selectedColor = const Color.fromARGB(255, 64, 64, 64),
      super.side = const BorderSide(color: Colors.transparent, width: 0.0)})
      : super(
            label: Text(text, style: textStyle),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            visualDensity: VisualDensity.compact,
            showCheckmark: false);
}
