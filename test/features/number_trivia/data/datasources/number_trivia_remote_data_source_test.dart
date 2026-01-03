import 'dart:convert';

import 'package:clean_architecture_weather_app/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_weather_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;
  late Uri baseUri;

  const tNumber = 1;

  setUpAll(() {
    registerFallbackValue(Uri.parse('http://example.com'));
    registerFallbackValue(<String, String>{});
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
    baseUri = Uri.parse('http://numbersapi.com/$tNumber');
  });

  group('getConcreteNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
      json.decode(fixture('trivia.json')),
    );
    test('should perform a GET request with application/json header', () async {
      // arrange
      when(
        () => mockHttpClient.get(
          any(), // 👈 Uri matcher now safe
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));

      // act
      await dataSource.getConcreteNumberTrivia(tNumber);

      // assert
      verify(
        () => mockHttpClient.get(
          baseUri,
          headers: {'Content-Type': 'application/json'},
        ),
      ).called(1);
    });

    test(
      'should return NumberTrivia when the response code is 200 (success)',
      () async {
        // arrange
        when(
          () => mockHttpClient.get(
            any(), // 👈 Uri matcher now safe
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
        // act
        final result = await dataSource.getConcreteNumberTrivia(tNumber);
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );
  });
}
