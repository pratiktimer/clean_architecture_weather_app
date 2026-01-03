import 'package:clean_architecture_weather_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_weather_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: "Test Text");
  test('should be a subclass of NumberTriviaEntity', () async {
    //asset
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });
}
