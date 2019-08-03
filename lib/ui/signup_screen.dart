import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:retroshare/model/account.dart';
import 'package:retroshare/model/identity.dart';
import 'package:retroshare/services/account.dart';
import 'package:retroshare/services/auth.dart';
import 'package:retroshare/services/identity.dart';

import 'package:retroshare/redux/model/app_state.dart';
import 'package:retroshare/redux/actions/app_actions.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

enum PasswordError { correct, notTheSame, tooShort }

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController repeatPasswordController = new TextEditingController();
  TextEditingController nodeNameController = new TextEditingController();

  bool advancedOption;
  bool isUsernameCorrect;
  PasswordError passwordError;

  @override
  void initState() {
    super.initState();
    advancedOption = false;
    isUsernameCorrect = true;
    passwordError = PasswordError.correct;
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    nodeNameController.dispose();
    super.dispose();
  }

  void createAccount() async {
    bool success = true;
    if (usernameController.text.length < 3) {
      setState(() {
        isUsernameCorrect = false;
      });
      success = false;
    }
    if (passwordController.text != repeatPasswordController.text) {
      setState(() {
        passwordError = PasswordError.notTheSame;
      });
      success = false;
    }
    if (passwordController.text.length < 3) {
      setState(() {
        passwordError = PasswordError.tooShort;
      });
      success = false;
    }

    if (!success) return;

    Tuple2<bool, Account> accountCreate;
    Navigator.pushNamed(context, '/', arguments: true);
    if (nodeNameController.text == '')
      accountCreate = await requestAccountCreation(
          context, usernameController.text, passwordController.text);
    else
      accountCreate = await requestAccountCreation(
          context,
          usernameController.text,
          passwordController.text,
          nodeNameController.text);

    if (accountCreate != null && accountCreate.item1) {
      bool isAuthTokenValid = await checkExistingAuthTokens(
          accountCreate.item2.locationId, passwordController.text);
      if (isAuthTokenValid) {
        List<Identity> ownIdsList = await getOwnIdentities();

        Navigator.pop(context);

        if (ownIdsList.isEmpty)
          Navigator.pushReplacementNamed(context, '/create_identity', arguments: true);
        else {
          final store = StoreProvider.of<AppState>(context);
          store.dispatch(UpdateOwnIdentitiesAction(ownIdsList));
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Image.asset('assets/rs-logo.png',
                      height: 250, width: 250),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xFFF5F5F5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    height: 40,
                    child: TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.person_outline,
                            color: Color(0xFF9E9E9E),
                            size: 22.0,
                          ),
                          hintText: 'Username'),
                      style: Theme.of(context).textTheme.body2,
                    ),
                  ),
                ),
                Visibility(
                  visible: !isUsernameCorrect,
                  child: SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 52,
                        ),
                        Container(
                          height: 25,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Username is too short',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: isUsernameCorrect,
                  child: const SizedBox(height: 10),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xFFF5F5F5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    height: 40,
                    child: TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.lock_outline,
                            color: Color(0xFF9E9E9E),
                            size: 22.0,
                          ),
                          hintText: 'Password'),
                      style: Theme.of(context).textTheme.body2,
                      obscureText: true,
                    ),
                  ),
                ),
                Visibility(
                  visible: passwordError == PasswordError.tooShort,
                  child: SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 52,
                        ),
                        Container(
                          height: 25,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Password is too short',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: passwordError != PasswordError.tooShort,
                  child: const SizedBox(height: 10),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xFFF5F5F5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    height: 40,
                    child: TextField(
                      controller: repeatPasswordController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.lock_outline,
                            color: Color(0xFF9E9E9E),
                            size: 22.0,
                          ),
                          hintText: 'Repeat password'),
                      style: Theme.of(context).textTheme.body2,
                      obscureText: true,
                    ),
                  ),
                ),
                Visibility(
                  visible: passwordError == PasswordError.notTheSame,
                  child: SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 52,
                        ),
                        Container(
                          height: 25,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Passwords do not match',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: passwordError != PasswordError.notTheSame,
                  child: const SizedBox(height: 10),
                ),
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        advancedOption = !advancedOption;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        //color: Color(0xFFF5F5F5),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      height: 45,
                      child: Row(
                        children: <Widget>[
                          Checkbox(
                            value: advancedOption,
                            onChanged: (bool value) {
                              setState(() {
                                advancedOption = value;
                              });
                            },
                          ),
                          SizedBox(width: 3),
                          Text(
                            'Advanced option',
                            style: Theme.of(context).textTheme.body1,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: advancedOption,
                  child: SizedBox(height: 10),
                ),
                Visibility(
                  visible: advancedOption,
                  child: SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xFFF5F5F5),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      height: 40,
                      child: TextField(
                        controller: nodeNameController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.smartphone,
                            color: Color(0xFF9E9E9E),
                            size: 22.0,
                          ),
                          hintText: 'Node name',
                        ),
                        style: Theme.of(context).textTheme.body2,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: advancedOption,
                  child: SizedBox(height: 10),
                ),
                Visibility(
                  visible: advancedOption,
                  child: SizedBox(
                    width: double.infinity,
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          //color: Color(0xFFF5F5F5),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        height: 45,
                        child: Row(
                          children: <Widget>[
                            Checkbox(
                              value: false,
                            ),
                            SizedBox(width: 3),
                            Text(
                              'Tor/I2p Hidden node',
                              style: Theme.of(context).textTheme.body1,
                            )
                          ],
                        )),
                  ),
                ),
                const SizedBox(height: 20),
                FlatButton(
                  onPressed: () {
                    createAccount();
                  },
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          colors: <Color>[
                            Color(0xFF00FFFF),
                            Color(0xFF29ABE2),
                          ],
                          begin: Alignment(-1.0, -4.0),
                          end: Alignment(1.0, 4.0),
                        ),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: const Text(
                        'Create account',
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 70),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
