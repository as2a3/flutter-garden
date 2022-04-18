import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garden/database/database_repository.dart';
import 'package:garden/model/plant.dart';
import 'package:garden/model/type.dart';
import 'package:garden/module/home/bloc/home_bloc.dart';
import 'package:garden/module/home/event/home_event.dart';
import 'package:garden/module/home/state/home_state.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeBloc extends MockBloc<HomeEvent, HomeState> implements HomeBloc {}

// class MockHomeBloc extends HomeBloc with Mock {
//   MockHomeBloc({
//     required DatabaseRepository databaseRepository,
//   }) : super(databaseRepository: databaseRepository);
// }

class MockPlant extends Plant with Mock {
  MockPlant({
    required String name,
    required int plantingDate,
    required int typeId,
  }) : super(name: name, plantingDate: plantingDate, typeId: typeId);
}

class MockPlantType extends PlantType with Mock {
  MockPlantType({required String name}) : super(name: name);
}


void main() {
  // Create a mock instance
  final homeBloc = MockHomeBloc();
  setUp(() async {
    homeBloc.databaseRepository = await DatabaseRepository().init();
  });

  test('Init home bloc', () {
    // Assert that the initial state is correct.
    // expect(counterBloc.state, equals(0));
  });


  // late MockPlant mockPlant;
  // late MockHomeBloc mockHomeBloc;
  //
  // setUp(() async {
  //   mockHomeBloc = MockHomeBloc(
  //     databaseRepository: await DatabaseRepository().init(),
  //   );
  // });
  //
  // test('Init home bloc', () {
  //   mockHomeBloc.add(AddPlantEvent(plant: Plant(
  //     name: 'Plant 1',
  //     plantingDate: DateTime.now().millisecondsSinceEpoch,
  //     typeId: 2,
  //   )));
  //   expect(mockHomeBloc.plants, []);
  // });

  // group('HomeBloc', () {
  //   test('Init plants is empty', () {
  //     final mockPlant = MockPlant(
  //       name: 'Plant 1',
  //       plantingDate: DateTime.now().millisecondsSinceEpoch,
  //       typeId: 2,
  //     );
  //
  //     expect(mockPlant.name, 'Plant 1');
  //   });
    //
    // blocTest<AddPlantEvent, HomeState>(
    //   'add plant',
    //   build: () => AddPlantEvent(
    //         plant: Plant(
    //           name: 'Test 1',
    //           typeId: 1,
    //           plantingDate: DateTime
    //               .now()
    //               .millisecondsSinceEpoch,
    //         ),
    //       ),
    // );
  // });
}
