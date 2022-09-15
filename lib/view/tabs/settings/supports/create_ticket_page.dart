import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qixer/service/support_ticket/create_ticket_service.dart';
import 'package:qixer/view/utils/common_helper.dart';
import 'package:qixer/view/utils/constant_colors.dart';
import 'package:qixer/view/utils/constant_styles.dart';
import 'package:qixer/view/utils/custom_input.dart';

import '../../../booking/components/textarea_field.dart';
import '../../../utils/others_helper.dart';

class CreateTicketPage extends StatefulWidget {
  const CreateTicketPage({Key? key}) : super(key: key);

  @override
  _CreateTicketPageState createState() => _CreateTicketPageState();
}

class _CreateTicketPageState extends State<CreateTicketPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Provider.of<CreateTicketService>(context, listen: false)
        .fetchOrderDropdown(context);
  }

  TextEditingController descController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonHelper().appbarCommon('Create ticket', context, () {
          Provider.of<CreateTicketService>(context, listen: false)
              .makeOrderlistEmpty();
          Navigator.pop(context);
        }),
        body: WillPopScope(
          onWillPop: () {
            Provider.of<CreateTicketService>(context, listen: false)
                .makeOrderlistEmpty();
            return Future.value(true);
          },
          child: SingleChildScrollView(
            physics: physicsCommon,
            child: Consumer<CreateTicketService>(
              builder: (context, provider, child) => Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenPadding, vertical: 20),
                  child: Column(children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Priority dropdown ======>
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonHelper().labelCommon("Priority"),
                            Container(
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                border: Border.all(color: cc.greyFive),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  // menuMaxHeight: 200,
                                  // isExpanded: true,
                                  value: provider.selectedPriority,
                                  icon: Icon(Icons.keyboard_arrow_down_rounded,
                                      color: cc.greyFour),
                                  iconSize: 26,
                                  elevation: 17,
                                  style: TextStyle(color: cc.greyFour),
                                  onChanged: (newValue) {
                                    provider.setPriorityValue(newValue);

                                    //setting the id of selected value
                                    provider.setSelectedPriorityId(
                                        provider.priorityDropdownIndexList[
                                            provider.priorityDropdownList
                                                .indexOf(newValue!)]);
                                  },
                                  items: provider.priorityDropdownList
                                      .map<DropdownMenuItem<String>>((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                            color:
                                                cc.greyPrimary.withOpacity(.8)),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            )
                          ],
                        ),

                        //Order dropdown =======>
                        provider.hasOrder == true
                            ? provider.orderDropdownList.isNotEmpty
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      sizedBox20(),
                                      CommonHelper()
                                          .labelCommon("Order number"),
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: cc.greyFive),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            // menuMaxHeight: 200,
                                            // isExpanded: true,
                                            value: provider.selectedOrder
                                                .toString(),
                                            icon: Icon(
                                                Icons
                                                    .keyboard_arrow_down_rounded,
                                                color: cc.greyFour),
                                            iconSize: 26,
                                            elevation: 17,
                                            style:
                                                TextStyle(color: cc.greyFour),
                                            onChanged: (newValue) {
                                              provider.setOrderValue(newValue);

                                              //setting the id of selected value
                                              provider.setSelectedOrderId(
                                                  provider.orderDropdownIndexList[
                                                      provider.orderDropdownList
                                                          .indexOf(newValue!)]);
                                            },
                                            items: provider.orderDropdownList
                                                .map<DropdownMenuItem<String>>(
                                                    (value) {
                                              return DropdownMenuItem(
                                                value: value.toString(),
                                                child: Text(
                                                  value.toString(),
                                                  style: TextStyle(
                                                      color: cc.greyPrimary
                                                          .withOpacity(.8)),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                : Container(
                                    margin: const EdgeInsets.only(top: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        OthersHelper()
                                            .showLoading(cc.primaryColor)
                                      ],
                                    ),
                                  )
                            : Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: Text(
                                  'You don\'t have any active order',
                                  style: TextStyle(color: cc.warningColor),
                                )),

                        sizedBox20(),
                        CommonHelper().labelCommon("Title"),
                        CustomInput(
                          controller: titleController,
                          validation: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter ticket title';
                            }
                            return null;
                          },
                          hintText: "Ticket title",
                          // icon: 'assets/icons/user.png',
                          paddingHorizontal: 18,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        CommonHelper().labelCommon("Description"),
                        TextareaField(
                          hintText: 'Please explain your problem',
                          notesController: descController,
                        ),

                        //Save button =========>

                        const SizedBox(
                          height: 30,
                        ),
                        CommonHelper().buttonOrange('Create ticket', () {
                          if (provider.hasOrder == false) {
                            OthersHelper().showToast(
                                'You don\'t have any active order',
                                Colors.black);
                          } else if (_formKey.currentState!.validate()) {
                            if (provider.isLoading == false &&
                                provider.hasOrder == true) {
                              provider.createTicket(
                                  context,
                                  titleController.text,
                                  provider.selectedPriority,
                                  descController.text,
                                  provider.selectedOrderId);
                            }
                          }
                        },
                            isloading:
                                provider.isLoading == false ? false : true)
                      ],
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ));
  }
}
