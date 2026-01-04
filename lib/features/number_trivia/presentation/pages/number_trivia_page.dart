import '../bloc/number_trivia_bloc.dart';
import '../widgets/trivia_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/widgets.dart';
import '../../../../injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Number Trivia')),
      body: SingleChildScrollView(child: buildBody(context)),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              // Top half
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return MessageDisplay(
                      message: 'Start searching!',
                      key: UniqueKey(),
                    );
                  } else if (state is Loading) {
                    return LoadingWidget(key: UniqueKey());
                  } else if (state is Loaded) {
                    return TriviaDisplay(
                      key: UniqueKey(),
                      numberTrivia: state.trivia,
                    );
                  } else if (state is Error) {
                    return MessageDisplay(
                      key: UniqueKey(),
                      message: state.errorMessage,
                    );
                  }
                  return SizedBox();
                },
              ),
              SizedBox(height: 20),
              // Bottom half
              TriviaControls(key: UniqueKey(),),
            ],
          ),
        ),
      ),
    );
  }
}
