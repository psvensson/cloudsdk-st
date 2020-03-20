Class {
	#name : #CCDeploymentsWindow,
	#superclass : #PanelMorph,
	#instVars : [
		'deploymentsList',
		'deployments',
		'selectedDeploymentIndex',
		'account',
		'table',
		'deploymentConnection'
	],
	#category : #'CloudConversations-UI-Deployments'
}

{ #category : #accessing }
CCDeploymentsWindow >> account [
	^ account
]

{ #category : #accessing }
CCDeploymentsWindow >> account: anObject [
	account := anObject.
	self getGoogleRunDeployments.
]

{ #category : #accessing }
CCDeploymentsWindow >> deploymentSelected: aDeploymentIndex [
	|  deployment |
	aDeploymentIndex = 0 ifTrue: [ ^ self ].
	selectedDeploymentIndex := aDeploymentIndex .
	deploymentsList selectionIndex: aDeploymentIndex .
]

{ #category : #accessing }
CCDeploymentsWindow >> deployments [
	^ deployments
]

{ #category : #accessing }
CCDeploymentsWindow >> deployments: d [
	deployments := d
]

{ #category : #accessing }
CCDeploymentsWindow >> getGoogleRunDeployments [
	| connection status | 
	connection := CCMainController getConnectionForAccount: account .
	status := connection connect .	
	deployments := CCGoogleRunDeployments listAllServicesForConnection: connection.	
	self class savedContainers: deployments.
	deploymentsList
		on: self
		list: #containers
		selected: #selectedContainerIndex
		changeSelected: #containerSelected:
		menu: nil
		keystroke: nil.
	deployments isEmpty ifFalse: [ self deploymentSelected: 1 ]	
]

{ #category : #initialization }
CCDeploymentsWindow >> initialize [ 	
	| title |
	super initialize.
	self initializeLayout.	
	self initializeDeploymentsList.
	self initializeTable .
	title := TextMorph new.
	title contents: 'Deployments'.
	self addMorph: title.
	
]

{ #category : #initialization }
CCDeploymentsWindow >> initializeDeploymentsList [
	deploymentsList := PluggableIconListMorph new.
	deploymentsList
		color: Color gray;
		top: 35;
		left: 10;
		width:220;
		height:400;
		borderWidth: 10;
		hResizing: #shrinkWrap;
		"vResizing: #shrinkWrap ;"
		getIconSelector: #icon.
	
	self addMorph: deploymentsList	
]

{ #category : #initialization }
CCDeploymentsWindow >> initializeLayout [
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
CCDeploymentsWindow >> initializeTable [
	table := CCDeploymentDetail new.
	table
		top: 35.
		"left: 250"
	self addMorph: table
]
