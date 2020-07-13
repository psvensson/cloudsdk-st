Class {
	#name : #CCDeploymentsPanelMorph,
	#superclass : #CCGroupbox,
	#category : #'CloudConversations-UI-Deployments'
}

{ #category : #initialization }
CCDeploymentsPanelMorph >> getDetailPanel [
	^ CCDeploymentDetail new
]

{ #category : #initialization }
CCDeploymentsPanelMorph >> getListPanel [
	| listpanel |
	listpanel := CCDeploymentsListPanel new.
	listpanel
		account: CCMainController lastUsedAccount.
	^ listpanel
]

{ #category : #initialization }
CCDeploymentsPanelMorph >> modelName [
	^ 'Deployments'
]
