Class {
	#name : #CCContainerRowModel,
	#superclass : #Object,
	#instVars : [
		'property',
		'value'
	],
	#category : #'CloudConversations-Models'
}

{ #category : #accessing }
CCContainerRowModel >> property [
	^ property
]

{ #category : #accessing }
CCContainerRowModel >> property: anObject [
	property := anObject
]

{ #category : #accessing }
CCContainerRowModel >> value [
	^ value
]

{ #category : #accessing }
CCContainerRowModel >> value: anObject [
	value := anObject
]
