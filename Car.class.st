"
exercises.
"
Class {
	#name : #Car,
	#superclass : #Object,
	#instVars : [
		'price',
		'rentDates'
	],
	#category : #'LifewareHR-Core'
}

{ #category : #'instance creation' }
Car class >> golf [
	^ self price: 100
]

{ #category : #'instance creation' }
Car class >> panda [
	^ self price: 50
]

{ #category : #'instance creation' }
Car class >> price: aPrice [
	^ self new setPrice: aPrice
]

{ #category : #'instance creation' }
Car class >> tesla [
	^ self price: 400
]

{ #category : #boolean }
Car >> available: aDate [
	"Looks if a car is available at a certain date."
	|available|
	available:= false.
	(rentDates isNil) ifTrue: [rentDates := OrderedCollection new.].
		
	rentDates detect: [:dates | dates equals: aDate] ifFound:[available := false] 
						ifNone: [available:= true].
		
	^available  
]

{ #category : #boolean }
Car >> availableFrom: initDate to: lastDate [
	"Looks if a car is available on a certain interval of dates."
	|bufferDate available|
	bufferDate := initDate.
	available := true.
	[bufferDate equals: (lastDate addDays: 1)] whileFalse: [ 
		(self available: bufferDate) ifFalse: [available:= false]. bufferDate := bufferDate addDays: 1].
	^available
]

{ #category : #accessor }
Car >> price [
	^ price
]

{ #category : #accessor }
Car >> price: aPrice [
	price := aPrice
]

{ #category : #accessor }
Car >> rentFrom: initDate to: lastDate [ 
	"Car will be rented from initDate to lastDate. Therefore it will be unavailable between those days."
	| bufferDate |
	(rentDates isNil)
		ifTrue: [ rentDates := OrderedCollection new].
		
	bufferDate := initDate.
	[bufferDate equals: (lastDate addDays: 1)] whileFalse: 
		[ rentDates add: bufferDate . 
				bufferDate := bufferDate addDays: 1]
]

{ #category : #initialization }
Car >> setPrice: aPrice [
	price := aPrice.
]
