// ignore_for_file: prefer_const_constructors

import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:qixer/view/services/components/desc_from_html.dart';
import 'package:qixer/view/utils/constant_colors.dart';

import '../service_helper.dart';

class OverviewTab extends StatelessWidget {
  const OverviewTab({Key? key, required this.provider}) : super(key: key);

  final provider;
  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Text(
        //   provider.serviceAllDetails.serviceDetails.description,
        //   style: TextStyle(
        //     color: cc.greyParagraph,
        //     fontSize: 14,
        //     height: 1.4,
        //   ),
        // ),
        DescInHtml(
          desc: provider.serviceAllDetails.serviceDetails.description,
        ),
        const SizedBox(
          height: 20,
        ),
        AutoSizeText(
          'Benefits of the premium package:',
          maxLines: 1,
          style: TextStyle(
              color: cc.greyFour, fontSize: 19, fontWeight: FontWeight.bold),
        ),
        //checklist
        const SizedBox(
          height: 19,
        ),
        for (int i = 0;
            i < provider.serviceAllDetails.serviceBenifits.length;
            i++)
          ServiceHelper().checkListCommon(
              provider.serviceAllDetails.serviceBenifits[i].benifits),

        //FAQ ===============>
        (provider.serviceAllDetails.serviceDetails.serviceFaq).isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  AutoSizeText(
                    'FAQ:',
                    maxLines: 1,
                    style: TextStyle(
                        color: cc.greyFour,
                        fontSize: 19,
                        fontWeight: FontWeight.bold),
                  ),
                  //checklist
                  const SizedBox(
                    height: 15,
                  ),

                  for (int i = 0;
                      i <
                          provider.serviceAllDetails.serviceDetails.serviceFaq
                              .length;
                      i++)
                    ExpandablePanel(
                      controller: ExpandableController(initialExpanded: false),
                      theme: const ExpandableThemeData(hasIcon: false),
                      header: Container(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                provider.serviceAllDetails.serviceDetails
                                        .serviceFaq[i].title ??
                                    '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: cc.greyFour,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: cc.greyParagraph,
                              ),
                            )
                          ],
                        ),
                      ),
                      collapsed: Text(''),
                      expanded: Container(
                          //Dropdown
                          margin: const EdgeInsets.only(bottom: 20, top: 8),
                          child: Column(
                            children: [
                              Text(provider.serviceAllDetails.serviceDetails
                                      .serviceFaq[i].description ??
                                  '')
                            ],
                          )),
                    ),
                ],
              )
            : Container()
      ]),
    );
  }
}
