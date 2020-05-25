Class {
	#name : #CCTemplateDetail,
	#superclass : #PanelMorph,
	#instVars : [
		'template',
		'editor',
		'saveButton',
		'copyButton',
		'textMorph',
		'editButton',
		'labelMorph',
		'renameButton',
		'templateUpdate',
		'containerButton',
		'loadeditButton',
		'loadeditor',
		'loadtextMorph',
		'deleteButton',
		'templateDelete'
	],
	#category : #'CloudConversations-UI-Templates'
}

{ #category : #accessing }
CCTemplateDetail >> createContainer [
	| really connection containers storage zipfile kind type |
	connection := CCMainController
		getConnectionForAccount: CCMainController lastUsedAccount.
	connection connect.
	really := UIManager default
		confirm: 'Do you really waant to create a container of this template?'
		orCancel: [ ^ false ].
	really
		ifFalse: [ ^ false ].
	containers := CCGoogleContainers with: connection.
	storage := CCStorage with: connection.
	zipfile := template zipArchiveForBuildWith: connection serviceAccount.
	kind := UIManager default
		chooseFrom: #('Cloud Run cloud function' 'Cloud VM')
		message: 'What kind of service do you want to create?'
		title: 'Deploy'.
	type := kind = 2
		ifTrue: [ 'vm' ]
		ifFalse: [ 'cloud run' ].
	(containers
		uploadFile: zipfile
		as: template name asLowercase
		To: storage
		andCreate: template
		type: type)
		onSuccessDo: [ : result |CCMainController getMainWindow hideBusyIcon ].
	CCMainController getMainWindow showBusyIcon.
	UIManager default
		informUser: 'Container created and deploy started.'
		during: [ (Delay forSeconds: 3) wait ].
	^ true
]

{ #category : #accessing }
CCTemplateDetail >> deleteTemplate [
	templateDelete ifNotNil: [ templateDelete value: template ]
]

{ #category : #initialization }
CCTemplateDetail >> initialize [
	super initialize.
	
	self initializeLayout.
	editor := TextEditor new.
	editor model: template.
	textMorph := TextMorph new.
	editor morph: textMorph .
	loadeditor := TextEditor new.
	loadeditor model: template.
	loadtextMorph := TextMorph new.
	loadeditor morph: loadtextMorph .
	textMorph width: 300.
	loadtextMorph width: 300; height:300.	
	"textMorph contents: template content ."
	self	layoutInset: 5 @ 5;
		width:300.
	self initializeButtons .

]

{ #category : #accessing }
CCTemplateDetail >> initializeButtons [
	deleteButton := SimpleButtonMorph newWithLabel: 'Delete'.
	saveButton := SimpleButtonMorph newWithLabel: 'Save'.
	containerButton := SimpleButtonMorph newWithLabel: 'Deploy'.
	containerButton color: Color green darker darker darker.
	copyButton := SimpleButtonMorph newWithLabel: 'Copy'.
	editButton := SimpleButtonMorph newWithLabel: 'Edit Dockerfile'.
	loadeditButton := SimpleButtonMorph newWithLabel: 'Edit loadfile'.
	renameButton := SimpleButtonMorph newWithLabel: 'Rename'.
	editButton target: self;
		actionSelector: #openEditor.
	loadeditButton target: self;
		actionSelector: #openLoadEditor.		
	containerButton target: self;
		actionSelector: #createContainer.			
	self addMorph: saveButton.
	saveButton target: self;
		actionSelector: #saveEditor.
	self addMorph: deleteButton.
	deleteButton target: self;
		actionSelector: #deleteTemplate.	
	self addMorph: copyButton.
	self addMorph: editButton.
	self addMorph: loadeditButton.
	self addMorph: renameButton.
	self addMorph: containerButton .
	renameButton target: self;
		actionSelector: #renameTemplate.
]

{ #category : #initializing }
CCTemplateDetail >> initializeLayout [
	self
		layoutPolicy: TableLayout new;
		wrapCentering: #topLeft;"
		"wrapDirection: #leftToRight;
		listDirection: #leftToRight  ;
		listCentering: #topLeft;
		hResizing: #spaceFill;
		vResizing: #shrinkWrap;
		"hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;"
		width:300;
		color: Color yellow ;
		"wrapDirection: #leftToRight ;"
		"cellInset: 10;"
		color: Color gray darker
]

{ #category : #accessing }
CCTemplateDetail >> onTemplateDelete: aBlock [
	templateDelete := aBlock 
	
]

{ #category : #accessing }
CCTemplateDetail >> onTemplateUpdate: aBlock [
	templateUpdate := aBlock
	
]

{ #category : #accessing }
CCTemplateDetail >> openEditor [
	Transcript show:'tempalteDetail.openEditor. dependecies = ',template dependencies size asString;cr.
	textMorph contents: template content.
	textMorph   openInWindow .
]

{ #category : #accessing }
CCTemplateDetail >> openLoadEditor [
	loadtextMorph contents: template loadFile .
	loadtextMorph   openInWindow .
]

{ #category : #accessing }
CCTemplateDetail >> renameTemplate [
	template
		name:
			(UIManager default
				request: 'Change name to:'
				initialAnswer: template name).
	templateUpdate value.
	self template: template
]

{ #category : #accessing }
CCTemplateDetail >> saveEditor [
	| result loadResults |
	result := textMorph contents.
	loadResults := loadtextMorph contents.
	template isNil
		ifFalse: [ template
				content: result;
				loadFile: loadResults;
				bumpGeneration ]
]

{ #category : #accessing }
CCTemplateDetail >> template [
	^ template
]

{ #category : #accessing }
CCTemplateDetail >> template: anObject [
	template := anObject.
	Transcript show: '--- TemplateDetail template set for: ',anObject asString;cr.
	textMorph contents: template content .
]
