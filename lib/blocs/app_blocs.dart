import 'package:starfleet_app/models/location.model.dart';
import 'package:starfleet_app/screens/util/backend_call.dart';
import 'app_events.dart';
import 'app_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final APIServices _apiServices;

  LocationBloc(this._apiServices) : super(LocationLoadingState()) {
    on<LoadLocationEvent>(((event, emit) async {
      emit(LocationLoadingState());
      try {
        final locationId = await _apiServices.getLocationId(event.locationName);
        final LocationModel location =
            await _apiServices.getLocationDetail(locationId);
        final categories = await _apiServices.getCategoryList(location);
        final attractions = await _apiServices.getAttractionList(location);
        emit(LocationLoadedState(attractions, categories, location));
      } catch (e) {
        emit(LocationErrorLoadedState(e.toString()));
      }
    }));

    on<ChooseLocationEvent>((((event, emit) {
      emit(ChooseLocationState());
    })));
  }
}
