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
				with: [ spec repository: 'github://noha/JSONWebToken:master/source' ].
			spec
				baseline: 'TaskIt'
				with: [ spec repository: 'github://sbragagnolo/taskit' ].
			spec
				baseline: 'Roassal2'
				with:
					[ spec repository: 'github://ObjectProfile/Roassal2/src' ] ]
]

{ #category : #baselines }
BaselineOfCloudConversations >> projectClass [
	^ MetacelloCypressBaselineProject
]
