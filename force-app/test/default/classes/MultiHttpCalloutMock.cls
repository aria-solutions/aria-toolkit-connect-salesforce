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

@IsTest
global class MultiHttpCalloutMock implements HttpCalloutMock {

  private final Options options;
  private final Map<HttpRequest, HttpResponse> requestResponseMap;

  public MultiHttpCalloutMock(Map<HttpRequest, HttpResponse> requestResponseMap) {
    this(requestResponseMap, new Options());
  }

  public MultiHttpCalloutMock(Map<HttpRequest, HttpResponse> requestResponseMap, Options options) {
    this.requestResponseMap = requestResponseMap;
    this.options = options;
  }

  global HttpResponse respond(HTTPRequest actualRequest) {
    System.assert(requestResponseMap.size() > 0,
      String.format('There are no requests expected. Actual call: {0} {1} => {2}', new String[] {
          actualRequest.getMethod(),
          actualRequest.getEndpoint(),
          actualRequest.getBody()
        }
      )
    );

    for (HttpRequest req : requestResponseMap.keySet()) {
      if (req.getEndpoint() == actualRequest.getEndpoint()
        && req.getMethod() == actualRequest.getMethod()
        && (!options.checkBody || req.getBody() == actualRequest.getBody())) {

        HttpResponse resp = requestResponseMap.get(req);
        requestResponseMap.remove(req);

        return resp;
      }
    }

    throw new AssertException(String.format('Could not find any mapping for request. Actual call: {0} {1} => {2}', new String[] {
      actualRequest.getMethod(),
      actualRequest.getEndpoint(),
      actualRequest.getBody()
    }));
  }

  public void assertAllRequestsInvoked() {
    System.assertEquals(0, requestResponseMap.size(), 'Not all requests have been invoked');
  }

  public class Options {
    public Boolean checkBody;

    public Options() {
      checkBody = true;
    }
  }
}