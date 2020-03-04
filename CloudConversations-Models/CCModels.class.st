Class {
	#name : #CCModels,
	#superclass : #Object,
	#instVars : [
		'accounts',
		'containers',
		'deployments',
		'templates'
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
]

{ #category : #accessing }
CCModels >> templates [
	^ templates
]

{ #category : #accessing }
CCModels >> templates: anObject [
	templates := anObject
]
