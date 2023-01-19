import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:now_pills/constants.dart';
import 'package:now_pills/exceptions/schedule_exception.dart';
import 'package:now_pills/services/notification_service.dart';
import 'package:timezone/timezone.dart';

class NotificationCreationController extends ChangeNotifier {
  int _notificationCounter = 0;
  int get notificationCounter => _notificationCounter;

  String _selectedDuration = possibleDuration.first;
  String get selectedDuration => _selectedDuration;
  set selectedDuration(String value) {
    _selectedDuration = value;
    Logger().i("Selected duration: $selectedDuration");
    notifyListeners();
  }

  int _selectedReccu = 0;
  int get selectedReccu => _selectedReccu;

  final _selectedHours = <int>[];
  List<int> get selectedHours => _selectedHours;

  set selectedReccu(int value) {
    _selectedReccu = value;
    notifyListeners();
  }

  int increaseCounter(){
    _notificationCounter++;
    notifyListeners();
    Logger().i("New counter: $notificationCounter");
    return notificationCounter;
  }

  void addHours(int value){
    _selectedHours.add(value);
    notifyListeners();
  }

  void removeHours(int value){
    selectedHours.remove(value);
    notifyListeners();
  }

  Future<void> configureNotification(String pillName, NotificationCreationController nController) async {
    final now = DateTime.now();
    final duration = int.parse(selectedDuration[0]);

    Logger().w("Selected hours size: ${selectedHours.length}");

    for(int i = 0 ; i < duration ; i++){
      for (final hourIndex in selectedHours) {
        final splitHour = possibleHours.elementAt(hourIndex).split("h");
        final scheduleDate = TZDateTime(local, now.year, now.month, now.day, int.parse(splitHour.first), int.parse(splitHour.last));

        if(scheduleDate.millisecondsSinceEpoch > now.millisecondsSinceEpoch){
          NotificationService().addNotification(
            title: "NowPills",
            body: "C'est l'heure de votre pillule $pillName",
            endTime: scheduleDate,
            sound: 'pills_notif.mp3', //Add this
            channel: "live",
            id: nController.increaseCounter(),
          );
        } else {
          if(selectedReccu == 1 && int.parse(selectedDuration[0]) == 1){
            Logger().e("Can't schedule dat anterior date");
            throw ScheduleException("Can't schedule at anterior date");
          }
        }
      }
    }
    resetInput();
  }

  void resetInput() {
    selectedHours.clear();
    selectedReccu = 0;
    notifyListeners();
  }
}