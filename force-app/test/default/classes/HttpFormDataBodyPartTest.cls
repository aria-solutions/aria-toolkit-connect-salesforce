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

HttpFormDataBodyPart; Oct 01, 2017 -- https://salesforce.stackexchange.com/questions/132135/how-can-i-compose-a-multipart-form-data-request

License MIT
*/

@isTest
private class HttpFormDataBodyPartTest {

  @isTest static void testGetBoundary() {
    System.assertEquals('1ff13444ed8140c7a32fc4e6451aa76d', HttpFormDataBodyPart.getBoundary());
  }

  @isTest static void testGetContentType() {
    System.assertEquals('multipart/form-data; charset="UTF-8"; boundary="1ff13444ed8140c7a32fc4e6451aa76d"', HttpFormDataBodyPart.GetContentType());
  }

  @isTest static void testWriteBlobBodyParameter() {
    System.assertEquals('Q29udGVudC1EaXNwb3NpdGlvbjogZm9ybS1kYXRhOyBuYW1lPSJzb21lS2V5IjsgZmlsZW5hbWU9ImZpbGVOYW1lLnBuZyIgIA0KQ29udGVudC1UeXBlOiBpbWFnZS9wbmcNCg0KsomeFileContentDQotLTFmZjEzNDQ0ZWQ4MTQwYzdhMzJmYzRlNjQ1MWFhNzZkLS0=',
      HttpFormDataBodyPart.WriteBlobBodyParameter('someKey', 'someFileContent', 'fileName.png'));
  }
}