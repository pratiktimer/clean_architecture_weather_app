import 'package:clean_architecture_weather_app/core/usecases/usecase.dart';
import 'package:clean_architecture_weather_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_weather_app/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture_weather_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  late GetRandomNumberTrivia usecase;
  late MockNumberTriviaRepository mockRepository;

  setUp(() {
    mockRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockRepository);
  });

  const tNumberTrivia = NumberTrivia(
    number: 1,
    text: 'test',
  );

  test(
    'should get trivia from the repository',
    () async {
      // arrange
      when(
        () => mockRepository.getRandomNumberTrivia(),
      ).thenAnswer(
        (_) async => const Right(tNumberTrivia),
      );

      // act
      final result = await usecase(NoParams());

      // assert
      expect(result, const Right(tNumberTrivia));

      verify(
        () => mockRepository.getRandomNumberTrivia(),
      ).called(1);

      verifyNoMoreInteractions(mockRepository);
    },
  );
}
