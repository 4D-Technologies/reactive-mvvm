part of mvvm;

class ObservableList<TElement> extends ListBase<TElement>
    with IObservable<ListChangedEvent<TElement>> {
  final List<TElement> innerList;

  final _subject = BehaviorSubject<ListChangedEvent<TElement>>();

  ObservableList._(this.innerList);

  factory ObservableList.empty({bool growable = false}) =>
      ObservableList._(List<TElement>.empty(growable: growable));

  factory ObservableList.fromList(List<TElement> list,
          {bool growable = false}) =>
      ObservableList._(List<TElement>.from(list, growable: growable));

  void dispose() {
    _subject.close();
  }

  @override
  Stream<ListChangedEvent<TElement>> get changes => Rx.merge([
        _subject.stream,
        Rx.merge(
          innerList.whereType<IObservable<TElement>>().map((e) {
            return e.changes.transform(
              StreamTransformer.fromHandlers(
                handleData: (data, sink) => sink.add(ListChangedEvent(
                    change: ListChangeTypes.update, elements: [data])),
              ),
            );
          }),
        )
      ]);

  @override
  int get length => innerList.length;
  set length(int value) => innerList.length = value;

  @override
  TElement operator [](int index) => innerList[index];

  @override
  void operator []=(int index, TElement value) => innerList[index] = value;

  @override
  void add(TElement element) {
    innerList.add(element);
    _subject.sink.add(
        ListChangedEvent(change: ListChangeTypes.add, elements: [element]));
  }

  @override
  void addAll(Iterable<TElement> iterable) {
    super.addAll(iterable);
    _subject.sink
        .add(ListChangedEvent(change: ListChangeTypes.add, elements: iterable));
  }

  @override
  bool remove(Object? element) {
    final result = innerList.remove(element);
    if (result && element is TElement) {
      _subject.sink.add(ListChangedEvent(
          change: ListChangeTypes.remove, elements: [element]));
    }
    return result;
  }

  @override
  TElement removeAt(int index) {
    final element = innerList.removeAt(index);
    _subject.sink.add(
        ListChangedEvent(change: ListChangeTypes.remove, elements: [element]));

    return element;
  }

  @override
  TElement removeLast() {
    final element = innerList.removeLast();
    _subject.sink.add(
        ListChangedEvent(change: ListChangeTypes.remove, elements: [element]));
    return element;
  }

  @override
  void removeRange(int start, int end) {
    final elements = innerList.getRange(start, end);
    super.removeRange(start, end);

    _subject.sink.add(
        ListChangedEvent(change: ListChangeTypes.remove, elements: elements));
  }

  @override
  void removeWhere(bool Function(TElement element) test) {
    innerList.removeWhere((element) {
      if (test(element)) {
        _subject.sink.add(ListChangedEvent(
            change: ListChangeTypes.remove, elements: [element]));
        return true;
      } else {
        return false;
      }
    });
  }
}
