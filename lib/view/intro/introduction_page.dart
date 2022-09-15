import 'package:flutter/material.dart';
import 'package:qixer/view/auth/login/login.dart';
import 'package:qixer/view/intro/intro_helper.dart';
import 'package:qixer/view/utils/common_helper.dart';
import 'package:qixer/view/utils/constant_colors.dart';
import 'package:qixer/view/utils/responsive.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({Key? key}) : super(key: key);

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  ConstantColors cc = ConstantColors();
  int _selectedSlide = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    // var screenWidth = MediaQuery.of(context).size.width;
    // var screenHeight = MediaQuery.of(context).size.height;
    print(screenWidth);
    return Scaffold(
      body: Container(
        clipBehavior: Clip.none,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          //Slider =============>
          SizedBox(
            height: screenHeight < fourinchScreenHeight
                ? screenHeight - 490
                : screenHeight - 550,
          ),
          SizedBox(
            height: screenHeight < fourinchScreenHeight ? 290 : 370,
            child: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    _selectedSlide = value;
                  });
                },
                itemCount: 3,
                itemBuilder: (context, i) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height:
                              screenHeight < fourinchScreenHeight ? 130 : 260,
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(IntroHelper().getImage(i)),
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                        Text(
                          IntroHelper().geTitle(i),
                          style: TextStyle(
                              color: cc.greyPrimary,
                              fontSize: 19,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 7,
                        ),

                        // Subtitle =============>
                        CommonHelper().paragraphCommon(
                            IntroHelper().geSubTitle(i), TextAlign.center)
                      ],
                    ),
                  );
                }),
          ),
          const SizedBox(
            height: 20,
          ),

          //slider count show =======>
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < 3; i++)
                Container(
                  margin: const EdgeInsets.only(right: 5),
                  height: 16,
                  width: 16,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: _selectedSlide == i
                              ? cc.primaryColor
                              : Colors.transparent),
                      shape: BoxShape.circle),
                  child: Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                        color: _selectedSlide == i
                            ? cc.primaryColor
                            : const Color(0xffD0D5DD),
                        shape: BoxShape.circle),
                  ),
                )
            ],
          ),

//buttons
          const SizedBox(
            height: 42,
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                        (Route<dynamic> route) => false);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 16),
                    decoration: BoxDecoration(
                        border: Border.all(color: cc.primaryColor, width: 1.5),
                        borderRadius: BorderRadius.circular(7)),
                    child: Text(
                      'Skip',
                      style: TextStyle(
                          color: cc.primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 18,
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    if (_selectedSlide == 2) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    } else {
                      _pageController.animateToPage(_selectedSlide + 1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease);
                    }
                  },
                  child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                          color: cc.primaryColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      )),
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
