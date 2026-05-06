import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:window_manager/window_manager.dart';
import 'app.dart';
import 'core/constants/app_colors.dart';
import 'core/utils/platform_utils.dart';
import 'providers/news_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (PlatformUtils.isDesktop) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(1100, 720),
      minimumSize: Size(800, 560),
      center: true,
      title: 'Swen',
      titleBarStyle: TitleBarStyle.normal,
    );
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

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

  if (PlatformUtils.isWeb) {
    newsApiService.setProxyUrl('https://corsproxy.io/?');
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const SwenApp(),
    ),
  );
}
