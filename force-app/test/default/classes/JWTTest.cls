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
private class JWTTest {

  @isTest static void testJwtNone() {
    JWT jwt = new JWT('none');
    jwt.iss = 'your issuer';
    jwt.sub = 'some subject';
    jwt.aud = 'some audience';

    System.assert(jwt.issue().startsWith('eyJhbGciOiJub25lIn0'));
  }

  @isTest static void testJwtHs256() {
    JWT jwt = new JWT('HS256');
    jwt.privateKey = 'base64 encoded secret';
    jwt.iss = 'your issuer';
    jwt.sub = 'some subject';
    jwt.aud = 'some audience';

    System.assert(jwt.issue().startsWith('eyJhbGciOiJIUzI1NiJ9'));
  }

  @isTest static void testJwtRs256() {
    JWT jwt = new JWT('RS256');
    jwt.pkcs8 = 'MIIBVgIBADANBgkqhkiG9w0BAQEFAASCAUAwggE8AgEAAkEAq7BFUpkGp3+LQmlQ' +
    'Yx2eqzDV+xeG8kx/sQFV18S5JhzGeIJNA72wSeukEPojtqUyX2J0CciPBh7eqclQ' +
    '2zpAswIDAQABAkAgisq4+zRdrzkwH1ITV1vpytnkO/NiHcnePQiOW0VUybPyHoGM' +
    '/jf75C5xET7ZQpBe5kx5VHsPZj0CBb3b+wSRAiEA2mPWCBytosIU/ODRfq6EiV04' +
    'lt6waE7I2uSPqIC20LcCIQDJQYIHQII+3YaPqyhGgqMexuuuGx+lDKD6/Fu/JwPb' +
    '5QIhAKthiYcYKlL9h8bjDsQhZDUACPasjzdsDEdq8inDyLOFAiEAmCr/tZwA3qeA' +
    'ZoBzI10DGPIuoKXBd3nk/eBxPkaxlEECIQCNymjsoI7GldtujVnr1qT+3yedLfHK' +
    'srDVjIT3LsvTqw==';
    jwt.iss = 'your issuer';
    jwt.sub = 'some subject';
    jwt.aud = 'some audience';

    System.assert(jwt.issue().startsWith('eyJhbGciOiJSUzI1NiJ9'));
  }
}