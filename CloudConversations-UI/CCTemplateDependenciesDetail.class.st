Class {
	#name : #CCTemplateDependenciesDetail,
	#superclass : #PanelMorph,
	#instVars : [
		'newButton',
		'template',
		'dependenciesList',
		'dependencySelectedIndex',
		'dialog',
		'removeButton'
	],
	#category : #'CloudConversations-UI-Templates'
}

{ #category : #accessing }
CCTemplateDependenciesDetail >> dependencies [ 
	^ template dependencies 
]

{ #category : #initialization }
CCTemplateDependenciesDetail >> dependencySelected: anIndex [
	dependencySelectedIndex := anIndex.
	dependenciesList selectionIndex: anIndex
]

{ #category : #initialization }
CCTemplateDependenciesDetail >> dependencySelectedIndex [
	^ dependencySelectedIndex 

]

{ #category : #initialization }
CCTemplateDependenciesDetail >> initialize [
	super initialize.
	self initializeButtons.
	self initializeList.
	self initializeLayout.
	self initializeDialog
]

{ #category : #initialization }
CCTemplateDependenciesDetail >> initializeButtons [
	| row |
	row := Morph new.
	row layoutPolicy: RowLayout new.
	row
		hResizing: #spaceFill;
		cellInset: 5;
		color: Color transparent;
		vResizing: #spaceFill.
	newButton := SimpleButtonMorph newWithLabel: 'Add Dependency'.
	newButton
		target: self;
		actionSelector: #newDependency.
		"hResizing: #spaceFill;
		vResizing: #spaceFill."
	removeButton := SimpleButtonMorph newWithLabel: 'Remove Dependency'.
	removeButton
		target: self;
		actionSelector: #removeDependency.
	self addMorph: row.
	row addMorph: newButton .
	row addMorph: removeButton .
	
]

{ #category : #initialization }
CCTemplateDependenciesDetail >> initializeDialog [
	dialog := CCTemplateDependenciesDialog new.
	dialog
		onProjectSelected: [ :aProject :type | 
			| dep |
			dep := CCDependency new.
			dep
				type: type;
				name: (aProject at: #full_name);
				installString: (aProject at: #installString);
				"baseline: (aProject at: #baseline);"
					"configuration: (aProject at: #configuration);"
					repository: (aProject at: #html_url).
			Transcript
				show: 'intializeDialog got add dependency callback';
				cr.
			template dependencies add: dep.
			dependenciesList updateList.
			template regenerateContent  ]
]

{ #category : #accessing }
CCTemplateDependenciesDetail >> initializeLayout [
	self
		layoutPolicy: TableLayout new;
		wrapCentering: #topLeft;
		"wrapDirection: #topToBottom;"
		wrapDirection: #leftToRight;
		listDirection: #topToBottom  ;
		"listCentering: #topLeft;"
		hResizing: #spaceFill;
		vResizing: #spaceFill;
		"hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;"
		height:300;
		width:300;
		"wrapDirection: #leftToRight ;"
		"cellInset: 10;"
		"layoutInset: 5 @ 5;"
		color: Color blue darker
]

{ #category : #initialization }
CCTemplateDependenciesDetail >> initializeList [
	dependenciesList := PluggableIconListMorph new.
	dependenciesList
		color: Color gray;
		top: 35;
		"left: 10;"
		"width:220;"
		height:200;
		borderWidth: 10;
		hResizing: #spaceFill;
		"vResizing: #spaceFill;"
		getIconSelector: #icon.
		
	self addMorph: dependenciesList.
	
]

{ #category : #initialization }
CCTemplateDependenciesDetail >> listDependencies [
	dependenciesList 
		on: self
		list: #dependencies
		selected: #dependencySelectedIndex
		changeSelected: #dependencySelected:
		menu: nil
		keystroke: nil.
	template dependencies isEmpty ifFalse: [ 
		self dependencySelected: 1 ]	
]

{ #category : #initialization }
CCTemplateDependenciesDetail >> newDependency [
	"Open new rewuirement dialog to search for and select github or smalltalkhub projects"
	| window |
	window := dialog openInWindow.
	window setLabel: 'Search for packages to add'
]

{ #category : #initialization }
CCTemplateDependenciesDetail >> removeDependency [
	| really |
	really := UIManager default
		confirm: 'Do you really waant to remove this Dependency?'
		orCancel: [ ^ false ].
	really ifTrue: [ template dependencies removeAt: dependencySelectedIndex .
		dependenciesList updateList. ]	.
		
]

{ #category : #initialization }
CCTemplateDependenciesDetail >> removeDependency: dependency [
	Transcript show: 'remvoeRequirement called for ',dependency asString;cr.
]

{ #category : #accessing }
CCTemplateDependenciesDetail >> template: anObject [
	Transcript show:'dependenciesdetail template dependencies set to: ',anObject dependencies  asString;cr.

	template := anObject.
	self listDependencies
]
