import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:now_pills/constants.dart';
import 'package:now_pills/exceptions/schedule_exception.dart';
import 'package:now_pills/services/notification_service.dart';
import 'package:timezone/timezone.dart';

class NotificationCreationController extends ChangeNotifier {
  int _selectedDuration = 0;
  int get selectedDuration => _selectedDuration;

  set selectedDuration(int value) {
    _selectedDuration = value;
    Logger().i("Selected duration: $selectedDuration");
    notifyListeners();
  }

  int _selectedReccu = 0;
  int get selectedReccu => _selectedReccu;

  List<int> _selectedHours = [];
  List<int> get selectedHours => _selectedHours;

  set selectedReccu(int value) {
    _selectedReccu = value;
    notifyListeners();
  }

  void addHours(int value){
    _selectedHours.add(value);
    notifyListeners();
  }

  void removeHours(int value){
    selectedHours.remove(value);
    notifyListeners();
  }

  set selectedHours(List<int> value) {
    _selectedHours = value;
    notifyListeners();
  }

  Future<void> configureNotification(String pillName) async {
    final now = DateTime.now();
    for(int i = 0 ; i <= selectedDuration+2 ; i++){
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
            id: i,
          ).then((_) => Logger().i("Notification scheduled for: ${DateTime.fromMillisecondsSinceEpoch(scheduleDate.millisecondsSinceEpoch)}"));

        } else {
          if(selectedReccu == 1 && selectedDuration == 1){
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