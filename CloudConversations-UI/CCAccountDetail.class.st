Class {
	#name : #CCAccountDetail,
	#superclass : #PanelMorph,
	#instVars : [
		'account',
		'allAccounts',
		'accountUpdate'
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
	| showContainersButton showDeploymentsButton row showContainerbuildsButton renameButton |
	row := Morph new.	
	row
		color: (Color gray);
		layoutPolicy: RowLayout new;
		listDirection: #topToBottom;
		cellInset: 6 @ 0;
		layoutInset: 5 @ 5;
		top: 10;
		hResizing: #spaceFill.
	showContainerbuildsButton := SimpleButtonMorph
		newWithLabel: 'Build results'.
	showContainerbuildsButton
		color: Color darkGray;
		target: self;
		actionSelector: #showContainerBuilds.
	showContainersButton := SimpleButtonMorph
		newWithLabel: 'Containers'.
	showContainersButton
		color: Color darkGray;
		target: self;
		actionSelector: #showContainers.	
	showDeploymentsButton := SimpleButtonMorph
		newWithLabel: 'Deployments'.
	showDeploymentsButton
		color: Color darkGray;
		target: self;
		actionSelector: #showDeployments.
	renameButton := SimpleButtonMorph newWithLabel: 'Rename'.
	renameButton
		color: Color darkGray;
		target: self;
		actionSelector: #renameAccount.		
	
	row addMorph: renameButton.
	row addMorph: showDeploymentsButton.
	row addMorph: showContainerbuildsButton.
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
	| really listItemWrappers |
	really := UIManager default
		confirm: 'Do you really waant to delete this Service Account Certificate?'
		orCancel: [ ^ false ].
	listItemWrappers := allAccounts select: [ :wrapper | wrapper item = account ].	
	allAccounts remove: listItemWrappers first .	
	accountUpdate value
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
		listDirection: #topToBottom  ;
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
CCAccountDetail >> onAccountUpdate: aBlock [
	accountUpdate := aBlock
	
]

{ #category : #accessing }
CCAccountDetail >> renameAccount [
	account
		name:
			(UIManager default
				request: 'Change name to:'
				initialAnswer: account name).
	accountUpdate value.
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
CCAccountDetail >> showContainerBuilds [
	| cw |
	cw := CCContainerBuildsWindow new.
	cw openInWindow.
	cw account: account 
]

{ #category : #accessing }
CCAccountDetail >> showContainers [
	| cw |
	cw := CCContainersWindow new.
	cw openInWindow.
	cw account: account 
]

{ #category : #accessing }
CCAccountDetail >> showDeployments [
	| dw |
	dw := CCDeploymentsWindow new.
	dw openInWindow.
	dw account: account 
]
