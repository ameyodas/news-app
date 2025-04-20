import 'package:news_app/news.dart';
import 'package:news_app/interests.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DBApi {
  static DBApi? instance;

  static Future<void> initialize(DBApi api) async {
    instance = api;
    await instance!.init();
  }

  Future<void> init() async {}
  Future<void> dispose() async {}

  Future<InterestsData?> getInterests() async => null;
  Future<void> setInterests(InterestsData interests) async {}

  Future<void> storeArticle(INNews news) async {}
  Future<INNews?> loadArticle(int newsId) async => null;
  Future<List<INNews>> loadArticles({int count = 1000}) async => [];
  Future<void> deleteArticle(String newsId) async => 0;
  Future<void> updateArticle(INNews news) async => 0;
}

class SQFliteDBApi extends DBApi {
  late Database _db;

  @override
  Future<void> init() async {
    await super.init();

    _db = await openDatabase('news.db', version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table saved_articles (
  news_id text primary key,
  headline text not null,
  content text not null,
  image_url text,
  tags text,
  source_url text,
  source_name text,
  first_saved_at timestamp default current_timestamp)
''');

      await db.execute('''
create table interests (
  id INTEGER PRIMARY KEY,
  keywords text,
  tags text)
''');
    });
  }

  @override
  Future<void> dispose() async {
    await _db.close();
    await super.dispose();
  }

  @override
  Future<InterestsData?> getInterests() async {
    final List<Map<String, Object?>> maps = await _db.query('interests');
    if (maps.isEmpty) return null;
    return InterestsData.fromMap(maps.last.cast<String, dynamic>());
  }

  @override
  Future<void> setInterests(InterestsData interests) async {
    await _db.insert(
      'interests',
      interests.toMap()..['id'] = 1,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> storeArticle(INNews news) async {
    await _db.insert('saved_articles', news.toMap());
  }

  @override
  Future<INNews?> loadArticle(int newsId) async {
    List<Map> maps = await _db
        .query('saved_articles', where: 'news_id = ?', whereArgs: [newsId]);
    if (maps.isNotEmpty) {
      return INNews.fromMap(maps.first.cast<String, String>());
    }
    return null;
  }

  @override
  Future<List<INNews>> loadArticles({int count = 1000}) async {
    final List<Map<String, Object?>> maps = await _db.query(
      'saved_articles',
      orderBy: 'first_saved_at DESC',
      limit: count,
    );

    return maps
        .map((map) => INNews.fromMap(map.cast<String, String>()))
        .toList();
  }

  @override
  Future<void> deleteArticle(String newsId) async {
    await _db
        .delete('saved_articles', where: 'news_id = ?', whereArgs: [newsId]);
  }

  @override
  Future<void> updateArticle(INNews news) async {
    await _db.update('saved_articles', news.toMap(),
        where: 'news_id = ?', whereArgs: [news.newsId]);
  }
}

class SupabaseDBApi extends DBApi {
  @override
  Future<InterestsData?> getInterests() async {
    final data = await Supabase.instance.client.from('interests').select();
    if (data.isEmpty) return Future.value(null);
    return InterestsData.fromMap(Map<String, dynamic>.from(data.last));
  }

  @override
  Future<void> setInterests(InterestsData interests) async {
    await Supabase.instance.client.from('interests').upsert(interests.toMap());
  }

  @override
  Future<void> storeArticle(INNews news) async {
    await Supabase.instance.client.from('saved_articles').insert(news.toMap());
  }

  @override
  Future<INNews?> loadArticle(int newsId) async {
    final data = await Supabase.instance.client
        .from('saved_articles')
        .select()
        .eq('news_id', newsId)
        .single();

    return INNews.fromMap(data.cast<String, String>());
  }

  @override
  Future<List<INNews>> loadArticles({int count = 1000}) async {
    final data = await Supabase.instance.client
        .from('saved_articles')
        .select()
        .order('first_saved_at', ascending: false)
        .limit(count);

    return data
        .map((map) => INNews.fromMap(map.cast<String, String>()))
        .toList();
  }

  @override
  Future<void> deleteArticle(String newsId) async {
    await Supabase.instance.client
        .from('saved_articles')
        .delete()
        .eq('news_id', newsId);
  }

  @override
  Future<void> updateArticle(INNews news) async {
    await Supabase.instance.client
        .from('saved_articles')
        .update(news.toMap())
        .eq('news_id', news.newsId);
  }
}

class UnifiedDBApi extends DBApi {
  final DBApi localDB;
  final DBApi remoteDB;

  UnifiedDBApi(this.localDB, this.remoteDB);

  @override
  Future<void> init() async {
    await super.init();
    await remoteDB.init();
    await localDB.init();
  }

  @override
  Future<void> dispose() async {
    await remoteDB.dispose();
    await localDB.dispose();
    await super.dispose();
  }

  @override
  Future<InterestsData?> getInterests() async {
    try {
      final remote = await remoteDB.getInterests();
      if (remote != null) {
        await localDB.setInterests(remote);
        return remote;
      }
    } catch (_) {}

    return await localDB.getInterests();
  }

  @override
  Future<void> setInterests(InterestsData interests) async {
    await remoteDB.setInterests(interests);
    await localDB.setInterests(interests);
  }

  @override
  Future<void> storeArticle(INNews news) async {
    await remoteDB.storeArticle(news);
    await localDB.storeArticle(news);
  }

  @override
  Future<INNews?> loadArticle(int newsId) async {
    try {
      final remote = await remoteDB.loadArticle(newsId);
      if (remote != null) {
        await localDB.storeArticle(remote);
        return remote;
      }
    } catch (_) {}

    return await localDB.loadArticle(newsId);
  }

  @override
  Future<List<INNews>> loadArticles({int count = 1000}) async {
    try {
      final remote = await remoteDB.loadArticles(count: count);
      for (final article in remote) {
        await localDB.storeArticle(article);
      }
      return remote;
    } catch (_) {
      return await localDB.loadArticles(count: count);
    }
  }

  @override
  Future<void> deleteArticle(String newsId) async {
    await remoteDB.deleteArticle(newsId);
    await localDB.deleteArticle(newsId);
  }

  @override
  Future<void> updateArticle(INNews news) async {
    await remoteDB.updateArticle(news);
    await localDB.updateArticle(news);
  }
}
