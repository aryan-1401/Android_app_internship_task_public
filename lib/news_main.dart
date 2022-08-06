import 'package:flutter/material.dart';
import 'package:newspaperapp/routes/route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      onGenerateRoute: MyRoutes().getRoute,
      builder: (context, child) {
        var data = MediaQuery.of(context).copyWith(textScaleFactor: 1);
        return MediaQuery(
          data: data,
          child: child,
        );
      },
    );
  }
}
