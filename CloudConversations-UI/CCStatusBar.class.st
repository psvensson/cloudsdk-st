Class {
	#name : #CCStatusBar,
	#superclass : #Morph,
	#instVars : [
		'loadingIcon',
		'loadingText',
		'alpha'
	],
	#category : #'CloudConversations-UI-Main'
}

{ #category : #'class initialization' }
CCStatusBar >> contents: text [ 
	loadingText contents: text
]

{ #category : #'class initialization' }
CCStatusBar >> fullDrawOn: aCanvas [

	super fullDrawOn: (aCanvas asAlphaBlendingCanvas: alpha)
]

{ #category : #'class initialization' }
CCStatusBar >> hide [ 
	alpha := 0.
	self changed
]

{ #category : #'class initialization' }
CCStatusBar >> initialize [
	super initialize.
	loadingIcon := CCImages animatedImage: 'loading1'.
	loadingText := TextMorph new contents: ''.
	self addMorph: loadingIcon.
	self addMorph: loadingText
]

{ #category : #'class initialization' }
CCStatusBar >> show [
	alpha := 1.0.
	self changed
]
