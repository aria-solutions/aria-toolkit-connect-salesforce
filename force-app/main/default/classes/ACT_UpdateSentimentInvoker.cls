/** Copyright 2017 Aria Solutions Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

global with sharing class ACT_UpdateSentimentInvoker {

  @TestVisible
  private static TokenProvider tokenProvider = EinsteinTokenProvider.forDefaultProfile();

  @InvocableMethod(label='Update Einstein Sentiment' description='Sends a text to Einstein for sentiment analysis using the community model and updates the record with the result.')
  global static void updateSentiments(List<SentimentArg> args) {
    for (SentimentArg arg : args) {
      System.enqueueJob(new ACT_UpdateSentimentQueueable(arg.objectType, arg.sentimentFieldName, arg.sentimentProbabilityFieldName, arg.recordId, arg.text, tokenProvider));
    }
  }

  global class SentimentArg {
    @InvocableVariable(label='Record Id' required=true Description='Id of the record that will be updated with the sentiment result')
    global Id recordId;

    @InvocableVariable(label='Text to be analyzed' required=true Description='The text to be analyzed for its sentiment')
    global String text;

    @InvocableVariable(label='Object Type' required=true Description='Name of the object associated with the given Record Id, i.e. Case')
    global String objectType;

    @InvocableVariable(label='Name of the field for sentiment result' required=true Description='Name of the field where the sentiment should be stored in, i.e. Sentiment__c')
    global String sentimentFieldName;

    @InvocableVariable(label='Name of the field for sentiment probability' required=false Description='Name of the field where the sentiment\'s probability should be stored in, i.e. Sentiment_Probability__c')
    global String sentimentProbabilityFieldName;
  }
}