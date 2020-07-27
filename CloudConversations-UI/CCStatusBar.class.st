Class {
	#name : #CCStatusBar,
	#superclass : #Morph,
	#instVars : [
		'loadingIcon',
		'loadingText',
		'alpha',
		'showCount'
	],
	#category : #'CloudConversations-UI-Main'
}

{ #category : #'class initialization' }
CCStatusBar >> contents: text [ 
	Transcript show:'statusBar setting text to: ',text;cr.
	loadingText contents: text.
	self changed
	
]

{ #category : #'class initialization' }
CCStatusBar >> fullDrawOn: aCanvas [

	super fullDrawOn: (aCanvas asAlphaBlendingCanvas: alpha)
]

{ #category : #'class initialization' }
CCStatusBar >> hide [
	alpha := 0.
	showCount := showCount - 1.
	showCount = 0
		ifTrue: [ self contents: ''.
			self changed ]
]

{ #category : #'class initialization' }
CCStatusBar >> initialize [
	super initialize.
	showCount := 0.
	alpha := 0.
	loadingIcon := CCImages animatedImage: 'loading1'.
	loadingText := TextMorph new contents: ''.
	self
		layoutPolicy: TableLayout new;
		color: Color transparent;
		"listDirection: #topToBottom;"
		width:300;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		addMorph: loadingIcon;
		addMorph: loadingText
]

{ #category : #'class initialization' }
CCStatusBar >> show [
	alpha := 1.0.
	showCount := showCount + 1.
	self changed
]
