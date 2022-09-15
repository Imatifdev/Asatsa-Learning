// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:qixer/view/home/components/service_card.dart';
// import 'package:qixer/view/utils/constant_colors.dart';

// class SearchPage extends StatefulWidget {
//   const SearchPage({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<SearchPage> createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> {
//   final TextEditingController _controller = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     ConstantColors cc = ConstantColors();
//     return Scaffold(
//         backgroundColor: cc.bgColor,
//         appBar: AppBar(
//             // The search area here
//             backgroundColor: ConstantColors().primaryColor,
//             title: Container(
//               width: double.infinity,
//               height: 40,
//               decoration: BoxDecoration(
//                   color: Colors.white, borderRadius: BorderRadius.circular(5)),
//               child: Center(
//                 child: TextField(
//                   controller: _controller,
//                   autofocus: true,
//                   onSubmitted: (value) {
//                     if (value.isNotEmpty) {
//                       //run the function to search
//                     }
//                   },
//                   decoration: InputDecoration(
//                       prefixIcon: Icon(
//                         Icons.search,
//                         color: ConstantColors().greyPrimary,
//                       ),
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           Icons.clear,
//                           color: ConstantColors().greyPrimary,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             _controller.clear();
//                           });
//                         },
//                       ),
//                       hintText: 'Search...',
//                       border: InputBorder.none),
//                 ),
//               ),
//             )),
//         body: Listener(
//           onPointerDown: (_) {
//             FocusScopeNode currentFocus = FocusScope.of(context);
//             if (!currentFocus.hasPrimaryFocus) {
//               currentFocus.focusedChild?.unfocus();
//             }
//           },
//           child: WillPopScope(
//             onWillPop: () {
//               return Future.value(true);
//             },
//             child: SingleChildScrollView(
//                 child: Column(
//               children: [
//                 for (int i = 0; i < 5; i++)
//                   ServiceCard(
//                       cc: cc,
//                       imageLink:
//                           'https://cdn.pixabay.com/photo/2022/05/10/11/12/tree-7186835__480.jpg',
//                       title: 'Service title',
//                       sellerName: 'saleheen',
//                       buttonText: 'Book',
//                       rating: 2,
//                       price: 200,
//                       width: double.infinity,
//                       marginRight: 0.0,
//                       pressed: () {},
//                       isSaved: false,
//                       serviceId: 1,
//                       sellerId: 1)
//               ],
//             )),
//           ),
//         ));
//   }
// }
