import 'package:clean_architecture_weather_app/core/error/failure.dart';
import 'package:clean_architecture_weather_app/core/usecases/usecase.dart';
import 'package:clean_architecture_weather_app/core/util/input_converter.dart';
import 'package:clean_architecture_weather_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_weather_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_weather_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture_weather_app/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

class FakeParams extends Fake implements Params {}

class FakeNoParams extends Fake implements NoParams {}

void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;
  setUpAll(() {
    registerFallbackValue(FakeParams());
    registerFallbackValue(FakeNoParams());
  });
  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState should be Empty', () {
    expect(bloc.state, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');
    void setUpMockInputConverterSuccess() => when(
      () => mockInputConverter.stringToUnsignedInteger(any()),
    ).thenReturn(Right(tNumberParsed));
    test(
      'should call the InputConverter to validate and convert to an unsigned integer',
      () async {
        // arrange
        when(
          () => mockInputConverter.stringToUnsignedInteger(any()),
        ).thenReturn(Right(tNumberParsed));
        when(
          () => mockGetConcreteNumberTrivia(any()),
        ).thenAnswer((_) async => Right(tNumberTrivia));
        // act
        bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString));
        await untilCalled(
          () => mockInputConverter.stringToUnsignedInteger(any()),
        );

        // assert
        verify(
          () => mockInputConverter.stringToUnsignedInteger(tNumberString),
        ).called(1);

        verifyNoMoreInteractions(mockInputConverter);
      },
    );

    test('should emit [Error] when the input is invalid', () async {
      // arrange
      when(
        () => mockInputConverter.stringToUnsignedInteger(any()),
      ).thenReturn(Left(InvalidInputFailure()));

      final expected = [Error(errorMessage: INVALID_INPUT_FAILURE_MESSAGE)];

      // assert
      expectLater(bloc.stream, emitsInOrder(expected));

      // act
      bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString));
    });
    test('should get data from the concrete use case', () async {
      // arrange
      when(
        () => mockInputConverter.stringToUnsignedInteger(any()),
      ).thenReturn(Right(tNumberParsed));

      when(
        () => mockGetConcreteNumberTrivia(any()),
      ).thenAnswer((_) async => Right(tNumberTrivia));

      // act
      bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString));
      await untilCalled(() => mockGetConcreteNumberTrivia(any()));

      // assert
      verify(
        () => mockGetConcreteNumberTrivia(Params(number: tNumberParsed)),
      ).called(1);
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      setUpMockInputConverterSuccess();

      when(
        () => mockGetConcreteNumberTrivia(any()),
      ).thenAnswer((_) async => Left(ServerFailure()));

      // assert
      expectLater(
        bloc.stream,
        emitsInOrder([Loading(), Error(errorMessage: SERVER_FAILURE_MESSAGE)]),
      );

      // act
      bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString));
    });
    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(
          () => mockGetConcreteNumberTrivia(any()),
        ).thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [
          Loading(),
          Error(errorMessage: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString));
      },
    );
    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(
          () => mockGetConcreteNumberTrivia(any()),
        ).thenAnswer((_) async => Right(tNumberTrivia));
        // assert later
        final expected = [Loading(), Loaded(trivia: tNumberTrivia)];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString));
      },
    );
  });

  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');
    test('should get data from the concrete use case', () async {
      // arrange

      when(
        () => mockGetRandomNumberTrivia(any()),
      ).thenAnswer((_) async => Right(tNumberTrivia));

      // act
      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(() => mockGetRandomNumberTrivia(any()));

      // assert
      verify(() => mockGetRandomNumberTrivia(NoParams())).called(1);
    });

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        when(
          () => mockGetRandomNumberTrivia(any()),
        ).thenAnswer((_) async => Right(tNumberTrivia));
        // assert later
        final expected = [Loading(), Loaded(trivia: tNumberTrivia)];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForRandomNumber());
      },
    );
    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        when(
          () => mockGetRandomNumberTrivia(any()),
        ).thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [
          Loading(),
          Error(errorMessage: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForRandomNumber());
      },
    );
    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        // arrange

        when(
          () => mockGetRandomNumberTrivia(any()),
        ).thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [
          Loading(),
          Error(errorMessage: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForRandomNumber());
      },
    );
  });
}
