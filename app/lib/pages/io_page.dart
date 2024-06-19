import 'package:mercurius/index.dart';
import 'package:path/path.dart' as p;

class IOPage extends StatelessWidget {
  const IOPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.importAndExport),
      ),
      body: const BasedListView(
        children: [
          _ImportSection(),
          _ExportSection(),
        ],
      ),
    );
  }
}

class _ImportSection extends StatelessWidget {
  const _ImportSection();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BasedListSection(
      titleText: l10n.import,
      children: const [
        _ImportJsonFile(),
        _ImportDiaryImages(),
        _ImportImageJsonFromV1(),
      ],
    );
  }
}

class _ImportJsonFile extends StatelessWidget {
  const _ImportJsonFile();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BasedListTile(
      leadingIcon: Icons.data_object_rounded,
      titleText: l10n.importJsonFile,
      onTap: () async {
        /// TIPS: 需要清除缓存，否则使用选择的和以前一样名称的文件
        if (Platform.isAndroid || Platform.isIOS) {
          await FilePicker.platform.clearTemporaryFiles();
        }

        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['json'],
        );

        if (result == null || result.files.single.path == null) return;

        final succuss = await isarService.importJsonWith(
          result.files.single.path!,
        );

        if (context.mounted && succuss) {
          App.vibration();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.pleaseBackToHomePage)),
          );
        }
      },
    );
  }
}

class _ImportImageJsonFromV1 extends ConsumerWidget {
  const _ImportImageJsonFromV1();

  void importImages(String imageDirectory) async {
    /// TIPS: 需要清除缓存，否则使用选择的和以前一样名称的文件
    if (Platform.isAndroid || Platform.isIOS) {
      await FilePicker.platform.clearTemporaryFiles();
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result == null || result.files.single.path == null) return;

    try {
      final file = File(result.files.single.path!);
      final images = jsonDecode(file.readAsStringSync()) as List;
      for (final image in images) {
        final f = File(p.join(imageDirectory, image['filename']));
        f.writeAsBytesSync(base64.decode(image['data']));
      }
    } catch (e) {
      App.printLog('Error', error: e);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final paths = ref.watch(pathsProvider);

    return BasedListTile(
      leadingIcon: Icons.add_photo_alternate_rounded,
      titleText: l10n.importImageJsonFromV1,
      onTap: () => importImages(paths.image.path),
    );
  }
}

class _ImportDiaryImages extends ConsumerWidget {
  const _ImportDiaryImages();

  void importImages(String imageDirectory) async {
    /// TIPS: 需要清除缓存，否则使用选择的和以前一样名称的文件
    if (Platform.isAndroid || Platform.isIOS) {
      await FilePicker.platform.clearTemporaryFiles();
    }

    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result == null || result.count < 1) return;

    try {
      for (final file in result.files) {
        final f = File(p.join(imageDirectory, p.basename(file.path!)));
        f.writeAsBytes(await file.xFile.readAsBytes());
      }
    } catch (e, s) {
      App.printLog('$e', error: e, stackTrace: s);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final paths = ref.watch(pathsProvider);

    return BasedListTile(
      leadingIcon: Icons.image_rounded,
      titleText: l10n.importDiaryImages,
      onTap: () => importImages(paths.image.path),
    );
  }
}

class _ExportSection extends ConsumerWidget {
  const _ExportSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final paths = ref.watch(pathsProvider);

    return BasedListSection(
      titleText: l10n.export,
      children: [
        BasedListTile(
          leadingIcon: Icons.data_object_rounded,
          titleText: l10n.exportDiaryJsonFile,
          onTap: () async {
            final path = p.join(paths.temp.path, 'export.json');
            final json = await isarService.exportDiaryJson();
            await File(path).writeAsString(jsonEncode(json));
            await App.shareXFiles([XFile(path)]);
          },
        ),
        const _ExportDiaryImagesTile(),
      ],
    );
  }
}

class _ExportDiaryImagesTile extends ConsumerWidget {
  const _ExportDiaryImagesTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final paths = ref.watch(pathsProvider);

    return BasedListTile(
      leadingIcon: Icons.photo_rounded,
      titleText: l10n.exportDiaryImages,
      onTap: () async {
        final images = paths.image.listSync();

        if (images.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.noData)),
          );
          return;
        }

        App.shareXFiles(
          images.map((e) => XFile(e.path)).toList(),
        );
      },
    );
  }
}
