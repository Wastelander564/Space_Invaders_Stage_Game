import 'package:flutter_bloc/flutter_bloc.dart';
import 'game_event.dart';
import 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(GamePlaying()) {
    on<StartGame>((event, emit) => emit(GamePlaying()));
    on<WinGame>((event, emit) => emit(GameWon()));
    on<LoseGame>((event, emit) => emit(GameLost()));
  }
}
