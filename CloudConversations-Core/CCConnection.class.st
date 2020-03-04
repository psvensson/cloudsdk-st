"
I am a connection ot a cloud provider. I need a ServiceAccount certificate which I will present to the cloud provider as my identity using my specific mean of connectivity.

I am used to send command to the cloud provider.
"
Class {
	#name : #CCConnection,
	#superclass : #Object,
	#instVars : [
		'serviceAccount',
		'token',
		'client',
		'containers'
	],
	#category : #'CloudConversations-Core-Connectivity'
}

{ #category : #'instance creation' }
CCConnection class >> getNakedPrivateKey: keystring [
	| key |
	key := keystring copyReplaceAll: '-----BEGIN PRIVATE KEY-----\n' with: ''.
	^  key copyReplaceAll: '\n-----END PRIVATE KEY-----\n' with: ''.
]

{ #category : #'instance creation' }
CCConnection class >> with: aServiceAccount [
	| instance |
	instance := self new.
	instance serviceAccount: aServiceAccount.
	^ instance.	
]

{ #category : #accessing }
CCConnection >> connect [
	self subclassResponsibility 
]

{ #category : #accessing }
CCConnection >> getContainerLogic [
	containers isNil
		ifTrue: [ containers := CCContainers with: self ].
	^ containers
]

{ #category : #accessing }
CCConnection >> initialize [ 
	client := ZnClient new.
]

{ #category : #accessing }
CCConnection >> secureJSONCallTo: url [
	client headerAt: 'Authorization' put: 'Bearer ',token.
	client headerAt: 'Accept' put: '*/*'.
	 "headerAt: 'Content-Type' put: 'application/json';"
	client contentReader: [ :entity | NeoJSONReader fromString: entity contents ].
		"request setBearerAuthentication: token;"
	client url: url;
		get.
	^ client contents
]

{ #category : #accessing }
CCConnection >> secureJSONCallTo: url withFile: file as: fileName [
	| value |
	client headerAt: 'Authorization' put: 'Bearer ',token.
	client headerAt: 'Accept' put: '*/*'.
	 "headerAt: 'Content-Type' put: 'application/json';"
	"client contentReader: [ :entity | NeoJSONReader fromString: entity contents ]."
		"request setBearerAuthentication: token;"
	value := file .	
	client url: url; 
		addPart: (ZnMimePart readFrom: value );
		post.
	^ client contents
]

{ #category : #accessing }
CCConnection >> serviceAccount [
	^ serviceAccount
]

{ #category : #accessing }
CCConnection >> serviceAccount: anObject [
	serviceAccount := anObject
]

{ #category : #accessing }
CCConnection >> token [
	^ token
]

{ #category : #accessing }
CCConnection >> token: anObject [
	token := anObject
]
