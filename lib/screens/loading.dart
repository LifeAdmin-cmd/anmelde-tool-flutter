import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  void setupWorldTime() async {
    // WorldTime instance = WorldTime(location: "Europe/Berlin", flag: "germany.png");
    // await instance.getTime();
    // Navigator.pushReplacementNamed(context, '/home', arguments: {
    //   'location': instance.location,
    //   'flag': instance.flag,
    //   'time': instance.time,
    //   'isDayTime': instance.isDayTime,
    // });
    await Future.delayed(const Duration(seconds: 2));

    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  void initState() {
    super.initState();
    setupWorldTime();
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
              padding: const EdgeInsets.fromLTRB(70, 0, 70, 0),
              child: Image(
                image: const AssetImage('lib/assets/DPV_Lilie.png',),
                height: imageSize,
                width: imageSize,
              ),
            ),
            // const SizedBox(height: 8.0,),
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
