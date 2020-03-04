Class {
	#name : #CCTemplateDependenciesDialog,
	#superclass : #PanelMorph,
	#instVars : [
		'searchresults',
		'ghlookup',
		'selectedResultIndex',
		'results',
		'descriptionmorph',
		'resultpage',
		'page',
		'selectedproject',
		'onProjectSelected',
		'searchbox',
		'query',
		'pharosearch',
		'smalltalksearch'
	],
	#category : #'CloudConversations-UI-Templates'
}

{ #category : #initialization }
CCTemplateDependenciesDialog >> backwardSearch [
	page > 9
		ifTrue: [ page := page - 10 ].
	self searchProjects .	
]

{ #category : #initialization }
CCTemplateDependenciesDialog >> doQuery [
	| searchstring |
	searchstring := query.
	pharosearch
		ifTrue: [ searchstring := searchstring , '+' , 'topic:pharo' ].
	smalltalksearch
		ifTrue: [ searchstring := searchstring , '+' , 'topic:smalltalk' ].
	self searchProjects: searchstring
]

{ #category : #initialization }
CCTemplateDependenciesDialog >> forwardSearch [
	page := page + 10.
	self searchProjects 
]

{ #category : #initialization }
CCTemplateDependenciesDialog >> getListElement: anIndex [
	| dep |
	dep := results at: anIndex .
	^ dep at: #full_name
]

{ #category : #initialization }
CCTemplateDependenciesDialog >> initalizeLayout [
	self		
		"extent: 300@300;"
		layoutPolicy: TableLayout new;
		"wrapCentering: #topLeft;"
		"wrapDirection: #leftToRight;"
		listDirection: #topToBottom  ;
		"listCentering: #topLeft;"
		"hResizing: #spaceFill;
		vResizing: #spaceFill;"
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		"height:500;"
		width:450;
		color: Color lightGreen ;
		"wrapDirection: #leftToRight ;"
		cellInset: 10.
]

{ #category : #initialization }
CCTemplateDependenciesDialog >> initialize [
	super initialize.
	self initializeLookups.
	self initializeButtons .
	self initializeList .
	self initializeOptions .
	self initalizeLayout.
	self initializeFields.
	self initializeDescription .
	
	
	
]

{ #category : #initialization }
CCTemplateDependenciesDialog >> initializeButtons [
	| row selectbutton forwardbutton backwardbutton  |
	row := Morph new.
	row layoutPolicy: RowLayout new.
	row
		hResizing: #spaceFill;
		cellInset: 5;
		color: Color transparent;
		vResizing: #spaceFill.
	selectbutton := SimpleButtonMorph newWithLabel: 'Select'.
	selectbutton color: Color darkGray.
	forwardbutton := IconicButton new.
	forwardbutton labelGraphic: (Smalltalk ui theme iconNamed: #forward); color: Color darkGray.
	backwardbutton := IconicButton new.
	backwardbutton labelGraphic: (Smalltalk ui theme iconNamed: #back); color: Color darkGray.
	row addMorph: selectbutton.
	row addMorph: forwardbutton.
	row addMorph: backwardbutton.
	selectbutton target: self;
		actionSelector: #selectProject.
	forwardbutton target: self;
		actionSelector: #forwardSearch.	
	backwardbutton target: self;
		actionSelector: #backwardSearch.		
	resultpage := TextMorph new.
	row addMorph: resultpage .
	self addMorph: row
]

{ #category : #initialization }
CCTemplateDependenciesDialog >> initializeDescription [
	descriptionmorph := TextMorph new.
	descriptionmorph
		contents: 'No project selected';
		hResizing: #spaceFill;
		vResizing: #shrinkWrap;
		wrapFlag: true;
		autoFit: true.
	
	self addMorph: descriptionmorph 
]

{ #category : #initialization }
CCTemplateDependenciesDialog >> initializeFields [
	| searchmorph |
	searchmorph := SearchMorph new.
	searchmorph
		hResizing: #spaceFill;
		"vResizing: #shrinkWrap."
		height: 30;
		model: self;
		updateSelector: #searchStringUpdated:.	
	self addMorph: searchmorph.
	searchbox := TextMorphForFieldView new.

	self addMorph: searchbox.
	
]

{ #category : #initialization }
CCTemplateDependenciesDialog >> initializeList [
	selectedResultIndex := 1.
	searchresults := PluggableIconListMorph new.
	searchresults
		color: Color gray;
		top: 35;
		"left: 10;"
		"width:220;"
		height: 200;
		borderWidth: 10;
		hResizing: #spaceFill;
		"vResizing: #shrinkWrap;"
		getIconSelector: #icon.
	searchresults
		on: self
		list: #results
		selected: #selectedResultIndex
		changeSelected: #resultSelected:
		menu: nil
		keystroke: nil.
	searchresults getListElementSelector: #getListElement:.	
	self addMorph: searchresults
]

{ #category : #initialization }
CCTemplateDependenciesDialog >> initializeLookups [
	ghlookup := CCGithubLookup new.
	page := 0.
]

{ #category : #initialization }
CCTemplateDependenciesDialog >> initializeOptions [
	| row pharooption smalltalkoption |
	pharosearch := true. smalltalksearch := true.
	row := Morph new.
	row layoutPolicy: RowLayout new.
	row
		hResizing: #spaceFill;
		cellInset: 5;
		color: Color transparent;
		vResizing: #spaceFill.
	pharooption := SimpleSwitchMorph newWithLabel: 'Pharo'.	
	row addMorph: pharooption.
	pharooption target: self;		
		onColor: Color green darker darker darker; offColor: Color gray;
		turnOn;
		actionSelector: #selectPharoSearch:.
	smalltalkoption := SimpleSwitchMorph newWithLabel: 'Smalltalk'.	
	row addMorph: smalltalkoption.
	smalltalkoption target: self;
		onColor: Color green darker darker darker; offColor: Color gray;turnOn;
		actionSelector: #selectSmalltalkSearch:.	
	
	self addMorph: row
]

{ #category : #initialization }
CCTemplateDependenciesDialog >> onProjectSelected: aBlock [ 	
	onProjectSelected := aBlock 
]

{ #category : #initialization }
CCTemplateDependenciesDialog >> resultSelected: anIndex [
	|  i |
	i := (anIndex = 0) ifTrue: [ 1 ] ifFalse: [ anIndex ].
	selectedResultIndex := i.
	searchresults updateList.
	selectedproject := results at: i.
	Transcript
		show: 'package dependency ' , selectedproject asString , ' selected';
		cr.
	descriptionmorph
		contents: (selectedproject at: #description);
		"width: 100;"
		hResizing: #spaceFill;
		vResizing: #shrinkWrap;
		wrapFlag: true;
		autoFit: true.
]

{ #category : #initialization }
CCTemplateDependenciesDialog >> results [
	"Transcript show:'searchresult called';cr."
	results
		ifNil: [ results := self searchProjects ].
	"Transcript show:'searchresults size = ',results size asString;cr.	"
	^ results
]

{ #category : #initialization }
CCTemplateDependenciesDialog >> searchProjects [
	query isNil ifFalse: [ ghlookup query: query ].
	results := ghlookup findProjectsFromPage: page.
	resultpage contents: page asString , ' - ' , (page + 10) asString.
	searchresults updateList.
	^ results
]

{ #category : #initialization }
CCTemplateDependenciesDialog >> searchProjects: searchstring [
	searchstring isNil ifFalse: [ ghlookup query: searchstring ].
	results := ghlookup findProjectsFromPage: page.
	resultpage contents: page asString , ' - ' , (page + 10) asString.
	searchresults updateList.
	^ results
]

{ #category : #initialization }
CCTemplateDependenciesDialog >> searchStringUpdated: aString [	
	Transcript show:'searchstring: ',aString;cr.
	query := aString.
	self doQuery
]

{ #category : #initialization }
CCTemplateDependenciesDialog >> selectPharoSearch: state [
	Transcript show:'selectPharoSearch: ',state asString;cr.
	pharosearch := state.
	self doQuery
	

]

{ #category : #initialization }
CCTemplateDependenciesDialog >> selectProject [
	selectedproject := results  at: selectedResultIndex.
	Transcript show:'selectProject called: ',selectedproject  asString;cr.
	onProjectSelected isNil ifFalse: [ 
		selectedproject at: #installString put: (ghlookup installStringForItem: selectedproject ).
		onProjectSelected value: selectedproject value: 'github' ]
]

{ #category : #initialization }
CCTemplateDependenciesDialog >> selectSmalltalkSearch: state [
	Transcript show:'selectSmalltalkSearch: ',state asString;cr.
	smalltalksearch := state.
	self doQuery

]

{ #category : #initialization }
CCTemplateDependenciesDialog >> selectedResultIndex [
	^ selectedResultIndex
]
