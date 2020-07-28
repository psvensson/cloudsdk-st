Class {
	#name : #CCDeploymentsListPanel,
	#superclass : #CCListPanel,
	#instVars : [
		'deploymentsList',
		'deployments',
		'selectedDeploymentIndex',
		'account',
		'table',
		'deploymentConnection',
		'endpoint',
		'reloadButton',
		'zone',
		'runDeployments',
		'computeEngineDeployments'
	],
	#category : #'CloudConversations-UI-Deployments'
}

{ #category : #accessing }
CCDeploymentsListPanel >> account [
	^ account
]

{ #category : #accessing }
CCDeploymentsListPanel >> account: anObject [
	account := anObject.
	account ifNotNil: [self reloadResults ]
]

{ #category : #accessing }
CCDeploymentsListPanel >> deploymentSelected: aDeploymentIndex [
	|  aDeployment |
	selectedDeploymentIndex := aDeploymentIndex .
	list selectionIndex: aDeploymentIndex .
	aDeployment := listCollection at: aDeploymentIndex .
	"table deployment: aDeployment .
	table showDeployment"
]

{ #category : #accessing }
CCDeploymentsListPanel >> deployments [
	^ deployments
]

{ #category : #accessing }
CCDeploymentsListPanel >> deployments: d [
	deployments := d
]

{ #category : #listing }
CCDeploymentsListPanel >> getGoogleComputeEngineDeployments [
	| connection operation |
	 connection := CCMainController getConnectionForAccount: CCMainController lastUsedAccount .
			zone := CCMainWindow models selectedZone.
			connection connect.
			operation := CCGoogleComputeEngineDeployments
				listServicesForConnection: connection
				andZone: zone.
			operation
				onSuccessDo: [ :result | 
					CCMainController getMainWindow hideBusyIcon.
					(result includesKey: #error)
						ifTrue: [ | msg |
							msg := result at: #error.
							UIManager default
								inform: (msg at: #status) , ': ' , (msg at: #message) ]
						ifFalse: [ | clist |
							clist := (result includesKey: #items)
								ifTrue: [ result at: #items ]
								ifFalse: [ #() ].
							computeEngineDeployments := clist
								collect: [ :each | CCDeployment from: each type: 'computeengine' ].
							self listCollection: runDeployments , computeEngineDeployments.
							listCollection isEmpty
								ifFalse: [ self itemSelected: 1 ] ] ];
				onFailureDo: [ :e | 
					Transcript
						show: 'list compute engine instance error: ' e asString;
						cr ] 
]

{ #category : #listing }
CCDeploymentsListPanel >> getGoogleRunDeployments [
	| connection future |
	 connection := CCMainController getConnectionForAccount: CCMainController lastUsedAccount .
			endpoint := CCMainWindow models selectedEndpoint.
			connection connect.
			future := CCGoogleRunDeployments
				listServicesForConnection: connection
				andEndpoint: endpoint.
			future
				onSuccessDo: [ :result | 
					CCMainController getMainWindow hideBusyIcon.
					(result includesKey: #error)
						ifTrue: [ | msg |
							msg := result at: #error.
							UIManager default
								inform: (msg at: #status) , ': ' , (msg at: #message) ]
						ifFalse: [ | rlist |
							rlist := (result includesKey: #items)
								ifTrue: [ result at: #items ]
								ifFalse: [ #() ].
							runDeployments := rlist
								collect: [ :each | CCDeployment from: each type: 'cloudrun' ].
							"self class savedContainers: deployments"
							self listCollection: runDeployments , computeEngineDeployments.
							listCollection isEmpty
								ifFalse: [ self itemSelected: 1 ] ] ];
				onFailureDo: [ :fail | 
					Transcript
						show: 'failed to get google run list: ' , fail asString;
						cr ] 
]

{ #category : #initialization }
CCDeploymentsListPanel >> initialize [
	super initialize.
	self initializeButtons
]

{ #category : #listing }
CCDeploymentsListPanel >> initializeButtons [
	reloadButton := SimpleButtonMorph newWithLabel: 'Reload'.
	reloadButton
		color: Color green darker darker darker;
		target: self;
		actionSelector: #reloadResults.
	self addMorph: reloadButton.
]

{ #category : #initialization }
CCDeploymentsListPanel >> initializeTable [
	table := CCDeploymentDetail new.
	
	self addMorph: table
]

{ #category : #initialization }
CCDeploymentsListPanel >> reloadResults [
	runDeployments  := OrderedCollection new.
	computeEngineDeployments := OrderedCollection new.
	CCMainController getMainWindow showBusyIcon.
	self getGoogleRunDeployments .
	self getGoogleComputeEngineDeployments .
]

{ #category : #accessing }
CCDeploymentsListPanel >> selectedDeploymentIndex [
	^ selectedDeploymentIndex
]

{ #category : #accessing }
CCDeploymentsListPanel >> selectedDeploymentIndex: anObject [
	selectedDeploymentIndex := anObject
]

{ #category : #rendering }
CCDeploymentsListPanel >> updateList [
	self reloadResults 
]
