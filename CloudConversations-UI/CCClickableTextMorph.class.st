Class {
	#name : #CCClickableTextMorph,
	#superclass : #TextMorph,
	#instVars : [
		'action'
	],
	#category : #'CloudConversations-UI-Common'
}

{ #category : #'event handling' }
CCClickableTextMorph >> action [
    ^ action
]

{ #category : #'event handling' }
CCClickableTextMorph >> action: anObject [
    action := anObject
]

{ #category : #'event handling' }
CCClickableTextMorph >> handlesMouseDown: evt [
    ^true
]

{ #category : #'event handling' }
CCClickableTextMorph >> mouseDown: evt [
	evt hand waitForClicksOrDrag: self event: evt.
	action ifNotNil: [ action value ]
]

{ #category : #'event handling' }
CCClickableTextMorph >> mouseUp: evt [
    "action value"
]
