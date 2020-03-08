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
	| serviceAccount status connection containers result repositories |
	serviceAccount := CCServiceAccount
		withCertificateAsJSONString: certificateString.
	connection := CCGoogleConnection with: serviceAccount.
	status := connection connect.
	self assert: status equals: true.
	containers := CCGoogleContainers with: connection.
	result := containers listContainers.
	self assert: (result at: 'repositories') isEmpty equals: false.
	repositories := result at: #repositories.
	repositories
		do: [ :each |
			| tags digest name manifest |
			tags := containers listRepositoryTags: each. 
			tags inspect.
			digest := (tags at: #manifest) keys first.
			name := tags at: #name.
			"manifest := containers getContainerManifestByName: name andReference: digest.
			manifest inspect."
			Transcript show: name,' -> ',digest;cr ]
]
