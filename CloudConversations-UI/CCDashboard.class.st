Class {
	#name : #CCDashboard,
	#superclass : #RTInteractiveTreeBuilder,
	#category : #'CloudConversations-UI-Main'
}

{ #category : #initialization }
CCDashboard >> getHierarchy [
	| templates containers deployments |
	"For all templates, add a collection for a container it has been used to create.
	For each container collection item, add a collection of all deployments made using
	that container"
	templates := OrderedCollection new.
	
	^ templates 
]

{ #category : #initialization }
CCDashboard >> initialize [ 
	super initialize.
	self initializeView
]

{ #category : #initialization }
CCDashboard >> initializeView [
	self view canvas color: (Color colorFrom: '#EEE').
]

{ #category : #initialization }
CCDashboard >> updateView [
	self explore: self getHierarchy.
	self rightward.
"b leftward."
	self gap: 200 @ 10.
	self build.
	^ self view
]
