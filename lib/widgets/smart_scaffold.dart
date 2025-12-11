import 'dart:async';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hiatunisie/utils/connectivity_manager.dart';
import 'package:hiatunisie/views/home/exports/export_homescreen.dart';


class SmartScaffold extends StatefulWidget {
  const SmartScaffold({
    super.key,
    required this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation = FloatingActionButtonLocation.centerDocked,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.backgroundColor = Colors.white,
    this.resizeToAvoidBottomInset,
    this.extendBody = false,
    this.displayBack = false,
    this.displayMenu = false,
    this.displayClose = false,
    this.isAuth = false,
    this.title,
    this.tilteColor = Colors.blueGrey,
    this.titleStyle,
    this.leadingIconData,
    this.leadingIconColor = Colors.white,
    this.onLeadingPressed,
    this.actionIconData,
    this.actionIconColor = Colors.white,
    this.actionBackgroundColor,
    this.onActionPressed,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.formKey,
  });

  final Widget body;
  final bool extendBody;
  final bool isAuth;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Color backgroundColor;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final bool? resizeToAvoidBottomInset;

  final bool displayBack;
  final bool displayMenu;
  final bool displayClose;

  final String? title;
  final Color? tilteColor;
  final TextStyle? titleStyle;

  final IconData? actionIconData;
  final void Function()? onLeadingPressed;
  final IconData? leadingIconData;
  final Color? leadingIconColor;
  final Color? actionBackgroundColor;
  final Color? actionIconColor;
  final void Function()? onActionPressed;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final GlobalKey? formKey;

  @override
  _SmartScaffoldState createState() => _SmartScaffoldState();
}

class _SmartScaffoldState extends State<SmartScaffold> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityManager>(
      builder: (contextn, connectivity, child) {
        if (!connectivity.isConnected) {
        //  return const DisconnectedWidget();
        }
        return GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: Scaffold(
            extendBody: widget.extendBody,
            key: widget.key,
            appBar: widget.displayBack || widget.displayMenu || widget.displayClose
                ? AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: widget.displayBack
                              ? Image.asset(
                                  'images/left-arrow.png',
                                  width: 18.w,
                                  height: 18.w,
                                )
                              : widget.displayMenu
                                  ? Icon(Icons.menu, color: widget.leadingIconColor)
                                  : widget.displayClose
                                      ? Icon(Icons.close, color: widget.leadingIconColor)
                                      : const SizedBox.shrink(),
                          onPressed: widget.onLeadingPressed ?? () => Navigator.pop(context),
                        ),
                      ),
                    ),
                    title: widget.title != null
                        ? Text(
                            widget.title!,
                            style: widget.titleStyle ??
                                TextStyle(color: widget.tilteColor, fontSize: 20),
                          )
                        : null,
                    actions: widget.actionIconData != null
                        ? [
                            IconButton(
                              icon: Icon(widget.actionIconData, color: widget.actionIconColor),
                              onPressed: widget.onActionPressed,
                            ),
                          ]
                        : null,
                  )
                : null,
            body: widget.isAuth
                ? Stack(
                    children: [
                      Positioned(
                        child: Image.asset(
                          'images/hiaauthbgg.png',
                          width: 52,
                          height: 62,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: Image.asset(
                          "images/hiaauthbgg.png",
                          width: 58,
                          height: 58,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: Image.asset(
                          "images/hiaauthbgg.png",
                          width: 160,
                          height: 160,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        child: Image.asset(
                          "images/hiaauthbgg.png",
                          width: 50,
                          height: 75,
                        ),
                      ),
                      widget.body,
                    ],
                  )
                : widget.body,
            floatingActionButton: widget.floatingActionButton,
            floatingActionButtonLocation: widget.floatingActionButtonLocation ?? (Platform.isIOS ? FloatingActionButtonLocation.endDocked : FloatingActionButtonLocation.endFloat),
            bottomSheet: widget.bottomSheet,
            backgroundColor: widget.backgroundColor,
            resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
            bottomNavigationBar: widget.bottomNavigationBar,
          ),
        );
      },
    );
  }
}