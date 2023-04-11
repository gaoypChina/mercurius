import 'package:mercurius/index.dart';

class MercuriusPathNotifier extends ChangeNotifier {
  late Future<Directory?> directory;

  late String path;

  void init() async {
    MercuriusKit.printLog('mercuriusPathNotifier 初始化中');

    /// 可见于 Android/pers.cierra_runis.mercurius/files
    directory = getExternalStorageDirectory();

    directory.then((value) {
      path = value!.path;
    });
  }
}
