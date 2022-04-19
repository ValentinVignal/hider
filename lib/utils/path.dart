import 'package:equatable/equatable.dart';

/// An object that describe the location of the user its items.
class HiderPath extends Iterable<String> with EquatableMixin, Iterator<String> {
  const HiderPath([this._path = const []]);

  final List<String> _path;

  @override
  List<String> get props => _path;

  String get name => _path.join('/');

  HiderPath add(String name) => HiderPath(_path + [name]);

  @override
  String get current => _path.iterator.current;

  @override
  Iterator<String> get iterator => _path.iterator;

  @override
  bool moveNext() {
    return _path.iterator.moveNext();
  }
}
