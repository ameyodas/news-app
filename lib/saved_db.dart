// import 'package:flutter/material.dart';
// import 'package:news_app/news.dart';
// import 'package:sqflite/sqflite.dart';

// const String tableSavedArticles = 'saved_articles';
// const String columnId = 'id';
// const String columnHeadline = 'headline';
// const String columnContent = 'content';
// const String columnImageUrl = 'image_url';
// const String columnTags = 'tags';
// const String columnSource = 'source';
// const String columnSourceName = 'source_name';

// class SavedArticlesProvider {
//   static late Database db;

//   static Future open() async {
//     db = await openDatabase('news.db', version: 1,
//         onCreate: (Database db, int version) async {
//       await db.execute('''
// create table $tableSavedArticles ( 
//   $columnId integer primary key, 
//   $columnHeadline text not null,
//   $columnContent text not null,
//   $columnImageUrl text,
//   $columnTags text,
//   $columnSource text,
//   $columnSourceName text)
// ''');
//     });
//   }

//   static Future<INNews> insert(INNews news) async {
//     await db.insert(tableSavedArticles, news.toMap());
//     return news;
//   }

//   static Future<INNews?> get(int id) async {
//     List<Map> maps = await db.query(tableSavedArticles,
//         columns: [
//           columnId,
//           columnHeadline,
//           columnContent,
//           columnImageUrl,
//           columnTags,
//           columnSource,
//           columnSourceName
//         ],
//         where: '$columnId = ?',
//         whereArgs: [id]);
//     if (maps.isNotEmpty) {
//       return INNews.fromMap(maps.first.cast<String, dynamic>());
//     }
//     return null;
//   }

//   static Future<List<INNews>> getLastN(int count) async {
//     final List<Map<String, Object?>> maps = await db.query(
//       tableSavedArticles,
//       columns: [
//         columnId,
//         columnHeadline,
//         columnContent,
//         columnImageUrl,
//         columnTags,
//         columnSource,
//         columnSourceName
//       ],
//       orderBy: '$columnId DESC',
//       limit: count,
//     );

//     debugPrint('returning last ${maps.length} saved articles');

//     return maps
//         .map((map) => INNews.fromMap(map.cast<String, dynamic>()))
//         .toList();
//   }

//   static Future<int> delete(int id) async {
//     return await db
//         .delete(tableSavedArticles, where: '$columnId = ?', whereArgs: [id]);
//   }

//   static Future<int> update(INNews news) async {
//     return await db.update(tableSavedArticles, news.toMap(),
//         where: '$columnId = ?', whereArgs: [news.id]);
//   }

//   static Future close() async => db.close();
// }
