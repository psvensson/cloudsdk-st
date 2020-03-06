"
I am the main window of Cloud Conversation which hold all other UI elements.
"
Class {
	#name : #CCMainWindow,
	#superclass : #StandardWindow,
	#instVars : [
		'fileMenu',
		'tools',
		'text',
		'dock',
		'holder',
		'cloud',
		'hat',
		'teacup',
		'tabmanager',
		'certificateDialog',
		'newAccountButton',
		'accountDetail',
		'accountPanelMorph',
		'templatePanelMorph'
	],
	#classInstVars : [
		'models'
	],
	#category : #'CloudConversations-UI-Main'
}

{ #category : #'instance creation' }
CCMainWindow class >> initialize [ 
	models := CCModels new.
]

{ #category : #accessing }
CCMainWindow class >> models [
	models isNil ifTrue: [ models := CCModels new. ].
	"models := CCModels new."
	^ models
]

{ #category : #accessing }
CCMainWindow class >> models: anObject [
	models := anObject
]

{ #category : #'instance creation' }
CCMainWindow class >> open [
	| window |
	window := self new.
	window hResizing: #shrinkWrap.
	window extent: 700 @ 500.
]

{ #category : #'initialization - private' }
CCMainWindow >> accountsTab [
	| tab accountsPanel |
	tab := TabMorph label: 'Service Accounts' icon: nil morph: Morph new.
	tab morph color: self tabColour.
	accountsPanel := CCAccountsPanel new.
	accountsPanel
		accounts: self class models accounts;
		allAccounts: self class models accounts.
	tab morph addMorph: accountsPanel.
	accountDetail := CCAccountDetail new.
	accountDetail showAccount.
	accountsPanel
		onAccountSelected: [ :selectedAccount | 
			accountDetail isNil
				ifFalse: [ tab morph removeMorph: accountDetail ].
			
			accountDetail
				account: selectedAccount item;
				showAccount.
			].
	tab morph addMorph: accountDetail after: accountsPanel.	
	tab
		layoutPolicy: ProportionalLayout new;
		listDirection: #leftToRight ;
		hResizing: #shrinkWrap ;
		vResizing: #shrinkWrap .
	tab closeable: false.
	^ tab
]

{ #category : #'initialization - private' }
CCMainWindow >> addTabs [
	self tabs do: [ :tab | tabmanager addTab: tab ]
]

{ #category : #initialization }
CCMainWindow >> initialize [
	super initialize.
	self layoutPolicy: ProportionalLayout new;
			addCloseBox ;
			wrapCentering: #topLeft;
			"wrapDirection: #leftToRight  ;"
			listDirection: #leftToRight;
			listCentering: #topLeft;
			height: 700;
			cellInset: 10.
			"wrapCentering: #center;"
	self title: 'Cloud Conversations - Talking to the cloud about poetry'.
	self initializeImages.
	self initializeFileMenu.
	self initializeTools.
	self initializeDialogs.
	"self initializeDock."
	"self initializeTextEditor.	"
	"self initializeTabs."
	self initializePanels.
	self
		themeChanged;
		openInWorld
]

{ #category : #'initialization - private' }
CCMainWindow >> initializeDialogs [
	certificateDialog := TextEntryDialogWindow minimumWidth: 400
]

{ #category : #'initialization - private' }
CCMainWindow >> initializeDock [
	dock := self newToolDockingBar.
	dock
		add: 'Deployments' translated
			font: self theme menuBarFont
			icon: (self iconNamed: #catalog)
			help: 'File operations' translated
			subMenu: fileMenu;
		addMorphBack: tools.
	self
		addMorph: dock
			fullFrame:
			(LayoutFrame identity
				bottomFraction: 0;
				bottomOffset: dock minExtent y)
]

{ #category : #'initialization - private' }
CCMainWindow >> initializeFileMenu [
	fileMenu := self newMenu.
	fileMenu addToggle: 'Open' translated target: nil selector: #openFile.	"would be model"
	fileMenu lastItem
		font: self theme menuFont;
		icon: (self iconNamed: #smallOpenIcon);
		keyText: 'Ctrl+O'.
	fileMenu
		addToggle: 'Save' translated
		target: nil
		selector: #saveFile
		getStateSelector: nil
		enablementSelector: nil.
	fileMenu lastItem
		font: self theme menuFont;
		icon: (self iconNamed: #smallSaveIcon);
		keyText: 'Ctrl+S'.
	fileMenu
		addToggle: 'Print...' translated
		target: nil
		selector: #print.
	fileMenu lastItem
		font: self theme menuFont;
		icon: (self iconNamed: #smallPrintIcon);
		keyText: 'Ctrl+P'.
]

{ #category : #'initialization - private' }
CCMainWindow >> initializeImages [
	cloud := ImageMorph withForm: (CCImages spriteImage: 'cloud').
	hat := ImageMorph withForm: (CCImages spriteImage: 'wizardshat').
	teacup := ImageMorph withForm: (CCImages spriteImage: 'teacup').
	"hat position: self position - 100."
	hat resize: 100@100.
	
	"self addMorph: hat."
	hat form rotateBy: 45.
	hat rotationDegrees: 45.	
]

{ #category : #'initialization - private' }
CCMainWindow >> initializePanels [
	accountPanelMorph := CCAccountPanelMorph new.
	accountPanelMorph accounts: self class models accounts.
	accountPanelMorph top: 35; left: 10.
	templatePanelMorph := CCTemplatesPanelMorph new.
	templatePanelMorph templates: self class models templates.
	templatePanelMorph top: 35; left: 260.
	self addMorph: accountPanelMorph .
	self addMorph: templatePanelMorph 
]

{ #category : #'initialization - private' }
CCMainWindow >> initializeTabs [
	tabmanager := TabManagerMorph new.
	self addTabs .
	"self addMorph: tabmanager fullFrame: (LayoutFrame identity topOffset: dock minExtent y)"
	self addMorph: tabmanager fullFrame: (LayoutFrame identity)
]

{ #category : #'initialization - private' }
CCMainWindow >> initializeTextEditor [
	holder := NewValueHolder new.
	text := self
		newTextEditorFor: holder
		getText: #value
		setText: #value:.
	self addMorph: text
			fullFrame: (LayoutFrame identity topOffset: dock minExtent y).		
]

{ #category : #'initialization - private' }
CCMainWindow >> initializeTools [
	tools := self
		newToolbar:
			{(self
				newButtonFor: nil
				getState: nil
				action: #openFile
				arguments: nil
				getEnabled: nil
				labelForm: (self iconNamed: #smallOpenIcon)
				help: 'Open file' translated).	"if we had a model it would go here"
			(self
				newButtonFor: nil
				getState: nil
				action: #saveFile
				arguments: nil
				getEnabled: nil
				labelForm: (self iconNamed: #smallSaveIcon)
				help: 'Save file' translated).
			(self
				newButtonFor: nil
				getState: nil
				action: #print
				arguments: nil
				getEnabled: nil
				labelForm: (self iconNamed: #smallPrintIcon)
				help: 'Print' translated)}.
]

{ #category : #'initialization - private' }
CCMainWindow >> tabColour [
	^ Color gray: 0.2
]

{ #category : #'initialization - private' }
CCMainWindow >> tabs [
	| accountsTab |
	accountsTab := (CCAccountsTab label: 'Service Accounts' icon: nil morph: Morph new).
	accountsTab accounts: self class models accounts.
	^ OrderedCollection new
		add: accountsTab;
		add: self templatesTab;
		yourself
]

{ #category : #'initialization - private' }
CCMainWindow >> templatesTab [
	| tab |
	tab := TabMorph label: 'Dockerfile Templates' icon: nil morph: Morph new.
	tab morph color: self tabColour.
	
	tab closeable: false.
	^ tab
]