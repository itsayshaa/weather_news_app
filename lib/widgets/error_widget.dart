import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomErrorWidget
    extends StatelessWidget {

  final String message;

  const CustomErrorWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {

    return Center(

      child: Padding(

        padding:
        const EdgeInsets.all(20),

        child: Column(

          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [

            Lottie.asset(
              "assets/animations/error.json",
              height: 200,
            ),

            const SizedBox(
              height: 20,
            ),

            Text(
              message,

              textAlign:
              TextAlign.center,

              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight:
                FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}