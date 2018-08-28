/// Model class for basic pillbox functionality

/// Represents the status of a Pill
enum PillType {
  STD, // standard pill icon
  NULL, // empty pill icon
  TAKEN, // tick icon
  MISSED // cross icon
}

/// The time of day a pill is due at
enum ToD {
  MORNING,
  MIDDAY,
  EVENING,
  NIGHT
}

/// A class containing useful time-based methods
///
/// This was aimed to be expanded however it might be best to merge this
///   with another class
class Time {

  /// Returns the time of day associated with a specific hour
  ///
  /// @param [hour] (int) : the hour to get the ToD from
  /// @return (ToD) : the time of day associated with the given hour
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
}

/// Represents a pill in a pillbox at a certain time
class Pill {
  Prescription master; // the prescription this pill is a part of
  DateTime time; // the time this pill needs to be taken
  ToD tod; // the ToD this pill needs to be taken (generated when initialized)
  PillType status; // the current taken status of the pill

  /// Constructor for a new Pill
  ///
  /// @param [time] (DateTime) : the date/time this pill needs to be taken at
  Pill(this.time) {
    this.status = PillType.STD;
    this.tod = Time.getToD(time.hour);
  }
}

/// Represents a prescription of multiple pills
class Prescription {
  Map<DateTime, Pill> pills; // a mapping of times to pill objects
  double frequency;  // how many days per pill
  String desc; // the name/description of the pill to be taken
  String notes; // notes about the prescription left by the GP

  /// Constructor for a new Prescription
  ///
  /// @param [desc] (String) : the name of the pill
  /// @optional @param [notes] (String) : GP notes
  /// @optional @param [pills] (List<Pill>) : the pills held by this prescription
  Prescription(this.desc, {this.notes, List<Pill> pills}) {
    this.pills = new Map();
    for(Pill p in pills) {
      this.pills.putIfAbsent(p.time, (() => p));
      p.master = this;
    }
  }

  /// Returns the pill stored at a specific date at the time of day
  ///
  /// @param [date] (DateTime) : the date the pill is taken at
  ///                             (NOTE: the time-based fields of this object are ignored)
  /// @param [tod] (ToD) : the time of day the pill is taken at
  /// @return (Pill) : the pill at the given date/time, null if there is none
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

  List<DateTime> getPills() {
    return new List.from(pills.keys);
  }

  bool operator ==(o) => o is Prescription && desc == o.desc;
  int get hashCode => desc.hashCode;
}
