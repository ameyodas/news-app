import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class INChip extends Chip {
  INChip({
    super.key,
    required String text,
    TextStyle textStyle = const TextStyle(fontSize: 14),
    super.padding = const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
    super.labelPadding = const EdgeInsets.all(0.0),
    super.backgroundColor = Colors.white,
    super.side = const BorderSide(color: Colors.black26),
  }) : super(
          label: Text(
            text,
            style: textStyle,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          visualDensity: VisualDensity.compact,
        );
}

class INDeletableChip extends Chip {
  INDeletableChip(
      {super.key,
      required String text,
      TextStyle textStyle = const TextStyle(fontSize: 14),
      super.padding =
          const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      super.labelPadding = const EdgeInsets.all(0.0),
      super.backgroundColor = Colors.white,
      super.side = const BorderSide(color: Colors.black26),
      super.onDeleted})
      : super(
          label: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 120),
                child: Text(
                  text,
                  style: textStyle,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              )),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          deleteIcon: const Icon(
            FluentIcons.dismiss_12_filled,
            color: Colors.grey,
            size: 13.0,
          ),
          visualDensity: VisualDensity.compact,
        );
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
      super.side = const BorderSide(color: Colors.transparent, width: 0.0),
      super.deleteIcon,
      super.onDeleted})
      : super(
            label: Text(text, style: textStyle),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            visualDensity: VisualDensity.compact,
            showCheckmark: false);
}
