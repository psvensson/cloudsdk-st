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

{ #category : #'as yet unclassified' }
CCGoogleConnection class >> zones [
	| zones |
	zones := #(
		'asia-east1-a'
		'asia-east1-b'
		'asia-east1-c'
		'asia-east2-a'
		'asia-east2-b'
		'asia-east2-c'
		'asia-northeast1-a'
		'asia-northeast1-b'
		'asia-northeast1-c'
		'asia-northeast2-a'
		'asia-northeast2-b'
		'asia-northeast2-c'
		'asia-northeast3-a'
		'asia-northeast3-b'
		'asia-northeast3-c'
		'asia-south1-a'
		'asia-south1-b'
		'asia-south1-c'
		'asia-southeast1-a'
		'asia-southeast1-b'
		'asia-southeast1-c'
		'australia-southeast1-a'
		'australia-southeast1-b'
		'australia-southeast1-c'
		'europe-north1-a'
		'europe-north1-b'
		'europe-north1-c'
		'europe-west1-b'
		'europe-west1-c'
		'europe-west1-d'
		
		'europe-west2-a'
		'europe-west2-b'
		'europe-west2-c'
		
		'europe-west3-a'
		'europe-west3-b'
		'europe-west3-c'
		
		'europe-west4-a'
		'europe-west4-b'
		'europe-west4-c'
		
		'europe-west5-a'
		'europe-west5-b'
		'europe-west5-c'
		
		'europe-west6-a'
		'europe-west6-b'
		'europe-west6-c'
		
		'northamerica-northeast1-a'
		'northamerica-northeast1-b'
		'northamerica-northeast1-c'
		
		'southamerica-east1-a'
		'southamerica-east1-b'
		'southamerica-east1-c'
		
		'us-central1-a'
		'us-central1-b'
		'us-central1-c'
		'us-central1-d'
		
		'us-east1-b' 	
		'us-east1-c' 	
		'us-east1-d'
		
	 	'us-east4-a' 	
		'us-east4-b' 	
		'us-east4-c'	
			
		'us-west1-a'	
		'us-west1-b'	
		'us-west1-c'			
		
		'us-west2-a'	
		'us-west2-b'	
		'us-west2-c'	
			
		'us-west3-a'	
		'us-west3-b'	
		'us-west3-c'		
	).
	^ zones 
]

{ #category : #accessing }
CCGoogleConnection >> connect [
	| jwt |
	jwt := self class createJWTForServiceAccount: serviceAccount.
	Transcript show:'CCGoogleConnection connect called for service account ',serviceAccount name;cr.
	token := self class requestAccessTokenForJWT: jwt.
	^ token isEmpty not
]
