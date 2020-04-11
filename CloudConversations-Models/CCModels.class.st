Class {
	#name : #CCModels,
	#superclass : #Object,
	#instVars : [
		'accounts',
		'containers',
		'deployments',
		'templates',
		'selectedEndpoint',
		'selectedZone'
	],
	#category : #'CloudConversations-Models'
}

{ #category : #accessing }
CCModels >> accounts [
	^ accounts
]

{ #category : #accessing }
CCModels >> accounts: anObject [
	accounts := anObject
]

{ #category : #accessing }
CCModels >> containers [
	^ containers
]

{ #category : #accessing }
CCModels >> containers: anObject [
	containers := anObject
]

{ #category : #accessing }
CCModels >> deployments [
	^ deployments
]

{ #category : #accessing }
CCModels >> deployments: anObject [
	deployments := anObject
]

{ #category : #accessing }
CCModels >> initialize [ 
	accounts := OrderedCollection new.
	containers  := OrderedCollection new.
	deployments  := OrderedCollection new.
	templates  := OrderedCollection new.
	selectedEndpoint :=	CCGoogleRunDeployments serviceEndpoints at: 'us-central1'
]

{ #category : #accessing }
CCModels >> selectedEndpoint [
	selectedEndpoint isNil
		ifTrue: [ selectedEndpoint := CCGoogleRunDeployments serviceEndpoints
				at: 'us-central1' ].
	^ selectedEndpoint
]

{ #category : #accessing }
CCModels >> selectedEndpoint: anObject [
	selectedEndpoint := anObject
]

{ #category : #accessing }
CCModels >> selectedZone [
selectedZone isNil ifTrue: [ selectedZone := 'us-central1-a' ].
	^ selectedZone
]

{ #category : #accessing }
CCModels >> selectedZone: anObject [
	selectedZone := anObject
]

{ #category : #accessing }
CCModels >> templates [
	^ templates
]

{ #category : #accessing }
CCModels >> templates: anObject [
	templates := anObject
]
