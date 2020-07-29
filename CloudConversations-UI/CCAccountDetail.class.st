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
	| row "showContainerbuildsButton" renameButton |
	row := Morph new.
	row
		color: Color gray;
		layoutPolicy: RowLayout new;
		listDirection: #topToBottom;
		cellInset: 6 @ 0;
		layoutInset: 5 @ 5;
		top: 10;
		hResizing: #spaceFill.
	renameButton := CCMainController
		buildButtonText: #renameLabel
		action: #renameAccount
		model: self.
	row addMorph: renameButton.
	"row addMorph: showDeploymentsButton."
	"row addMorph: showContainerbuildsButton."
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
CCAccountDetail >> deleteLabel [
	^ 'Delete'
]

{ #category : #accessing }
CCAccountDetail >> icon [
	^ CCImages imageMorphFrom: (account cloudType )
]

{ #category : #accessing }
CCAccountDetail >> iconNameRow [
	| row icon nameMorph textstring deleteAccountButton |
	row := Morph new.
	row
		layoutPolicy: RowLayout new;
		color: Color gray darker;
		cellInset: 6 @ 0;
		layoutInset: 5 @ 5;
		listDirection: #leftToRight;
		hResizing: #spaceFill.
	icon := (CCImages imageMorphFrom: account cloudType) resize: 32 @ 32.
	textstring := account name.
	nameMorph := TextMorph new contents: textstring.
	deleteAccountButton := CCMainController
		buildButtonText: #deleteLabel
		action: #deleteAccount
		pointSize: 9
		model: self.
	row addMorph: nameMorph.
	row addMorph: icon.
	row addMorph: deleteAccountButton.
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
		listDirection: #topToBottom  ;
		cellPositioning: #topLeft;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap ;
		height:300;
		top: 30;
		color: Color yellow ;
		cellInset: 10;
		color: Color gray darker
]

{ #category : #accessing }
CCAccountDetail >> onAccountUpdate: aBlock [
	accountUpdate := aBlock
	
]

{ #category : #accessing }
CCAccountDetail >> projectIdMorph [
	|  m |
	Transcript
		show: 'account for project selected: ' , account projectId;
		cr.
	m := Morph new.
	m
		layoutInset: 8 @ 8;
		color: Color transparent;
		layoutPolicy: TableLayout new;
		listDirection: #leftToRight.
	m
		addMorph:
			(CCMainController
				getTextMorph: account projectId
				color: Color green darker
				pointSize: 14).	
	m
		addMorph:
			(CCMainController
				getTextMorph: 'Project: '
				color: Color white
				pointSize: 14).
	
	^ m
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
CCAccountDetail >> renameLabel [
	^ 'Rename'
]

{ #category : #accessing }
CCAccountDetail >> showAccount [
	self removeAllMorphs.
	account isNil
		ifFalse: [ self
				addMorph: self iconNameRow;
				addMorph: self actionsRow;
				addMorph: self projectIdMorph ]
		ifTrue: [ | text |
			text := TextMorph new.
			text contents: 'No Account Selected'.
			self addMorph: text ]
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
	cw := CCContainersListPanel new.
	cw openInWindow.
	cw account: account 
]

{ #category : #accessing }
CCAccountDetail >> showDeployments [
	| dw |
	dw := CCDeploymentsListPanel new.
	dw openInWindow.
	dw account: account 
]
