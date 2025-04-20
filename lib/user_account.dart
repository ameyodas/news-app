import 'package:news_app/api/db_api.dart';
import 'package:news_app/api/llm_tts_api.dart';
import 'package:news_app/api/news_provider_api.dart';
import 'package:news_app/env.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserAccount {
  static UserAccount? instance;

  static Future<void> initialize() async {
    if (instance != null) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final provider = prefs.getString('account/login_account_provider');

    switch (provider) {
      case 'local':
        instance = LocalAccount();
      case 'supabase':
        instance = SupabaseAccount();
    }

    await instance?.init();
    await instance?._apiInit();
  }

  static Future<void> set(UserAccount? account) async {
    await instance?.signOut();
    instance = account;
    await instance?.init();
    await instance?._apiInit();

    final prefs = await SharedPreferences.getInstance();
    if (account == null) {
      prefs.remove('account/login_account_provider');
    } else {
      prefs.setString('account/login_account_provider', instance!.type());
    }
  }

  String type() => 'null';
  String? name() => null;
  Future<void> init() async {}
  Future<void> _apiInit() async {}
  Future<void> signIn({String? email, String? password}) async {}
  Future<void> signOut() async {}
  Future<void> signUp({String? email, String? password}) async {}
}

class LocalAccount extends UserAccount {
  @override
  String type() => 'local';

  @override
  String? name() => 'local';

  @override
  Future<void> _apiInit() async {
    NewsProviderApi.initialize(WorldNewsApi());
    LLMApi.initialize(LLMAWSApi());
    await DBApi.initialize(SQFliteDBApi());
  }

  @override
  Future<void> signIn({String? email, String? password}) async {
    await _apiInit();
  }

  @override
  Future<void> signOut() async {
    NewsProviderApi.instance = null;
    LLMApi.instance = null;
    DBApi.instance!.dispose();
    DBApi.instance = null;
  }

  @override
  Future<void> signUp({String? email, String? password}) async {
    await signIn(email: email, password: password);
  }
}

class SupabaseAccount extends UserAccount {
  static bool _initialized = false;

  @override
  String type() => 'supabase';

  @override
  String? name() => Supabase.instance.client.auth.currentUser!.email;

  @override
  Future<void> init() async {
    if (!_initialized) {
      await Supabase.initialize(
        url: 'https://slncuihwyxnyfsumachr.supabase.co',
        anonKey: Env.supabaseAnonKey,
      );
      _initialized = true;
    }
  }

  @override
  Future<void> _apiInit() async {
    NewsProviderApi.initialize(WorldNewsApi());
    LLMApi.initialize(LLMAWSApi());
    await DBApi.initialize(SupabaseDBApi());
  }

  @override
  Future<void> signIn({String? email, String? password}) async {
    final res = await Supabase.instance.client.auth
        .signInWithPassword(email: email!, password: password!);

    if (res.user == null) {
      throw const AuthException('Failed to sign in');
    }

    await _apiInit();
  }

  @override
  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();

    NewsProviderApi.instance = null;
    LLMApi.instance = null;
    DBApi.instance!.dispose();
    DBApi.instance = null;
  }

  @override
  Future<void> signUp({String? email, String? password}) async {
    final res = await Supabase.instance.client.auth
        .signUp(email: email!, password: password!);

    if (res.user == null) {
      throw const AuthException('Failed to sign up');
    }

    await signIn(email: email, password: password);
  }
}
