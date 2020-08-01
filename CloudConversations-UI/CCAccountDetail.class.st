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
	| row "showContainerbuildsButton" renameButton renameBucketButton deleteButton |
	row := self createRow.
	deleteButton := CCMainController
		buildButtonText: #deleteLabel
		action: #deleteAccount
		model: self.
	
	renameButton := CCMainController
		buildButtonText: #renameLabel
		action: #renameAccount
		model: self.
	
	renameBucketButton := CCMainController
		buildButtonText: #renameBucketLabel
		action: #renameAccountBucket
		model: self.
	row addMorph: renameBucketButton.
	row addMorph: renameButton.
	row addMorph: deleteButton.
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
CCAccountDetail >> createRow [
	| row |
	row := Morph new.
	row
		layoutPolicy: RowLayout new;
		color: Color gray darker;
		cellInset: 6 @ 0;
		layoutInset: 5 @ 5;
		listDirection: #leftToRight
		"hResizing: #spaceFill".
	^ row	
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
	^ 'Remove'
]

{ #category : #accessing }
CCAccountDetail >> googleStorageBucketRow [
	| row nameMorph textstring renameAccountButton |
	row := self createRow.
	textstring := account bucket.
	nameMorph := TextMorph new contents: textstring.
	renameAccountButton := CCMainController
		buildButtonText: #renameBucketLabel
		action: #renameAccountBucket
		pointSize: 9
		model: self.
	row addMorph: nameMorph.
	row addMorph: renameAccountButton.
	^ row
]

{ #category : #accessing }
CCAccountDetail >> icon [
	^ CCImages imageMorphFrom: (account cloudType )
]

{ #category : #accessing }
CCAccountDetail >> iconNameRow [
	| row icon nameMorph textstring deleteAccountButton |
	row := self createRow.
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
CCAccountDetail >> renameAccountBucket [
	account
		bucket:
			(UIManager default
				request: 'Change bucket name to:'
				initialAnswer: account bucket ).
	accountUpdate value.
]

{ #category : #accessing }
CCAccountDetail >> renameBucketLabel [
	^ 'Rename Bucket'
]

{ #category : #accessing }
CCAccountDetail >> renameLabel [
	^ 'Rename project'
]

{ #category : #accessing }
CCAccountDetail >> showAccount [
	self removeAllMorphs.
	account isNil
		ifFalse: [ self
				"addMorph: self googleStorageBucketRow;"
				"addMorph: self iconNameRow;"
				addMorph: self actionsRow;
				addMorph: self projectIdMorph.
				CCMainController lastUsedAccount: account ]
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
