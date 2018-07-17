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

@isTest
private class ACT_UpdateSentimentInvokerTest {

  @isTest static void testExecute_Failure() {
    Test.setMock(HttpCalloutMock.class, new MultiHttpCalloutMock(createRequestMapping()));

    ACT_UpdateSentimentInvoker.tokenProvider = new TokenProviderMock();

    Case c = createCase('This is not great!');

    Test.startTest();
    ACT_UpdateSentimentInvoker.updateSentiments(createArgs(c));
    try {
      Test.stopTest();
      System.assert(false, 'Expected Exception has not been thrown.');
    } catch (EinsteinLanguageService.EinsteinLanguageIntendException ex) {
      System.assert(true);
    }
  }

  private static List<ACT_UpdateSentimentInvoker.SentimentArg> createArgs(Case c) {
    ACT_UpdateSentimentInvoker.SentimentArg arg = new ACT_UpdateSentimentInvoker.SentimentArg();
    arg.recordId = c.Id;
    arg.text = c.Description;
    arg.objectType = 'Case';
    arg.sentimentFieldName = 'Subject';

    return new List<ACT_UpdateSentimentInvoker.SentimentArg> {
      arg
    };
  }

  private static Case createCase(String description) {
    Case c = new Case(
      Subject = 'Foo bar',
      Description = description
    );
    insert c;

    return c;
  }

  private static Map<HttpRequest, HttpResponse> createRequestMapping() {
    return new Map<HttpRequest, HttpResponse> {
      createTokenProviderRequest() => createTokenProviderResponse(),
      createSentimentRequest() => createSentimentResponse()
    };
  }

  private static HttpRequest createTokenProviderRequest() {
    HttpRequest req = new HttpRequest();
    req.setMethod('POST');
    req.setEndpoint('https://api.einstein.ai/v2/oauth2/token');
    req.setHeader('Content-type', 'application/x-www-form-urlencoded');

    return req;
  }

  private static HttpResponse createTokenProviderResponse() {
    HttpResponse resp = new HttpResponse();
    resp.setStatusCode(200);
    resp.setBody('{ "access_token": "foo-bar" }');

    return resp;
  }

  private static HttpRequest createSentimentRequest() {
    HttpRequest req = new HttpRequest();
    req.setMethod('POST');
    req.setEndpoint('https://api.einstein.ai/v2/language/sentiment');
    req.setHeader('Content-type', HttpFormDataBodyPart.GetContentType());

    return req;
  }

  private static HttpResponse createSentimentResponse() {
    HttpResponse resp = new HttpResponse();
    resp.setStatusCode(200);
    resp.setBody('{"probabilities":[{"label":"positive","probability":0.8673582},{"label":"negative","probability":0.1316828},{"label":"neutral","probability":9.590242E-4}],"object":"predictresponse"}');

    return resp;
  }

  public class TokenProviderMock implements TokenProvider {

    public String getToken() {
      throw new ACT_UpdateSentimentInvokerTest.TokenProviderMockException();
    }
  }

  public class TokenProviderMockException extends Exception { }
}