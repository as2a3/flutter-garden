import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garden/common/cubit/select_date_cubit.dart';
import 'package:garden/common/state/bloc_state.dart';
import 'package:garden/common/state/init_state.dart';

class MockSelectDateCubit extends MockCubit<BlocState> implements SelectDateCubit {}

void main() {
  late MockSelectDateCubit mockSelectDateCubit;

  setUp(() {
    mockSelectDateCubit = MockSelectDateCubit();
  });

  test('Init Select Date Cubit', () {
    expect(mockSelectDateCubit.state, const InitState());
  });

}
