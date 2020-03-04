Class {
	#name : #CCGoogleConnectionTest,
	#superclass : #TestCase,
	#instVars : [
		'certificateString'
	],
	#category : #'CloudConversations-Core-Tests'
}

{ #category : #tests }
CCGoogleConnectionTest >> setUp [
	certificateString := 'service_account.json' asFileReference readStream contents.
]

{ #category : #tests }
CCGoogleConnectionTest >> testCreateJWTForServiceAccount [
	| serviceAccount |
	serviceAccount := CCServiceAccount withCertificateAsJSONString: certificateString .	
	CCGoogleConnection createJWTForServiceAccount: serviceAccount .
]

{ #category : #tests }
CCGoogleConnectionTest >> testRequestAccessTokenForJWT [
	| serviceAccount jwt result |
	serviceAccount := CCServiceAccount withCertificateAsJSONString: certificateString .	
	jwt := CCGoogleConnection createJWTForServiceAccount: serviceAccount .
	result := CCGoogleConnection requestAccessTokenForJWT: jwt.
	"Transcript show: result;cr."
	self assert: result isEmpty equals: false
]
