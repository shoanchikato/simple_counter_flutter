import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CounterEvent { increment }

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0);

  // void increment() => emit(state + 1);

  @override
  Stream<int> mapEventToState(CounterEvent event) async* {
    switch (event) {
      case CounterEvent.increment:
        yield state + 1;
        break;
      default:
        state;
    }
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => CounterBloc(),
        child: CounterPage(),
      ),
    );
  }
}

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter'),
      ),
      body: Center(
        // child: CounterText(),
        child: Builder(
          builder: (context) {
            // NB: Part 2: if you want to use [context.watch()] with a widget hierachy
            // make sure that is wrapped inside a Builder widget so that ONLY
            // that part of the widget is rebuild when state changes
            // NB: also checkout [context.select]
            
            final count = context.watch<CounterBloc>().state;
            final theme = Theme.of(context);
            return Text(
              '$count',
              style: theme.textTheme.headline1,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // BlocProvider.of<CounterBloc>(context).increment();
          context.read<CounterBloc>().add(CounterEvent.increment);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class CounterText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // NB: PART 1: if you are going to use this approach of accessing state try to
    // scope this as low as possible, so that only the widgets that need to be
    // changed get rebuilt, because each time the state counter changes
    // the all the widget(s) in the widget with [context.watch()] will be
    // rebuilt/re-rendered

    final count = context.watch<CounterBloc>().state;
    return Text(
      '$count',
      style: theme.textTheme.headline1,
    );
  }
}
