import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';

final List<Reaction<String>> reactions = [
  Reaction<String>(
    value: '0',
    title: buildEmojiTitle(
      'Me gusta',
    ),
    previewIcon: buildEmojiPreviewIcon(
      'assets/icons/like.png',
    ),
    icon: buildReactionsIcon(
      'assets/icons/like.png',
      const Text(
        'Me gusta',
        style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Color(0XFF3b5998),
            fontSize: 14.0,
            letterSpacing: -0.5),
      ),
    ),
  ),
  Reaction<String>(
    value: '1',
    title: buildEmojiTitle(
      'Me encanta',
    ),
    previewIcon: buildEmojiPreviewIcon(
      'assets/icons/in-love.png',
    ),
    icon: buildReactionsIcon(
      'assets/icons/in-love.png',
      const Text(
        'Me encanta',
        style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Color(0xFFFF5859),
            fontSize: 14.0,
            letterSpacing: -0.5),
      ),
    ),
  ),
  Reaction<String>(
    value: '2',
    title: buildEmojiTitle(
      'Me divierte',
    ),
    previewIcon: buildEmojiPreviewIcon(
      'assets/icons/happy.png',
    ),
    icon: buildReactionsIcon(
      'assets/icons/happy.png',
      const Text(
        'Me divierte',
        style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Color(0XFFF6B125),
            fontSize: 14.0,
            letterSpacing: -0.5),
      ),
    ),
  ),
  Reaction<String>(
    value: '3',
    title: buildEmojiTitle(
      'Me asombra',
    ),
    previewIcon: buildEmojiPreviewIcon(
      'assets/icons/surprised.png',
    ),
    icon: buildReactionsIcon(
      'assets/icons/surprised.png',
      const Text(
        'Me asombra',
        style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Color(0XFFF6B125),
            fontSize: 14.0,
            letterSpacing: -0.5),
      ),
    ),
  ),
  Reaction<String>(
    value: '4',
    title: buildEmojiTitle(
      'Me entristece',
    ),
    previewIcon: buildEmojiPreviewIcon(
      'assets/icons/sad.png',
    ),
    icon: buildReactionsIcon(
      'assets/icons/sad.png',
      const Text('Me entristece', style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Color(0XFFF6B125),
            fontSize: 14.0,
            letterSpacing: -0.5),),
    ),
  ),
  Reaction<String>(
    value: '5',
    title: buildEmojiTitle(
      'Me enoja',
    ),
    previewIcon: buildEmojiPreviewIcon(
      'assets/icons/angry.png',
    ),
    icon: buildReactionsIcon(
      'assets/icons/angry.png',
      const Text('Me enoja', style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Color(0XFFed5168),
            fontSize: 14.0,
            letterSpacing: -0.5),),
    ),
  ),
];

Widget buildEmojiTitle(String title) {
  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(.75),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 8,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget buildEmojiPreviewIcon(String path) {
  return Image.asset(path);
}

Widget buildFlagIcon(String path) {
  return Image.asset(path);
}

Widget buildReactionsIcon(String path, Text text) {
  return Container(
    color: Colors.transparent,
    child: Row(
      children: <Widget>[
        Image.asset(path, height: 20),
        const SizedBox(width: 5),
        text,
      ],
    ),
  );
}


/*final List<Reaction<int>> reactions = [
  Reaction<int>(
    value: 0,
    title: buildEmojiTitle('Me gusta'),
    previewIcon: buildEmojiPreviewIcon('assets/icons/like.png'),
    icon: buildReactionsIcon(
      'assets/icons/like.png',
      const Text(
        'Me gusta',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Color(0XFF3b5998),
          fontSize: 14.0,
          letterSpacing: -0.5,
        ),
      ),
    ),
  ),
  Reaction<int>(
    value: 1,
    title: buildEmojiTitle('Me encanta'),
    previewIcon: buildEmojiPreviewIcon('assets/icons/in-love.png'),
    icon: buildReactionsIcon(
      'assets/icons/in-love.png',
      const Text(
        'Me encanta',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Color(0xFFFF5859),
          fontSize: 14.0,
          letterSpacing: -0.5,
        ),
      ),
    ),
  ),
  Reaction<int>(
    value: 2,
    title: buildEmojiTitle('Me divierte'),
    previewIcon: buildEmojiPreviewIcon('assets/icons/happy.png'),
    icon: buildReactionsIcon(
      'assets/icons/happy.png',
      const Text(
        'Me divierte',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Color(0XFFF6B125),
          fontSize: 14.0,
          letterSpacing: -0.5,
        ),
      ),
    ),
  ),
  Reaction<int>(
    value: 3,
    title: buildEmojiTitle('Me asombra'),
    previewIcon: buildEmojiPreviewIcon('assets/icons/surprised.png'),
    icon: buildReactionsIcon(
      'assets/icons/surprised.png',
      const Text(
        'Me asombra',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Color(0XFFF6B125),
          fontSize: 14.0,
          letterSpacing: -0.5,
        ),
      ),
    ),
  ),
  Reaction<int>(
    value: 4,
    title: buildEmojiTitle('Me entristece'),
    previewIcon: buildEmojiPreviewIcon('assets/icons/sad.png'),
    icon: buildReactionsIcon(
      'assets/icons/sad.png',
      const Text(
        'Me entristece',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Color(0XFFF6B125),
          fontSize: 14.0,
          letterSpacing: -0.5,
        ),
      ),
    ),
  ),
  Reaction<int>(
    value: 5,
    title: buildEmojiTitle('Me enoja'),
    previewIcon: buildEmojiPreviewIcon('assets/icons/angry.png'),
    icon: buildReactionsIcon(
      'assets/icons/angry.png',
      const Text(
        'Me enoja',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Color(0XFFed5168),
          fontSize: 14.0,
          letterSpacing: -0.5,
        ),
      ),
    ),
  ),
];*/