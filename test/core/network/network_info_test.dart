import 'package:clean_architecture_weather_app/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class MockDataConnectionChecker extends Mock
    implements InternetConnectionChecker {}

void main() {
  late NetworkInfoImpl networkInfoImpl;
  late MockDataConnectionChecker mockDataConnectionChecker;
  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);
  });

  group('isConnected', () {
    test(
      'should forward the call to InternetConnectionChecker.hasConnection',
      () async {
        // arrange
        when(
          () => mockDataConnectionChecker.hasConnection,
        ).thenAnswer((_) async => true);

        // act
        final result = await networkInfoImpl.isConnected;

        // assert
        verify(() => mockDataConnectionChecker.hasConnection).called(1);
        expect(result, true);
      },
    );
  });
}
