import 'package:flutter/material.dart';
import 'package:projet_pfe/screens/screens.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Pages extends StatelessWidget {
  final _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: PageView(
                  controller: _controller,
                  children: const [
                    Page1(),
                    Page2(),
                    Page3(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: ExpandingDotsEffect(
                    activeDotColor: Color.fromARGB(255, 18, 120, 171),
                    dotColor: Color.fromARGB(255, 161, 161, 161),
                    dotHeight: 14,
                    dotWidth: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
