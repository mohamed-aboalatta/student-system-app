import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final db = FirebaseFirestore.instance;

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final gradeController = TextEditingController();

  Future<void> addStudentToServer() async {
    emit(HomeLoading());
    try {
      await db.collection('students').add({
        "name": nameController.text,
        "age": ageController.text,
        "grade": gradeController.text,
      });
      emit(AddStudentSuccess());
    } catch (e) {
      emit(HomeFailure(e.toString()));
    }
  }

  Future<void> getStudentFromServer() async {
    emit(HomeLoading());
    try {
      final response = await db.collection('students').get();
      emit(GetStudentSuccess(response.docs));
    } catch (e) {
      emit(HomeFailure(e.toString()));
    }
  }

  Future<void> deleteStudentFromServer(String id) async {
    try {
      await db.collection('students').doc(id).delete();
      emit(DeleteStudentSuccess());
    } catch (e) {
      emit(HomeFailure(e.toString()));
    }
  }

  Future<void> updateStudentOnServer(String id) async {
    try {
      await db.collection('students').doc(id).update({
        "name": nameController.text,
        "age": ageController.text,
        "grade": gradeController.text,
      });
      emit(UpdateStudentSuccess());
    } catch (e) {
      emit(HomeFailure(e.toString()));
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    ageController.dispose();
    gradeController.dispose();
    return super.close();
  }
}
