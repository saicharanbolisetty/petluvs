import 'package:flutter_facebook_connect/flutter_facebook_connect.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';



class Id {
  final String id;
  Id(this.id);
}
class Cover {
  final String id;
  final int offsetY;
  final String source;
  Cover(this.id, this.offsetY, this.source);
  Cover.fromMap(Map<String, dynamic> json)
      : id = json['id'],
        offsetY = json['offset_y'],
        source = json['source'];
}
class PublicProfile extends Id {
  final Cover cover;
  final String name;
  PublicProfile.fromMap(Map<String, dynamic> json)
      : cover =
  json.containsKey('cover') ? new Cover.fromMap(json['cover']) : null,
        name = json['name'],
        super(json['id']);
}
class FacebookGraph {
  final String _baseGraphUrl = "https://graph.facebook.com/v2.8/";
  final FacebookOAuthToken token;
  FacebookGraph(this.token);

//  final Token token;
//  FacebookGraph(this.token);
  Future<PublicProfile> me(List<String> fields) async {
    String _fields = fields.join(",");
    final http.Response response = await http
        .get("$_baseGraphUrl/me?fields=$_fields&access_token=${token.access}");
    return new PublicProfile.fromMap(JSON.decode(response.body));
  }
}