import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hiatunisie/views/home/exports/export_homescreen.dart';

class CountdownDisplay extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;

  const CountdownDisplay({
    Key? key,
    required this.text,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Example: A horizontal gradient from orange to deepOrange
    // with some rounded corners, a clock icon, and white text.
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.orange, Colors.deepOrange],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time_outlined,
            color: Colors.white,
            size: 16.sp,
          ),
          SizedBox(width: 4.w),
          Text(
            text,
            style: textStyle?.copyWith(color: Colors.white) ??
                TextStyle(color: Colors.white, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}