Class {
	#name : #CCListItemWrapper,
	#superclass : #ListItemWrapper,
	#category : #'CloudConversations-UI-Main'
}

{ #category : #accessing }
CCListItemWrapper >> handlesMouseDown: evt [
    ^true
]

{ #category : #accessing }
CCListItemWrapper >> icon [
	^ Smalltalk ui icons iconNamed: #references
]

{ #category : #accessing }
CCListItemWrapper >> mouseDown: evt [
    Transcript show:'CCListItemWrapper mousedown on list item ',item asString;cr.
]
