Class {
	#name : #CCAccountsPanel,
	#superclass : #PanelMorph,
	#instVars : [
		'accounts',
		'accountList',
		'accountDetail',
		'newAccountButton',
		'onSelectedAccount',
		'accountSelectedIndex'
	],
	#category : #'CloudConversations-UI-Accounts'
}

{ #category : #accessing }
CCAccountsPanel >> accountSelected: anIndex [
	| selectedAccount |
	accountSelectedIndex := anIndex.
	accountList selectionIndex: anIndex.
	Transcript
		show: 'accountpanel accountSelected ' , anIndex asString;
		cr.
	anIndex > 0
		ifTrue: [ selectedAccount := accounts at: anIndex ].
	onSelectedAccount isNil
		ifFalse: [ onSelectedAccount value: selectedAccount ]
]

{ #category : #accessing }
CCAccountsPanel >> accountSelectedIndex [
	^ accountSelectedIndex

]

{ #category : #accessing }
CCAccountsPanel >> accountSelectedIndex: index [
	index > 0
		ifTrue: [ accountSelectedIndex := index.
		self accountSelected: index.	 ]
]

{ #category : #accessing }
CCAccountsPanel >> accounts [
	^ accounts
]

{ #category : #accessing }
CCAccountsPanel >> accounts: anObject [
	accounts := anObject.
	accountList
		on: self
		list: #accounts
		selected: #accountSelectedIndex
		changeSelected: #accountSelected:
		menu: nil
		keystroke: nil.
	accounts isEmpty ifFalse: [ 
		self accountSelected: 1.
		accountList updateList ]	
]

{ #category : #accessing }
CCAccountsPanel >> createAccountFrom: certAstext type: type [
	| account |
	account := CCServiceAccount new.	
	account
		cloudType: type;
		certificateAsJSONString: certAstext.
	accounts add: (CCListItemWrapper with: account).
	accountList updateList.
	self changed
]

{ #category : #accessing }
CCAccountsPanel >> fileCertificate [
	| filepath |
	filepath := UIManager default
		chooseFullFileNameMatching: nil
		label: 'Choose Service Account file'.
	^ filepath asFileReference readStream contents
]

{ #category : #initialization }
CCAccountsPanel >> initialize [
	super initialize.
	newAccountButton := SimpleButtonMorph newWithLabel: 'New Account'.
	newAccountButton color: Color orange.
	newAccountButton
		target: self;
		actionSelector: #showCertificateDialog.
	self initializeAccountsList .
	self initializeLayout.
	self addMorph: newAccountButton.
	
]

{ #category : #initialization }
CCAccountsPanel >> initializeAccountsList [
	accountList := PluggableIconListMorph new.
	accountList
		color: Color gray;
		top: 35;
		"left: 10;"
		"width:220;"
		height:200;
		borderWidth: 10;
		hResizing: #spaceFill;
		"vResizing: #spaceFill;"
		getIconSelector: #icon.
		
	self addMorph: accountList
]

{ #category : #initialization }
CCAccountsPanel >> initializeLayout [
	self
		layoutPolicy: TableLayout new;
		listDirection: #topToBottom;		
		"width: 300;"
		"height:300;"
		cellInset: 5;
		left:10;
		"hResizing: #shrinkWrap;	
		vResizing: #shrinkWrap."
		hResizing: #spaceFill;
		vResizing: #spaceFill;
		themeChanged;
		color: Color gray darker
]

{ #category : #accessing }
CCAccountsPanel >> onAccountSelected: aBlock [
	onSelectedAccount := aBlock 
]

{ #category : #accessing }
CCAccountsPanel >> pasteCertificate [
	^ UIManager default
		multiLineRequest: 'Paste the text contents of your JSON certifcate file'
		initialAnswer: ''
		answerHeight: 250
]

{ #category : #accessing }
CCAccountsPanel >> showCertificateAlert [
	UIManager default
		alert: 'The certificate is stored in your image. Please remember to save image state (SHIFT-S).'
		title:
			'Reminder'
]

{ #category : #'initialization - private' }
CCAccountsPanel >> showCertificateDialog [
	| result kind type |
	"self openModal: certificateDialog "
	kind := UIManager default
		chooseFrom: #(File Paste)
		message: 'How do you want to add a Service Account Certificate?'
		title: 'New Account'.
	result := kind = 2
		ifTrue: [ self pasteCertificate ]
		ifFalse: [ self fileCertificate ].
	type := UIManager default
		chooseFrom: #(AWS Google)
		message: 'For which cloud is this Service Account Certificate made?'
		title: 'New Account'.
	self
		createAccountFrom: result
		type:
			(type = 1
				ifTrue: [ 'aws' ]
				ifFalse: [ 'gcloud' ]).
	self showCertificateAlert
]
