Class {
	#name : #BaselineOfCloudConversations,
	#superclass : #BaselineOf,
	#category : #BaselineOfCloudConversations
}

{ #category : #baselines }
BaselineOfCloudConversations >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec
				package: 'CloudConversations-Models';
				package: 'CloudConversations-Core';
				package: 'CloudConversations-UI'.
			spec
				baseline: 'NeoJSON'
				with: [ spec repository: 'github://svenvc/NeoJSON/repository' ].
			spec
				baseline: 'JSONWebToken'
				with: [ spec repository: 'github://noha/JSONWebToken/source' ].
			"spec
				baseline: 'TaskIt'
				with: [ spec repository: 'github://sbragagnolo/taskit' ]" ]
]

{ #category : #baselines }
BaselineOfCloudConversations >> projectClass [
	^ MetacelloCypressBaselineProject
]
