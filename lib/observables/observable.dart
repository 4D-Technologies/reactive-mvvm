part of mvvm;

mixin IObservable<TValue> {
  Stream<TValue> get changes;
}
