import 'package:mercurius/index.dart';

class DiaryEditorToolbarWidget extends ConsumerWidget {
  const DiaryEditorToolbarWidget({
    super.key,
    required this.diary,
    required this.scrollController,
    required this.quillController,
    required this.handleChangeDiary,
  });

  final Diary diary;
  final ScrollController scrollController;
  final QuillController quillController;
  final ValueChanged<Diary?> handleChangeDiary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconSelectedFillColor =
        Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).colorScheme.outlineVariant
            : Theme.of(context).colorScheme.primaryContainer;

    final quillIconTheme = QuillIconTheme(
      borderRadius: 12,
      iconSelectedFillColor: iconSelectedFillColor,
    );

    final path = ref.watch(mercuriusPathProvider);

    final MercuriusL10N l10n = MercuriusL10N.of(context);

    List<EmbedButtonBuilder> embedButtons = [
      (controller, _, __, ___) {
        return path.when(
          loading: () => const MercuriusLoadingWidget(),
          error: (error, stackTrace) => Container(),
          data: (data) => DiaryEditorToolbarImageButtonWidget(
            tooltip: l10n.insertImage,
            controller: controller,
            context: context,
            path: data,
          ),
        );
      },
      (controller, _, __, ___) {
        return DiaryEditorToolbarTagButtonWidget(
          tooltip: l10n.insertTag,
          controller: controller,
          context: context,
        );
      }
    ];

    return QuillToolbar.basic(
      controller: quillController,
      showUndo: false,
      showRedo: false,
      showFontFamily: false,
      showFontSize: false,
      showBackgroundColorButton: false,
      showClearFormat: false,
      showColorButton: false,
      showCodeBlock: false,
      showInlineCode: false,
      showAlignmentButtons: true,
      showListBullets: false,
      showListCheck: false,
      showListNumbers: false,
      showJustifyAlignment: false,
      showDividers: false,
      showSmallButton: true,
      showSearchButton: false,
      showIndent: false,
      showLink: false,
      showSubscript: false,
      showSuperscript: false,
      toolbarSectionSpacing: 2,
      iconTheme: quillIconTheme,
      embedButtons: embedButtons,
      customButtons: [
        DiaryEditorToolbarMoodButtonWidget(
          context: context,
          currentDiary: diary,
          handleToolbarChangeDiary: handleChangeDiary,
          tooltip: l10n.changeMood,
        ),
        DiaryEditorToolbarWeatherButtonWidget(
          context: context,
          currentDiary: diary,
          handleToolbarChangeDiary: handleChangeDiary,
          tooltip: l10n.changeWeather,
        ),
        DiaryEditorToolbarDateTimeButtonWidget(
          currentDiary: diary,
          context: context,
          handleToolbarChangeDiary: handleChangeDiary,
          tooltip: l10n.changeDate,
        ),
      ],
      locale: Localizations.localeOf(context),
    );
  }
}
