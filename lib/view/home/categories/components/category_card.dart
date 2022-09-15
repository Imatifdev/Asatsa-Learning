import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:qixer/view/utils/others_helper.dart';

import '../../../services/service_by_category_page.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard(
      {Key? key,
      required this.name,
      required this.id,
      required this.cc,
      required this.index,
      required this.marginRight,
      required this.imagelink})
      : super(key: key);

  final name;
  final id;
  final cc;
  final index;
  final imagelink;
  final double marginRight;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => ServicebyCategoryPage(
              categoryName: name,
              categoryId: id,
            ),
          ),
        );
      },
      child: Container(
        alignment: Alignment.center,
        width: 100,
        margin: EdgeInsets.only(
          right: marginRight,
        ),
        decoration: BoxDecoration(
            border: Border.all(color: cc.borderColor),
            borderRadius: BorderRadius.circular(9)),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 35,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: imagelink ?? placeHolderUrl,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.fitHeight,
                )),
            const SizedBox(
              height: 5,
            ),
            AutoSizeText(
              name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: cc.greyFour,
                fontSize: 13,
                height: 1.4,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
