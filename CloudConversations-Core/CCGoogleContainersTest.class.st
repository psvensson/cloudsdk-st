Class {
	#name : #CCGoogleContainersTest,
	#superclass : #TestCase,
	#instVars : [
		'certificateString'
	],
	#category : #'CloudConversations-Core-Tests'
}

{ #category : #running }
CCGoogleContainersTest >> setUp [
	certificateString := 'service_account.json' asFileReference readStream contents.
]

{ #category : #tests }
CCGoogleContainersTest >> testList [
	| serviceAccount status connection containers result |
	serviceAccount := CCServiceAccount withCertificateAsJSONString: certificateString .	
	connection := CCGoogleConnection with: serviceAccount .
	status := connection connect .
	self assert: status equals: true.
	containers := CCGoogleContainers with: connection.
	result := containers list.
	self assert: (result at: 'nextPageToken') isEmpty equals: false.
	
]
