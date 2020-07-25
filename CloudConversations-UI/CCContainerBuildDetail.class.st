Class {
	#name : #CCContainerBuildDetail,
	#superclass : #CCDetailPanel,
	#instVars : [
		'container',
		'allContainers'
	],
	#category : #'CloudConversations-UI-Containers'
}

{ #category : #accessing }
CCContainerBuildDetail >> addContainerPropsAndValueTo: aMorph [
	container props keysAndValuesDo: [ :key : value |
		| row |
		row := self containerPropertyRow: key value: value.
		aMorph addMorph: row ]
]

{ #category : #accessing }
CCContainerBuildDetail >> allContainers [
	^ allContainers
]

{ #category : #accessing }
CCContainerBuildDetail >> allContainers: anObject [
	allContainers := anObject
]

{ #category : #accessing }
CCContainerBuildDetail >> container [
	^ container
]

{ #category : #accessing }
CCContainerBuildDetail >> container: anObject [
	container := anObject
]

{ #category : #accessing }
CCContainerBuildDetail >> containerPropertyRow: prop value: val [
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

{ #category : #accessing }
CCContainerBuildDetail >> initialize [
	super initialize .
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
		self showContainer 
]

{ #category : #initialization }
CCContainerBuildDetail >> initializeButtons [
	
]

{ #category : #rendering }
CCContainerBuildDetail >> renderDetail [
	self showContainer 
]

{ #category : #accessing }
CCContainerBuildDetail >> showContainer [
	self removeAllMorphs.
	container isNil
		ifFalse: [ self addContainerPropsAndValueTo: self ]
		ifTrue: [ | text |
			text := TextMorph new.
			text contents: 'No Container Selected'.
			self addMorph: text ]
]
