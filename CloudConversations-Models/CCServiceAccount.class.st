"
I hold the cryoptographic certificate of a service account for a cloud provider.
I am the way in which all communication with a cloud provider can be tied to a specific identity.
------------
"
Class {
	#name : #CCServiceAccount,
	#superclass : #Object,
	#instVars : [
		'certificate',
		'cloudType',
		'name',
		'jsonStringCertificate'
	],
	#category : #'CloudConversations-Models'
}

{ #category : #'instance creation' }
CCServiceAccount class >> with: aCertificate [
	^ self new certificate: aCertificate 
]

{ #category : #'instance creation' }
CCServiceAccount class >> withCertificateAsJSONString: aString [
	^ self new certificateAsJSONString: aString
]

{ #category : #accessing }
CCServiceAccount >> asString [
	^ self name 
]

{ #category : #accessing }
CCServiceAccount >> certificate [
	^ certificate
]

{ #category : #accessing }
CCServiceAccount >> certificate: anObject [
	certificate := anObject
]

{ #category : #accessing }
CCServiceAccount >> certificateAsJSONString: aString [
	| reader |
	jsonStringCertificate := aString .
	reader := [ :string | (NeoJSONReader on: string readStream) next ].
	certificate := reader value: aString .
]

{ #category : #accessing }
CCServiceAccount >> cloudType [
	^ cloudType
]

{ #category : #accessing }
CCServiceAccount >> cloudType: anObject [
	cloudType := anObject
]

{ #category : #accessing }
CCServiceAccount >> icon [
	^ CCImages iconFrom: cloudType 
]

{ #category : #accessing }
CCServiceAccount >> jsonStringCertificate [
	^ jsonStringCertificate
]

{ #category : #accessing }
CCServiceAccount >> jsonStringCertificate: anObject [
	jsonStringCertificate := anObject
]

{ #category : #accessing }
CCServiceAccount >> name [
	^ name isNil ifTrue: [certificate at: #client_email] ifFalse: [ name ]
]

{ #category : #accessing }
CCServiceAccount >> name: anObject [
	name := anObject
]

{ #category : #accessing }
CCServiceAccount >> projectId [
	^ certificate at: 'project_id'
]
