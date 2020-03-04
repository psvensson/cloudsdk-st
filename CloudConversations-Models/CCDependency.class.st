Class {
	#name : #CCDependency,
	#superclass : #Object,
	#instVars : [
		'name',
		'type',
		'repository',
		'baseline',
		'configuration',
		'addPackage',
		'installString'
	],
	#category : #'CloudConversations-Models'
}

{ #category : #accessing }
CCDependency >> addPackage [
	^ addPackage
]

{ #category : #accessing }
CCDependency >> addPackage: anObject [
	addPackage := anObject
]

{ #category : #accessing }
CCDependency >> asString [
	^ name
]

{ #category : #accessing }
CCDependency >> baseline [
	^ baseline
]

{ #category : #accessing }
CCDependency >> baseline: anObject [
	baseline := anObject
]

{ #category : #accessing }
CCDependency >> configuration [
	^ configuration
]

{ #category : #accessing }
CCDependency >> configuration: anObject [
	configuration := anObject
]

{ #category : #accessing }
CCDependency >> installString [
	^ installString
]

{ #category : #accessing }
CCDependency >> installString: anObject [
	installString := anObject
]

{ #category : #accessing }
CCDependency >> name [
	^ name
]

{ #category : #accessing }
CCDependency >> name: anObject [
	name := anObject
]

{ #category : #accessing }
CCDependency >> repository [
	^ repository
]

{ #category : #accessing }
CCDependency >> repository: anObject [
	repository := anObject
]

{ #category : #accessing }
CCDependency >> type [
	^ type
]

{ #category : #accessing }
CCDependency >> type: anObject [
	type := anObject
]
