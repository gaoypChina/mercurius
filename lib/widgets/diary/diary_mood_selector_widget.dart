import 'package:mercurius/index.dart';

class DiaryMoodSelectorWidget extends StatefulWidget {
  /// 自定义组件
  const DiaryMoodSelectorWidget({
    Key? key,
    required this.diary,
  }) : super(key: key);

  final Diary diary;

  @override
  State<DiaryMoodSelectorWidget> createState() =>
      _DiaryMoodSelectorWidgetState();
}

class _DiaryMoodSelectorWidgetState extends State<DiaryMoodSelectorWidget> {
  late Diary _diary;

  @override
  void initState() {
    super.initState();
    setState(() {
      _diary = widget.diary;
    });
  }

  List<Widget> _listAllMood() {
    List<Widget> buttonList = [];
    for (var element in DiaryMoodType.values) {
      buttonList.add(
        IconButton(
          onPressed: () => Navigator.of(context).pop(
            Diary.copyWith(_diary, moodType: element),
          ),
          icon: Column(
            children: [Icon(element.iconData), Text(element.mood)],
          ),
          color: _diary.moodType != element
              ? null
              : Theme.of(context).colorScheme.primary,
        ),
      );
    }
    return buttonList;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('现在心情如何'),
          Text(
            'ねぇ、今どんな気持ち',
            style: TextStyle(
              fontSize: 10,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: double.minPositive,
        child: ListView(
          shrinkWrap: true,
          children: [
            Center(
              child: Wrap(
                spacing: 16,
                direction: Axis.horizontal,
                children: _listAllMood(),
              ),
            ),
          ],
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      actions: [
        TextButton(
          onPressed: () {
            MercuriusKit.vibration();
            Navigator.of(context).pop();
          },
          child: const Text('返回'),
        ),
      ],
    );
  }
}
