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

JWT; Oct 01, 2017 -- https://github.com/salesforceidentity/jwt

License BSD3-clause, License: https://github.com/salesforceidentity/jwt/blob/master/LICENSE.md
*/
public class JWTBearerFlow {

  public static AccessTokenInfo getAccessToken(String tokenEndpoint, JWT jwt) {

    String body = 'grant_type=urn%3Aietf%3Aparams%3Aoauth%3Agrant-type%3Ajwt-bearer&assertion=' + jwt.issue();
    HttpRequest req = new HttpRequest();
    req.setMethod('POST');
    req.setEndpoint(tokenEndpoint);
    req.setHeader('Content-type', 'application/x-www-form-urlencoded');
    req.setBody(body);
    Http http = new Http();
    HTTPResponse res = http.send(req);

    String access_token = null;
    Integer expires_in = null;
    if ( res.getStatusCode() == 200 ) {
      System.debug('Auth response: ' + res.getBody());
      System.JSONParser parser = System.JSON.createParser(res.getBody());
      while (parser.nextToken() != null) {
        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'access_token')) {
          parser.nextToken();
          access_token = parser.getText();
        }

        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'expires_in')) {
          parser.nextToken();
          expires_in = Integer.valueOf(parser.getText());
        }
      }
    }
    return access_token == null ? null : new AccessTokenInfo(access_token, expires_in);
  }

  public class AccessTokenInfo {
    public String token { get; private set; }
    public Integer expiresIn { get; private set; }

    public AccessTokenInfo(String token, Integer expiresIn) {
      this.token = token;
      this.expiresIn = expiresIn;
    }
  }
}