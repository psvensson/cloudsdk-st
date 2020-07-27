Class {
	#name : #CCUrlClickableTextMorph,
	#superclass : #CCClickableTextMorph,
	#instVars : [
		'url'
	],
	#classInstVars : [
		'url'
	],
	#category : #'CloudConversations-UI-Common'
}

{ #category : #'as yet unclassified' }
CCUrlClickableTextMorph class >> content: c url: u [
	| instance |
	instance := self new.
	instance
		underlined;
		textColor: Color blue;
		contents: c;
		url: u;
		action: [ Transcript show:'url clicked: ',u;cr.
			WebBrowser openOn: u ].
	^ instance
]

{ #category : #'as yet unclassified' }
CCUrlClickableTextMorph class >> url: u [
	| instance |
	instance := self new.
	instance
		underlined;
		textColor: Color blue;
		url: u;
		action: [ WebBrowser openOn: url ].
	^ instance
]

{ #category : #accessing }
CCUrlClickableTextMorph >> url [
	^ url
]

{ #category : #accessing }
CCUrlClickableTextMorph >> url: u [
		url := u
]
