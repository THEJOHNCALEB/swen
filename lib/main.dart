import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';
import 'core/constants/app_colors.dart';
import 'providers/news_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.surface,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  final container = ProviderContainer();
  final cacheService = container.read(cacheServiceProvider);

  await cacheService.init();

  final newsApiService = container.read(newsApiServiceProvider);
  final apiKey = dotenv.env['API_KEY'];

  if (apiKey != null && apiKey.isNotEmpty) {
    newsApiService.setApiKey(apiKey);
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const SwenApp(),
    ),
  );
}
