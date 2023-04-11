import 'package:mercurius/index.dart';

import 'package:flutter_quill/flutter_quill.dart' as flutter_quill;

class DiaryPageViewBodyWidget extends StatefulWidget {
  const DiaryPageViewBodyWidget({
    Key? key,
    required this.diary,
  }) : super(key: key);

  final Diary diary;

  @override
  State<DiaryPageViewBodyWidget> createState() =>
      _DiaryPageViewBodyWidgetState();
}

class _DiaryPageViewBodyWidgetState extends State<DiaryPageViewBodyWidget> {
  late Diary _currentDiary;

  @override
  void initState() {
    super.initState();
    _currentDiary = widget.diary;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SizedBox(
        child: Container(
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            color: Theme.of(context).colorScheme.background,
            shadows: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 15.0,
                spreadRadius: 4.0,
              ),
            ],
          ),
          child: Column(
            children: [
              SizedOverflowBox(
                size: const Size.fromHeight(134),
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(flex: 1, child: Container()),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${_currentDiary.createDateTime.toString().substring(0, 4)}年，${_currentDiary.createDateTime.toString().substring(5, 7)}月',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _currentDiary.createDateTime
                                  .toString()
                                  .substring(8, 10),
                              style: const TextStyle(
                                fontSize: 60,
                                fontFamily: 'Saira',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  size: 8,
                                  QWeatherIcon.getIconDataById(
                                    int.parse(_currentDiary.weather),
                                  ),
                                ),
                                Text(
                                  '${DiaryConstance.weekdayMap[_currentDiary.createDateTime!.weekday]!} ${_currentDiary.latestEditTime.toString().substring(11, 19)}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                Icon(
                                  size: 9,
                                  DiaryConstance.moodMap[_currentDiary.mood] ??
                                      DiaryConstance.moodMap['开心'],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 134 * 0.8,
                        alignment: Alignment.topCenter,
                        child: IconButton(
                          onPressed: () {
                            MercuriusKit.vibration();
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 0,
                indent: 8,
                endIndent: 8,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  child: flutter_quill.QuillEditor(
                    locale: const Locale('zh', 'CN'),
                    focusNode: FocusNode(),
                    scrollController: ScrollController(),
                    scrollable: true,
                    expands: false,
                    padding: const EdgeInsets.all(4.0),
                    autoFocus: false,
                    showCursor: false,
                    enableInteractiveSelection: false,
                    enableSelectionToolbar: false,
                    controller: flutter_quill.QuillController(
                      document: flutter_quill.Document.fromJson(
                        jsonDecode(_currentDiary.contentJsonString!),
                      ),
                      selection: const TextSelection.collapsed(offset: 0),
                    ),
                    onLaunchUrl: (url) {
                      launchUrlString(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    readOnly: true,
                    scrollBottomInset: 10,
                    customStyles: flutter_quill.DefaultStyles(
                      placeHolder: flutter_quill.DefaultTextBlockStyle(
                        TextStyle(
                          fontFamily: 'Saira',
                          fontSize: 14,
                          height: 1.5,
                          color: Colors.grey.withOpacity(0.6),
                        ),
                        const flutter_quill.VerticalSpacing(0, 0),
                        const flutter_quill.VerticalSpacing(0, 0),
                        null,
                      ),
                      paragraph: flutter_quill.DefaultTextBlockStyle(
                        TextStyle(
                          fontFamily: 'Saira',
                          fontSize: 14,
                          height: 1.5,
                          color: Theme.of(context).colorScheme.inverseSurface,
                        ),
                        const flutter_quill.VerticalSpacing(0, 0),
                        const flutter_quill.VerticalSpacing(0, 0),
                        null,
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(
                height: 0,
                indent: 8,
                endIndent: 8,
              ),
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            MercuriusKit.vibration();
                            Navigator.pop(context);
                            isarService.deleteDiaryById(
                              _currentDiary.id!,
                            );
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            MercuriusKit.vibration();
                            Diary? editedDiary = await _showDiaryEditorPage(
                              context,
                              _currentDiary,
                            );
                            setState(() {
                              _currentDiary = editedDiary ?? _currentDiary;
                            });
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            MercuriusKit.vibration();
                            Share.share(
                              '${_currentDiary.createDateTime.toString().substring(0, 10)}\n'
                              '天气：${DiaryConstance.weatherCommitMap[_currentDiary.weather] ?? '未记录'}\n'
                              '标题：${_currentDiary.titleString ?? '无标题'}\n'
                              '心情：${_currentDiary.mood}\n'
                              '\n'
                              '${flutter_quill.Document.fromJson(
                                jsonDecode(_currentDiary.contentJsonString!),
                              ).toPlainText().trimRight()}',
                            );
                          },
                          icon: const Icon(UniconsLine.share),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Diary?> _showDiaryEditorPage(BuildContext context, Diary diary) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiaryEditorPage(
          diary: diary,
        ),
      ),
    );
  }
}
