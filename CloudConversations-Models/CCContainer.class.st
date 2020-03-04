Class {
	#name : #CCContainer,
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
	#category : #'CloudConversations-Models'
}

{ #category : #accessing }
CCContainer >> artifacts [
	^ artifacts
]

{ #category : #accessing }
CCContainer >> artifacts: anObject [
	artifacts := anObject at: #images
]

{ #category : #accessing }
CCContainer >> asString [
	^ (artifacts at: 1) 
]

{ #category : #accessing }
CCContainer >> createTime [
	^ createTime
]

{ #category : #accessing }
CCContainer >> createTime: anObject [
	createTime := anObject
]

{ #category : #accessing }
CCContainer >> finishTime [
	^ finishTime
]

{ #category : #accessing }
CCContainer >> finishTime: anObject [
	finishTime := anObject
]

{ #category : #accessing }
CCContainer >> id [
	^ id
]

{ #category : #accessing }
CCContainer >> id: anObject [
	id := anObject
]

{ #category : #accessing }
CCContainer >> images [
	^ images
]

{ #category : #accessing }
CCContainer >> images: anObject [
	images := anObject
]

{ #category : #accessing }
CCContainer >> logUrl [
	^ logUrl
]

{ #category : #accessing }
CCContainer >> logUrl: anObject [
	logUrl := anObject
]

{ #category : #accessing }
CCContainer >> logsBucket [
	^ logsBucket
]

{ #category : #accessing }
CCContainer >> logsBucket: anObject [
	logsBucket := anObject
]

{ #category : #accessing }
CCContainer >> options [
	^ options
]

{ #category : #accessing }
CCContainer >> options: anObject [
	options := anObject
]

{ #category : #accessing }
CCContainer >> projectId [
	^ projectId
]

{ #category : #accessing }
CCContainer >> projectId: anObject [
	projectId := anObject
]

{ #category : #accessing }
CCContainer >> props [
	^ props
]

{ #category : #accessing }
CCContainer >> props: anObject [
	props := anObject
]

{ #category : #accessing }
CCContainer >> results [
	^ results
]

{ #category : #accessing }
CCContainer >> results: anObject [
	results := anObject
]

{ #category : #accessing }
CCContainer >> source [
	^ source
]

{ #category : #accessing }
CCContainer >> source: obj [
	source := (obj at: #storageSource) at: #bucket
]

{ #category : #accessing }
CCContainer >> sourceProvenance [
	^ sourceProvenance 
]

{ #category : #accessing }
CCContainer >> sourceProvenance: obj [
	sourceProvenance := obj
]

{ #category : #accessing }
CCContainer >> startTime [
	^ startTime
]

{ #category : #accessing }
CCContainer >> startTime: anObject [
	startTime := anObject
]

{ #category : #accessing }
CCContainer >> status [
	^ status
]

{ #category : #accessing }
CCContainer >> status: anObject [
	status := anObject
]

{ #category : #accessing }
CCContainer >> steps [
	^ steps
]

{ #category : #accessing }
CCContainer >> steps: anObject [
	steps := (anObject at: 1) at: #args
]

{ #category : #accessing }
CCContainer >> timeout [
	^ timeout
]

{ #category : #accessing }
CCContainer >> timeout: anObject [
	timeout := anObject
]

{ #category : #accessing }
CCContainer >> timing [
	^ timing
]

{ #category : #accessing }
CCContainer >> timing: anObject [
	timing := anObject
]
