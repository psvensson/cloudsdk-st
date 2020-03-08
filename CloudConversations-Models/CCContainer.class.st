Class {
	#name : #CCContainer,
	#superclass : #Object,
	#instVars : [
		'dict',
		'name',
		'tags',
		'imageSize',
		'mediaType',
		'timeUploaded',
		'timeCreated',
		'reference'
	],
	#category : #'CloudConversations-Models'
}

{ #category : #accessing }
CCContainer >> dict [
	^ dict
]

{ #category : #accessing }
CCContainer >> dict: anObject [
	dict := anObject
]

{ #category : #'instance creation' }
CCContainer >> fromDict: d [
	| instance |
	instance := self.
	instance dict: d.
	instance imageSize: (d at: #imageSizeBytes).
	instance mediaType: (d at: #mediaType).
	instance name: (d at: #name).
	instance reference: (d at: #reference).
	instance tags: (d at: #tags).
	instance timeCreated: (d at: #timeCreatedMs).
	instance timeUploaded: (d at: #timeUploadedMs).
	^ instance.
]

{ #category : #accessing }
CCContainer >> imageSize: anObject [
	imageSize := anObject
]

{ #category : #accessing }
CCContainer >> imagesize [
	^ imageSize
]

{ #category : #accessing }
CCContainer >> mediaType [
	^ mediaType
]

{ #category : #accessing }
CCContainer >> mediaType: anObject [
	mediaType := anObject
]

{ #category : #accessing }
CCContainer >> name [
	^ name
]

{ #category : #accessing }
CCContainer >> name: anObject [
	name := anObject
]

{ #category : #accessing }
CCContainer >> reference [
	^ reference
]

{ #category : #accessing }
CCContainer >> reference: anObject [
	reference := anObject
]

{ #category : #accessing }
CCContainer >> tags [
	^ tags
]

{ #category : #accessing }
CCContainer >> tags: anObject [
	tags := anObject
]

{ #category : #accessing }
CCContainer >> timeCreated [
	^ timeCreated
]

{ #category : #accessing }
CCContainer >> timeCreated: anObject [
	timeCreated := anObject
]

{ #category : #accessing }
CCContainer >> timeUploaded [
	^ timeUploaded
]

{ #category : #accessing }
CCContainer >> timeUploaded: anObject [
	timeUploaded := anObject
]
