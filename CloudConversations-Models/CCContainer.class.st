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
		'reference',
		'image',
		'fromTemplate',
		'fromTemplateVersion'
	],
	#category : #'CloudConversations-Models'
}

{ #category : #'instance creation' }
CCContainer class >> from: cdict [
	| container manifest |
	container := self new.	
	manifest := cdict at: #manifest ifAbsent: [nil].
	container
		dict: cdict ;
		name: (cdict at: #name ifAbsent: [ (cdict at: #images) at: 1 ]);
		tags: (cdict at: #tags ifAbsent: [nil]);
		reference: (manifest isNil ifFalse: [manifest keys first]);
		imageSize: (cdict at: #imageSizeBytes ifAbsent: [nil]);
		mediaType: (cdict at: #mediaType ifAbsent: [nil]);
		timeUploaded: (cdict at: #timeUploadedMs ifAbsent: [nil]);
		timeCreated: (cdict at: #timeCreatedMs ifAbsent: [nil]).
	^ container
]

{ #category : #initialization }
CCContainer class >> getLatestContainerVersion: containerVersions [
	| values curriedVersions |
	curriedVersions := Dictionary new.
	containerVersions keysAndValuesDo: [ :key :value | 
		value at: #reference put: key.
		curriedVersions at: key put: value ].
	values := containerVersions values.
	values sort: [ :a :b | (a at: #timeCreatedMs) > (b at: #timeCreatedMs) ].
	^ values first.
]

{ #category : #accessing }
CCContainer >> asString [
	^ name
]

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
CCContainer >> fromTemplate [
	^ fromTemplate
]

{ #category : #accessing }
CCContainer >> fromTemplate: anObject [
	fromTemplate := anObject
]

{ #category : #accessing }
CCContainer >> fromTemplateVersion [
	^ fromTemplateVersion
]

{ #category : #accessing }
CCContainer >> fromTemplateVersion: anObject [
	fromTemplateVersion := anObject
]

{ #category : #accessing }
CCContainer >> getCreationSpec [
	|s|
	s := Dictionary new.
	s at: #image put: 'https://gcr.io/',name.
	s at: #command put: #().
	^ s
]

{ #category : #accessing }
CCContainer >> image [
	^ image
]

{ #category : #accessing }
CCContainer >> image: i [
	image := i
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
