import 'dart:ffi';

import 'package:advancetut/flashchat/utilities/constants.dart';
import 'package:advancetut/flashchat/widgets/app_title.dart';
import 'package:flutter/services.dart';

import 'package:advancetut/flashchat/view_model/login_view_model.dart';
import 'package:advancetut/flashchat/widgets/base_widget.dart';
import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password;
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
//  TextEditingController _passwordController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    //HandleOrientation.potrait();
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      builder: (context, model, _) => BaseWidget(
        title: 'LogIn',
        child: Column(
          children: <Widget>[
            Expanded(flex: 1, child: AppTitle()),
            Expanded(
              flex: 4,
              child: Form(
                  key: _formKey,
                  child: ListView(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onFieldSubmitted: (_) => model.fieldFocusChange(
                            context, _emailFocusNode, _passwordFocusNode),
                        focusNode: _emailFocusNode,
                        keyboardType: TextInputType.emailAddress,
                        decoration: new InputDecoration(
                            labelText: 'Email Address',
                            hintText: 'xyz@weare.com'),
                        validator: (value) => model.validateEmail(value),
                        textInputAction: TextInputAction.next,
                        onSaved: (email) => _email = email,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                       // controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        obscureText: true, // Use secure text for passwords.
                        decoration: new InputDecoration(
                            hintText: 'Password',
                            labelText: 'Enter your password'),
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            await model.handleLogIn(_email, _password, context);
                          }
                        },
                        onSaved: (password) => _password = password,
                      ),
                    ),
                  ])),
            ),
            Row(
              
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: model.busy
                      ? Container(
                        alignment: Alignment.center,
                          child: CircularProgressIndicator())
                      : FlatButton(
                          child: const Text(
                            'LogIn',
                            style: const TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              await model.handleLogIn(
                                  _email, _password, context);
                                  
                            }
                          },
                          color: Colors.blue,
                        ),
                  //   margin: new EdgeInsets.only(top: 20.0),
                ),
                Flexible(
                  child: FlatButton(
                    child: const Text(
                      'Register New Account',
                      style: const TextStyle(color: Colors.white),
                    ),
                    onPressed: 
                    model.busy
                    ?null
                    :() async { await Navigator.pushNamed(context, registration_screen);},
                    color: 
                    model.busy
                    ?Colors.grey.withOpacity(0.5)
                    :Colors.deepOrange.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
