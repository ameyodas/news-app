import 'package:flutter/material.dart';

class INChip extends Chip {
  INChip({
    super.key,
    required String text,
    super.padding = const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
    super.labelPadding = const EdgeInsets.all(0.0),
  }) : super(
            label: Text(
          text,
          style: const TextStyle(fontSize: 14),
        ));
}

class INFilterChip extends FilterChip {
  INFilterChip({
    super.key,
    required String text,
    required super.onSelected,
    super.padding = const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
    super.labelPadding = const EdgeInsets.all(0.0),
  }) : super(
            label: Text(
          text,
          style: const TextStyle(fontSize: 14),
        ));
}
