Class {
	#name : #CCDeploymentDetail,
	#superclass : #PanelMorph,
	#instVars : [
		'deployment',
		'allDeployments'
	],
	#category : #'CloudConversations-UI-Deployments'
}

{ #category : #accessing }
CCDeploymentDetail >> addDeploymentPropsAndValueTo: aMorph [
	#(annotations apiVersion containerConcurrency timeoutSeconds name traffic uid generation creationTimestamp namespace url)
		do: [ :key | 
			| row |
			row := self deploymentPropertyRow: key.
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
	propline := TextMorph new.
	method := prop asSymbol .
	valstr := '--'.
	(deployment respondsTo: method) ifTrue: [ valstr := deployment perform:  method  ] .
	propline
		contents: prop , ': ' , valstr asString;
		hResizing: #spaceFill;
		vResizing: #spaceFill.
	^ propline
]

{ #category : #accessing }
CCDeploymentDetail >> initialize [
	super initialize .
	self		
		layoutPolicy: TableLayout new;
		listDirection: #topToBottom;
		"listCentering: #topLeft;
		wrapCentering: #center;"
		layoutInset: 4;
		hResizing: #shrinkWrap;
		"vResizing: #shrinkWrap;"
		cellInset: 15;	
			left: 250;	
		height:400;
		width:300;
		color: Color gray darker darker.
		self showDeployment 
]

{ #category : #accessing }
CCDeploymentDetail >> showDeployment [
	self removeAllMorphs.
	deployment isNil
		ifFalse: [ self addDeploymentPropsAndValueTo: self ]
		ifTrue: [ | text |
			text := TextMorph new.
			text contents: 'No Deplyment Selected'.
			self addMorph: text ]
]
