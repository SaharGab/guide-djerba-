import 'package:flutter/material.dart';

import 'package:projet_pfe/screens/screens.dart';

class QuesS extends StatefulWidget {
  const QuesS({Key? key}) : super(key: key);

  @override
  State<QuesS> createState() => _QuesSState();
}

class _QuesSState extends State<QuesS> {
  int currentPage = 0;

  void _onPageChanged(int index) {
    setState(() {
      currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalPages = 4;
    final PageController pageController = PageController();

    return Stack(
      children: [
        ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcOver,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/mos.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment(0.6, 0)),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(146, 71, 71, 71),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  height: 40,
                  width: 40,
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        (context),
                        MaterialPageRoute(
                          builder: ((context) => Ques0()),
                        ),
                      );
                    },
                    icon: Icon(Icons.arrow_back),
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: PageView(
                  controller: pageController,
                  onPageChanged: _onPageChanged,
                  children: <Widget>[Ques1(), Ques2(), Ques3(), Ques4()],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 165),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 70,
                      height: 70,
                      child: CircularProgressIndicator(
                        value: (currentPage + 1) / totalPages,
                        backgroundColor: Colors.grey,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(255, 18, 120, 171),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward_ios),
                      color: Color.fromARGB(255, 18, 120, 171),
                      onPressed: () {
                        if (currentPage < totalPages) {
                          // Not on the last page, so animate to the next page.
                          pageController.animateToPage(
                            currentPage + 1,
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          // Last page: Handle survey completion here.
                          // For example, navigate to a 'Thank You' screen or submit the results.
                          Navigator.push(
                            (context),
                            MaterialPageRoute(
                              builder: ((context) => Home()),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              )
            ],
          ),
        ),
      ],
    );
  }
}
