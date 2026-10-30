part of 'home_cubit.dart';

abstract class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeFailure extends HomeState {
  final String msg;
  HomeFailure(this.msg);
}

final class GetStudentSuccess extends HomeState {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> students;
  GetStudentSuccess(this.students);
}

final class AddStudentSuccess extends HomeState {}

final class UpdateStudentSuccess extends HomeState {}

final class DeleteStudentSuccess extends HomeState {}
