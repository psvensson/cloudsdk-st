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
		'containers',
		'onStartConnect',
		'onEndConnect'
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
CCConnection >> onEndConnect: aBlock [ 
	onEndConnect := aBlock 
]

{ #category : #accessing }
CCConnection >> onStartConnect: aBlock [ 
	onStartConnect := aBlock 
]

{ #category : #accessing }
CCConnection >> secureJSONCallTo: url [
	^ [ Transcript
		show: url;
		cr.
	client headerAt: 'Authorization' put: 'Bearer ' , token.
	client headerAt: 'Accept' put: '*/*'.
	"headerAt: 'Content-Type' put: 'application/json';"
	client
		contentReader: [ :entity | NeoJSONReader fromString: entity contents ].
	client
		url: url;
		"enforceHttpSuccess: true;"
			ifFail: [ :ex | 
			UIManager default inform: 'Network Error: ' , ex asString.
			Transcript
				show: 'Network error: ' , ex asString;
				cr.
			ex ];
		get.
	self sendEndConnect.
	client contents ] future
]

{ #category : #accessing }
CCConnection >> secureJSONCallTo: url JSONContent: json [
	^ [ self sendStartConnect.
	client headerAt: 'Authorization' put: 'Bearer ' , token.
	client headerAt: 'Accept' put: '*/*'.
	"headerAt: 'Content-Type' put: 'application/json';"
	client
		contentReader: [ :entity | NeoJSONReader fromString: entity contents ].
	"request setBearerAuthentication: token;"
	client
		url: url;
		entity: (ZnEntity with: json type: ZnMimeType applicationJson);
		ifFail: [ :ex | 
			UIManager default
				inform: 'Network Error: ' , ex asString ];
		post.
	self sendEndConnect.
	client contents ] future
]

{ #category : #accessing }
CCConnection >> secureJSONCallTo: url withFile: file as: fileName [
	| value |
	self sendStartConnect .
	client headerAt: 'Authorization' put: 'Bearer ',token.
	client headerAt: 'Accept' put: '*/*'.
	"client headerAt: 'Content-Type' put: 'application/zip'."
	"client contentReader: [ :entity | NeoJSONReader fromString: entity contents ]."
		"request setBearerAuthentication: token;"
	value := ReadStream on: file .	
	client url: url; 
		"addPart: (ZnMimePart readFrom: value );"
		"addPart: (ZnMimePart fieldName: fileName value: file);
		headerAt: 'Content-Type' put: 'application/zip';"
		entity: (
      ZnEntity
        readBinaryFrom: value   
        usingType: (ZnMimeType main: 'application' sub:'zip')
		 andLength: file size);
		ifFail: [ :ex | 
			UIManager default
				inform: 'Network Error: ' , ex asString ];
		post.
	self sendEndConnect .	
	^ client contents
]

{ #category : #accessing }
CCConnection >> sendEndConnect [
	onEndConnect ifNotNil: [ onEndConnect value ]
]

{ #category : #accessing }
CCConnection >> sendStartConnect [
	onStartConnect ifNotNil: [ onStartConnect value ]
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
