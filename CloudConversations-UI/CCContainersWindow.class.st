Class {
	#name : #CCContainersWindow,
	#superclass : #PanelMorph,
	#instVars : [
		'containerList',
		'containers',
		'selectedContainerIndex',
		'account',
		'table',
		'containerConnection'
	],
	#classInstVars : [
		'savedContainers'
	],
	#category : #'CloudConversations-UI-Containers'
}

{ #category : #accessing }
CCContainersWindow class >> savedContainers [
	^ savedContainers
]

{ #category : #accessing }
CCContainersWindow class >> savedContainers: anObject [
	savedContainers := anObject
]

{ #category : #accessing }
CCContainersWindow >> account [
	^ account
]

{ #category : #accessing }
CCContainersWindow >> account: anObject [
	account := anObject.
	self getContainerListFromCloud
]

{ #category : #initialization }
CCContainersWindow >> containerSelected: aContainerIndex [
	| aContainerName tags container containerVersions cdict |
	aContainerIndex = 0
		ifTrue: [ ^ self ].
	selectedContainerIndex := aContainerIndex.
	containerList selectionIndex: aContainerIndex.
	aContainerName := containers at: aContainerIndex.
	tags := containerConnection listRepositoryTags: aContainerName.
	containerVersions := tags at: #manifest.
	cdict := CCContainer getLatestContainerVersion: containerVersions.
	cdict at: #name put: aContainerName.
	cdict at: #tags put: (tags at: #tags).
	cdict at: #manifest put: containerVersions.
	container := CCContainer from: cdict.
	table container: container.
	table showContainer
]

{ #category : #accessing }
CCContainersWindow >> containers [
	^ containers
]

{ #category : #accessing }
CCContainersWindow >> containers: anObject [
	containers := anObject
]

{ #category : #accessing }
CCContainersWindow >> deleteContainer [
	Transcript show:'delte container (unimplemented)';cr.
]

{ #category : #accessing }
CCContainersWindow >> deployContainer [
	Transcript show:'deploycontainer (unimplemented)';cr.
]

{ #category : #initialization }
CCContainersWindow >> getContainerListFromCloud [
	| connection status list |
	connection := CCMainController getConnectionForAccount: account .
	status := connection connect .
	containerConnection := CCGoogleContainers with: connection.
	list := containerConnection listContainers.
	containers := list at: #repositories .
	self class savedContainers: containers.
	containerList
		on: self
		list: #containers
		selected: #selectedContainerIndex
		changeSelected: #containerSelected:
		menu: nil
		keystroke: nil.
	containers isEmpty ifFalse: [ self containerSelected: 1 ]	
]

{ #category : #initialization }
CCContainersWindow >> initialize [
	| title |
	super initialize.
	self initializeLayout.	
	self initializeContainerList.
	self initializeTable .
	title := TextMorph new.
	title contents: 'Available Docker Containers'.
	self addMorph: title.
	
]

{ #category : #initialization }
CCContainersWindow >> initializeContainerList [
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
CCContainersWindow >> initializeLayout [
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
CCContainersWindow >> initializeTable [
	table := CCContainerDetail new.
	table
		top: 35.
		"left: 250"
	self addMorph: table
]

{ #category : #initialization }
CCContainersWindow >> selectedContainerIndex [
	^ selectedContainerIndex
]
