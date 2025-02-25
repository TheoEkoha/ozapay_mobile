import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'data/services/injection/injection_service.dart';
import 'presentation/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Load environment
  await dotenv.load(fileName: '.env.dev');

  /// Dependency injection
  await configure();

  // l10n
  await EasyLocalization.ensureInitialized();
  // Initialiser le stockage HydratedBloc
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale("fr", "FR")],
      path: 'assets/translations',
      fallbackLocale: const Locale("fr", "FR"),
      assetLoader: const YamlAssetLoader(),
      child: const OzapayApp(),
    ),
  );
}
