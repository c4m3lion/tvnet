import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/my_functions.dart' as func;
import '../../services/my_globals.dart' as globals;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isWrong = false;
  TextEditingController loginInput = TextEditingController();
  TextEditingController passwordInput = TextEditingController();
  FocusNode loginFocus = FocusNode();

  void loginStart({required String login, required String pass}) async {
    isWrong = false;
    if (isLoading || !_formKey.currentState!.validate()) return;
    func.showSnack(context, "Loading your account...");
    setState(() {
      isLoading = true;
    });

    try {
      globals.token = await func.login(login: login, password: pass);
      await globals.localStorage.setString('login', login);
      await globals.localStorage.setString('pass', pass);
      if (mounted) {
        func.showSnack(context, "Loading Channels...");
      }
      await func.setChannelsAndCategories();

      if (mounted) {
        func.clearSnackBar(context);
        Navigator.pushReplacementNamed(
          context,
          '/video',
        );
      }
    } catch (e) {
      func.showSnack(context, e.toString());
      setState(() {
        isWrong = true;
      });
      _formKey.currentState!.validate();
    }
    isLoading = false;
  }

  void loadLocalData() async {
    globals.localStorage = await SharedPreferences.getInstance();
    loginInput.text = globals.localStorage.getString('login') ?? "";
    passwordInput.text = globals.localStorage.getString('pass') ?? "";
    if (loginInput.text != "" && passwordInput.text != "") {
      loginStart(
        login: loginInput.text,
        pass: passwordInput.text,
      );
    }
  }

  @override
  void initState() {
    loadLocalData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return SafeArea(
      child: Scaffold(
        body: Flex(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          direction: isPortrait ? Axis.vertical : Axis.horizontal,
          children: [
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.center,
                child: isLoading
                    ? const SizedBox(
                        width: 120,
                        height: 120,
                        child: CircularProgressIndicator(),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset(
                          "assets/images/app_logo.png",
                          width: 200,
                        ),
                      ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment:
                    isPortrait ? Alignment.topCenter : Alignment.centerLeft,
                child: Shortcuts(
                  shortcuts: <LogicalKeySet, Intent>{
                    // LogicalKeySet(LogicalKeyboardKey.arrowLeft):
                    //     const PreviousFocusIntent(),
                    // LogicalKeySet(LogicalKeyboardKey.arrowDown):
                    //     const NextFocusIntent(),
                    // LogicalKeySet(LogicalKeyboardKey.arrowUp):
                    //     const PreviousFocusIntent(),
                    // LogicalKeySet(LogicalKeyboardKey.arrowRight):
                    //     const NextFocusIntent(),
                  },
                  child: ExcludeFocus(
                    excluding: isLoading,
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          width: 320,
                          child: Card(
                            child: ListView(
                              padding: EdgeInsets.all(8),
                              shrinkWrap: true,
                              children: [
                                Focus(
                                  onKey: (node, event) {
                                    if (event.isKeyPressed(
                                        LogicalKeyboardKey.arrowDown)) {}
                                    return KeyEventResult.ignored;
                                  },
                                  canRequestFocus: false,
                                  child: TextFormField(
                                    autofocus: true,
                                    focusNode: loginFocus,
                                    controller: loginInput,
                                    decoration: const InputDecoration(
                                      icon: Icon(Icons.person),
                                      hintText: 'Enter your Login',
                                      labelText: 'Login...',
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty || isWrong) {
                                        return 'Please enter valid login';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                                TextFormField(
                                  controller: passwordInput,
                                  decoration: const InputDecoration(
                                    icon: Icon(Icons.password),
                                    hintText: 'Enter your password',
                                    labelText: 'Password...',
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty || isWrong) {
                                      return 'Please enter valid password';
                                    }
                                    return null;
                                  },
                                  obscureText: true,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (value) => {
                                    loginStart(
                                      login: loginInput.text,
                                      pass: passwordInput.text,
                                    ),
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 24, left: 24, right: 24),
                                  child: ElevatedButton(
                                    child: const Text(
                                      'Submit',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      loginStart(
                                        login: loginInput.text,
                                        pass: passwordInput.text,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
