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

public with sharing class ACT_UpdateSentimentQueueable implements Queueable, Database.AllowsCallouts {

  private final String objType;
  private final String id;
  private final String text;
  private final String sentimentFieldName;
  private final String sentimentProbabilityFieldName;
  private final TokenProvider tokenProvider;

  public ACT_UpdateSentimentQueueable(String objType, String sentimentFieldName, String sentimentProbabilityFieldName, String id, String text) {
    this(objType, sentimentFieldName, sentimentProbabilityFieldName, id, text, EinsteinTokenProvider.forDefaultProfile());
  }

  public ACT_UpdateSentimentQueueable(String objType, String sentimentFieldName, String sentimentProbabilityFieldName, String id, String text, TokenProvider tokenProvider) {
    this.id = id;
    this.text = text;
    this.objType = objType;
    this.sentimentFieldName = sentimentFieldName;
    this.sentimentProbabilityFieldName = sentimentProbabilityFieldName;
    this.tokenProvider = tokenProvider;
  }

  public void execute(QueueableContext ctx) {
    EinsteinLanguageService service = new EinsteinLanguageService(tokenProvider);

    EinsteinLanguageService.SentimentResult result = service.getCommunitySentiment(text);

    SObject obj = Schema.getGlobalDescribe().get(objType).newSObject() ;
    obj.Id = id;
    obj.put(sentimentFieldName, result.probabilities.get(0).label);

    if (String.isNotEmpty(sentimentProbabilityFieldName)) {
      obj.put(sentimentProbabilityFieldName, result.probabilities.get(0).probability);
    }

    update obj;
  }
}