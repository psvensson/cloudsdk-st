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
	| propline method valstr text |
	method := prop asSymbol.
	valstr := '--'.
	(item respondsTo: method)
		ifTrue: [ valstr := item perform: method ].
	text := prop , ': ' , valstr asString.
	propline := prop = 'url'
		ifFalse: [ TextMorph new
				contents: text;
				yourself ]
		ifTrue: [ (valstr includesSubstring: '://')
				ifFalse: [ valstr := 'http://' , valstr.
					text := prop , ': ' , valstr asString ].
			CCUrlClickableTextMorph content: text url: valstr ].
	propline
		layoutPolicy: TableLayout new;
		wrapCentering: #topLeft;
		wrapDirection: #leftToRight;
		listDirection: #leftToRight;
		hResizing: #spaceFill;
		vResizing: #spaceFill.
	^ propline
]

{ #category : #accessing }
CCDeploymentDetail >> initialize [
	super initialize.
	self showDeployment
	
]

{ #category : #initialization }
CCDeploymentDetail >> initializeButtons [
	"no buttons for us yet"
]

{ #category : #rendering }
CCDeploymentDetail >> renderDetail [
	self showDeployment 
]

{ #category : #accessing }
CCDeploymentDetail >> showDeployment [
	self removeAllMorphs.
	item isNil
		ifFalse: [ self addDeploymentPropsAndValueTo: self ]
		ifTrue: [ | text |
			text := TextMorph new.
			text contents: 'No Depolyment Selected'.
			self addMorph: text ]
]
