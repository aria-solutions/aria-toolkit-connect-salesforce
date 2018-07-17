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
private class JWTBearerFlowTest {

  private static final String ENDPOINT = 'https://login.salesforce.com/services/oauth2/token';

  @isTest static void testGetAccessToken() {
    Test.setMock(HttpCalloutMock.class, new MultiHttpCalloutMock(createRequestMapping(200), createRequestOptions()));

    JWT jwt = new JWT('HS256');
    jwt.privateKey = 'base64 encoded secret';
    jwt.iss = 'your issuer';
    jwt.sub = 'some subject';
    jwt.aud = 'https://login.salesforce.com/services/oauth2/token';

    String access_token = JWTBearerFlow.getAccessToken(ENDPOINT, jwt).token;

    System.assertEquals('foo-bar', access_token);
  }

  @isTest static void testGetAccessToken_BadResponse() {
    Test.setMock(HttpCalloutMock.class, new MultiHttpCalloutMock(createRequestMapping(500), createRequestOptions()));

    JWT jwt = new JWT('HS256');
    jwt.privateKey = 'base64 encoded secret';
    jwt.iss = 'your issuer';
    jwt.sub = 'some subject';
    jwt.aud = 'https://login.salesforce.com/services/oauth2/token';

    JWTBearerFlow.AccessTokenInfo access_token = JWTBearerFlow.getAccessToken(ENDPOINT, jwt);

    System.assertEquals(null, access_token);
  }

  private static Map<HttpRequest, HttpResponse> createRequestMapping(Integer responseCode) {
    return new Map<HttpRequest, HttpResponse> {
      createExpectedRequest() => createMockResponse(responseCode)
    };
  }

  private static HttpRequest createExpectedRequest() {
    HttpRequest req = new HttpRequest();
    req.setMethod('POST');
    req.setEndpoint(ENDPOINT);
    req.setHeader('Content-type', 'application/x-www-form-urlencoded');

    return req;
  }

  private static HttpResponse createMockResponse(Integer responseCode) {
    HttpResponse resp = new HttpResponse();
    resp.setStatusCode(responseCode);
    resp.setBody('{ "access_token": "foo-bar" }');

    return resp;
  }

  private static MultiHttpCalloutMock.Options createRequestOptions() {
    MultiHttpCalloutMock.Options options = new MultiHttpCalloutMock.Options();
    options.checkBody = false;
    return options;
  }
}