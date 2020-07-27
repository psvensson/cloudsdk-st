Class {
	#name : #CCDeployment,
	#superclass : #Object,
	#instVars : [
		'dict',
		'name',
		'tags',
		'containerConcurrency',
		'timeoutSeconds',
		'image',
		'port',
		'cpu',
		'memory',
		'maxScale',
		'traffic',
		'apiVersion',
		'kind',
		'generation',
		'latestReadyRevisionName',
		'url',
		'uid',
		'creationTimestamp',
		'namespace',
		'annotations',
		'status',
		'type',
		'container'
	],
	#category : #'CloudConversations-Models'
}

{ #category : #'instance creation' }
CCDeployment class >> from: cdict type: type [
	cdict at: #type put: type.
	type = 'cloudrun' ifTrue: [ ^ self fromCloudRun: cdict].
	type = 'computeengine' ifTrue: [ ^ self fromComputeEngine: cdict].
]

{ #category : #'instance creation' }
CCDeployment class >> fromCloudRun: cdict [
	| c spec m url |
	spec := self getSpec: cdict.
	m := (((cdict at: #status) at: #conditions) at: 1) asString.
	url := (cdict at: #status) at: #url ifAbsent: [ '' ].
	Transcript
		show: 'CCDeployment::fromCloudRun message -> ' , m;
		cr.
	c := self new.
	c
		dict: cdict;
		type: (cdict at: #type);
		annotations: ((cdict at: #metadata) at: #annotations);
		apiVersion: (cdict at: #apiVersion);
		containerConcurrency: (spec at: #containerConcurrency);
		container: (self getContainer: cdict);
		timeoutSeconds: ((((cdict at: #spec) at: #template) at: #spec) at: #timeoutSeconds);
		name: ((((cdict at: #spec) at: #template) at: #metadata) at: #name);
		annotations: ((((cdict at: #spec) at: #template) at: #metadata) at: #annotations);
		traffic: ((cdict at: #spec) at: #traffic);
		uid: ((cdict at: #metadata) at: #uid);
		generation: ((cdict at: #metadata) at: #generation);
		creationTimestamp: ((cdict at: #metadata) at: #creationTimestamp);
		namespace: ((cdict at: #metadata) at: #namespace);
		url: url.
	^ c
]

{ #category : #'instance creation' }
CCDeployment class >> fromComputeEngine: cdict [
	| c |
	c := self new.
	c
		dict: cdict;
		type: (cdict at: #type);
		status: (cdict at: #status);
		name: (cdict at: #name);
		tags: (cdict at: #tags) values first;
		creationTimestamp: (cdict at: #creationTimestamp);
		url:
			(((cdict at: #networkInterfaces) first at: #accessConfigs) first
				at: #natIP).
	^ c
]

{ #category : #'instance creation' }
CCDeployment class >> getContainer: cdict [
	| spec image |
	spec := self getSpec: cdict.
	image := ((spec at: #containers) at: 1) at: #image.
	^ (image includesSubstring: '@')
		ifTrue: [ (image substrings: '@') at: 1 ]
		ifFalse: [ image ]
]

{ #category : #'instance creation' }
CCDeployment class >> getSpec: cdict [
	^  ((cdict at: #spec) at: #template) at: #spec
]

{ #category : #accessing }
CCDeployment >> annotations [
	^ annotations
]

{ #category : #accessing }
CCDeployment >> annotations: anObject [
	annotations := anObject
]

{ #category : #accessing }
CCDeployment >> apiVersion [
	^ apiVersion
]

{ #category : #accessing }
CCDeployment >> apiVersion: anObject [
	apiVersion := anObject
]

{ #category : #accessing }
CCDeployment >> asString [
	^ self name
]

{ #category : #accessing }
CCDeployment >> container [
	^ container
]

{ #category : #accessing }
CCDeployment >> container: aContainer [
	container := aContainer
]

{ #category : #accessing }
CCDeployment >> containerConcurrency [
	^ containerConcurrency
]

{ #category : #accessing }
CCDeployment >> containerConcurrency: anObject [
	containerConcurrency := anObject
]

{ #category : #accessing }
CCDeployment >> cpu [
	^ cpu
]

{ #category : #accessing }
CCDeployment >> cpu: anObject [
	cpu := anObject
]

{ #category : #accessing }
CCDeployment >> creationTimestamp [
	^ creationTimestamp
]

{ #category : #accessing }
CCDeployment >> creationTimestamp: anObject [
	creationTimestamp := anObject
]

{ #category : #accessing }
CCDeployment >> dict [
	^ dict
]

{ #category : #accessing }
CCDeployment >> dict: anObject [
	dict := anObject
]

{ #category : #accessing }
CCDeployment >> generation [
	^ generation
]

{ #category : #accessing }
CCDeployment >> generation: anObject [
	generation := anObject
]

{ #category : #accessing }
CCDeployment >> icon [
	^ CCImages iconFrom: type
]

{ #category : #accessing }
CCDeployment >> image [
	^ image
]

{ #category : #accessing }
CCDeployment >> image: anObject [
	image := anObject
]

{ #category : #accessing }
CCDeployment >> kind [
	^ kind
]

{ #category : #accessing }
CCDeployment >> kind: anObject [
	kind := anObject
]

{ #category : #accessing }
CCDeployment >> latestReadyRevisionName [
	^ latestReadyRevisionName
]

{ #category : #accessing }
CCDeployment >> latestReadyRevisionName: anObject [
	latestReadyRevisionName := anObject
]

{ #category : #accessing }
CCDeployment >> maxScale [
	^ maxScale
]

{ #category : #accessing }
CCDeployment >> maxScale: anObject [
	maxScale := anObject
]

{ #category : #accessing }
CCDeployment >> memory [
	^ memory
]

{ #category : #accessing }
CCDeployment >> memory: anObject [
	memory := anObject
]

{ #category : #accessing }
CCDeployment >> name [
	^ name
]

{ #category : #accessing }
CCDeployment >> name: anObject [
	name := anObject
]

{ #category : #accessing }
CCDeployment >> namespace [
	^ namespace
]

{ #category : #accessing }
CCDeployment >> namespace: anObject [
	namespace := anObject
]

{ #category : #accessing }
CCDeployment >> port [
	^ port
]

{ #category : #accessing }
CCDeployment >> port: anObject [
	port := anObject
]

{ #category : #accessing }
CCDeployment >> status [
	^ status
]

{ #category : #accessing }
CCDeployment >> status: anObject [
	status := anObject
]

{ #category : #accessing }
CCDeployment >> tags [
	^ tags
]

{ #category : #accessing }
CCDeployment >> tags: anObject [
	tags := anObject
]

{ #category : #accessing }
CCDeployment >> timeoutSeconds [
	^ timeoutSeconds
]

{ #category : #accessing }
CCDeployment >> timeoutSeconds: anObject [
	timeoutSeconds := anObject
]

{ #category : #accessing }
CCDeployment >> traffic [
	^ traffic
]

{ #category : #accessing }
CCDeployment >> traffic: anObject [
	traffic := anObject
]

{ #category : #accessing }
CCDeployment >> type [
	^ type
]

{ #category : #accessing }
CCDeployment >> type: anObject [
	type := anObject
]

{ #category : #accessing }
CCDeployment >> uid [
	^ uid
]

{ #category : #accessing }
CCDeployment >> uid: anObject [
	uid := anObject
]

{ #category : #accessing }
CCDeployment >> url [
	^ url
]

{ #category : #accessing }
CCDeployment >> url: anObject [
	url := anObject
]
