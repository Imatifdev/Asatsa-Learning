import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/rtl_service.dart';
import 'package:qixer/service/support_ticket/support_messages_service.dart';
import 'package:qixer/view/tabs/settings/supports/image_big_preview.dart';
import 'package:qixer/view/tabs/settings/supports/support_ticket_helper.dart';
import 'package:qixer/view/utils/constant_colors.dart';
import 'package:qixer/view/utils/constant_styles.dart';
import 'package:qixer/view/utils/others_helper.dart';
import 'package:qixer/view/utils/responsive.dart';

class TicketChatPage extends StatefulWidget {
  const TicketChatPage({Key? key, required this.title, required this.ticketId})
      : super(key: key);

  final String title;
  final ticketId;

  @override
  State<TicketChatPage> createState() => _TicketChatPageState();
}

class _TicketChatPageState extends State<TicketChatPage> {
  bool firstTimeLoading = true;

  TextEditingController sendMessageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 10,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  XFile? pickedImage;

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();

    return Listener(
      onPointerDown: (_) {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          flexibleSpace: SafeArea(
            child: Container(
              padding: const EdgeInsets.only(right: 16, left: 8),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: cc.greyParagraph,
                    ),
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  // CircleAvatar(
                  //   backgroundColor: Colors.white,
                  //   child: Container(
                  //     padding: const EdgeInsets.all(5),
                  //     decoration: const BoxDecoration(
                  //         shape: BoxShape.circle, color: Colors.white),
                  //     child: ClipRRect(
                  //       child: Image.asset(
                  //         'assets/images/logo.png',
                  //       ),
                  //     ),
                  //   ),
                  //   maxRadius: 22,
                  // ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          widget.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          "#${widget.ticketId}",
                          style:
                              TextStyle(color: cc.primaryColor, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  // Icon(
                  //   Icons.settings,
                  //   color: Colors.black54,
                  // ),
                ],
              ),
            ),
          ),
        ),
        body: Consumer<SupportMessagesService>(
            builder: (context, provider, child) {
          if (provider.messagesList.isNotEmpty &&
              provider.sendLoading == false) {
            Future.delayed(const Duration(milliseconds: 500), () {
              _scrollDown();
            });
          }
          return Stack(
            children: <Widget>[
              provider.isloading == false
                  ?
                  //chat messages
                  Container(
                      margin: const EdgeInsets.only(bottom: 60),
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: provider.messagesList.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                        ),
                        physics: physicsCommon,
                        itemBuilder: (context, index) {
                          return Row(
                            mainAxisAlignment:
                                provider.messagesList[index]['type'] == "seller"
                                    ? MainAxisAlignment.start
                                    : MainAxisAlignment.end,
                            children: [
                              //small show profile pic
                              // provider.messagesList[index].type == "seller"
                              //     ? Container(
                              //         margin: const EdgeInsets.only(
                              //           left: 13,
                              //         ),
                              //         width: 18,
                              //         height: 18,
                              //         decoration: const BoxDecoration(
                              //             shape: BoxShape.circle,
                              //             color: Colors.white),
                              //         child: ClipRRect(
                              //           child: Image.asset(
                              //             'assets/images/logo.png',
                              //           ),
                              //         ),
                              //       )
                              //     : Container(),
                              //the message
                              Expanded(
                                child: Consumer<RtlService>(
                                  builder: (context, rtlP, child) => Container(
                                    padding: EdgeInsets.only(
                                        left: provider.messagesList[index]
                                                    ['type'] ==
                                                "seller"
                                            ? rtlP.direction == 'ltr'
                                                ? 10
                                                : 90
                                            : rtlP.direction == 'ltr'
                                                ? 90
                                                : 10,
                                        right: provider.messagesList[index]
                                                    ['type'] ==
                                                "seller"
                                            ? rtlP.direction == 'ltr'
                                                ? 90
                                                : 10
                                            : rtlP.direction == 'ltr'
                                                ? 10
                                                : 90,
                                        top: 10,
                                        bottom: 10),
                                    child: Align(
                                      alignment: (provider.messagesList[index]
                                                  ['type'] ==
                                              "seller"
                                          ? Alignment.topLeft
                                          : Alignment.topRight),
                                      child: Column(
                                        crossAxisAlignment:
                                            (provider.messagesList[index]
                                                        ['type'] ==
                                                    "seller"
                                                ? CrossAxisAlignment.start
                                                : CrossAxisAlignment.end),
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color:
                                                  (provider.messagesList[index]
                                                              ['type'] ==
                                                          "seller"
                                                      ? Colors.grey.shade200
                                                      : cc.primaryColor),
                                            ),
                                            padding: const EdgeInsets.all(16),
                                            //message =====>
                                            child: Text(
                                              SupportTicketHelper().removePTag(
                                                  provider.messagesList[index]
                                                      ['message']),
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: (provider.messagesList[
                                                              index]['type'] ==
                                                          "seller"
                                                      ? Colors.grey[800]
                                                      : Colors.white)),
                                            ),
                                          ),
                                          provider.messagesList[index]
                                                      ['attachment'] !=
                                                  null
                                              ? Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 11),
                                                  child: provider.messagesList[
                                                                  index]
                                                              ['imagePicked'] ==
                                                          false
                                                      ? InkWell(
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute<
                                                                  void>(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    ImageBigPreviewPage(
                                                                  networkImgLink:
                                                                      provider.messagesList[
                                                                              index]
                                                                          [
                                                                          'attachment'],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: provider
                                                                            .messagesList[
                                                                        index][
                                                                    'attachment'] ??
                                                                placeHolderUrl,
                                                            placeholder:
                                                                (context, url) {
                                                              return Image.asset(
                                                                  'assets/images/placeholder.png');
                                                            },
                                                            height: 150,
                                                            width: screenWidth /
                                                                    2 -
                                                                50,
                                                            fit:
                                                                BoxFit.fitWidth,
                                                          ),
                                                        )
                                                      : InkWell(
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute<
                                                                  void>(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    ImageBigPreviewPage(
                                                                  assetImgLink:
                                                                      provider.messagesList[
                                                                              index]
                                                                          [
                                                                          'attachment'],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Image.file(
                                                            File(provider
                                                                        .messagesList[
                                                                    index]
                                                                ['attachment']),
                                                            height: 150,
                                                            width: screenWidth /
                                                                    2 -
                                                                50,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                )
                                              : Container()
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // provider.messagesList[index].type == "seller"
                              //     ? Container(
                              //         margin: const EdgeInsets.only(
                              //           right: 13,
                              //         ),
                              //         width: 15,
                              //         height: 15,
                              //         decoration: const BoxDecoration(
                              //             shape: BoxShape.circle,
                              //             color: Colors.white),
                              //         child: ClipRRect(
                              //           borderRadius: BorderRadius.circular(100),
                              //           child: Image.network(
                              //             'https://cdn.pixabay.com/photo/2016/09/08/13/58/desert-1654439__340.jpg',
                              //             fit: BoxFit.cover,
                              //           ),
                              //         ),
                              //       )
                              //     : Container(),
                            ],
                          );
                        },
                      ),
                    )
                  : OthersHelper().showLoading(cc.primaryColor),

              //write message section
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 20, bottom: 10, top: 10, right: 10),
                  height: 60,
                  width: double.infinity,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      pickedImage != null
                          ? Image.file(
                              File(pickedImage!.path),
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                            )
                          : Container(),
                      const SizedBox(
                        width: 13,
                      ),
                      Expanded(
                        child: TextField(
                          controller: sendMessageController,
                          decoration: const InputDecoration(
                              hintText: "Write message...",
                              hintStyle: TextStyle(color: Colors.black54),
                              border: InputBorder.none),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      //pick image =====>
                      IconButton(
                          onPressed: () async {
                            pickedImage = await provider.pickImage();
                            setState(() {});
                          },
                          icon: const Icon(Icons.attachment)),

                      //send message button
                      const SizedBox(
                        width: 13,
                      ),
                      FloatingActionButton(
                        onPressed: () async {
                          if (sendMessageController.text.isNotEmpty) {
                            //hide keyboard
                            FocusScope.of(context).unfocus();
                            //send message
                            provider.sendMessage(
                              widget.ticketId,
                              sendMessageController.text,
                              pickedImage?.path,
                            );

                            //clear input field
                            sendMessageController.clear();
                            //clear image
                            setState(() {
                              pickedImage = null;
                            });
                          } else {
                            OthersHelper().showToast(
                                'Please write a message first', Colors.black);
                          }
                        },
                        child: provider.sendLoading == false
                            ? const Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 18,
                              )
                            : const SizedBox(
                                height: 14,
                                width: 14,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 1.5,
                                ),
                              ),
                        backgroundColor: cc.primaryColor,
                        elevation: 0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
