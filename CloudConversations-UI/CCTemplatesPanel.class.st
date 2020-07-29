Class {
	#name : #CCTemplatesPanel,
	#superclass : #PanelMorph,
	#instVars : [
		'templates',
		'templatesList',
		'onSelectedTemplate',
		'selectedTemplateIndex',
		'dependenciesdetail'
	],
	#category : #'CloudConversations-UI-Templates'
}

{ #category : #accessing }
CCTemplatesPanel >> addDependenciesDetail [
	dependenciesdetail := CCTemplateDependenciesDetail new.
	self addMorph: dependenciesdetail.
	
]

{ #category : #initialization }
CCTemplatesPanel >> createNewTemplate [
	"create new CCTemplate"
	| template |
	template := CCTemplate new.
	"Add new template to Models templates list"
	templates add: template.
	self updateList.
	"Select new template as selected"
	self templateSelected: (templates indexOf: template)
]

{ #category : #initialization }
CCTemplatesPanel >> deleteTemplate [
	| really |
	really := UIManager default
		confirm: 'Do you really waant to delete this Service Account Certificate?'
		orCancel: [ ^ false ].
	templates remove: (templates at: selectedTemplateIndex).
	self updateList
]

{ #category : #initialization }
CCTemplatesPanel >> highlightSelectedTemplate [
	templates
		ifEmpty: [  ]
		ifNotEmpty: [ templatesList selectionIndex: selectedTemplateIndex   ]
]

{ #category : #initialization }
CCTemplatesPanel >> initialize [
	| newTemplateButton |
	super initialize.
	self initializeLayout.
	newTemplateButton := CCMainController
		buildButtonText: #newTemplateLabel
		action: #createNewTemplate
		model: self.
	
	self addDependenciesDetail.
	self initializeTemplatesList.	
	self addMorph: newTemplateButton
]

{ #category : #initialization }
CCTemplatesPanel >> initializeLayout [
	self
		layoutPolicy: TableLayout new;
		"wrapCentering: #topLeft;"
		"wrapDirection: #leftToRight;"
		listDirection: #topToBottom  ;
		"listCentering: #topLeft;"
		"wrapDirection: #leftToRight ;"
		cellInset: 10@20;		
		"wrapCentering: #center;"
		"vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;"
		hResizing: #spaceFill;
		vResizing: #spaceFill;
		"height: 200;"
		themeChanged;
		color: Color gray darker
]

{ #category : #initialization }
CCTemplatesPanel >> initializeTemplatesList [
	templatesList := PluggableIconListMorph new.
	templatesList
		color: Color gray;
		top: 35;
		"left: 10;"
			"width:220;"
			height: 200;
		borderWidth: 10;
		hResizing: #spaceFill;
		"vResizing: #spaceFill;"
			getIconSelector: #icon.
	self addMorph: templatesList.
	templatesList updateList
]

{ #category : #initialization }
CCTemplatesPanel >> newTemplateLabel [
	^ 'New Template' 
]

{ #category : #initialization }
CCTemplatesPanel >> onTemplateSelected: aBlock [
	onSelectedTemplate := aBlock.
	
	
]

{ #category : #initialization }
CCTemplatesPanel >> selectListRow [
	^ selectedTemplateIndex 
]

{ #category : #initialization }
CCTemplatesPanel >> templateSelected: anIndex [
	| template |
	anIndex > 0
		ifFalse: [ ^ self ].
	selectedTemplateIndex := anIndex.
	template := templates at: selectedTemplateIndex.
	onSelectedTemplate ifNotNil: [ onSelectedTemplate value: template ].
	self highlightSelectedTemplate.
	dependenciesdetail template: template
]

{ #category : #initialization }
CCTemplatesPanel >> templates [
	^ templates 
]

{ #category : #initialization }
CCTemplatesPanel >> templates: aCollection [
	templates := aCollection.
	templatesList
		on: self
		list: #templates
		selected: #selectListRow
		changeSelected: #templateSelected:
		menu: nil
		keystroke: nil.
	aCollection isEmpty ifFalse: [ self templateSelected: 1 ].
]

{ #category : #initialization }
CCTemplatesPanel >> updateList [ 
	templatesList updateList.
]
