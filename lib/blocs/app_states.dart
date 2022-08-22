import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:starfleet_app/models/attraction.model.dart';
import 'package:starfleet_app/models/category.model.dart';
import 'package:starfleet_app/models/location.model.dart';

@immutable
abstract class LocationState extends Equatable {}

//Data Loading State
class LocationLoadingState extends LocationState {
  @override
  List<Object?> get props => [];
}

//Data Loaded State
class LocationLoadedState extends LocationState {
  LocationLoadedState(
      this.attractions, this.categories, this.location, this.locationString);
  final List<AttractionModel> attractions;
  final List<CategoryModel> categories;
  final LocationModel location;
  final String? locationString;
  @override
  List<Object?> get props =>
      [attractions, categories, location, locationString];
}

//Data error Loading State

class LocationErrorLoadedState extends LocationState {
  LocationErrorLoadedState(this.error);
  final String? error;
  @override
  List<Object?> get props => [error];
}

class ChooseLocationState extends LocationState {
  @override
  List<Object?> get props => throw UnimplementedError();
}
