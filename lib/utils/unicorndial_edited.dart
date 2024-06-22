import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class UnicornOrientation {
  static const HORIZONTAL = 0;
  static const VERTICAL = 1;
}

class UnicornButton extends StatelessWidget {
  final FloatingActionButton currentButton;
  final String labelText;
  final double labelFontSize;
  final Color labelColor;
  final Color? labelBackgroundColor;
  final Color? labelShadowColor;
  final bool labelHasShadow;
  final bool hasLabel;

  UnicornButton({
    required this.currentButton,
    required this.labelText,
    this.labelFontSize = 14.0,
    required this.labelColor,
    this.labelBackgroundColor,
    this.labelShadowColor,
    this.labelHasShadow = true,
    this.hasLabel = false,
  });

  Widget returnLabel() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: labelHasShadow
            ? [
          BoxShadow(
            color: labelShadowColor!,
            blurRadius: 3.0,
          ),
        ]
            : null,
        color: labelBackgroundColor,
        borderRadius: BorderRadius.circular(3.0),
      ),
      padding: EdgeInsets.all(9.0),
      child: Text(
        labelText,
        style: TextStyle(
          fontSize: labelFontSize,
          fontWeight: FontWeight.bold,
          color: labelColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return currentButton;
  }
}

class UnicornDialer extends StatefulWidget {
  final int orientation;
  final Widget parentButton;
  final Widget finalButtonIcon;
  final bool hasBackground;
  final Color parentButtonBackground;
  final List<UnicornButton> childButtons;
  final int animationDuration;
  final int mainAnimationDuration;
  final double childPadding;
  final Color backgroundColor;
  final VoidCallback onMainButtonPressed;
  final Object parentHeroTag;
  final bool hasNotch;

  UnicornDialer({
    required this.parentButton,
    required this.parentButtonBackground,
    required this.childButtons,
    required this.onMainButtonPressed,
    this.orientation = UnicornOrientation.VERTICAL,
    this.hasBackground = true,
    this.backgroundColor = Colors.white30,
    this.parentHeroTag = "parent",
    required this.finalButtonIcon,
    this.animationDuration = 180,
    this.mainAnimationDuration = 200,
    this.childPadding = 4.0,
    this.hasNotch = false,
  });

  @override
  _UnicornDialer createState() => _UnicornDialer();
}

class _UnicornDialer extends State<UnicornDialer> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _parentController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.animationDuration),
    );

    _parentController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.mainAnimationDuration),
    );

    _animationController.reverse();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _parentController.dispose();
    super.dispose();
  }

  void mainActionButtonOnPressed() {
    if (_animationController.isDismissed) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    widget.onMainButtonPressed();
  }

  @override
  Widget build(BuildContext context) {
    var hasChildButtons = widget.childButtons.isNotEmpty;

    var mainFAB = AnimatedBuilder(
      animation: _parentController,
      builder: (BuildContext context, Widget? child) {
        return Transform(
          transform: Matrix4.diagonal3(vector.Vector3(
            _parentController.value,
            _parentController.value,
            _parentController.value,
          )),
          alignment: FractionalOffset.center,
          child: FloatingActionButton(
            heroTag: widget.parentHeroTag,
            backgroundColor: widget.parentButtonBackground,
            onPressed: mainActionButtonOnPressed,
            child: !hasChildButtons
                ? widget.parentButton
                : AnimatedBuilder(
              animation: _animationController,
              builder: (BuildContext context, Widget? child) {
                return Transform(
                  transform: Matrix4.rotationZ(_animationController.value * 0.8),
                  alignment: FractionalOffset.center,
                  child: _animationController.isDismissed
                      ? widget.parentButton
                      : widget.finalButtonIcon,
                );
              },
            ),
          ),
        );
      },
    );

    if (hasChildButtons) {
      var mainFloatingButton = AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget? child) {
          return Transform.rotate(
            angle: _animationController.value * 0.8,
            child: mainFAB,
          );
        },
      );

      var childButtonsList = List.generate(widget.childButtons.length, (index) {
        var intervalValue = index == 0
            ? 0.9
            : ((widget.childButtons.length - index) / widget.childButtons.length) - 0.2;

        intervalValue = intervalValue < 0.0 ? (1 / index) * 0.5 : intervalValue;

        var childFAB = FloatingActionButton(
          onPressed: widget.childButtons[index].currentButton.onPressed,
          child: widget.childButtons[index].currentButton.child,
          heroTag: widget.childButtons[index].currentButton.heroTag,
          backgroundColor: widget.childButtons[index].currentButton.backgroundColor,
          mini: widget.childButtons[index].currentButton.mini,
          tooltip: widget.childButtons[index].currentButton.tooltip,
          key: widget.childButtons[index].currentButton.key,
          elevation: widget.childButtons[index].currentButton.elevation,
          foregroundColor: widget.childButtons[index].currentButton.foregroundColor,
          highlightElevation: widget.childButtons[index].currentButton.highlightElevation,
          isExtended: widget.childButtons[index].currentButton.isExtended,
          shape: widget.childButtons[index].currentButton.shape,
        );

        return Positioned(
          right: widget.orientation == UnicornOrientation.VERTICAL
              ? (widget.childButtons[index].currentButton.mini ? 4.0 : 0.0)
              : ((widget.childButtons.length - index) * 55.0) + 15,
          bottom: widget.orientation == UnicornOrientation.VERTICAL
              ? ((widget.childButtons.length - index) * 55.0) + 15
              : 8.0,
          child: Row(
            children: [
              ScaleTransition(
                scale: CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(intervalValue, 1.0, curve: Curves.linear),
                ),
                alignment: FractionalOffset.center,
                child: (!widget.childButtons[index].hasLabel) ||
                    widget.orientation == UnicornOrientation.HORIZONTAL
                    ? Container()
                    : Container(
                  padding: EdgeInsets.only(right: widget.childPadding),
                  child: widget.childButtons[index].returnLabel(),
                ),
              ),
              ScaleTransition(
                scale: CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(intervalValue, 1.0, curve: Curves.linear),
                ),
                alignment: FractionalOffset.center,
                child: childFAB,
              ),
            ],
          ),
        );
      });

      var unicornDialWidget = Container(
        margin: widget.hasNotch ? EdgeInsets.only(bottom: 15.0) : null,
        height: double.infinity,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: childButtonsList
            ..add(
              Positioned(
                right: null,
                bottom: null,
                child: mainFloatingButton,
              ),
            ),
        ),
      );

      var modal = ScaleTransition(
        scale: CurvedAnimation(
          parent: _animationController,
          curve: Interval(1.0, 1.0, curve: Curves.linear),
        ),
        alignment: FractionalOffset.center,
        child: GestureDetector(
          onTap: mainActionButtonOnPressed,
          child: Container(
            color: widget.backgroundColor,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
        ),
      );

      return widget.hasBackground
          ? Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned(right: -16.0, bottom: -16.0, child: modal),
          unicornDialWidget,
        ],
      )
          : unicornDialWidget;
    }

    return mainFAB;
  }
}
