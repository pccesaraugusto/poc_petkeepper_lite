part of 'generated.dart';

class GetSurveyVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  GetSurveyVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<GetSurveyData> dataDeserializer = (dynamic json)  => GetSurveyData.fromJson(jsonDecode(json));
  Serializer<GetSurveyVariables> varsSerializer = (GetSurveyVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetSurveyData, GetSurveyVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetSurveyData, GetSurveyVariables> ref() {
    GetSurveyVariables vars= GetSurveyVariables(id: id,);
    return _dataConnect.query("GetSurvey", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetSurveySurvey {
  final String id;
  final String title;
  final String? description;
  final List<GetSurveySurveyQuestionsOnSurvey> questions_on_survey;
  GetSurveySurvey.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  title = nativeFromJson<String>(json['title']),
  description = json['description'] == null ? null : nativeFromJson<String>(json['description']),
  questions_on_survey = (json['questions_on_survey'] as List<dynamic>)
        .map((e) => GetSurveySurveyQuestionsOnSurvey.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetSurveySurvey otherTyped = other as GetSurveySurvey;
    return id == otherTyped.id && 
    title == otherTyped.title && 
    description == otherTyped.description && 
    questions_on_survey == otherTyped.questions_on_survey;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, title.hashCode, description.hashCode, questions_on_survey.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['title'] = nativeToJson<String>(title);
    if (description != null) {
      json['description'] = nativeToJson<String?>(description);
    }
    json['questions_on_survey'] = questions_on_survey.map((e) => e.toJson()).toList();
    return json;
  }

  GetSurveySurvey({
    required this.id,
    required this.title,
    this.description,
    required this.questions_on_survey,
  });
}

@immutable
class GetSurveySurveyQuestionsOnSurvey {
  final String id;
  final String text;
  final String type;
  final List<String>? options;
  GetSurveySurveyQuestionsOnSurvey.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  text = nativeFromJson<String>(json['text']),
  type = nativeFromJson<String>(json['type']),
  options = json['options'] == null ? null : (json['options'] as List<dynamic>)
        .map((e) => nativeFromJson<String>(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetSurveySurveyQuestionsOnSurvey otherTyped = other as GetSurveySurveyQuestionsOnSurvey;
    return id == otherTyped.id && 
    text == otherTyped.text && 
    type == otherTyped.type && 
    options == otherTyped.options;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, text.hashCode, type.hashCode, options.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['text'] = nativeToJson<String>(text);
    json['type'] = nativeToJson<String>(type);
    if (options != null) {
      json['options'] = options?.map((e) => nativeToJson<String>(e)).toList();
    }
    return json;
  }

  GetSurveySurveyQuestionsOnSurvey({
    required this.id,
    required this.text,
    required this.type,
    this.options,
  });
}

@immutable
class GetSurveyData {
  final GetSurveySurvey? survey;
  GetSurveyData.fromJson(dynamic json):
  
  survey = json['survey'] == null ? null : GetSurveySurvey.fromJson(json['survey']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetSurveyData otherTyped = other as GetSurveyData;
    return survey == otherTyped.survey;
    
  }
  @override
  int get hashCode => survey.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (survey != null) {
      json['survey'] = survey!.toJson();
    }
    return json;
  }

  GetSurveyData({
    this.survey,
  });
}

@immutable
class GetSurveyVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetSurveyVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetSurveyVariables otherTyped = other as GetSurveyVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  GetSurveyVariables({
    required this.id,
  });
}

