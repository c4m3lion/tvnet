import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tvnet/services/my_data.dart';
import 'package:tvnet/services/my_functions.dart';
import 'package:tvnet/services/my_network.dart';

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
    MyMessage.showSnack(context: context, text: "Loading your account...");
    setState(() {
      isLoading = true;
    });

    String status = await MyNetwork().login(login: login, pass: pass);
    if (status == "OK") {
      await MyData.localStorage.setString('login', login);
      await MyData.localStorage.setString('pass', pass);

      MyMessage.showSnack(context: context, text: "Loading Channels...");
      status = await MyNetwork().getChannels();
      if (status == "OK") {
        await MyFunctions().loadLocalData();
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        Navigator.pushNamed(
          context,
          '/video',
        );
      } else {
        MyMessage.showSnack(context: context, text: status);
      }
    } else {
      setState(() {
        isWrong = true;
      });
      _formKey.currentState!.validate();
      MyMessage.showSnack(context: context, text: status);
    }
    isLoading = false;
  }

  void loadLocalData() async {
    MyData.localStorage = await SharedPreferences.getInstance();
    loginInput.text = MyData.localStorage.getString('login') ?? "";
    passwordInput.text = MyData.localStorage.getString('pass') ?? "";
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
                    ? SizedBox(
                        width: 120,
                        height: 120,
                        child: CircularProgressIndicator(),
                      )
                    : Image.asset("assets/icons/app_logo-removebg-preview.png"),
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
                        padding: EdgeInsets.all(16),
                        child: Container(
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
                                    child: const Text('Submit'),
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
