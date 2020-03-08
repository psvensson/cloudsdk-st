Class {
	#name : #CCContainerDetail,
	#superclass : #ScrollPane,
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
	aMorph addMorph: (self containerPropertyRow: #name value: (container name)).
	aMorph addMorph: (self containerPropertyRow: #tags value: (container tags)).
	aMorph addMorph: (self containerPropertyRow: #imagesize value: (container dict at: #imageSizeBytes )).
	aMorph addMorph: (self containerPropertyRow: #mediaType value: (container mediaType)).
	aMorph addMorph: (self containerPropertyRow: #timeUplaoded value: (container timeUploaded)).
	aMorph addMorph: (self containerPropertyRow: #timeCreated value: (container timeCreated)).
	aMorph addMorph: (self containerPropertyRow: #reference value: (container reference)).
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
	method := prop asSymbol .
	valstr := '--'.
	(container respondsTo: method) ifTrue: [ valstr := container perform:  method  ] .
	propline
		contents: prop , ': ' , valstr asString;
		hResizing: #spaceFill;
		vResizing: #spaceFill.
	^ propline
]

{ #category : #initialization }
CCContainerDetail >> initialize [
	super initialize. 
	self		
		layoutPolicy: TableLayout new;
		listDirection: #topToBottom;
		"listCentering: #topLeft;
		wrapCentering: #center;"
		layoutInset: 4;
		hResizing: #shrinkWrapl;
		"vResizing: #shrinkWrap;"
		cellInset: 15;	
			left: 250;	
		height:400;
		width:300;
		color: Color gray darker darker.
		self showContainer .
	self addMorph: self actionsRow .	
]

{ #category : #accessing }
CCContainerDetail >> showContainer [
	self removeAllMorphs.
	container isNil
		ifFalse: [ self addContainerPropsAndValueTo: self ]
		ifTrue: [ | text |
			text := TextMorph new.
			text contents: 'No Container Selected'.
			self addMorph: text ]
]
