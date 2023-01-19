import 'package:flutter/material.dart';
import 'package:now_pills/constants.dart';
import 'package:now_pills/controllers/notification_creation_controller.dart';
import 'package:provider/provider.dart';

class DurationDialog extends StatefulWidget {
  const DurationDialog({Key? key}) : super(key: key);

  @override
  State<DurationDialog> createState() => _DurationDialogState();
}

class _DurationDialogState extends State<DurationDialog> {
  late NotificationCreationController _nController;
  late String _tempSelectedDuration;

  @override
  Widget build(BuildContext context) {
    _nController = Provider.of<NotificationCreationController>(context);
    _tempSelectedDuration = _nController.selectedDuration;

    return AlertDialog(
      title: const Text("Choisissez la durée du traitement (dont aujourd'hui)"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Annuler"),
        ),
        TextButton(
          onPressed: () {
            _nController.selectedDuration = _tempSelectedDuration;
            Navigator.of(context).pop();
          },
          child: const Text("Confirmer"),
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              items: possibleDuration
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _tempSelectedDuration = value);
                }
              },
              value: _tempSelectedDuration,
            ),
          ),
        ],
      ),
    );
  }
}
