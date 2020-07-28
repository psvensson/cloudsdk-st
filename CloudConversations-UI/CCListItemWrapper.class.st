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

{ #category : #accessing }
CCListItemWrapper >> wrapSelector [
	| icon morph text |
	icon := CCImages iconFrom: item cloudType.
	text := TextMorph new
		contents: item name;
		color: Color white.
	morph := Morph new.
	morph
		color: Color transparent;
		layoutPolicy: TableLayout new;
		listDirection: #leftToRight;
		cellInset: 2 @ 20;
		"width: 280;"
			cellPositioning: #center;
		hResizing: #spaceFill;
		vResizing: #shrinkWrap.
	morph
		addMorph: text;
		addMorph: icon.
	^ morph
]
