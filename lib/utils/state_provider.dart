import 'package:riverpod/misc.dart';
import 'package:riverpod/riverpod.dart';

typedef StateProviderCreateFunction<StateT, ArgT> =
    StateT Function(Ref ref, ArgT param);

abstract class StateProvider {
  static NotifierProviderFamily<StateNotifier<StateT, ArgT>, StateT, ArgT>
  autoDisposeFamily<StateT, ArgT>(
    StateProviderCreateFunction<StateT, ArgT> createFunction, {
    Iterable<ProviderOrFamily>? dependencies,
  }) {
    return NotifierProvider.autoDispose
        .family<StateNotifier<StateT, ArgT>, StateT, ArgT>(
          (ArgT arg) => StateNotifier<StateT, ArgT>(createFunction, arg),
          dependencies: dependencies,
        );
  }
}

class StateNotifier<StateT, ArgT> extends Notifier<StateT> {
  StateNotifier(this._createFunction, this._arg);

  final StateProviderCreateFunction<StateT, ArgT> _createFunction;

  final ArgT _arg;

  @override
  StateT build() => _createFunction(ref, _arg);

  @override
  StateT get state => super.state;

  @override
  set state(StateT newState) {
    super.state = newState;
  }

  void update(StateT Function(StateT) updateFn) {
    state = updateFn(state);
  }
}
