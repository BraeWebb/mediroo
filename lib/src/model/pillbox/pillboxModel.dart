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

class PillboxModel {
  List<List<PillboxCell>> _array;
  int _width;
  int _height;

  PillboxModel(int width, int height) {
    _width = width;
    _height = 0;
    _array = new List();
    for(int i = 0; i < height; i++) {
      addRow();
    }
  }

  int getWidth() {
    return _width;
  }

  int getHeight() {
    return _height;
  }

  void addRow() {
    _height += 1;
    List<PillboxCell> row = new List(_width);
    for(int j = 0; j < _width; j++) {
      row[j] = new PillboxCell(PillType.NULL);
    }
    _array.add(row);
  }

  PillboxCell get(int row, int col) {
    return _array[row][col];
  }

  PillboxCell getByIndex(int index) {
    int row = index ~/ _width;
    int col = index % _width;
    return get(row, col);
  }

}