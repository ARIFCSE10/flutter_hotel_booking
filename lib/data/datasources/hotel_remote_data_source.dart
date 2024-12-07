import 'package:hotel_booking/data/models/hotel_model.dart';

abstract class HotelRemoteDataSource {
  Future<List<HotelModel>> getHotels();
}

class HotelRemoteDataSourceMockImpl implements HotelRemoteDataSource {
  @override
  Future<List<HotelModel>> getHotels() async {
    return <HotelModel>[].mock(10);
  }
}
