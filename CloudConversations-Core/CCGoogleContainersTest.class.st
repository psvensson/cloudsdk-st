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
CCGoogleContainersTest >> testCreate [
	| serviceAccount status connection containers result template storage files zipfile archive |
	serviceAccount := CCServiceAccount withCertificateAsJSONString: certificateString .	
	serviceAccount cloudType: 'google'.
	connection := CCGoogleConnection with: serviceAccount .
	status := connection connect .
	self assert: status equals: true.
	containers := CCGoogleContainers with: connection.
	storage := CCStorage with: connection.
	template := CCTemplate new.
	template name: 'foo17'.
	zipfile := template zipArchiveForBuild .
	result := containers uploadFile: zipfile To: storage andCreate: template .
	
	self assert: (result at: #metadata) isEmpty equals: false.
	Transcript show:'container create result: ',((result at: #metadata) at: #build) asString;cr.
	
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
