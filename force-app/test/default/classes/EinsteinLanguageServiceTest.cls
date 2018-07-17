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
private class EinsteinLanguageServiceTest {

  @isTest static void testGetCommunitySentiment() {
    Test.setMock(HttpCalloutMock.class, new MultiHttpCalloutMock(createRequestMapping(), createRequestOptions()));

    EinsteinLanguageService service = new EinsteinLanguageService(new TokenProviderMock());

    EinsteinLanguageService.SentimentResult result = service.getCommunitySentiment('the presentation was great and I learned a lot');

    assertSentiment(result.probabilities.get(0), 'positive', 0.8673582);
    assertSentiment(result.probabilities.get(1), 'negative', 0.1316828);
    assertSentiment(result.probabilities.get(2), 'neutral', Decimal.valueOf('9.590242E-4'));
  }

  private static void assertSentiment(EinsteinLanguageService.Sentiment sentiment, String label, Decimal probability) {
    System.assertEquals(label, sentiment.label);
    System.assertEquals(probability, sentiment.probability);
  }

  private static Map<HttpRequest, HttpResponse> createRequestMapping() {
    return new Map<HttpRequest, HttpResponse> {
      createExpectedRequest() => createMockResponse()
    };
  }

  private static HttpRequest createExpectedRequest() {
    HttpRequest req = new HttpRequest();
    req.setMethod('POST');
    req.setEndpoint('https://api.einstein.ai/v2/language/sentiment');
    req.setHeader('Content-type', HttpFormDataBodyPart.GetContentType());

    return req;
  }

  private static HttpResponse createMockResponse() {
    HttpResponse resp = new HttpResponse();
    resp.setStatusCode(200);
    resp.setBody('{"probabilities":[{"label":"positive","probability":0.8673582},{"label":"negative","probability":0.1316828},{"label":"neutral","probability":9.590242E-4}],"object":"predictresponse"}');

    return resp;
  }

  private static MultiHttpCalloutMock.Options createRequestOptions() {
    MultiHttpCalloutMock.Options options = new MultiHttpCalloutMock.Options();
    options.checkBody = false;
    return options;
  }

  public class TokenProviderMock implements TokenProvider {

    public String getToken() {
      return 'fake-token';
    }
  }
}