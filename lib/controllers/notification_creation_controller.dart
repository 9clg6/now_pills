import 'package:flutter/material.dart';
import 'package:now_pills/constants.dart';
import 'package:now_pills/exceptions/empty_selected_hours_exception.dart';
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
    notifyListeners();
  }

  int _selectedRecurrence = 0;
  int get selectedRecurrence => _selectedRecurrence;
  set selectedRecurrence(int value) {
    _selectedRecurrence = value;
    notifyListeners();
  }

  final _selectedHours = <int>[];
  List<int> get selectedHours => _selectedHours;

  int increaseCounter() {
    _notificationCounter++;
    notifyListeners();
    return notificationCounter;
  }

  void addHours(int value) {
    _selectedHours.add(value);
    notifyListeners();
  }

  void removeHours(int value) {
    selectedHours.remove(value);
    notifyListeners();
  }

  void configureNotification(String pillName, NotificationCreationController nController) {
    final now = DateTime.now();
    final duration = int.parse(selectedDuration[0]);

    if (nController.selectedHours.isEmpty) {
      throw EmptySelectedHoursException(
        "Empty selected hour list",
        "Au moins une heure de prise doit être sélectionné",
      );
    }

    for (int i = 0; i < duration; i++) {
      for (final hourIndex in selectedHours) {
        final splitHour = possibleHours.elementAt(hourIndex).split("h");
        final scheduleDate =
            TZDateTime(local, now.year, now.month, now.day, int.parse(splitHour.first), int.parse(splitHour.last));

        if (scheduleDate.millisecondsSinceEpoch > now.millisecondsSinceEpoch) {
          NotificationService().addNotification(
            title: "NowPills",
            body: "C'est l'heure de votre pillule $pillName",
            endTime: scheduleDate,
            sound: 'pills_notif.mp3', //Add this
            channel: "live",
            id: nController.increaseCounter(),
          );
        } else {
          if (selectedRecurrence == 0 && int.parse(selectedDuration[0]) == 1) {
            throw ScheduleException(
              "Can't schedule at anterior date",
              "Vous ne pouvez pas programmer un rappel à une date antérieure",
            );
          }
        }
      }
    }
    resetInput();
  }

  void resetInput() {
    selectedHours.clear();
    selectedRecurrence = 0;
    selectedDuration = possibleDuration.first;
    notifyListeners();
  }
}
