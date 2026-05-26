import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomLoader
    extends StatelessWidget {

  const CustomLoader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Center(

      child: Column(

        mainAxisAlignment:
        MainAxisAlignment.center,

        children: [

          Lottie.asset(
            "assets/animations/loading.json",
            height: 180,
          ),

          const SizedBox(
            height: 10,
          ),

          const Text(
            "Loading...",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}