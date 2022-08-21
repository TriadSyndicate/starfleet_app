import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
abstract class LocationEvent extends Equatable {
  const LocationEvent();
}

class LoadLocationEvent extends LocationEvent {
  String? locationName;
  LoadLocationEvent(this.locationName);
  @override
  List<Object?> get props => [];
}

class ChooseLocationEvent extends LocationEvent {
  @override
  List<Object?> get props => [];
}
