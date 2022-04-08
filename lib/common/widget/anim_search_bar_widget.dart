import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garden/common/ui.dart';

class AnimSearchBar extends StatefulWidget {
  final double width;
  final TextEditingController textController;
  final Icon? suffixIcon;
  final Icon? prefixIcon;
  final String hintText;
  final int animationDurationInMilli;
  final VoidCallback onSuffixTap;
  final bool rtl;
  final bool autoFocus;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final bool closeSearchOnSuffixTap;
  final Color? color;
  final Color? cursorColor;
  final List<TextInputFormatter>? inputFormatters;
  final BoolCallBack? onToggleChanged;
  final StringCallback? onChanged;
  final bool isOpening;

  const AnimSearchBar({
    Key? key,

    /// The width cannot be null
    required this.width,

    /// The textController cannot be null
    required this.textController,
    this.suffixIcon,
    this.prefixIcon,
    this.hintText = 'Search...',

    /// choose your custom color
    this.color = Colors.white,

    /// The onSuffixTap cannot be null
    required this.onSuffixTap,
    this.animationDurationInMilli = 375,

    /// make the search bar to open from right to left
    this.rtl = false,

    /// make the keyboard to show automatically when the searchbar is expanded
    this.autoFocus = false,

    /// TextStyle of the contents inside the searchbar
    this.style,
    this.hintStyle,

    /// close the search on suffix tap
    this.closeSearchOnSuffixTap = false,

    /// can add list of inputFormatters to control the input
    this.inputFormatters,
    this.cursorColor,
    this.onToggleChanged,
    this.onChanged,
    this.isOpening = false,
  }) : super(key: key);

  @override
  _AnimSearchBarState createState() => _AnimSearchBarState();
}

class _AnimSearchBarState extends State<AnimSearchBar>
    with SingleTickerProviderStateMixin {
  ///initializing the AnimationController
  late AnimationController _con;
  FocusNode focusNode = FocusNode();

  ///toggle - 0 => false or closed
  ///toggle 1 => true or open
  // int toggle = 0;

  @override
  void initState() {
    super.initState();

    ///Initializing the animationController which is responsible for the expanding and shrinking of the search bar
    _con = AnimationController(
      vsync: this,

      /// animationDurationInMilli is optional, the default value is 375
      duration: Duration(milliseconds: widget.animationDurationInMilli),
    );
  }

  void unFocusKeyboard() {
    final FocusScopeNode currentScope = FocusScope.of(context);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    const horizontalPaddings = 4.0;
    return Container(
      height: 100.0,

      padding: const EdgeInsets.symmetric(
        horizontal: horizontalPaddings,
      ),

      ///if the rtl is true, search bar will be from right to left
      alignment: widget.rtl
          ? Alignment.centerRight
          : Alignment.centerLeft, //const Alignment(-1.0, 0.0),

      ///Using Animated container to expand and shrink the widget
      child: AnimatedContainer(
        duration: Duration(milliseconds: widget.animationDurationInMilli),
        height: 40.0,
        width: !widget.isOpening ? 48.0 : widget.width - (horizontalPaddings * 2),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          /// can add custom color or the color will be white
          color: widget.color,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: -10.0,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Stack(
          children: [
            ///Using Animated Positioned widget to expand and shrink the widget
            AnimatedPositioned(
              duration: Duration(milliseconds: widget.animationDurationInMilli),
              // top: 6.0,
              right: widget.rtl ? null : 7.0,
              left: widget.rtl ? 7.0 : null,
              curve: Curves.easeOut,
              child: AnimatedOpacity(
                opacity: !widget.isOpening ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    /// can add custom color or the color will be white
                    color: widget.color,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: AnimatedBuilder(
                    builder: (context, widget) {
                      ///Using Transform.rotate to rotate the suffix icon when it gets expanded
                      return Transform.rotate(
                        angle: _con.value * 2.0 * pi,
                        child: widget,
                      );
                    },
                    animation: _con,
                    child: GestureDetector(
                      onTap: () {
                        try {
                          ///trying to execute the onSuffixTap function
                          widget.onSuffixTap();

                          ///closeSearchOnSuffixTap will execute if it's true
                          if (widget.closeSearchOnSuffixTap) {
                            unFocusKeyboard();

                            onIconsClicked();
                            // changeToggleValue(0);

                            // setState(() {
                            //   toggle = 0;
                            // });
                          }
                        } catch (e) {
                          ///print the error if the try block fails
                          if (kDebugMode) {
                            print(e);
                          }
                        }
                      },

                      ///suffixIcon is of type Icon
                      child: widget.suffixIcon ??
                          const Icon(
                            Icons.close,
                            // size: 20.0,
                          ),
                    ),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: widget.animationDurationInMilli),
              left: widget.rtl
                  ? null
                  : !widget.isOpening
                      ? 20.0
                      : 40.0,
              right: widget.rtl
                  ? !widget.isOpening
                      ? 20.0
                      : 40.0
                  : null,

              curve: Curves.easeOut,
              top: 11.0,

              ///Using Animated opacity to change the opacity of th textField while expanding
              child: AnimatedOpacity(
                opacity: !widget.isOpening ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.topCenter,
                  width: widget.width / 1.7,
                  child: TextField(
                    ///Text Controller. you can manipulate the text inside this textField by calling this controller.
                    controller: widget.textController,
                    inputFormatters: widget.inputFormatters,
                    focusNode: focusNode,
                    cursorRadius: const Radius.circular(10.0),
                    onEditingComplete: () {
                      unFocusKeyboard();
                      changeToggleValue(0);
                    },
                    onChanged: (text) => widget.onChanged?.call(text),

                    ///style is of type TextStyle, the default is just a color black
                    style: widget.style ?? const TextStyle(color: Colors.black),
                    cursorColor: widget.cursorColor ?? Colors.white,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(bottom: -5),
                      // contentPadding: EdgeInsets.zero,
                      isDense: true,

                      hintText: widget.hintText,
                      hintStyle: widget.hintStyle,

                      // floatingLabelBehavior: FloatingLabelBehavior.never,
                      // labelText: widget.helpText,
                      // labelStyle: widget.labelStyle ??
                      //     const TextStyle(
                      //       color: Colors.white, //Color(0xff5B5B5B),
                      //       fontSize: 17.0,
                      //       fontWeight: FontWeight.w500,
                      //     ),
                      // alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            ///Using material widget here to get the ripple effect on the prefix icon
            Material(
              /// can add custom color or the color will be white
              color: widget.color,
              borderRadius: BorderRadius.circular(30.0),
              child: !widget.isOpening
                  ? IconButton(
                      icon: const Icon(
                        Icons.search,
                      ),
                      onPressed: onIconsClicked,
                    )
                  : IconButton(
                      splashRadius: 19.0,
                      icon: Icon(
                        Icons.search,
                        color: Colors.white.withAlpha(125),
                      ),
                      onPressed: null,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void onIconsClicked() {
    setState(
      () {
        ///if the search bar is closed
        if (!widget.isOpening) {
          changeToggleValue(1);
          // toggle = 1;

          setState(() {
            ///if the autoFocus is true, the keyboard will pop open, automatically
            if (widget.autoFocus) {
              FocusScope.of(context).requestFocus(focusNode);
            }
          });

          ///forward == expand
          _con.forward();
        } else {
          ///if the search bar is expanded
          changeToggleValue(0);

          ///if the autoFocus is true, the keyboard will close, automatically
          setState(() {
            if (widget.autoFocus) unFocusKeyboard();
          });

          ///reverse == close
          _con.reverse();
        }
      },
    );
  }

  void changeToggleValue(int value) {
    widget.onToggleChanged?.call(value == 1);
  }
}
