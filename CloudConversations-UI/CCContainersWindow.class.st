Class {
	#name : #CCContainersWindow,
	#superclass : #CCListPanel,
	#instVars : [
		'containerList',
		'containers',
		'selectedContainerIndex',
		'account',
		'table',
		'containerConnection',
		'reloadButton'
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
	container := containers at: aContainerIndex.
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
CCContainersWindow >> getContainerFor: aContainerName [
	| containerVersions cdict container future |
	future := TKTFuture new.
	(containerConnection listRepositoryTags: aContainerName)
		onSuccessDo: [ :tags | 
			tags inspect.
			containerVersions := tags at: #manifest ifAbsent: [  ].
			containerVersions
				ifNotNil: [ cdict := CCContainer getLatestContainerVersion: containerVersions.
					cdict at: #name put: aContainerName.
					cdict at: #tags put: (tags at: #tags).
					cdict at: #manifest put: containerVersions.
					container := CCContainer from: cdict.
					future deploySuccess: container ] ].
	^ future
]

{ #category : #initialization }
CCContainersWindow >> getContainerListFromCloud [
	| connection future |
	connection := CCMainController getConnectionForAccount: account.
	connection connect.
	containerConnection := CCGoogleContainers with: connection.
	future := containerConnection listContainers.
		future onSuccessDo: [ :clist | 
			clist inspect.
			(clist includesKey: #errors)
				ifTrue: [ | msg |
					msg := (clist at: #errors) at: 1.
					UIManager default
						inform: (msg at: #code) , ': ' , (msg at: #message) ]
				ifFalse: [ | containerFutures |
					containerFutures := (clist at: #child)
						collect: [ :each | self getContainerFor: each ].
					(CCMainController futuresAll: containerFutures)
						onSuccessDo: [ :cs | 
							containers removeAll.
							containers addAll: cs.
							containerList
								on: self
								list: #containers
								selected: #selectedContainerIndex
								changeSelected: #containerSelected:
								menu: nil
								keystroke: nil.
							cs isEmpty
								ifFalse: [ self containerSelected: 1 ] ] ] ];
					onFailureDo: [ :fail | 
			Transcript
				show: 'failed to get container list: ' , fail asString;
				cr ]
]

{ #category : #initialization }
CCContainersWindow >> initialize [
	| title |
	super initialize.
	self initializeLayout.	
	self initializeContainerList.
	self initializeTable .
	title := TextMorph new.
	title contents: 'Available Docker Containers'; left: 200.
	self addMorph: title.
	self initializeButtons.
	containers := CCMainWindow models containers.
	
]

{ #category : #initialization }
CCContainersWindow >> initializeButtons [
	reloadButton := SimpleButtonMorph newWithLabel: 'Reload'.
	reloadButton
		color: Color green darker darker;
		target: self;
		actionSelector: #reloadResults.
	self addMorph: reloadButton.
	
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
CCContainersWindow >> reloadResults [
	self getContainerListFromCloud
	
]

{ #category : #initialization }
CCContainersWindow >> selectedContainerIndex [
	^ selectedContainerIndex
]
