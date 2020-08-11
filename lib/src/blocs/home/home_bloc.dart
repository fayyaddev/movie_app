import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movie_app/src/models/home.dart';
import 'package:movie_app/src/repositories/home_page_repository.dart';

import './home_event.dart';
import './home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  @override
  HomeState get initialState => HomeUninitialized();

  HomeBloc({@required this.homeRepository}) : assert(homeRepository != null);

  final HomePageRepository homeRepository;

  @override
  Stream<HomeState> mapEventToState(
    HomeState currentState,
    HomeEvent event,
  ) async* {
    if (event is FetchHomePage) {
      yield HomeLoading();

      try {
        final HomePageModel homeModel = await homeRepository.getHomePageData();
        yield HomeLoaded(model: homeModel);
      } catch (e) {
        print(e);
        yield HomeError(error: e);
      }
    }
  }
}
