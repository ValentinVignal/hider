const noName = '[No name]';

extension NullableStringX on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}
