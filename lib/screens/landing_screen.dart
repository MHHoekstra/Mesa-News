import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../design_system/colors.dart';
import '../l10n/mesa_localizations.dart';
import '../utils/scale.dart';
import '../widgets/rouded_button.dart';
import 'login_screen.dart';

class LandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MesaColors.mainBlue,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                SvgPicture.asset(
                  'lib/assets/logo.svg',
                  height: scale(101.0),
                  width: scale(116.0),
                ),
                SizedBox(
                  height: scale(19.0),
                ),
                Text(
                  "NEWS",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: scale(19.0),
                      fontWeight: FontWeight.w900,
                      letterSpacing: scale(25.0)),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: scale(16.0)),
              child: RoundedButton(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                backgroundColor: Colors.white,
                text: Text(
                  MesaLocalizations.of(context)?.landingScreenButtonText ??
                      "Entrar com o e-mail",
                  style: TextStyle(
                      fontSize: scale(15.0),
                      fontWeight: FontWeight.w700,
                      color: MesaColors.lightBlue),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
