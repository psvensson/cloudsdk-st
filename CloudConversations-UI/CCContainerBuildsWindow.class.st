Class {
	#name : #CCContainerBuildsWindow,
	#superclass : #PanelMorph,
	#instVars : [
		'account',
		'containerList',
		'containers',
		'table',
		'selectedContainerIndex'
	],
	#classInstVars : [
		'savedContainers'
	],
	#category : #'CloudConversations-UI-Containers'
}

{ #category : #accessing }
CCContainerBuildsWindow class >> savedContainers [
	^ savedContainers
]

{ #category : #accessing }
CCContainerBuildsWindow class >> savedContainers: anObject [
	savedContainers := anObject
]

{ #category : #accessing }
CCContainerBuildsWindow >> account [
	^ account
]

{ #category : #accessing }
CCContainerBuildsWindow >> account: anObject [
	account := anObject.
	self getContainerListFromCloud
]

{ #category : #accessing }
CCContainerBuildsWindow >> containerSelected: aContainerIndex [
	|  aContainer |
	selectedContainerIndex := aContainerIndex .
	containerList selectionIndex: aContainerIndex .
	aContainer := containers at: aContainerIndex .
	table container: aContainer.
	table showContainer 
]

{ #category : #accessing }
CCContainerBuildsWindow >> containers [
	^ containers
]

{ #category : #accessing }
CCContainerBuildsWindow >> containers: anObject [
	containers := anObject
]

{ #category : #services }
CCContainerBuildsWindow >> getContainerListFromCloud [
	| connection status result list |
	connection := CCMainController getConnectionForAccount: account .
	status := connection connect .
	Transcript show:'connection status: ',status asString;cr.
	result := CCGoogleContainers with: connection.
	list := result list.
	containers := list collect: [ :each | CCContainerBuildResults from: each].
	self class savedContainers: containers.
	containerList
		on: self
		list: #containers
		selected: #selectedContainerIndex
		changeSelected: #containerSelected:
		menu: nil
		keystroke: nil
]

{ #category : #accessing }
CCContainerBuildsWindow >> getContainerObjectFrom: cdict [
	| container |
	container := CCContainerBuildResults new.
	cdict
		at: #result
		ifPresent: [ container
				results: (cdict at: #results);
				timing: (cdict at: #timing);
				sourceProvenance: (cdict at: #sourceProvenance);
				logsBucket: (cdict at: #logsBucket) ].
	container
		props: cdict;
		options: (cdict at: #options);
		images: (cdict at: #images);
		steps: (cdict at: #steps);
		finishTime: (cdict at: #finishTime);
		timeout: (cdict at: #timeout);
		id: (cdict at: #id);
		startTime: (cdict at: #startTime);
		projectId: (cdict at: #projectId);
		status: (cdict at: #status);
		createTime: (cdict at: #createTime);
		artifacts: (cdict at: #artifacts);
		logUrl: (cdict at: #logUrl);
		source: (cdict at: #source).
	^ container
]

{ #category : #accessing }
CCContainerBuildsWindow >> getTableCollectionForContainer: aContainer [
	| collection |
	collection := OrderedCollection new.
	aContainer props keysAndValuesDo: [  :key :value |
		| row |
		row := CCContainerRowModel new.
		Transcript show:'adding prop ',key asString,' -> ',value asString;cr.
		row property: key; value: value.
		collection add: row ].
	^ collection
]

{ #category : #initialization }
CCContainerBuildsWindow >> initialize [
	| title |
	super initialize.
	self initializeLayout.
	self initializeContainerList.
	self initializeTable .
	title := TextMorph new.
	title contents: 'Result of Docker Container builds'.
	self addMorph: title.
]

{ #category : #initialization }
CCContainerBuildsWindow >> initializeContainerList [
	containerList := PluggableIconListMorph new.
	containerList
		color: Color gray;
		top: 35;
		left: 10;
		width:220;
		height:400;
		borderWidth: 10;
		hResizing: #shrinkWrap;
		"vResizing: #shrinkWrap ;"
		getIconSelector: #icon.
	
	self addMorph: containerList	
]

{ #category : #initialization }
CCContainerBuildsWindow >> initializeLayout [
	self
		layoutPolicy: ProportionalLayout new;
		"wrapCentering: #topLeft;"
		"wrapDirection: #leftToRight;"
		listDirection: #rightToLeft  ;
		"listCentering: #topLeft;"
		"wrapDirection: #leftToRight ;"
		cellInset: 10;		
		"wrapCentering: #center;"
		"vResizing: #shrinkWrap;"
		"hResizing: #shrinkWrap;"
		width: 560;
		height: 450;
		themeChanged;
		color: Color gray darker
]

{ #category : #initialization }
CCContainerBuildsWindow >> initializeTable [
	table := CCContainerBuildDetail new.
	table
		top: 35.
		"left: 250"
	self addMorph: table
]

{ #category : #services }
CCContainerBuildsWindow >> selectedContainerIndex [
	^ selectedContainerIndex
]
