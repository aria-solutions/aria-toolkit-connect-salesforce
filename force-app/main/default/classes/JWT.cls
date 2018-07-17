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
public class JWT {

  public String alg {get;set;}
  public String iss {get;set;}
  public String sub {get;set;}
  public String aud {get;set;}
  public String exp {get;set;}
  public String iat {get;set;}
  public Map<String,String> claims {get;set;}
  public Integer validFor {get;set;}
  public String cert {get;set;}
  public String pkcs8 {get;set;}
  public String privateKey {get;set;}

  public static final String HS256 = 'HS256';
  public static final String RS256 = 'RS256';
  public static final String NONE = 'none';

  public JWT(String alg) {
    this.alg = alg;
    this.validFor = 300;
  }

  public String issue() {

    String jwt = '';

    JSONGenerator header = JSON.createGenerator(false);
    header.writeStartObject();
    header.writeStringField('alg', this.alg);
    header.writeEndObject();
    String encodedHeader = base64URLencode(Blob.valueOf(header.getAsString()));

    JSONGenerator body = JSON.createGenerator(false);
    body.writeStartObject();
    body.writeStringField('iss', this.iss);
    body.writeStringField('sub', this.sub);
    body.writeStringField('aud', this.aud);
    Long rightNow = (dateTime.now().getTime()/1000)+1;
    body.writeNumberField('iat', rightNow);
    body.writeNumberField('exp', (rightNow + validFor));
    if (claims != null) {
      for (String claim : claims.keySet()) {
        body.writeStringField(claim, claims.get(claim));
      }
    }
    body.writeEndObject();

    jwt = encodedHeader + '.' + base64URLencode(Blob.valueOf(body.getAsString()));

    if ( this.alg == HS256 ) {
      Blob key = EncodingUtil.base64Decode(privateKey);
      Blob signature = Crypto.generateMac('hmacSHA256',Blob.valueof(jwt),key);
      jwt += '.' + base64URLencode(signature);
    } else if ( this.alg == RS256 ) {
      Blob signature = null;

      if (cert != null ) {
        signature = Crypto.signWithCertificate('rsa-sha256', Blob.valueOf(jwt), cert);
      } else {
        Blob privateKey = EncodingUtil.base64Decode(pkcs8);
        signature = Crypto.sign('rsa-sha256', Blob.valueOf(jwt), privateKey);
      }
      jwt += '.' + base64URLencode(signature);
    } else if ( this.alg == NONE ) {
      jwt += '.';
    }

    return jwt;

  }

  public String base64URLencode(Blob input){
    String output = encodingUtil.base64Encode(input);
    output = output.replace('+', '-');
    output = output.replace('/', '_');
    while ( output.endsWith('=')){
      output = output.subString(0,output.length()-1);
    }
    return output;
  }
}