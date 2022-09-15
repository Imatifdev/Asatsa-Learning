import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/leave_feedback_service.dart';
import 'package:qixer/service/profile_service.dart';
import 'package:qixer/view/booking/components/textarea_field.dart';
import 'package:qixer/view/services/components/service_details_top.dart';
import 'package:qixer/view/utils/common_helper.dart';
import 'package:qixer/view/utils/constant_colors.dart';
import 'package:qixer/view/utils/constant_styles.dart';

class WriteReviewPage extends StatefulWidget {
  const WriteReviewPage(
      {Key? key,
      required this.serviceId,
      required this.title,
      required this.userImg,
      required this.userName})
      : super(key: key);

  final serviceId;
  final String title;
  final String userImg;
  final String userName;
  @override
  State<WriteReviewPage> createState() => _WriteReviewPageState();
}

class _WriteReviewPageState extends State<WriteReviewPage> {
  double rating = 1;
  TextEditingController reviewController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonHelper().appbarCommon('Write a review', context, () {
        Navigator.pop(context);
      }),
      body: SingleChildScrollView(
        physics: physicsCommon,
        child: Consumer<ProfileService>(
          builder: (context, profileProvider, child) => Container(
            padding: EdgeInsets.symmetric(horizontal: screenPadding),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(
                height: 15,
              ),
              ServiceTitleAndUser(
                cc: cc,
                title: widget.title,
                userImg: widget.userImg,
                userName: widget.userName,
                videoLink: null,
              ),
              const SizedBox(
                height: 28,
              ),
              RatingBar.builder(
                initialRating: 1,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 3.0),
                itemSize: 32,
                unratedColor: cc.greyFive,
                itemBuilder: (context, _) => const Icon(
                  Icons.star_rounded,
                  color: Colors.amber,
                ),
                onRatingUpdate: (value) {
                  rating = value;
                  print(rating);
                },
              ),
              sizedBox20(),
              Text(
                'How was the service?',
                style: TextStyle(
                    color: cc.greyFour,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 14,
              ),
              TextareaField(
                notesController: reviewController,
                hintText: 'Write a review',
              ),
              sizedBox20(),
              Consumer<LeaveFeedbackService>(
                builder: (context, lfProvider, child) =>
                    CommonHelper().buttonOrange('Post review', () {
                  if (lfProvider.isloading == false) {
                    lfProvider.leaveFeedback(
                        rating,
                        profileProvider.profileDetails.userDetails.name ?? '',
                        profileProvider.profileDetails.userDetails.email ?? '',
                        reviewController.text,
                        widget.serviceId,
                        context);
                  }
                }, isloading: lfProvider.isloading == false ? false : true),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
