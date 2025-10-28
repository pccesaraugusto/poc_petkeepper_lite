part of 'generated.dart';

class ListSurveysVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  ListSurveysVariablesBuilder(this._dataConnect, );
  Deserializer<ListSurveysData> dataDeserializer = (dynamic json)  => ListSurveysData.fromJson(jsonDecode(json));
  
  Future<QueryResult<ListSurveysData, void>> execute() {
    return ref().execute();
  }

  QueryRef<ListSurveysData, void> ref() {
    
    return _dataConnect.query("ListSurveys", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class ListSurveysSurveys {
  final String id;
  final String title;
  final String? description;
  ListSurveysSurveys.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  title = nativeFromJson<String>(json['title']),
  description = json['description'] == null ? null : nativeFromJson<String>(json['description']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListSurveysSurveys otherTyped = other as ListSurveysSurveys;
    return id == otherTyped.id && 
    title == otherTyped.title && 
    description == otherTyped.description;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, title.hashCode, description.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['title'] = nativeToJson<String>(title);
    if (description != null) {
      json['description'] = nativeToJson<String?>(description);
    }
    return json;
  }

  ListSurveysSurveys({
    required this.id,
    required this.title,
    this.description,
  });
}

@immutable
class ListSurveysData {
  final List<ListSurveysSurveys> surveys;
  ListSurveysData.fromJson(dynamic json):
  
  surveys = (json['surveys'] as List<dynamic>)
        .map((e) => ListSurveysSurveys.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListSurveysData otherTyped = other as ListSurveysData;
    return surveys == otherTyped.surveys;
    
  }
  @override
  int get hashCode => surveys.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['surveys'] = surveys.map((e) => e.toJson()).toList();
    return json;
  }

  ListSurveysData({
    required this.surveys,
  });
}

