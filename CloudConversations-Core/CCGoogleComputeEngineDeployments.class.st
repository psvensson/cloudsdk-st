Class {
	#name : #CCGoogleComputeEngineDeployments,
	#superclass : #CCGoogleDeployments,
	#category : #'CloudConversations-Core-Deployments'
}

{ #category : #'as yet unclassified' }
CCGoogleComputeEngineDeployments class >> listServicesForConnection: connection andZone: zone [
	| projectId url |
	projectId := connection serviceAccount projectId.
	url := 'https://compute.googleapis.com/compute/v1/projects/'
		, projectId , '/zones/' , zone , '/instances'.
	Transcript
		show: 'list compute engine services for: ' , url;
		cr.
	^ connection secureJSONCallTo: url
]

{ #category : #accessing }
CCGoogleComputeEngineDeployments >> initialize [ 
	super initialize.
	type := 'computeengine'
]

{ #category : #accessing }
CCGoogleComputeEngineDeployments >> list [ 
	"https://compute.googleapis.com/compute/v1/projects/{project}/zones/{zone}/instances"

]
