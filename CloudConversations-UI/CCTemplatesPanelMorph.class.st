Class {
	#name : #CCTemplatesPanelMorph,
	#superclass : #GroupboxMorph,
	#instVars : [
		'templates',
		'templatesPanel',
		'templateDetail',
		'dependeciesDetail'
	],
	#category : #'CloudConversations-UI-Templates'
}

{ #category : #initialization }
CCTemplatesPanelMorph >> initialize [
	super initialize.
	self label: 'Docker Templates'.
	templatesPanel := CCTemplatesPanel new.
	templatesPanel
		onTemplateSelected: [ :selectedTemplate | templateDetail template: selectedTemplate ].
	templateDetail := CCTemplateDetail new.
	templateDetail onTemplateUpdate: [ templatesPanel updateList ].
	templateDetail
		onTemplateDelete: [ :template | templatesPanel deleteTemplate ].
	self initializeLayout.
	self addMorph: templateDetail.
	self addMorph: templatesPanel
]

{ #category : #initialization }
CCTemplatesPanelMorph >> initializeLayout [
	self
		layoutPolicy: TableLayout new;
		"height: 700;"
		listDirection: #topToBottom;
		"listCentering: #justified ;"
			"cellInset: 5;"
			height: 500;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap .
			
		"vResizing: #shrinkWrap" 
]

{ #category : #accessing }
CCTemplatesPanelMorph >> templates [
	^ templates
]

{ #category : #accessing }
CCTemplatesPanelMorph >> templates: anObject [
	templates := anObject.
	templatesPanel templates: templates .
	templatesPanel
		onTemplateSelected: [ :selectedTemplate | 
			templateDetail template: selectedTemplate]	
]
