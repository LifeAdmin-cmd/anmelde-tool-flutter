import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // Obtain the screen dimensions
    double screenHeight = MediaQuery.of(context).size.height;

    // Calculate the desired size for the image
    double imageSize = screenHeight * 0.5;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(32, 86, 223, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(70, 0, 70, imageSize/8),
              child: SvgPicture.asset(
                'lib/assets/DPV_Lilie.svg',
                width: imageSize,
                height: imageSize,
              ),
            ),
            // const SizedBox(height: 25.0,),
            const SpinKitRing(
              color: Colors.white,
              size: 50.0,
              // duration: Duration(milliseconds: 800),
            ),
          ],
        ),
      ),
    );
  }
}
