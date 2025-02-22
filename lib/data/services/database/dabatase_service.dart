import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'models/local_user.dart';

class DatabaseService {
  Future<Isar> get isar async {
    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open([LocalUserSchema], directory: dir.path);
  }
}
