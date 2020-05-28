import 'package:advancetut/flashchat/view_model/registration_view_model.dart';
import 'package:advancetut/flashchat/widgets/app_title.dart';
import 'package:advancetut/flashchat/widgets/base_widget.dart';
import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

class RegistrationView extends StatefulWidget {
  @override
  _RegistrationViewState createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
  FocusNode _usernameFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _confirmPasswordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  String _name, _email, _password, _confirmedPassword;
  @override
  Widget build(BuildContext context) {
    //HandleOrientation.potrait();
    return ViewModelBuilder<RegistrationViewModel>.reactive(
      viewModelBuilder: () => RegistrationViewModel(),
      builder: (context, model, _) => BaseWidget(
        title: 'Register',
        child: Container(
          child: Column(
            children: <Widget>[
              Flexible(child: AppTitle()),
              Flexible(
                flex: 4,
                              child: Form(
                    key: _formKey,
                    child: ListView(
                      children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          onFieldSubmitted: (_) => model.fieldFocusChange(
                              context, _usernameFocusNode, _emailFocusNode),
                          focusNode: _usernameFocusNode,
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.text,
                          decoration:
                              new InputDecoration(labelText: 'your name '),
                          validator: (value) => model.validateName(value),
                          textInputAction: TextInputAction.next,
                          onSaved: (name) => _name = name,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          onFieldSubmitted: (_) => model.fieldFocusChange(
                              context, _emailFocusNode, _passwordFocusNode),
                          focusNode: _emailFocusNode,

                          keyboardType: TextInputType
                              .emailAddress, // Use email input type for emails.
                          decoration: new InputDecoration(
                              hintText: 'you@example.com',
                              labelText: 'E-mail Address'),
                          textInputAction: TextInputAction.next,
                          validator: (value) => model.validateEmail(value),
                          onSaved: (email) => _email = email,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          onFieldSubmitted: (_) => model.fieldFocusChange(context,
                              _passwordFocusNode, _confirmPasswordFocusNode),
                          focusNode: _passwordFocusNode,

                          obscureText: true, // Use secure text for passwords.
                          decoration: new InputDecoration(
                              hintText: 'Password',
                              labelText: 'Enter your password'),
                          validator: (value) => model.validatePassword(value),
                          textInputAction: TextInputAction.next,
                          onSaved: (password) => _password = password,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          focusNode: _confirmPasswordFocusNode,
                          onFieldSubmitted: (_)async{
                             if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                    await model.handleRegistration(
                                      _name.toLowerCase(),
                                      _email,
                                      _password,
                                      context,
                                    );
                                  }
                          },
                          obscureText: true, // Use secure text for passwords.
                          decoration:
                              new InputDecoration(labelText: 'Confirm Password'),
                          validator: (value) => model.validateConfirmPassword(
                              value, _confirmedPassword),
                          textInputAction: TextInputAction.done,
                          onSaved: (cnfrmPassword) =>
                              _confirmedPassword = cnfrmPassword,
                          onChanged: (value) => _confirmedPassword = value,
                        ),
                      ),
                     
                    ])),
              ),
                   Flexible(
                                        child: Container(
                        width: double.infinity,
                        child: model.busy
                            ? Center(
                                widthFactor: 25.0,
                                heightFactor: 25.0,
                                child: CircularProgressIndicator())
                            : RaisedButton(
                                child: const Text(
                                  'Register',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                    await model.handleRegistration(
                                      _name.toLowerCase(),
                                      _email,
                                      _password,
                                      context,
                                    );
                                  }
                                },
                                color: Colors.blue,
                              ),
                        margin: new EdgeInsets.only(top: 20.0),
                      ),
                   ),
            ],
          ),
        ),
      ),
    );
  }
}
