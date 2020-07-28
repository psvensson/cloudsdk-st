Class {
	#name : #CCContainerProxy,
	#superclass : #Object,
	#instVars : [
		'name',
		'cloudType'
	],
	#category : #'CloudConversations-UI-Containers'
}

{ #category : #accessing }
CCContainerProxy >> cloudType [
	^ cloudType
]

{ #category : #accessing }
CCContainerProxy >> cloudType: anObject [
	cloudType := anObject
]

{ #category : #accessing }
CCContainerProxy >> name [
	^ name
]

{ #category : #accessing }
CCContainerProxy >> name: anObject [
	name := anObject
]

{ #category : #accessing }
CCContainerProxy >> wrapSelector [
	| icon morph text |
	icon := CCImages iconFrom: 'docker4'.
	text := TextMorph new
		contents: name;
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
