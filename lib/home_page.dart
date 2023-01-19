import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:now_pills/constants.dart';
import 'package:now_pills/controllers/notification_creation_controller.dart';
import 'package:now_pills/widgets/duration_dialog.dart';
import 'package:now_pills/widgets/input_field.dart';
import 'package:now_pills/widgets/multiselection_tile.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pillNameInputController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isEmptyFormFieldClicked = false;
  final _focusNode = FocusNode();

  late NotificationCreationController _nController;

  @override
  Widget build(BuildContext context) {
    _nController = Provider.of<NotificationCreationController>(context);

    return GestureDetector(
      onTap: () => _resetFocus(),
      child: Scaffold(
        backgroundColor: mainColor,
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Stack(
            alignment: Alignment.center,
            children: [
              _buildTitle(context),
              Baseline(
                baselineType: TextBaseline.alphabetic,
                baseline: MediaQuery.of(context).size.height / 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildInputBox(),
                    CustomBtn(
                      title: "Je vais me rappeler, promis",
                      onClick: () {
                        if (_formKey.currentState != null) {
                          if (_formKey.currentState!.validate() && _nController.selectedHours.isNotEmpty) {
                            try {
                              _nController.configureNotification(_pillNameInputController.text);
                              /*
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return _buildSuccessDialog();
                                },
                              );
                               */
                            } catch (e) {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return _buildErrorDialog(context);
                                },
                              );
                            }
                          }
                        }
                      },
                    ),
                    _buildDurationSelectionBtn(context),
                  ],
                ),
              ),
              _buildCGU(),
            ],
          ),
        ),
      ),
    );
  }

  AlertDialog _buildSuccessDialog() {
    return AlertDialog(
      title: const Text("On a hâte !"),
      content:
          _nController.selectedDuration > 1 || _nController.selectedReccu > 1 || _nController.selectedHours.length > 1
              ? const Text("Vos alertes ont été créees avec succès ! 💊")
              : const Text("Votre alerte a été créee avec succès ! 💊"),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text(
            "Super !",
            style: TextStyle(color: mainColor),
          ),
        )
      ],
    );
  }

  Widget _buildDurationSelectionBtn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: InkWell(
        onTap: () {
          _buildDurationSelectionDialog(context);
        },
        child: Column(
          children: [
            const Text(
              "Changer la durée du traitement",
              style: standardTextStyle,
            ),
            const SizedBox(height: 3),
            Text(
              "(Actuellement ${possibleDuration.elementAt(_nController.selectedDuration)})",
              style: standardTextStyle,
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> _buildDurationSelectionDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (dialogContext) {
        return const DurationDialog();
      },
    );
  }

  Align _buildCGU() {
    return const Align(
      alignment: Alignment.bottomCenter,
      child: Text(
        "Conditions Générales d'Utilisation",
        style: standardTextStyle,
      ),
    );
  }

  AlertDialog _buildErrorDialog(BuildContext context) {
    return AlertDialog(
      title: const Text("Il fallait y penser avant..."),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text("Vous ne pouvez pas programmer un rappel à une date antérieur à l'heure actuelle."),
          SizedBox(height: 15),
          Text("Ou changez la durée de prise en cliquant sur ”Modifier la durée de prise”")
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Dommage", style: TextStyle(color: mainColor)),
        ),
      ],
    );
  }

  void _resetFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _isEmptyFormFieldClicked = false;
    });
  }

  Positioned _buildTitle(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height / 5,
      child: Container(
        alignment: Alignment.center,
        child: Text(
          "NowPills",
          style: TextStyle(
            color: Colors.white,
            fontSize: 60,
            fontWeight: FontWeight.bold,
            shadows: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                offset: const Offset(-3, 4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFakeForm() {
    return InkWell(
      onTap: () {
        setState(() => _isEmptyFormFieldClicked = !_isEmptyFormFieldClicked);
        _focusNode.requestFocus();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Text(
          "Quelle pillule dois-je me rappeler?",
          style: TextStyle(
            color: Colors.black.withOpacity(0.6),
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildInputForm() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildPillsNameField(),
        ),
        Expanded(
          flex: 2,
          child: _buildDropdownRecurrence(),
        ),
        Expanded(
          child: InkWell(
            onTap: () async {
              await _buildHoursSelectionDialog(possibleHours);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  buildDisplayText(),
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Form _buildPillsNameField() {
    return Form(
      key: _formKey,
      child: TextFormField(
        focusNode: _focusNode,
        validator: (value) {
          if (value == null || value.isEmpty || value == "") {
            return "Merci de rentrer le nom d'une pillule";
          }
          return null;
        },
        maxLength: 15,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        controller: _pillNameInputController,
        decoration: const InputDecoration(
          hintText: "Quelle pillule ?",
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
          counterText: "",
        ),
      ),
    );
  }

  DropdownButtonHideUnderline _buildDropdownRecurrence() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        icon: const SizedBox.shrink(),
        value: possibleRecurrences.elementAt(_nController.selectedReccu),
        onChanged: (value) {
          if (value != null) {
            if (possibleRecurrences.indexOf(value) < _nController.selectedReccu) {
              _nController.selectedHours.clear();
            }
            _nController.selectedReccu = possibleRecurrences.indexOf(value);
            Logger().i("Selected reccurence: ${possibleRecurrences.indexOf(value)}");
          }
        },
        items: possibleRecurrences
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
      ),
    );
  }

  String buildDisplayText() {
    if (_nController.selectedHours.length < _nController.selectedReccu + 1 && _nController.selectedHours.isNotEmpty) {
      return "⏳";
    } else if (_nController.selectedHours.length == _nController.selectedReccu + 1) {
      return "✅";
    }
    return "heures";
  }

  Future<dynamic> _buildHoursSelectionDialog(List<String> hours) {
    return showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "Selectionnez ${_nController.selectedReccu + 1} ${_nController.selectedReccu > 1 ? "heures" : "heure"} de rappel",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: hours.length,
                    itemBuilder: (context, index) {
                      return MultiSelectionTile(
                        tileText: hours.elementAt(index),
                        value: index,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(dialogContext, rootNavigator: true).pop();
                            _nController.selectedHours.clear();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(border: Border.all(color: mainColor)),
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: const Text("Annuler"),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: Navigator.of(dialogContext, rootNavigator: true).pop,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            color: mainColor,
                            alignment: Alignment.center,
                            child: const Text(
                              "Confirmer",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Padding _buildInputBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: _isEmptyFormFieldClicked ? _buildInputForm() : _buildFakeForm(),
      ),
    );
  }
}
