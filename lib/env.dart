import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
final class Env {
  @EnviedField(varName: 'SUPABASE_ANON_KEY', obfuscate: true)
  static final String supabaseAnonKey = _Env.supabaseAnonKey;

  @EnviedField(varName: 'WORLD_NEWS_API_KEY', obfuscate: true)
  static final String worldNewsApiKey = _Env.worldNewsApiKey;

  @EnviedField(varName: 'GNEWS_API_KEY', obfuscate: true)
  static final String gnewsApiKey = _Env.gnewsApiKey;
}
