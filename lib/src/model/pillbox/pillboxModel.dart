import 'package:quiver/core.dart';

enum PillType {
  STD, // standard pill icon
  NULL, // empty pill icon
  TAKEN, // tick icon
  MISSED // cross icon
}

enum ToD {
  MORNING,
  MIDDAY,
  EVENING,
  NIGHT
}

class Time {
  ToD tod;
  DateTime date; // NOTE: time is ignored

  Time(this.date, this.tod);

  bool operator ==(o) => o is Time && this.tod == o.tod && this.date.year == o.date.year
      && this.date.month == o.date.month && this.date.day == o.date.day;

  int get hashCode => hash4(tod, date.year, date.month, date.day);
}

class Pill {
  String _desc;
  int _pillCount;
  Map<Time, PillType> _calendar;

  Pill(this._desc, this._calendar);

  void setType(Time time, PillType type) {
    _calendar[time] = type;
  }

  PillType getType(Time time) {
    return _calendar[time];
  }

  String getDesc() {
    return _desc;
  }

  void pushToDb() {
    //to be implemented
  }

  void pullFromDb() {
    //to be implemented
  }
}
