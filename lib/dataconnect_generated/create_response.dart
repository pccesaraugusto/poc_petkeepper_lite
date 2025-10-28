part of 'generated.dart';

class CreateResponseVariablesBuilder {
  String surveyId;
  String respondentIdentifier;

  final FirebaseDataConnect _dataConnect;
  CreateResponseVariablesBuilder(this._dataConnect, {required  this.surveyId,required  this.respondentIdentifier,});
  Deserializer<CreateResponseData> dataDeserializer = (dynamic json)  => CreateResponseData.fromJson(jsonDecode(json));
  Serializer<CreateResponseVariables> varsSerializer = (CreateResponseVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateResponseData, CreateResponseVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateResponseData, CreateResponseVariables> ref() {
    CreateResponseVariables vars= CreateResponseVariables(surveyId: surveyId,respondentIdentifier: respondentIdentifier,);
    return _dataConnect.mutation("CreateResponse", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateResponseResponseInsert {
  final String id;
  CreateResponseResponseInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateResponseResponseInsert otherTyped = other as CreateResponseResponseInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateResponseResponseInsert({
    required this.id,
  });
}

@immutable
class CreateResponseData {
  final CreateResponseResponseInsert response_insert;
  CreateResponseData.fromJson(dynamic json):
  
  response_insert = CreateResponseResponseInsert.fromJson(json['response_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateResponseData otherTyped = other as CreateResponseData;
    return response_insert == otherTyped.response_insert;
    
  }
  @override
  int get hashCode => response_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['response_insert'] = response_insert.toJson();
    return json;
  }

  CreateResponseData({
    required this.response_insert,
  });
}

@immutable
class CreateResponseVariables {
  final String surveyId;
  final String respondentIdentifier;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateResponseVariables.fromJson(Map<String, dynamic> json):
  
  surveyId = nativeFromJson<String>(json['surveyId']),
  respondentIdentifier = nativeFromJson<String>(json['respondentIdentifier']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateResponseVariables otherTyped = other as CreateResponseVariables;
    return surveyId == otherTyped.surveyId && 
    respondentIdentifier == otherTyped.respondentIdentifier;
    
  }
  @override
  int get hashCode => Object.hashAll([surveyId.hashCode, respondentIdentifier.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['surveyId'] = nativeToJson<String>(surveyId);
    json['respondentIdentifier'] = nativeToJson<String>(respondentIdentifier);
    return json;
  }

  CreateResponseVariables({
    required this.surveyId,
    required this.respondentIdentifier,
  });
}

