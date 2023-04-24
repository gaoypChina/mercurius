import 'package:mercurius/index.dart';

/// [MercuriusModifiedListItem] 是由 [StatelessWidget] 衍生出的列表系列组件的基类
class MercuriusModifiedListItem extends StatelessWidget {
  const MercuriusModifiedListItem({
    Key? key,
    this.padding,
    this.icon,
    this.iconData,
    this.titleText,
    this.titleTextStyle,
    this.summaryText,
    this.summaryTextStyle,
    this.detailText,
    this.detailTextStyle,
    this.showTitleTextBadge,
    this.showIconBadge,
    this.showDetailTextBadge,
    this.showAccessoryViewBadge,
    this.accessoryView,
    this.bottomView,
    this.disabled = false,
    this.onTap,
  }) : super(key: key);

  final EdgeInsets? padding;
  final Icon? icon;
  final IconData? iconData;
  final String? titleText;
  final TextStyle? titleTextStyle;
  final String? summaryText;
  final TextStyle? summaryTextStyle;
  final String? detailText;
  final TextStyle? detailTextStyle;
  final Widget? accessoryView;
  final bool? showIconBadge;
  final bool? showTitleTextBadge;
  final bool? showDetailTextBadge;
  final bool? showAccessoryViewBadge;
  final Widget? bottomView;
  final bool disabled;
  final VoidCallback? onTap;

  void _onTap() {
    MercuriusKit.vibration();
    if (onTap != null) onTap!();
  }

  Widget buildDetailText(BuildContext context) {
    return Badge(
      showBadge: showDetailTextBadge ?? false,
      child: detailText != null
          ? Text(
              detailText!,
              style: detailTextStyle ??
                  TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.outline,
                  ),
            )
          : Container(),
    );
  }

  Widget buildAccessoryView(BuildContext context) {
    return Badge(
      showBadge: showAccessoryViewBadge ?? false,
      child: accessoryView ??
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Icon(
              Icons.navigate_next,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.38),
            ),
          ),
    );
  }

  Widget buildBottomView(BuildContext context) => bottomView ?? Container();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: disabled ? null : _onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(
              minHeight: 56.0,
            ),
            padding: padding ?? const EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: Row(
              children: [
                if (icon != null)
                  Container(
                    margin: const EdgeInsets.fromLTRB(8.0, 0, 24.0, 0),
                    child: Badge(
                      showBadge: showIconBadge ?? false,
                      child: icon,
                    ),
                  )
                else
                  Container(
                    margin: const EdgeInsets.fromLTRB(8.0, 0, 24.0, 0),
                    child: Badge(
                      showBadge: showIconBadge ?? false,
                      child: Icon(
                        iconData,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.38),
                      ),
                    ),
                  ),
                if (titleText != null || summaryText != null)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (titleText != null)
                          Badge(
                            showBadge: showTitleTextBadge ?? false,
                            child: Text(
                              titleText ?? '',
                              style: titleTextStyle ??
                                  const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Saira',
                                  ),
                            ),
                          ),
                        if (summaryText != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 4),
                            child: Text(
                              summaryText ?? '',
                              style: summaryTextStyle ??
                                  TextStyle(
                                    fontSize: 8,
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                            ),
                          ),
                      ],
                    ),
                  ),
                buildDetailText(context),
                buildAccessoryView(context),
              ],
            ),
          ),
          buildBottomView(context),
        ],
      ),
    );
  }
}

/// 由 [MercuriusModifiedListItem] 衍生的组件，其右边被替换为开关
class MercuriusListSwitchItem extends MercuriusModifiedListItem {
  final bool? value;
  final ValueChanged<bool>? onChanged;

  const MercuriusListSwitchItem({
    Key? key,
    Icon? icon,
    IconData? iconData,
    String? titleText,
    TextStyle? titleTextStyle,
    String? summaryText,
    TextStyle? summaryTextStyle,
    String? detailText,
    TextStyle? detailTextStyle,
    Widget? accessoryView,
    VoidCallback? onTap,
    @required this.value,
    @required this.onChanged,
  }) : super(
          key: key,
          icon: icon,
          iconData: iconData,
          titleText: titleText,
          titleTextStyle: titleTextStyle,
          summaryText: summaryText,
          summaryTextStyle: summaryTextStyle,
          detailText: detailText,
          detailTextStyle: detailTextStyle,
          accessoryView: accessoryView,
          onTap: onTap,
        );

  @override
  void _onTap() {
    onChanged!(!value!);
    super._onTap();
  }

  @override
  Widget buildAccessoryView(BuildContext context) {
    return Transform.scale(
      scale: 0.7,
      child: Switch(
        value: value!,
        onChanged: onChanged,
      ),
    );
  }
}

/// 由 [MercuriusModifiedListItem] 衍生的组件，其中部被替换为 [TextField] 输入框
class MercuriusListTextFieldItem extends MercuriusModifiedListItem {
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;

  const MercuriusListTextFieldItem({
    Key? key,
    Icon? icon,
    IconData? iconData,
    String? titleText,
    TextStyle? titleTextStyle,
    String? summaryText,
    TextStyle? summaryTextStyle,
    Widget? accessoryView = const Padding(
      padding: EdgeInsets.only(left: 4),
      child: Icon(null),
    ),
    VoidCallback? onTap,
    this.hintText,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
  }) : super(
          key: key,
          icon: icon,
          iconData: iconData,
          titleText: titleText,
          titleTextStyle: titleTextStyle,
          summaryText: summaryText,
          summaryTextStyle: summaryTextStyle,
          accessoryView: accessoryView,
          onTap: onTap,
        );

  @override
  bool get disabled => true;

  @override
  Widget buildDetailText(BuildContext context) {
    return Expanded(
      child: TextField(
        decoration: InputDecoration(hintText: hintText),
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        onSubmitted: onSubmitted,
      ),
    );
  }
}
