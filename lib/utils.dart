/// ********************************************************************************************************************
/// A few global utility-type things needed by multiple places in the codebase.
/// ********************************************************************************************************************

import "dart:io";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "BaseModel.dart";

/// The application's document directory for contact avatar image files and database files.
Directory docsDir;

/// Function for getting a selected date from the user.
///
/// form of inDateString: (ex) "2020,11,25"
///
/// @param  inContext The BuildContext of the parent Widget.
/// @return           Future. (ex) "2020,11,25"
Future selectDate(
    BuildContext inContext, BaseModel inModel, String inDateString) async {
  DateTime initialDate = DateTime.now();

  if (inDateString != null) {
    List dateParts = inDateString.split(',');
    initialDate = DateTime(int.parse(dateParts[0]), int.parse(dateParts[1]),
        int.parse(dateParts[2]));
  }

  DateTime picked = await showDatePicker(
    context: inContext,
    initialDate: initialDate,
    firstDate: DateTime(1900),
    lastDate: DateTime(2100),
  );

  if (picked!= null){
    inModel.setChosenDate(DateFormat.yMMMMd("en_US").format(picked.toLocal()));
    return "${picked.year},${picked.month},${picked.day}";
  }
}
//
// Future selectTime(
//     BuildContext inContext, AppointmentsModel inModel, String inTimeString) async {
//   TimeOfDay initialTime = TimeOfDay.now();
//
//   if (inTimeString != null) {
//     List timeParts = inTimeString.split(',');
//     initialTime = TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
//   }
//
//   TimeOfDay picked = await showTimePicker(
//     context: inContext,
//     initialTime: initialTime,
//   );
//
//   if (picked!= null){
//     inModel.setApptTime(picked.format(inContext));
//     return "${picked.hour},${picked.minute}";
//   }
// }


