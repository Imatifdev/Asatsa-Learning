// import 'package:flutter/material.dart';
// import 'package:qixer/view/utils/common_helper.dart';
// import 'package:qixer/view/utils/constant_colors.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class WatchVideoPage extends StatelessWidget {
//   const WatchVideoPage({Key? key, required this.videoUrl}) : super(key: key);

//   final videoUrl;

//   @override
//   Widget build(BuildContext context) {
//     ConstantColors cc = ConstantColors();
//     return Scaffold(
//       appBar: CommonHelper().appbarCommon('Video', context, () {
//         Navigator.pop(context);
//       }),
//       body: Container(
//         alignment: Alignment.center,
//         child: WebView(
//           initialUrl: Uri.dataFromString('<html><body>$videoUrl</body></html>',
//                   mimeType: 'text/html')
//               .toString(),
//           javascriptMode: JavascriptMode.unrestricted,
//         ),
//       ),
//     );
//   }
// }
