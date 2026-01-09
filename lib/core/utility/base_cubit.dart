import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseCubit<T> extends Cubit<T> {
  BaseCubit(super.initialState);

  void safeEmit(T state) {
    if (!isClosed) emit(state);
  }
}
