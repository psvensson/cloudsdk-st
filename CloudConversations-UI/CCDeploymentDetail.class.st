Class {
	#name : #CCDeploymentDetail,
	#superclass : #CCDetailPanel,
	#instVars : [
		'deployment',
		'allDeployments'
	],
	#category : #'CloudConversations-UI-Deployments'
}

{ #category : #accessing }
CCDeploymentDetail >> addDeploymentPropsAndValueTo: aMorph [
	#(apiVersion containerConcurrency timeoutSeconds container name uid generation creationTimestamp namespace url)
		do: [ :key | 
			| row |
			row := self deploymentPropertyRow: key.
			row 
				vResizing: #shrinkWrap;
				hResizing: #shrinkWrap.
			aMorph addMorph: row ]
]

{ #category : #accessing }
CCDeploymentDetail >> allDeployments [
	^ allDeployments
]

{ #category : #accessing }
CCDeploymentDetail >> allDeployments: anObject [
	allDeployments := anObject
]

{ #category : #accessing }
CCDeploymentDetail >> deployment [
	^ deployment
]

{ #category : #accessing }
CCDeploymentDetail >> deployment: anObject [
	deployment := anObject
]

{ #category : #accessing }
CCDeploymentDetail >> deploymentPropertyRow: prop [
	| propline method valstr |
	propline := CCClickableTextMorph new.
	prop = 'url'
		ifTrue: [ propline
				underlined; fillStyle: Color white;
				color: Color blue;
				action: [ Transcript
						show: 'callback';
						cr.
					WebBrowser openOn: valstr  ] ].
	"TODO: add mousedown event handler and open os web browser"
	method := prop asSymbol.
	valstr := '--'.
	(item respondsTo: method)
		ifTrue: [ valstr := item perform: method ].
	propline
		layoutPolicy: TableLayout new;
		wrapCentering: #topLeft;
		wrapDirection: #leftToRight;
		listDirection: #leftToRight;
		contents: prop , ': ' , valstr asString;
		hResizing: #spaceFill;
		vResizing: #spaceFill.
	^ propline
]

{ #category : #accessing }
CCDeploymentDetail >> initialize [
	super initialize.
	
]

{ #category : #initialization }
CCDeploymentDetail >> initializeButtons [
	"no buttons for us yet"
]

{ #category : #rendering }
CCDeploymentDetail >> renderDetail [
	self removeAllMorphs.
	item
		ifNil: [ | text |
			text := TextMorph new.
			text contents: '* No Deployment Selected'.
			self addMorph: text ]
		ifNotNil: [ self addDeploymentPropsAndValueTo: self ]
]

{ #category : #accessing }
CCDeploymentDetail >> showDeployment [
	self removeAllMorphs.
	deployment isNil
		ifFalse: [ self addDeploymentPropsAndValueTo: self ]
		ifTrue: [ | text |
			text := TextMorph new.
			text contents: '* No Deplyment Selected'.
			self addMorph: text ]
]
