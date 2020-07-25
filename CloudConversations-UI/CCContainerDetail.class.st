Class {
	#name : #CCContainerDetail,
	#superclass : #CCDetailPanel,
	#instVars : [
		'container',
		'allContainers',
		'table'
	],
	#category : #'CloudConversations-UI-Containers'
}

{ #category : #accessing }
CCContainerDetail >> actionsRow [
	| row deleteContainerButton deployContainerButton |
	row := Morph new.	
	row
		color: (Color gray darker );
		layoutPolicy: RowLayout new;
		listDirection: #leftToRight;
		cellInset: 6 @ 5;
		layoutInset: 5 @ 5;
		vResizing: #shrinkWrap;
		hResizing: #spaceFill.
	deleteContainerButton := SimpleButtonMorph
		newWithLabel: 'Delete Container'.
	deleteContainerButton
		color: Color red;
		target: self;
		actionSelector: #deleteContainer.
	deployContainerButton := SimpleButtonMorph
		newWithLabel: 'Deploy Container'.
	deployContainerButton
		color: Color green darker darker;
		target: self;
		actionSelector: #deployContainer.
	
	row addMorph: deleteContainerButton .
	row addMorph: deployContainerButton .
	^ row
]

{ #category : #accessing }
CCContainerDetail >> addContainerPropsAndValueTo: aMorph [
	| timeUploaded timeCreated |
	timeUploaded := CCMainController formattedDateFromMillis: item timeUploaded.
	timeCreated := CCMainController formattedDateFromMillis: item timeCreated .
	aMorph addMorph: (self containerPropertyRow: #name value: item name).
	aMorph addMorph: (self containerPropertyRow: #tags value: item tags).
	aMorph
		addMorph:
			(self
				containerPropertyRow: #imagesize
				value: (item dict at: #imageSizeBytes)).
	"aMorph addMorph: (self containerPropertyRow: #mediaType value: (item mediaType))."
	aMorph
		addMorph:
			(self
				containerPropertyRow: #timeUploaded 
				value: timeUploaded).
	aMorph
		addMorph: (self containerPropertyRow: #timeCreated value: timeCreated).
	"aMorph addMorph: (self containerPropertyRow: #reference value: (item reference))."
]

{ #category : #accessing }
CCContainerDetail >> allContainers [
	^ allContainers
]

{ #category : #accessing }
CCContainerDetail >> allContainers: anObject [
	allContainers := anObject
]

{ #category : #accessing }
CCContainerDetail >> container [
	^ container
]

{ #category : #accessing }
CCContainerDetail >> container: anObject [
	container := anObject
]

{ #category : #accessing }
CCContainerDetail >> containerPropertyRow: prop value: val [
	| propline method valstr |
	propline := TextMorph new.
	"method := prop asSymbol ."
	valstr := val ifNil: ['--'] ifNotNil: [val asString].
	"(item respondsTo: method) ifTrue: [ valstr := item perform:  method  ] ."
	propline
		contents: prop , ': ' , valstr asString;
		"hResizing: #shrinkWrap."
		vResizing: #shrinkWrap .
	^ propline
]

{ #category : #initialization }
CCContainerDetail >> initialize [
	super initialize.
	self showContainer
]

{ #category : #initialization }
CCContainerDetail >> initializeButtons [
	self addMorph: self actionsRow .	
]

{ #category : #rendering }
CCContainerDetail >> renderDetail [
	self showContainer 
]

{ #category : #accessing }
CCContainerDetail >> showContainer [
	self removeAllMorphs.
	item isNil
		ifFalse: [ self addContainerPropsAndValueTo: self ]
		ifTrue: [ | text |
			text := TextMorph new.
			text contents: 'No Container Selected'.
			self addMorph: text ]
]
