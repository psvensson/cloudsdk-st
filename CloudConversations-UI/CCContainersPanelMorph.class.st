Class {
	#name : #CCContainersPanelMorph,
	#superclass : #CCGroupbox,
	#category : #'CloudConversations-UI-Containers'
}

{ #category : #initialization }
CCContainersPanelMorph >> getDetailPanel [
	^ CCContainerDetail new
]

{ #category : #initialization }
CCContainersPanelMorph >> getListPanel [
	| listpanel |
	listpanel := CCContainersWindow new.
	listpanel
		account: CCMainController lastUsedAccount.
	^ listpanel
]

{ #category : #initialization }
CCContainersPanelMorph >> modelName [
	^ 'Containers'
]
