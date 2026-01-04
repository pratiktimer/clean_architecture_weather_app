import 'package:bloc/bloc.dart';
import 'package:clean_architecture_weather_app/core/error/failure.dart';
import 'package:clean_architecture_weather_app/core/usecases/usecase.dart';
import 'package:clean_architecture_weather_app/core/util/input_converter.dart';
import 'package:clean_architecture_weather_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_weather_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import '../../domain/entities/number_trivia.dart';
import 'package:equatable/equatable.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(Empty()) {
    on<GetTriviaForConcreteNumber>(_onGetTriviaForConcreteNumber);
    on<GetTriviaForRandomNumber>(_onGetTriviaForRandomNumber);
  }

  Future<void> _onGetTriviaForConcreteNumber(
    GetTriviaForConcreteNumber event,
    Emitter<NumberTriviaState> emit,
  ) async {
    final inputEither = inputConverter.stringToUnsignedInteger(
      event.numberString,
    );

    inputEither.fold(
      (failure) {
        emit(
          Error(
            errorMessage: failure is ServerFailure
                ? SERVER_FAILURE_MESSAGE
                : CACHE_FAILURE_MESSAGE,
          ),
        );
      },
      (integer) async {
        emit(Loading());

        final failureOrTrivia = await getConcreteNumberTrivia(
          Params(number: integer),
        );

        failureOrTrivia.fold(
          (failure) {
            emit(const Error(errorMessage: SERVER_FAILURE_MESSAGE));
          },
          (trivia) {
            emit(Loaded(trivia: trivia));
          },
        );
      },
    );
  }

  Future<void> _onGetTriviaForRandomNumber(
    GetTriviaForRandomNumber event,
    Emitter<NumberTriviaState> emit,
  ) async {
    emit(Loading());

    final failureOrTrivia = await getRandomNumberTrivia(NoParams());

    failureOrTrivia.fold(
      (failure) {
        emit(Error(errorMessage: failure is ServerFailure
                ? SERVER_FAILURE_MESSAGE
                : CACHE_FAILURE_MESSAGE,));
      },
      (trivia) {
        emit(Loaded(trivia: trivia));
      },
    );
  }
}
