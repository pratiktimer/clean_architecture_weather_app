import 'package:clean_architecture_weather_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_weather_app/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture_weather_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  late GetConcreteNumberTrivia usecase;
  late MockNumberTriviaRepository mockRepository;

  setUp(() {
    mockRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockRepository);
  });

  const tNumber = 2;
  const tNumberTrivia = NumberTrivia(
    number: 2,
    text: 'test',
  );

  test(
    'should get trivia for the number from the repository',
    () async {
      // arrange
      when(
        () => mockRepository.getConcreteNumberTrivia(any()),
      ).thenAnswer(
        (_) async => const Right(tNumberTrivia),
      );

      // act
      final result = await usecase.execute(number: tNumber);

      // assert
      expect(result, const Right(tNumberTrivia));

      verify(
        () => mockRepository.getConcreteNumberTrivia(tNumber),
      ).called(1);

      verifyNoMoreInteractions(mockRepository);
    },
  );
}
