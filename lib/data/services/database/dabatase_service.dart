import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'models/local_user.dart';

class DatabaseService {
  Isar? _isar;

  Future<Isar> get isar async {
    // Vérifiez si l'instance est déjà créée
    if (_isar != null) {
      return _isar!;
    }

    // Obtenez le répertoire des documents de l'application
    final dir = await getApplicationDocumentsDirectory();
    // Ouvrez l'instance d'Isar
    _isar = await Isar.open([LocalUserSchema], directory: dir.path);
    return _isar!;
  }
}