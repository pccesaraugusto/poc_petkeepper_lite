library dataconnect_generated;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

part 'create_user.dart';

part 'list_surveys.dart';

part 'create_response.dart';

part 'get_survey.dart';







class ExampleConnector {
  
  
  CreateUserVariablesBuilder createUser () {
    return CreateUserVariablesBuilder(dataConnect, );
  }
  
  
  ListSurveysVariablesBuilder listSurveys () {
    return ListSurveysVariablesBuilder(dataConnect, );
  }
  
  
  CreateResponseVariablesBuilder createResponse ({required String surveyId, required String respondentIdentifier, }) {
    return CreateResponseVariablesBuilder(dataConnect, surveyId: surveyId,respondentIdentifier: respondentIdentifier,);
  }
  
  
  GetSurveyVariablesBuilder getSurvey ({required String id, }) {
    return GetSurveyVariablesBuilder(dataConnect, id: id,);
  }
  

  static ConnectorConfig connectorConfig = ConnectorConfig(
    'us-central1',
    'example',
    'pocpetkeepperlite',
  );

  ExampleConnector({required this.dataConnect});
  static ExampleConnector get instance {
    return ExampleConnector(
        dataConnect: FirebaseDataConnect.instanceFor(
            connectorConfig: connectorConfig,
            sdkType: CallerSDKType.generated));
  }

  FirebaseDataConnect dataConnect;
}

