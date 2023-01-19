import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:now_pills/constants.dart';
import 'package:now_pills/controllers/notification_creation_controller.dart';
import 'package:provider/provider.dart';

class MultiSelectionTile extends StatefulWidget {
  final String tileText;
  final int value;

  const MultiSelectionTile({
    Key? key,
    required this.tileText,
    required this.value,
  }) : super(key: key);

  @override
  State<MultiSelectionTile> createState() => _MultiSelectionTileState();
}

class _MultiSelectionTileState extends State<MultiSelectionTile> {
  late NotificationCreationController _notificationCreationController;
  late bool isChecked;

  @override
  void initState() {
    _notificationCreationController = Provider.of<NotificationCreationController>(context, listen: false);
    isChecked = _notificationCreationController.selectedHours.contains(widget.value);
    super.initState();
  }

  void setCheck(){
    setState((){
      if(isChecked){
        isChecked = false;
        _notificationCreationController.removeHours(widget.value);
      } else {
        if(_notificationCreationController.selectedHours.length < _notificationCreationController.selectedReccu+1){
          isChecked = true;
          _notificationCreationController.addHours(widget.value);
        } else {
          Logger().e("Can't select more than ${_notificationCreationController.selectedHours.length} hours");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: setCheck,
      child: Row(
        children: [
          Checkbox(
            value: isChecked,
            onChanged: (_) => setCheck(),
            activeColor: mainColor,
          ),
          Text(widget.tileText),
        ],
      ),
    );
  }
}
