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
  DateTime dt;

  Time(this.dt, this.tod);

  static ToD getToD(int hour) {
    if(0 <= hour && hour < 10) {
      return ToD.MORNING;
    } else if(10 <= hour && hour < 15) {
      return ToD.MIDDAY;
    } else if(15 <= hour && hour < 19) {
      return ToD.EVENING;
    } else {
      return ToD.NIGHT;
    }
  }

  void setToD() {
    tod = getToD(dt.hour);
  }

  bool operator ==(o) => o is Time && this.dt == o.dt;

  int get hashCode => dt.hashCode;
}

class Pill {
  Prescription master;
  DateTime time;
  ToD tod;
  PillType status;

  Pill(this.time) {
    this.status = PillType.STD;
    this.tod = Time.getToD(time.hour);
  }
}

class Prescription {
  Map<DateTime, Pill> pills;
  String desc;
  String notes;

  Prescription(this.desc, {this.notes, List<Pill> pills}) {
    this.pills = new Map();
    for(Pill p in pills) {
      this.pills.putIfAbsent(p.time, (() => p));
      p.master = this;
    }
  }

  Pill getPill(DateTime date, ToD tod) {
    print(tod);
    print(pills);
    for(DateTime t in pills.keys) {
      if(Time.getToD(t.hour) == tod && date.year == t.year &&
          date.month == t.month && date.day == t.day) {
        return pills[t];
      }
    }
    return null;
  }
}
