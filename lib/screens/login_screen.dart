import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../blocs/authentication_bloc.dart';
import '../blocs/news_bloc.dart';
import '../design_system/colors.dart';
import '../l10n/mesa_localizations.dart';
import '../utils/api_exceptions.dart';
import '../utils/scale.dart';
import '../widgets/rouded_button.dart';
import 'news_feed_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formEmailKey = GlobalKey<FormState>();
  final _formPasswordKey = GlobalKey<FormState>();

  final FocusNode _passwordFocus = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.close,
            size: scale(16.0),
          ),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
        ),
        centerTitle: true,
        title: Text(
          MesaLocalizations.of(context)!.loginScreenTitle,
          style: TextStyle(
            fontSize: scale(17.0),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationFailure) {
            if (state.exception is ClientErrorException &&
                (state.exception as ClientErrorException).code == 401) {
              final SnackBar snackBar = SnackBar(
                  content: Text(MesaLocalizations.of(context)!
                      .wrongEmailOrPassSnackbarText));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else if (state.exception is ConnectionException) {
              final SnackBar snackBar = SnackBar(
                  content: Text(MesaLocalizations.of(context)!
                      .noInternetAccessSnackbarText));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          } else if (state is AuthenticationSuccess) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => NewsFeedScreen(
                    newsBloc: BlocProvider.of<NewsBloc>(context),
                  ),
                ),
                (route) => false);
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: scale(16.0), vertical: scale(40)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SvgPicture.asset(
                    'lib/assets/login.svg',
                    height: scale(119.0),
                    width: scale(120.0),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: scale(55.0),
                          bottom: scale(2.0),
                        ),
                        child: Text(
                          "E-mail",
                          style: TextStyle(
                              fontSize: scale(12.0),
                              fontWeight: FontWeight.w500,
                              color: MesaColors.darkBlue),
                        ),
                      ),
                      Form(
                        key: _formEmailKey,
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          autofocus: true,
                          validator: (value) {
                            if (value != null) {
                              if (!EmailValidator.validate(value)) {
                                return "Insira um e-mail válido";
                              }
                            }
                          },
                          onEditingComplete: () {
                            if (_formEmailKey.currentState!.validate()) {
                              _passwordFocus.requestFocus();
                            }
                          },
                          onFieldSubmitted: (value) {
                            if (_formEmailKey.currentState!.validate()) {
                              _passwordFocus.requestFocus();
                            }
                          },
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(
                                scale(5.0),
                              ),
                            ),
                            filled: true,
                            fillColor: Color(0xffF0F0F0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: scale(26.0),
                          bottom: scale(2.0),
                        ),
                        child: Text(
                          "Senha",
                          style: TextStyle(
                              fontSize: scale(12.0),
                              fontWeight: FontWeight.w500,
                              color: MesaColors.darkBlue),
                        ),
                      ),
                      Form(
                        key: _formPasswordKey,
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return "Insira uma senha";
                            }
                          },
                          focusNode: _passwordFocus,
                          controller: _passwordController,
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(
                                scale(5.0),
                              ),
                            ),
                            filled: true,
                            fillColor: Color(0xffF0F0F0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: scale(32.0),
                      ),
                    ],
                  ),
                  BlocBuilder<AuthenticationBloc, AuthenticationState>(
                    builder: (context, state) => RoundedButton(
                      backgroundColor: MesaColors.mainBlue,
                      loading: state is AuthenticationInProgress,
                      onTap: () {
                        if (_formEmailKey.currentState!.validate() &&
                            _formPasswordKey.currentState!.validate()) {
                          log("message");
                          BlocProvider.of<AuthenticationBloc>(context).add(
                              SignInRequested(
                                  email: _emailController.text,
                                  password: _passwordController.text));
                        }
                      },
                      text: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: scale(15.0),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
