Class {
	#name : #CCAccountDetail,
	#superclass : #PanelMorph,
	#instVars : [
		'account',
		'allAccounts'
	],
	#category : #'CloudConversations-UI-Accounts'
}

{ #category : #accessing }
CCAccountDetail >> account [
	^ account
]

{ #category : #accessing }
CCAccountDetail >> account: anObject [
	account := anObject
]

{ #category : #accessing }
CCAccountDetail >> actionsRow [
	| showContainersButton showDeploymentsButton row |
	row := Morph new.	
	row
		color: (Color gray);
		layoutPolicy: RowLayout new;
		listDirection: #leftToRight;
		cellInset: 6 @ 0;
		layoutInset: 5 @ 5;
		top: 10;
		hResizing: #spaceFill.
	showContainersButton := SimpleButtonMorph
		newWithLabel: 'Show Containers'.
	showContainersButton
		color: Color darkGray;
		target: self;
		actionSelector: #showContainers.
	showDeploymentsButton := SimpleButtonMorph
		newWithLabel: 'Show Deployments'.
	showDeploymentsButton
		color: Color darkGray;
		target: self;
		actionSelector: #showDeployments.
	
	row addMorph: showDeploymentsButton.
	row addMorph: showContainersButton.
	^ row
]

{ #category : #accessing }
CCAccountDetail >> allAccounts [
	^ allAccounts
]

{ #category : #accessing }
CCAccountDetail >> allAccounts: anObject [
	allAccounts := anObject
]

{ #category : #accessing }
CCAccountDetail >> deleteAccount [
	| really |
	really := UIManager default
		confirm: 'Do you really waant to delete this Service Account Certificate?'
		orCancel: [ ^ false ]
]

{ #category : #accessing }
CCAccountDetail >> icon [
	^ CCImages imageMorphFrom: (account cloudType )
]

{ #category : #accessing }
CCAccountDetail >> iconNameRow [
	| row icon nameMorph textstring deleteAccountButton |
	row := Morph new.
	row layoutPolicy: RowLayout new;
		color: (Color gray darker );
		cellInset:6@0;
		layoutInset: 5@5; 
		listDirection: #leftToRight;
		hResizing: #spaceFill.
	icon := (CCImages imageMorphFrom: account cloudType) resize: 32 @ 32.	
	textstring := account name.
	nameMorph := TextMorph new contents: textstring.
	deleteAccountButton := SimpleButtonMorph newWithLabel: 'Delete'.
	deleteAccountButton 
		color: (Color red);
		target: self; actionSelector: #deleteAccount  .
	row addMorph: nameMorph.
	row addMorph: icon.
	row addMorph: deleteAccountButton .
	^ row
]

{ #category : #accessing }
CCAccountDetail >> initialize [ 
	super initialize .
	self initializeLayout 
	
]

{ #category : #accessing }
CCAccountDetail >> initializeLayout [
	self
		layoutPolicy: TableLayout new;
		"wrapCentering: #topLeft;"
		"wrapDirection: #leftToRight;"
		listDirection: #leftToRight  ;
		listCentering: #topLeft;
		hResizing: #spaceFill;
		vResizing: #spaceFill;
		"hResizing: #shrinkWrap;"
		"vResizing: #shrinkWrap;"
		height:300;
		top: 30;
		color: Color yellow ;
		"wrapDirection: #leftToRight ;"
		cellInset: 10;
		color: Color gray darker
]

{ #category : #accessing }
CCAccountDetail >> showAccount [
	self
		removeAllMorphs;
		layoutPolicy: TableLayout new;
		listDirection: #topToBottom;
		listCentering: #topLeft;
		"wrapCentering: #center;"
		"layoutInset: 4;"
		vResizing: #shrinkWrap ;
		cellInset: 8;
		top:30;
		hResizing: #spaceFill ;
		color: Color gray darker.
	account isNil
		ifFalse: [ self
				addMorph: self iconNameRow;
				addMorph: self actionsRow ]
		ifTrue: [ 
			| text |
			text := TextMorph new.
			text contents: 'No Account Selected'.
			self addMorph: text  ]
]

{ #category : #accessing }
CCAccountDetail >> showContainers [
	| cw |
	cw := CCContainerBuildsWindow new.
	cw openInWindow.
	cw account: account 
]

{ #category : #accessing }
CCAccountDetail >> showDeployments [
	Transcript show:'showDeployments';cr.
]
