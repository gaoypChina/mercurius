import 'package:mercurius/index.dart';

class MercuriusExportSectionWidget extends ConsumerWidget {
  const MercuriusExportSectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MercuriusL10N l10n = MercuriusL10N.of(context);

    return MercuriusListSectionWidget(
      title: Text(l10n.export),
      children: [
        MercuriusListItemWidget(
          iconData: Icons.data_object_rounded,
          titleText: l10n.exportJsonFile,
          onTap: () async {
            String dir = await ref.watch(mercuriusPathProvider.future);
            String path = '$dir/export.json';
            await isarService.exportJsonWith(path);

            /// FIXME: https://github.com/fluttercommunity/plus_plugins/issues/1351
            await Share.shareFiles([path]);
          },
        ),
        MercuriusListItemWidget(
          iconData: Icons.nfc_rounded,
          titleText: l10n.exportNfcData,
          // TODO: 写逻辑
          summaryText: l10n.notYetCompleted,
        ),
      ],
    );
  }
}
