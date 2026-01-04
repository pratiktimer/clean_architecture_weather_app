import 'dart:convert';

import '../../../../core/error/exceptions.dart';

import '../models/number_trivia_model.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

// class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
//   final http.Client client;

//   NumberTriviaRemoteDataSourceImpl({required this.client});
//   @override
//   Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
//     return await _getTriviaFromUrl('http://numbersapi.com/$number');
//   }

//   @override
//   Future<NumberTriviaModel> getRandomNumberTrivia() async {
//     return await _getTriviaFromUrl('http://numbersapi.com/random');
//   }

//   Future<NumberTriviaModel> _getTriviaFromUrl(String url) async {
//     final response = await client.get(
//       Uri.parse(url),
//       headers: {'Content-Type': 'application/json'},
//     );
//     if (response.statusCode == 200) {
//       return NumberTriviaModel.fromJson(json.decode(response.body));
//     } else {
//       throw ServerException();
//     }
//   }
// }
class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    return await _getTriviaFromUrl('http://numbersapi.com/$number');
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    return await _getTriviaFromUrl('http://numbersapi.com/random');
  }

  // 🔴 FAKE API SIMULATION
  Future<NumberTriviaModel> _getTriviaFromUrl(String url) async {
    // simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // exact fake response like numbersapi
    const fakeResponse = {
      "text": "Test Text",
      "number": 1,
      "found": true,
      "type": "trivia",
    };

    return NumberTriviaModel.fromJson(fakeResponse);
  }
}
