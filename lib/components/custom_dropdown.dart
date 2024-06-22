import 'package:flutter/material.dart';
import 'package:untitled1/utils/contstants.dart';

class CustomDropdown extends StatefulWidget {
  final String initialText;
  final int type;
  final List<dynamic> list;

  CustomDropdown({Key? key, required this.initialText, required this.list, required this.type, required String text, required Null Function(dynamic value) onChanged}) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  late GlobalKey actionKey;
  OverlayEntry? floatingDropdown;
  String selectedText = "";

  void findDropDownData() {
    RenderBox? renderBox = actionKey.currentContext?.findRenderObject() as RenderBox?;
    double height = renderBox?.size.height ?? 0.0;
    double width = renderBox?.size.width ?? 0.0;
    Offset offset = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;

    double screenHeight = MediaQuery.of(context).size.height;
    double dropdownHeight = offset.dy + height * 4 + 40 < screenHeight
        ? height * 4 + 40
        : screenHeight - offset.dy - 70.0;

    floatingDropdown = _createFloatingDropdown(offset.dx, offset.dy + height, width, dropdownHeight);
  }

  OverlayEntry _createFloatingDropdown(double xPosition, double yPosition, double width, double height) {
    return OverlayEntry(builder: (context) {
      return Positioned(
        left: xPosition,
        width: width,
        top: yPosition,
        height: height,
        child: Card(
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          margin: EdgeInsets.only(left: 24.0, right: 24.0, top: 8.0),
          child: Scrollbar(
            child: ListView.separated(
              padding: EdgeInsets.all(0.0),
              separatorBuilder: (BuildContext context, int index) => Divider(
                thickness: 2,
                height: 5,
                color: Constants.DARK_SKYBLUE,
              ),
              itemBuilder: (context, index) {
                bool isSelected = selectedText == widget.list[index].toString();
                return Material(
                  color: isSelected ? Constants.SKYBLUE : Colors.white,
                  child: ListTile(
                    title: Text(
                      widget.list[index].toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      setState(() {
                        selectedText = widget.list[index].toString();
                        floatingDropdown?.remove();
                        floatingDropdown = null; // Close dropdown
                      });
                    },
                  ),
                );
              },
              itemCount: widget.list.length,
            ),
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    actionKey = GlobalKey();
    selectedText = widget.initialText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: GestureDetector(
        key: actionKey,
        onTap: () {
          if (floatingDropdown == null) {
            findDropDownData();
            Overlay.of(context)?.insert(floatingDropdown!);
          } else {
            floatingDropdown?.remove();
            floatingDropdown = null; // Close dropdown
          }
        },
        child: Container(
          height: 50.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              colors: [Constants.DARK_SKYBLUE, Constants.SKYBLUE],
              stops: [0.0, 0.9],
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 8),
          child: Row(
            children: [
              Text(
                selectedText,
                style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Icon(
                Icons.expand_more,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
