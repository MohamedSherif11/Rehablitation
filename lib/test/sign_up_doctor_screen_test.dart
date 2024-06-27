import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:graddone/view/screens/doctor/signup_doctor_screen.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../services/doctors_auth/sign_up/logic/sign_up_cubit.dart';

// Mock classes
class MockSignUpCubitDoctor extends Mock implements SignUpCubitDoctor {}
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

@GenerateMocks([MockSignUpCubitDoctor, MockFirebaseFirestore])
void main() {
  final mockSignUpCubit = MockSignUpCubitDoctor();

  // Function to create the testable widget
  Widget createTestableWidget(Widget widget) {
    return MaterialApp(
      home: BlocProvider<SignUpCubitDoctor>(
        create: (context) => mockSignUpCubit,
        child: widget,
      ),
    );
  }

  testWidgets('User can enter text into all fields', (WidgetTester tester) async {
    // Build the SignUpDoctorScreen widget
    await tester.pumpWidget(createTestableWidget(const SignUpDoctorScreen()));

    // Find the input fields using keys for better reliability
    final usernameField = find.byKey(const Key('usernameField'));
    final emailField = find.byKey(const Key('emailField'));
    final ageField = find.byKey(const Key('ageField'));
    final specializationField = find.byKey(const Key('specializationField'));
    final phoneField = find.byKey(const Key('phoneField'));
    final passwordField = find.byKey(const Key('passwordField'));

    // Enter text into each field
    await tester.enterText(usernameField, 'mohamedd');
    await tester.enterText(emailField, 'mm@gmail.com');
    await tester.enterText(ageField, '30');
    await tester.enterText(specializationField, 'Cardiology');
    await tester.enterText(phoneField, '1234567890');
    await tester.enterText(passwordField, 'password123');

    // Verify the text has been entered
    expect(find.text('mohamedd'), findsOneWidget);
    expect(find.text('mm@gmail.com'), findsOneWidget);
    expect(find.text('30'), findsOneWidget);
    expect(find.text('Cardiology'), findsOneWidget);
    expect(find.text('1234567890'), findsOneWidget);
    expect(find.text('password123'), findsOneWidget);

    // Tap the Sign Up button
    final signUpButton = find.byKey(const Key('signUpButton'));
    await tester.tap(signUpButton);

    // Rebuild the widget after the state has changed
    await tester.pump();

    // Verify the function was called with correct arguments
    verify(mockSignUpCubit.createAccount(
      name: 'mohamedd',
      phone: '1234567890',
      email: 'mm@gmail.com',
      password: 'password123',
      age: 30,
      specialization: 'Cardiology',
    )).called(1);
  });
}
