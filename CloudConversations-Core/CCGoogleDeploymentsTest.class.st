Class {
	#name : #CCGoogleDeploymentsTest,
	#superclass : #TestCase,
	#instVars : [
		'certificateString'
	],
	#category : #'CloudConversations-Core-Tests'
}

{ #category : #tests }
CCGoogleDeploymentsTest >> setUp [
	certificateString := 'foobar-app-engine.json' asFileReference readStream contents.
]

{ #category : #tests }
CCGoogleDeploymentsTest >> testCreateDeployment [
	| serviceAccount status connection containers result repositories cdict container deployments  aContainerName tags containerVersions |
	serviceAccount := CCServiceAccount
		withCertificateAsJSONString: certificateString.
	connection := CCGoogleConnection with: serviceAccount.
	status := connection connect.
	self assert: status equals: true.
	containers := CCGoogleContainers with: connection.
	result := containers listContainers.
	self assert: (result at: 'repositories') isEmpty equals: false.
	repositories := result at: #repositories.
	aContainerName := repositories first.
	tags := containers listRepositoryTags: aContainerName .
	containerVersions := tags at: #manifest.
	cdict := CCContainer getLatestContainerVersion: containerVersions.
	cdict at: #name put: aContainerName .
	cdict at: #tags put: (tags at: #tags).
	cdict at: #manifest put: containerVersions .
	container := CCContainer from: cdict.
	deployments := CCGoogleRunDeployments with: connection.
	deployments endpoint: (CCGoogleRunDeployments serviceEndpoints at: 'us-central1').
	deployments createService: 'fooservice' fromContainer: container.
	
	
]

{ #category : #tests }
CCGoogleDeploymentsTest >> testList [
	| serviceAccount status connection deployments result md |
	serviceAccount := CCServiceAccount
		withCertificateAsJSONString: certificateString.
	connection := CCGoogleConnection with: serviceAccount.
	status := connection connect.
	self assert: status equals: true.
	deployments := CCGoogleRunDeployments with: connection.
	deployments endpoint: (CCGoogleRunDeployments serviceEndpoints at: 'us-central1').
	result := deployments listDeployments .
	self assert: (result at: 'items') isEmpty equals: false.
	md := result at: #items.
	md inspect.
	Transcript show:md asString;cr.
	
]
