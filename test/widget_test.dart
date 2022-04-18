// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garden/app.dart';
import 'package:garden/common/cubit/select_date_cubit.dart';
import 'package:garden/common/state/bloc_state.dart';
import 'package:garden/database/database_repository.dart';
import 'package:garden/module/home/bloc/home_bloc.dart';
import 'package:garden/module/home/event/home_event.dart';
import 'package:garden/module/home/state/home_state.dart';

class MockHomeBloc extends MockBloc<HomeEvent, HomeState> implements HomeBloc {}
class MockSelectDateCubit extends MockCubit<BlocState> implements SelectDateCubit {}

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      GardenApp(
        databaseRepository: DatabaseRepository(),
      ),
    );

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
