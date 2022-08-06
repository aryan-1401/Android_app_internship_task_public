import 'package:flutter/material.dart';

import '../../../constants.dart';

class LoginScreenTopImage extends StatelessWidget {
  const LoginScreenTopImage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "LOGIN",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
        ),
        SizedBox(height: defaultPadding * 2),
        Row(
          children:<Widget> [
            const Spacer(),
            Expanded(
              flex: 20,
              child: Image(
                image: AssetImage('assets/images/pngwing.com.png'),
              ),
            ),
            const Spacer(),
          ],
        ),
        SizedBox(height: defaultPadding * 2),
      ],
    );
  }
}