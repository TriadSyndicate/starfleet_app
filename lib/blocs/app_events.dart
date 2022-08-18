import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

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
