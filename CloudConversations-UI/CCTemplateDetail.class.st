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
		'templateDelete',
		'buildProcessBlock',
		'regenerateeButton',
		'regenerateButton'
	],
	#category : #'CloudConversations-UI-Templates'
}

{ #category : #examples }
CCTemplateDetail class >> createButton: label target: target selector: selector [
	| button |
	button := CCMainController
		buildButtonText: label
		action: selector
		model: target.
	^ button
]

{ #category : #accessing }
CCTemplateDetail >> copyLabel [
	^ 'Copy'
]

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
		onSuccessDo: [ :result | 
			self showBuildProcess: result
			"TODO: start polling process to show buidl step progress" ].
	CCMainController getMainWindow showBusyIcon.
	UIManager default
		informUser: 'Container created and deploy started.'
		during: [ (Delay forSeconds: 3) wait ].
	^ true
]

{ #category : #accessing }
CCTemplateDetail >> deleteLabel [
	^ 'Delete'
]

{ #category : #accessing }
CCTemplateDetail >> deleteTemplate [
	templateDelete ifNotNil: [ templateDelete value: template ]
]

{ #category : #accessing }
CCTemplateDetail >> deployLabel [
	^ 'Deploy'
]

{ #category : #accessing }
CCTemplateDetail >> dockerfileLabel [
	^ 'Edit Dockerfile'
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
	loadtextMorph width: 300; height:300.	
	"textMorph contents: template content ."
	self	layoutInset: 5 @ 5.
	"self	width:300."
	self initializeButtons .

]

{ #category : #accessing }
CCTemplateDetail >> initializeButtons [
	regenerateButton := self class
		createButton: #regenerateLabel
		target: self
		selector: #regenerateTemplate.
	saveButton := self class
		createButton: #saveLabel
		target: self
		selector: #saveEditor.
	deleteButton := self class
		createButton: #deleteLabel
		target: self
		selector: #deleteTemplate.	
	containerButton := self class
		createButton: #deployLabel
		target: self
		selector: #createContainer.
	containerButton color: Color green darker darker darker.
	copyButton := self class
		createButton: #copyLabel
		target: self
		selector: #copyContainer.
	editButton := self class
		createButton: #dockerfileLabel
		target: self
		selector: #openEditor.
	loadeditButton := self class
		createButton: #loadfileLabel
		target: self
		selector: #openLoadEditor.
	renameButton := self class
		createButton: #renameLabel
		target: self
		selector: #renameTemplate.
	self addMorph: saveButton.
	self addMorph: deleteButton.
	self addMorph: copyButton.
	self addMorph: editButton.
	self addMorph: regenerateButton.
	self addMorph: loadeditButton.
	self addMorph: renameButton.
	self addMorph: containerButton
]

{ #category : #initializing }
CCTemplateDetail >> initializeLayout [
	self
		layoutPolicy: TableLayout new;
		wrapDirection: #topToBottom;
		listDirection: #leftToRight;
		vResizing: #shrinkWrap;
		width: 300;
		cellInset: 1;
		layoutInset: 1;
		color: Color yellow;
		color: Color gray darker
]

{ #category : #accessing }
CCTemplateDetail >> loadfileLabel [
	^ 'Edit loadfile'
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
CCTemplateDetail >> regenerateLabel [
	^ 'Recreate'
]

{ #category : #accessing }
CCTemplateDetail >> regenerateTemplate [
	template regenerateContent 
]

{ #category : #accessing }
CCTemplateDetail >> renameLabel [
	^ 'Rename'
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
CCTemplateDetail >> saveLabel [
	^ 'Save'
]

{ #category : #accessing }
CCTemplateDetail >> showBuildProcess: buildResult [
	| buildId logUrl connection containers buildTime mainWindow |
	buildResult at: #error ifPresent: [ | err |
		err := buildResult at: #error.
		UIManager default
								inform: (err at: #status) , ': ' , (err at: #message) .
		^ self ].
	mainWindow := CCMainController getMainWindow.
	buildId := ((buildResult at: #metadata) at: #build) at: #id.
	logUrl := ((buildResult at: #metadata) at: #build) at: #logUrl.
	connection := CCMainController
		getConnectionForAccount: CCMainController lastUsedAccount.
	connection connect.
	containers := CCGoogleContainers with: connection.
	buildTime := 0.
	buildProcessBlock := [ CCGoogleContainers with: connection.
	1 seconds wait.
	buildTime := buildTime + 1.
	Transcript
		show: 'getting build status.  .  .';
		cr.
	(containers getBuildResultFor: buildId)
		onSuccessDo: [ :result | 
			| text fail success cancel |
			fail := 0.
			success := 0.
			cancel := 0.
			text := 'Build time: ' , buildTime asString , 's  '.
			result
				keysAndValuesDo: [ :step :status | 
					text := text , step , ': ' , status , ' '.
					status = 'SUCCESS'
						ifTrue: [ success := success + 1 ].
					status = 'FAILURE'
						ifTrue: [ fail := fail + 1 ] .
					status = 'CANCELLED'
						ifTrue: [ 
							Transcript show:'cacnelled';cr.
							cancel := cancel + 1 ] ].
			mainWindow statusBar contents: text.
			cancel = 0 ifTrue: [ 
			(fail > 0 or: success = result keys size)
				ifTrue: [ mainWindow containersPanelMorph update.
					mainWindow deploymentPanelMorph update.
					10 seconds wait.
					mainWindow hideBusyIcon ]
				ifFalse: [ mainWindow showBusyIcon.
					buildProcessBlock value ] ] ]].
	buildProcessBlock value
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
	CCMainController lastUsedTemplate: anObject 
]
