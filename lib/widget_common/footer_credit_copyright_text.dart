import 'package:flutter/material.dart';

class FooterCopyrightCreditText extends StatelessWidget {
  const FooterCopyrightCreditText({super.key});

  void _launchURL() async {
    // const url = 'https://fortxcore.com';
    // if (await canLaunch(url)) {
    //   await launch(url);
    // } else {
    //   throw 'Could not launch $url';
    // }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _launchURL,
      child: Text(
        'Developed with ❤️ in Sri Lanka',
        style: TextStyle(
          fontSize: 10.0,
          color: Colors.blue,
        ),
      ),
    );
  }
}
