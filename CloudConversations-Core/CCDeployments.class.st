Class {
	#name : #CCDeployments,
	#superclass : #Object,
	#instVars : [
		'connection'
	],
	#category : #'CloudConversations-Core-Deployments'
}

{ #category : #'instance creation' }
CCDeployments class >> with: aConnection [
	| instance |
	instance := self new.
	instance connection: aConnection .
	^ instance
]

{ #category : #accessing }
CCDeployments >> connection [
	^ connection
]

{ #category : #accessing }
CCDeployments >> connection: anObject [
	connection := anObject
]

{ #category : #accessing }
CCDeployments >> createDeploymentFromContainer: aContainer [
	self subclassResponsibility 
]

{ #category : #accessing }
CCDeployments >> deleteDeployment: aDeployment [
	self subclassResponsibility 
]

{ #category : #accessing }
CCDeployments >> deploymentRegions [
	self subclassResponsibility 
]

{ #category : #accessing }
CCDeployments >> listDeployments [
	self subclassResponsibility 
]
