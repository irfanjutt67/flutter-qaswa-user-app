import '../consts/consts.dart';

Widget loadingIndicator({circleColor = redColor}) {
  return Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(circleColor),
    ),
  );
}
