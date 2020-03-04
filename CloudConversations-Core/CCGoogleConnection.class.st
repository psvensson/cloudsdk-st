"
POST https://cloudbuild.googleapis.com/v1/projects/foobar-6e993/builds?key=[YOUR_API_KEY] HTTP/1.1

Authorization: Bearer [YOUR_ACCESS_TOKEN]
Accept: application/json
Content-Type: application/json

{
  ""source"": {
    ""storageSource"": {
      ""bucket"": ""foobar-6e993.appspot.com"",
      ""object"": ""install.zip""
    }
  },
  ""steps"": [
    {
      ""name"": ""gcr.io/cloud-builders/docker"",
      ""args"": [
        ""build"",
        ""-t"",
        ""gcr.io/foobar-6e993/pharotest"",
        "".""
      ]
    }
  ],
  ""images"": [
    ""gcr.io/foobar-6e993/pharotest""
  ]
}

"
Class {
	#name : #CCGoogleConnection,
	#superclass : #CCConnection,
	#category : #'CloudConversations-Core-Connectivity'
}

{ #category : #generating }
CCGoogleConnection class >> createJWTForServiceAccount: aServiceAccount [
	| jws cert iat exp |
	cert := aServiceAccount certificate.
	iat := (DateAndTime now) asUnixTime.
	exp := iat + (59 * 60).
	jws := JsonWebSignature new
		algorithmName: 'RS256';
		payload:
			(JWTClaimsSet new
				at: 'iss' put: (cert at: 'client_email');
				at: 'scope'
					put: 'https://www.googleapis.com/auth/cloud-platform';
				at: 'aud' put: 'https://oauth2.googleapis.com/token';
				at: 'exp' put: exp;
				at: 'iat' put: iat).
	jws key: ( CCConnection getNakedPrivateKey: (cert at: 'private_key')).
	^ jws compactSerialized
]

{ #category : #generating }
CCGoogleConnection class >> requestAccessTokenForJWT: aJWT [
	| client result |
	
	(client := ZnClient new)
			url: 'https://oauth2.googleapis.com';
			addPath: 'token';
			formAt: 'grant_type' put: 'urn:ietf:params:oauth:grant-type:jwt-bearer';
			formAdd: 'assertion' -> aJWT ;
			post.
	result := NeoJSONObject fromString: client contents.		
	^ result at: 'access_token'
]

{ #category : #accessing }
CCGoogleConnection >> connect [
	| jwt |
	jwt := self class createJWTForServiceAccount: serviceAccount.
	token := self class requestAccessTokenForJWT: jwt.
	^ token isEmpty not
]
