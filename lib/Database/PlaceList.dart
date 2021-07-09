
class PlaceList {

  int id ;
  String placeName;
  double userLat;
  double userLng;


  PlaceList({this.id, this.placeName, this.userLat, this.userLng});

  String table(){
    return 'places';
  }

  String database() {
    return 'places_db';
  }

  Map< String, dynamic> tomap() {
    return{
      'id' : this.id,
      'name' : this.placeName,
      'Lat' : this.userLat,
      'Lng' : this.userLng,
    };
  }

  // PlaceList(dynamic obj){
  //   id = obj['id'];
  //   placeName = obj['name'];
  //   userlat = obj['lat'];
  //   userlng = obj['lng'];
  // }

  String getname() {
    return this.placeName;
  }

  PlaceList.fromMap(Map<String, dynamic> data){
    id = data['id'];
    placeName = data['name'];
    userLat = data['Lat'];
    userLng = data['Lng'];
  }
}