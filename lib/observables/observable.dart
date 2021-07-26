mixin IObservable<TValue> {
  Stream<TValue> get changes;
}
