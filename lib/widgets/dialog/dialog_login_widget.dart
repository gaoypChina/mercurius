import 'package:mercurius/index.dart';

class DialogLoginWidget extends StatefulWidget {
  const DialogLoginWidget({super.key});

  @override
  State<DialogLoginWidget> createState() => _DialogLoginWidgetState();
}

class _DialogLoginWidgetState extends State<DialogLoginWidget> {
  final TextEditingController _mercuriusId = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('登录'),
          Text(
            '欢迎来到 ${MercuriusConstance.name}',
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
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _mercuriusId,
                    decoration: const InputDecoration(
                      hintText: '${MercuriusConstance.name} Id',
                    ),
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return '${MercuriusConstance.name} Id 不能为空';
                      }
                      try {
                        int.parse(value);
                      } catch (e) {
                        return '请仅输入数字';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _password,
                    decoration: const InputDecoration(
                      hintText: '密码',
                    ),
                    validator: (value) =>
                        value!.trim().isNotEmpty ? null : '密码不能为空',
                    obscureText: true,
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () => _showDialogRegisterWidget(context),
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: const Align(
                heightFactor: 3,
                child: Text(
                  '没有帐号？点此注册～',
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      actions: [
        Consumer<MercuriusProfileNotifier>(
          builder: (context, mercuriusProfileNotifier, childe) {
            return TextButton(
              onPressed: () {
                if ((_formKey.currentState as FormState).validate()) {
                  _fetchUser(
                    int.parse(_mercuriusId.text),
                    _password.text,
                    context,
                  );
                }
              },
              child: const Text('确认'),
            );
          },
        ),
      ],
    );
  }

  Future<void> _showDialogRegisterWidget(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    showDialog<void>(
      context: context,
      builder: (context) => const DialogRegisterWidget(),
    );
    showDialog<void>(
      context: context,
      builder: (context) => const DialogPrivacyWidget(),
    );
    return showDialog<void>(
      context: context,
      builder: (context) => const DialogAgreementWidget(),
    );
  }

  Future<void> _fetchUser(
    num mercuriusId,
    String password,
    BuildContext context,
  ) async {
    User newUser = User()
      ..mercuriusId = mercuriusId
      ..username = '田所浩二'
      ..email = 'byrdsaron@gmail.com';
    mercuriusProfileNotifier
        .changeProfile(mercuriusProfileNotifier.profile..user = newUser);
    Navigator.of(context).pop();
  }
}
