import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movie_app/src/repositories/related_movies_repository.dart';
import './related_event.dart';
import './related_state.dart';

class RelatedBloc extends Bloc<FetchRelatedMoviesEvent, RelatedState> {
  @override
  RelatedState get initialState => RelatedUninitialized();

  RelatedBloc({@required this.repository, @required this.id})
      : assert(repository != null);

  final RelatedRepository repository;
  final String id;

  @override
  Stream<RelatedState> mapEventToState(
    RelatedState currentState,
    event,
  ) async* {
    if (event is FetchRelatedMoviesEvent) {
      yield RelatedLoading();

      try {
        final movies = await repository.getRelatedMovies(id: id);
        yield RelatedLoaded(movies: movies);
      } catch (e) {
        print(e);
        yield RelatedError(error: e);
      }
    }
  }
}
