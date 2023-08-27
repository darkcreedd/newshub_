import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:newshub_tabview/screens/home_screen.dart';
import 'package:provider/provider.dart';

import '../data/dataclass.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    var data = Provider.of<DataClass>(context, listen: false);
    data.reload('us');

    Future.delayed(const Duration(seconds: 3)).then((value) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQ = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: mediaQ.height,
        width: mediaQ.width,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 150.h,
                width: 150.w,
                child: const Image(
                  image: AssetImage('assets/images/icona.png'),
                  fit: BoxFit.fill,
                ),
              ),
              Text(
                'News Hub',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 25.sp),
              ),
              SpinKitWave(
                color: const Color.fromARGB(255, 231, 20, 5),
                size: 30.sp,
              )
            ],
          ),
        ),
      ),
    );
  }
}
