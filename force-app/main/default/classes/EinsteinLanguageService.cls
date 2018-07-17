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

public class EinsteinLanguageService {

  private final TokenProvider tokenProvider;

  public EinsteinLanguageService(TokenProvider tokenProvider) {
    this.tokenProvider = tokenProvider;
  }

  public SentimentResult getCommunitySentiment(String text) {
    try {
      HttpRequest req = buildRequest()
        .withToken(tokenProvider.getToken())
        .withParam('modelId', 'CommunitySentiment')
        .withParam('document', text)
        .create();

      System.debug('Request: ' + req.getBody());

      Http http = new Http();
      HttpResponse respone = http.send(req);

      String sentimentResultJson = respone.getBody();
      System.debug('Sentiment response: ' + sentimentResultJson);

      return (SentimentResult) JSON.deserialize(sentimentResultJson, SentimentResult.class);
    } catch (Exception ex) {
      throw new EinsteinLanguageIntendException(ex);
    }
  }

  private static EinsteinLanguageService.EinsteinRequestBuilder buildRequest() {
    return new EinsteinLanguageService.EinsteinRequestBuilder('https://api.einstein.ai/v2/language/sentiment');
  }

  public class SentimentResult {
    public List<Sentiment> probabilities;
  }

  public class Sentiment {
    public String label;
    public Decimal probability;
  }

  public class EinsteinRequestBuilder {

    private final HttpRequest request = new HttpRequest();

    private final Map<String, String> params = new Map<String, String>();

    private EinsteinRequestBuilder(String endpoint) {
      request.setEndpoint(endpoint);
    }

    public EinsteinLanguageService.EinsteinRequestBuilder withToken(String token) {
      request.setHeader('Authorization', 'Bearer ' + token);
      return this;
    }

    public EinsteinLanguageService.EinsteinRequestBuilder withParam(String key, String val) {
      params.put(key, val);
      return this;
    }

    public HttpRequest create() {
      request.setMethod('POST');
      request.setHeader('Cache-Control', 'no-cache');
      request.setHeader('Content-Type', HttpFormDataBodyPart.GetContentType());

      String bodyString = '';
      for (String key : params.keySet()) {
        bodyString += HttpFormDataBodyPart.WriteBoundary();
        bodyString += HttpFormDataBodyPart.WriteBodyParameter(key, params.get(key));
      }

      bodyString += HttpFormDataBodyPart.WriteBoundary(HttpFormDataBodyPart.EndingType.CrLf);
      Blob bodyBlob = EncodingUtil.base64Decode(bodyString);

      request.setBodyAsBlob(bodyBlob);

      return request;
    }
  }

  public class EinsteinLanguageIntendException extends Exception { }
}
