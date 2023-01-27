import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:now_pills/constants.dart';
import 'package:now_pills/controllers/notification_creation_controller.dart';
import 'package:now_pills/exceptions/custom_exception.dart';
import 'package:now_pills/widgets/app_title.dart';
import 'package:now_pills/widgets/custom_dialog.dart';
import 'package:now_pills/widgets/duration_dialog.dart';
import 'package:now_pills/widgets/input_field.dart';
import 'package:now_pills/widgets/multiselection_tile.dart';
import 'package:provider/provider.dart';

class WelcomingPage extends StatefulWidget {
  const WelcomingPage({Key? key}) : super(key: key);

  @override
  State<WelcomingPage> createState() => _WelcomingPageState();
}

class _WelcomingPageState extends State<WelcomingPage> with SingleTickerProviderStateMixin {
  final _pillNameInputController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isEmptyFormFieldClicked = false;
  final _focusNode = FocusNode();
  late NotificationCreationController _nController;
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void dispose() {
    _animationController.stop();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1, milliseconds: 500));
    _animation = Tween<double>(begin: 0, end: -25).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticInOut),
    );

    _animation.addListener(() {
      if (_animation.isCompleted) {
        Future.delayed(
          const Duration(seconds: 1),
          () {
            _animationController.reverse();
          },
        );
      } else if (_animation.isDismissed) {
        Future.delayed(
          const Duration(seconds: 15),
          () {
            _animationController.forward();
          },
        );
      }
    });

    Future.delayed(
      const Duration(seconds: 10),
      () => _animationController.forward(),
    );
  }

  @override
  Widget build(BuildContext context) {
    _nController = Provider.of<NotificationCreationController>(context);

    return GestureDetector(
      onTap: () => _resetFocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_animation.value, 0),
                    child: child,
                  );
                },
                child: Container(
                  color: mainColor,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AppTitle(top: MediaQuery.of(context).size.height / 5),
                      Baseline(
                        baselineType: TextBaseline.alphabetic,
                        baseline: MediaQuery.of(context).size.height / 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildInputBox(),
                            _buildCreateBtn(),
                            _buildDurationSelectionBtn(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCGUbtn() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed("/cgu"),
        child: const Text(
          "Conditions Générales d'Utilisation",
          style: standardTextStyle,
        ),
      ),
    );
  }

  Widget _buildCreateBtn() {
    return CustomBtn(
      title: "Je vais me rappeler, promis",
      onClick: () {
        if (_isEmptyFormFieldClicked) {
          if (_formKey.currentState != null && _formKey.currentState!.validate()) {
            try {
              _nController.configureNotification(_pillNameInputController.text, _nController);
              showDialog(
                context: context,
                builder: (_) => _buildSuccessDialog(),
              );
            } on CustomException catch (e) {
              showDialog(
                context: context,
                builder: (_) {
                  return CustomDialog(
                    title: "Ooops...",
                    body: e.message,
                    onTap: Navigator.of(context).pop,
                    actionBtnText: "Dommage",
                  );
                },
              );
            }
          }
        } else {
          showDialog(
            context: context,
            builder: (_) {
              return CustomDialog(
                title: "Il faut nous aider...",
                body: "Sélectionnez la boîte de texte et remplissez les champs",
                onTap: Navigator.of(context).pop,
                actionBtnText: "Bon...ok",
              );
            },
          );
        }
      },
    );
  }

  AlertDialog _buildSuccessDialog() {
    return AlertDialog(
      title: const Text("On a hâte !"),
      content: int.parse(_nController.selectedDuration[0]) > 1 ||
              _nController.selectedRecurrence > 1 ||
              _nController.selectedHours.length > 1
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

  Widget _buildDurationSelectionBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: InkWell(
        onTap: () => _buildDurationSelectionDialog(context),
        child: Column(
          children: [
            const Text(
              "Changer la durée du traitement",
              style: standardTextStyle,
            ),
            const SizedBox(height: 3),
            Text(
              "(Actuellement ${_nController.selectedDuration})",
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
      builder: (_) => const DurationDialog(),
    );
  }

  void _resetFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _isEmptyFormFieldClicked = false);
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
            onTap: () => _buildHoursSelectionDialog(possibleHours),
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

  Widget _buildPillsNameField() {
    return Form(
      key: _formKey,
      child: TextFormField(
        focusNode: _focusNode,
        validator: (value) {
          if (value == null || value.isEmpty || value == "") {
            return "Champs obligatoire (nom pillule)";
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

  Widget _buildDropdownRecurrence() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        icon: const SizedBox.shrink(),
        value: possibleRecurrences.elementAt(_nController.selectedRecurrence),
        onChanged: (value) {
          if (value != null) {
            if (possibleRecurrences.indexOf(value) < _nController.selectedRecurrence) {
              _nController.selectedHours.clear();
            }
            _nController.selectedRecurrence = possibleRecurrences.indexOf(value);
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
    if (_nController.selectedHours.length < _nController.selectedRecurrence + 1 &&
        _nController.selectedHours.isNotEmpty) {
      return "⏳";
    } else if (_nController.selectedHours.length == _nController.selectedRecurrence + 1) {
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
                    "Selectionnez ${_nController.selectedRecurrence + 1} ${_nController.selectedRecurrence > 1 ? "heures" : "heure"} de rappel",
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
                            decoration: BoxDecoration(
                              border: Border.all(color: mainColor),
                            ),
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
                            decoration: BoxDecoration(
                              border: Border.all(color: mainColor),
                              color: mainColor,
                            ),
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
