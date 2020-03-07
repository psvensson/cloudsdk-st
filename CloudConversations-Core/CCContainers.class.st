"
I am the superclass for container related things. 
I hold generic collections and methods that can be of use for container creation and management for any cloud provider.
"
Class {
	#name : #CCContainers,
	#superclass : #Object,
	#instVars : [
		'containers',
		'connection',
		'dockerRegistry'
	],
	#category : #'CloudConversations-Core-Containers'
}

{ #category : #'instance creation' }
CCContainers class >> with: aConnection [
	| instance |
	instance := self new.
	instance connection: aConnection .
	^ instance
]

{ #category : #accessing }
CCContainers >> connection [
	^ connection
]

{ #category : #accessing }
CCContainers >> connection: anObject [
	
	connection := anObject.
	self initializeRegistry
]

{ #category : #accessing }
CCContainers >> containers [
	^ containers
]

{ #category : #accessing }
CCContainers >> containers: anObject [
	containers := anObject
]

{ #category : #accessing }
CCContainers >> createContainerForTemplate: aTemplate [
	"create a new container according to the spcification on the cloud provider"
	self subclassResponsibility 
]

{ #category : #accessing }
CCContainers >> delete: aContainerId [
	"Delete the container according to the specific id on the cloud provider"
	self subclassResponsibility 
]

{ #category : #accessing }
CCContainers >> initializeRegistry [
	self subclassResponsibility 
]
