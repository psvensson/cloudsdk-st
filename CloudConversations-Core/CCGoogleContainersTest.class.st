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
	certificateString := 'foobar-6e993-compute-engine.json' asFileReference readStream contents.
]

{ #category : #tests }
CCGoogleContainersTest >> testCreate [
	| serviceAccount status connection containers template storage zipfile |
	serviceAccount := CCServiceAccount
		withCertificateAsJSONString: certificateString.
	serviceAccount cloudType: 'google'.
	connection := CCGoogleConnection with: serviceAccount.
	status := connection connect.
	self assert: status equals: true.
	containers := CCGoogleContainers with: connection.
	storage := CCStorage with: connection.
	template := CCTemplate new.
	template name: 'foo18'.
	zipfile := template zipArchiveForBuildWith: serviceAccount .
	(containers
		uploadFile: zipfile
		as: 'foo18'
		To: storage
		andCreate: template
		type: 'run')
		onSuccessDo: [ :result | 
			"result inspect."
			"self assert: (result at: #metadata) isEmpty equals: false."
			Transcript
				show:
					'container create result: '
						, ((result at: #metadata) at: #build) asString;
				cr ]
]

{ #category : #tests }
CCGoogleContainersTest >> testList [
	| serviceAccount status connection containers repositories |
	serviceAccount := CCServiceAccount
		withCertificateAsJSONString: certificateString.
	connection := CCGoogleConnection with: serviceAccount.
	status := connection connect.
	self assert: status equals: true.
	containers := CCGoogleContainers with: connection.
	containers listContainers
		onSuccessDo: [ :result | 
			self assert: (result at: #child) isEmpty equals: false.
			repositories := result at: #child.
			repositories
				do: [ :each | 
					| digest name manifest |
					(containers listRepositoryTags: each)
						onSuccessDo: [ :tags | 							
							digest := (tags at: #manifest) keys first.
							name := tags at: #name.
							"manifest := containers getContainerManifestByName: name andReference: digest."
							"manifest inspect."
							Transcript
								show: name , ' -> ' , digest;
								cr ] ] ]
]

{ #category : #tests }
CCGoogleContainersTest >> testListOccurences [
	| serviceAccount connection containers repositories |
	serviceAccount := CCServiceAccount
		withCertificateAsJSONString: certificateString.
	connection := CCGoogleConnection with: serviceAccount.
	connection connect.
	containers := CCGoogleContainers with: connection.
	containers listContainerAnalysis
		onSuccessDo: [ :result | 
			result inspect.
			self assert: (result at: #child) isEmpty equals: false.
			repositories := result at: #child ];
		onFailureDo: [ :err | err inspect ] future
]
