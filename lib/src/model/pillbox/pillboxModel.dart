enum PillType {
  STD, // standard pill icon
  NULL, // empty pill icon
  TAKEN, // tick icon
  MISSED // cross icon
}

class PillboxCell {
  PillType _type;

  PillboxCell(PillType type) {
    this._type = type;
  }

  PillType getType() {
    return _type;
  }

  void setType(PillType type) {
    _type = type;
  }
}

class PillboxRow {
  String _desc;
  List<PillboxCell> _cells;

  PillboxRow(int width, String desc) {
    _desc = desc;
    _cells = new List();
    for(int i = 0; i < width; i++) {
      _cells.add(new PillboxCell(PillType.NULL));
    }
  }

  String getDesc() {
    return _desc;
  }

  PillboxCell get(int index) {
    return _cells[index];
  }
}

class PillboxModel {
  List<PillboxRow> _array;
  int _width;
  int _height;

  PillboxModel(int width) {
    _width = width;
    _height = 0;
    _array = new List();
  }

  int getWidth() {
    return _width;
  }

  int getHeight() {
    return _height;
  }

  void addRow(String desc) {
    _height += 1;
    _array.add(new PillboxRow(_width, desc));
  }

  PillboxCell get(int row, int col) {
    return _array[row].get(col);
  }

  PillboxRow getRow(int row) {
    return _array[row];
  }

  PillboxCell getByIndex(int index) {
    int row = index ~/ _width;
    int col = index % _width;
    return get(row, col);
  }

}