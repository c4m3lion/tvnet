import 'package:easy_localization/easy_localization.dart';
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
  static final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isWrong = false;
  TextEditingController loginInput = TextEditingController();
  TextEditingController passwordInput = TextEditingController();
  FocusNode loginFocus = FocusNode();

  void loginStart({required String login, required String pass}) async {
    isWrong = false;
    globals.name = login;
    if (isLoading || !_formKey.currentState!.validate()) return;
    func.showSnack(context, "Loading your account...".tr());
    setState(() {
      isLoading = true;
    });

    try {
      globals.token = await func.login(login: login, password: pass);
      await globals.localStorage.setString('login', login);
      await globals.localStorage.setString('pass', pass);
      if (mounted) {
        func.showSnack(context, "Loading Channels...".tr());
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
    Future.delayed(const Duration(milliseconds: 500), () {
      loginFocus.requestFocus();
    });
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
                          "assets/icons/app_logo.png",
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
                              TextFormField(
                                focusNode: loginFocus,
                                controller: loginInput,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.person),
                                  hintText: 'Enter your Login'.tr(),
                                  labelText: 'Login...'.tr(),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty || isWrong) {
                                    return 'Please enter valid login'.tr();
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                              ),
                              TextFormField(
                                controller: passwordInput,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.password),
                                  hintText: 'Enter your password'.tr(),
                                  labelText: 'Password...'.tr(),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty || isWrong) {
                                    return 'Please enter valid password'.tr();
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
                                  child: Text(
                                    'Submit'.tr(),
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
                              Padding(
                                padding: EdgeInsets.only(top: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Image.asset(
                                      "assets/icons/facebook_icon.png",
                                      width: 26,
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Image.asset(
                                      "assets/icons/telephone.png",
                                      width: 28,
                                    ),
                                    Text("012952"),
                                  ],
                                ),
                              )
                            ],
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
