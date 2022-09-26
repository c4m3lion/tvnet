import 'package:flutter/material.dart';
import 'package:tvnet/pages/home/home_page.dart';
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

  void loginStart({required String login, required String pass}) async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
      isWrong = false;
    });

    String status = await MyNetwork().login(login: login, pass: pass);
    if (status == "OK") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      setState(() {
        isWrong = true;
      });
      _formKey.currentState!.validate();
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text("Wrong credentials!")),
        );
    }
    isLoading = false;
  }

  @override
  void initState() {
    // TODO: implement initState
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
                            TextFormField(
                              controller: loginInput,
                              decoration: const InputDecoration(
                                icon: const Icon(Icons.person),
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
                            TextFormField(
                              controller: passwordInput,
                              decoration: const InputDecoration(
                                icon: const Icon(Icons.password),
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
                              textInputAction: TextInputAction.next,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 24, left: 24, right: 24),
                              child: ElevatedButton(
                                child: const Text('Submit'),
                                onPressed: () {
                                  isWrong = false;
                                  if (_formKey.currentState!.validate()) {
                                    loginStart(
                                      login: loginInput.text,
                                      pass: passwordInput.text,
                                    );
                                    ScaffoldMessenger.of(context)
                                      ..removeCurrentSnackBar()
                                      ..showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Loading your account...")),
                                      );
                                  }
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
          ],
        ),
      ),
    );
  }
}
