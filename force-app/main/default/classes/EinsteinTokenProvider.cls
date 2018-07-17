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

public class EinsteinTokenProvider implements TokenProvider {

  public static TokenProvider forProfile(String profileName) {
    return new EinsteinTokenProvider(profileName);
  }

  public static TokenProvider forDefaultProfile() {
    return new EinsteinTokenProvider(DEFAULT_SECURITY_PROFILE);
  }

  private static final Integer EXPIRY = 43200; // 12 hours

  private static final String BASE_URL = 'https://api.einstein.ai/v2';
  private static final String OAUTH2 = BASE_URL + '/oauth2/token';
  private static final String SESSION_TOKEN_KEY = 'einsteinSessionToken';

  private static final String DEFAULT_SECURITY_PROFILE = 'DefaultProfileLj2mLH';

  private final String securityProfileName;

  private EinsteinTokenProvider(String securityProfileName) {
    this.securityProfileName = securityProfileName;
  }

  public String getToken() {
    try {
      // if Token in Org cache, use token
      System.debug('Check Session Cache for token');
      String cachedToken = getCachedToken();
      if (String.isNotEmpty(cachedToken)) {
        return cachedToken;
      }

      // otherwise, request new token and save in org cache
      System.debug('No token in cache, requesting new token');
      JWTBearerFlow.AccessTokenInfo tokenRequestResult = requestNewToken();
      
      setTokenCache(tokenRequestResult);

      return tokenRequestResult.token;
    } catch (Exception ex) {
      throw new EinsteinTokenProviderException(ex);
    }
  }

  private void setTokenCache(JWTBearerFlow.AccessTokenInfo tokenInfo) {
    try {
      Cache.Org.put(getTokenCacheKey(), tokenInfo.token, tokenInfo.expiresIn - 60);
    } catch (Exception ex) {
      System.debug('Failed to access platform cache: ' + ex.getMessage());
    }
  }

  private String getCachedToken() {
    try {
      return (String) Cache.Org.get(getTokenCacheKey());
    } catch (Exception ex) {
      System.debug('Failed to access platform cache: ' + ex.getMessage());
      return null;
    }
  }

  private JWTBearerFlow.AccessTokenInfo requestNewToken() {
    Einstein_Security_Profile__mdt securityProfile = getSecurityProfile();

    String keyContents = securityProfile.RSA_Key__c;
    keyContents = keyContents.replace('-----BEGIN RSA PRIVATE KEY-----', '');
    keyContents = keyContents.replace('-----END RSA PRIVATE KEY-----', '');
    keyContents = keyContents.deleteWhitespace();

    JWT jwt = new JWT('RS256');
    jwt.pkcs8 = keyContents;
    jwt.iss = 'developer.force.com';
    jwt.sub = securityProfile.Account_Email__c;
    jwt.aud = OAUTH2;
    jwt.validFor = EXPIRY;

    return JWTBearerFlow.getAccessToken(OAUTH2, jwt);
  }

  private Einstein_Security_Profile__mdt getSecurityProfile() {
    if (securityProfileName == DEFAULT_SECURITY_PROFILE) {
      return getDefaultSecurityProfile();
    }

    return [SELECT Account_Email__c, RSA_Key__c FROM Einstein_Security_Profile__mdt WHERE DeveloperName = :securityProfileName];
  }

  private Einstein_Security_Profile__mdt getDefaultSecurityProfile() {
    try {
      return [SELECT Account_Email__c, RSA_Key__c FROM Einstein_Security_Profile__mdt WHERE Is_Default_Profile__c = TRUE];
    } catch (QueryException ex) {
      throw new DefaultProfileCouldNotBeLoadedException('The default Einstein Security Profile could not be retrieved. Details: ' + ex.getMessage(), ex);
    }
  }

  private String getTokenCacheKey() {
    return SESSION_TOKEN_KEY + securityProfileName;
  }

  public class DefaultProfileCouldNotBeLoadedException extends Exception { }
  public class EinsteinTokenProviderException extends Exception { }
}