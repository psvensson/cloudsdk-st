Class {
	#name : #CCContainerBuildResults,
	#superclass : #Object,
	#instVars : [
		'results',
		'options',
		'images',
		'steps',
		'finishTime',
		'timeout',
		'id',
		'startTime',
		'logsBucket',
		'timing',
		'projectId',
		'sourceProvenance',
		'status',
		'createTime',
		'artifacts',
		'logUrl',
		'source',
		'props'
	],
	#classInstVars : [
		'artifacts'
	],
	#category : #'CloudConversations-Models'
}

{ #category : #'instance creation' }
CCContainerBuildResults class >> from: cdict [
	| container manifest |
	container := self new.
	manifest := cdict at: #manifest ifAbsent: [ nil ].
	container
		props: cdict;
		"name: (cdict at: #name ifAbsent: [ (cdict at: #images) at: 1 ]);"
			id: (cdict at: #id ifAbsent: [ nil ]);
		status: (cdict at: #status);
		"artifacts: (cdict at: artifacts ifAbsent: [nil]);"
			createTime: (cdict at: #createTime ifAbsent: [ nil ]);
		finishTime: (cdict at: #finishTime ifAbsent: [ nil ]);
		images: (cdict at: #images ifAbsent: [ nil ]);
		logUrl: (cdict at: #logUrl);
		logsBucket: (cdict at: #logsBucket);
		options: (cdict at: #options);
		source: (cdict at: #source);
		sourceProvenance: (cdict at: #sourceProvenance);
		startTime: (cdict at: #startTime);
		steps: (cdict at: #steps);
		timeout: (cdict at: #timeout).
	(cdict includesKey: #results)
		ifTrue: [ container
				results: (cdict at: #results);
				timing: (cdict at: #timing) ].
	^ container
]

{ #category : #accessing }
CCContainerBuildResults >> artifacts [
	^ artifacts
]

{ #category : #accessing }
CCContainerBuildResults >> artifacts: anObject [
	artifacts := anObject at: #images
]

{ #category : #accessing }
CCContainerBuildResults >> asString [
	^ (images at: 1) 
]

{ #category : #accessing }
CCContainerBuildResults >> createTime [
	^ createTime
]

{ #category : #accessing }
CCContainerBuildResults >> createTime: anObject [
	createTime := anObject
]

{ #category : #accessing }
CCContainerBuildResults >> finishTime [
	^ finishTime
]

{ #category : #accessing }
CCContainerBuildResults >> finishTime: anObject [
	finishTime := anObject
]

{ #category : #accessing }
CCContainerBuildResults >> id [
	^ id
]

{ #category : #accessing }
CCContainerBuildResults >> id: anObject [
	id := anObject
]

{ #category : #accessing }
CCContainerBuildResults >> images [
	^ images
]

{ #category : #accessing }
CCContainerBuildResults >> images: anObject [
	images := anObject
]

{ #category : #accessing }
CCContainerBuildResults >> logUrl [
	^ logUrl
]

{ #category : #accessing }
CCContainerBuildResults >> logUrl: anObject [
	logUrl := anObject
]

{ #category : #accessing }
CCContainerBuildResults >> logsBucket [
	^ logsBucket
]

{ #category : #accessing }
CCContainerBuildResults >> logsBucket: anObject [
	logsBucket := anObject
]

{ #category : #accessing }
CCContainerBuildResults >> options [
	^ options
]

{ #category : #accessing }
CCContainerBuildResults >> options: anObject [
	options := anObject
]

{ #category : #accessing }
CCContainerBuildResults >> projectId [
	^ projectId
]

{ #category : #accessing }
CCContainerBuildResults >> projectId: anObject [
	projectId := anObject
]

{ #category : #accessing }
CCContainerBuildResults >> props [
	^ props
]

{ #category : #accessing }
CCContainerBuildResults >> props: anObject [
	props := anObject
]

{ #category : #accessing }
CCContainerBuildResults >> results [
	^ results
]

{ #category : #accessing }
CCContainerBuildResults >> results: anObject [
	results := anObject
]

{ #category : #accessing }
CCContainerBuildResults >> source [
	^ source
]

{ #category : #accessing }
CCContainerBuildResults >> source: obj [
	source := (obj at: #storageSource) at: #bucket
]

{ #category : #accessing }
CCContainerBuildResults >> sourceProvenance [
	^ sourceProvenance 
]

{ #category : #accessing }
CCContainerBuildResults >> sourceProvenance: obj [
	sourceProvenance := obj
]

{ #category : #accessing }
CCContainerBuildResults >> startTime [
	^ startTime
]

{ #category : #accessing }
CCContainerBuildResults >> startTime: anObject [
	startTime := anObject
]

{ #category : #accessing }
CCContainerBuildResults >> status [
	^ status
]

{ #category : #accessing }
CCContainerBuildResults >> status: anObject [
	status := anObject
]

{ #category : #accessing }
CCContainerBuildResults >> steps [
	^ steps
]

{ #category : #accessing }
CCContainerBuildResults >> steps: anObject [
	steps := (anObject at: 1) at: #args
]

{ #category : #accessing }
CCContainerBuildResults >> timeout [
	^ timeout
]

{ #category : #accessing }
CCContainerBuildResults >> timeout: anObject [
	timeout := anObject
]

{ #category : #accessing }
CCContainerBuildResults >> timing [
	^ timing
]

{ #category : #accessing }
CCContainerBuildResults >> timing: anObject [
	timing := anObject
]
