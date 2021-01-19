import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[250],
      body: Stack(
        children: [
          ClipPath(
            clipper: OvalBottomBorderClipper(),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 2.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: GradientColors.facebookMessenger
                )
              ),
            )
          ),
          Container(
            margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width / 2 - 64,
              top: MediaQuery.of(context).size.height / 3.1
            ),
            child: CircleAvatar(
              radius: 64,
              child: ClipOval(
                child: ColorFiltered(
                    child: Image.asset("assets/Images/profile.png"),
                    colorFilter: ColorFilter.mode(Colors.yellow, BlendMode.color),
                ),
              ),
            ),
          )
        ],
      )
    );
  }
}
