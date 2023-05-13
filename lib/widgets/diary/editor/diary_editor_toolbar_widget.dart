import 'package:mercurius/index.dart';

class DiaryEditorToolbarWidget extends ConsumerWidget {
  const DiaryEditorToolbarWidget({
    Key? key,
    required this.currentDiary,
    required this.scrollController,
    required this.controller,
    required this.handleToolbarChangeDiary,
  }) : super(key: key);

  final Diary currentDiary;
  final ScrollController scrollController;
  final QuillController controller;
  final ValueChanged<Diary?> handleToolbarChangeDiary;

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

    List<EmbedButtonBuilder> embedButtons = [
      (controller, _, __, ___) {
        return path.when(
          loading: () => const MercuriusLoadingWidget(withText: false),
          error: (error, stackTrace) => Container(),
          data: (data) => DiaryEditorToolbarImageButtonWidget(
            controller: controller,
            context: context,
            path: data,
          ),
        );
      }
    ];

    return QuillToolbar.basic(
      controller: controller,
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
        DiaryEditorToolbarTimestampButtonWidget(
          controller: controller,
        ),
        DiaryEditorToolbarMoodButtonWidget(
          context: context,
          currentDiary: currentDiary,
          handleToolbarChangeDiary: handleToolbarChangeDiary,
        ),
        DiaryEditorToolbarWeatherButtonWidget(
          context: context,
          currentDiary: currentDiary,
          handleToolbarChangeDiary: handleToolbarChangeDiary,
        ),
        DiaryEditorToolbarDateTimeButtonWidget(
          currentDiary: currentDiary,
          context: context,
          handleToolbarChangeDiary: handleToolbarChangeDiary,
        ),
      ],
      locale: const Locale('zh', 'CN'),
    );
  }
}
