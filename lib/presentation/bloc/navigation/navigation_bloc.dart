import 'package:bloc/bloc.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationInitial(tabIndex: 0)) {
    on<NavigationEvent>((event, emit) {
      if (event is SelectTab) {
        emit(NavigationInitial(tabIndex: event.tabIndex));
      }
    });
  }
}
