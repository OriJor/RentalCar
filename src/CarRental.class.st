"
commentStamp: 'LWhr 3/28/2017 14:51' prior: 0
"
Class {
	#name : #CarRental,
	#superclass : #Object,
	#instVars : [
		'cars'
	],
	#category : #'LifewareHR-Core'
}

{ #category : #adding }
CarRental >> addCar: aCar [
	"Adds a car into the CarRental OrderedCollection"
	cars add: aCar
	
]

{ #category : #accesing }
CarRental >> availableCars [
	"Returns all today's avaliable cars"

	^self availableCarsAt: Date today
]

{ #category : #accesing }
CarRental >> availableCarsAt: aDate [
	"Returns all the avaliable cars at this date"

	^cars select: [ :car | car available: aDate ]
]

{ #category : #accesing }
CarRental >> availableCarsFrom: initDate to: lastDate [
	"Returns all the avaliable cars in this date interval."
	^cars select: [ :car | car availableFrom: initDate to: lastDate ]
]

{ #category : #initialization }
CarRental >> initialize [
	cars := OrderedCollection new
]

{ #category : #printing }
CarRental >> interactWithTranscript: initDate to: lastDate [
"Shows the cars availables from initDay to lastDay and their prices. "
	|num listCarsAvailable|		
	listCarsAvailable := self availableCarsFrom: initDate to: lastDate .
	num := OrderedCollection new.
	1 timesRepeat: [ num add: (UIManager default request: 'Enter the car number you want to rent. If anyone, enter 0.') asNumber ].
	num do: [:each | (each <= listCarsAvailable size & each>0) ifTrue: 
		[self rent: (listCarsAvailable at: each) from: initDate to: lastDate ]].
]

{ #category : #util }
CarRental >> priceFor: aCar days: anInteger [
"Price for renting a car, given the car and the renting days. Taking into account a possible rebate depending on the car an the number of rented days."
	| price |
	(anInteger <0) ifTrue: [ ^0 ].
	cars detect: [ :car | car == aCar] ifFound: [] ifNone: [^0].
	
	price := aCar price * anInteger.
	^price - (self rebate: aCar days: anInteger)  

]

{ #category : #printing }
CarRental >> printAvailableCar: initDate to: lastDate [
"Shows the cars availables from initDay to lastDay and their prices. "
	| listCarsAvailable days prices info | 
	listCarsAvailable := self availableCarsFrom: initDate to: lastDate.
	days := lastDate subtractDate: initDate.
	prices := 0.
	info := ''.
	listCarsAvailable isEmpty
		ifTrue: [ ^ 0 ].
	info:= 'The following cars are available: ', String cr.
	listCarsAvailable	doWithIndex: [ :car :i | prices := self priceFor: car days: days.
			info:=info, 'Car ' , i asString , ' with cost: ' , prices asString , String cr ].
		
^info
]

{ #category : #util }
CarRental >> rebate: aCar days: anInteger [
	"Returs all the possible rebates and discounts our client has acces depending on the car they are renting and the number of rented days. List of rebates : 1. Fom the fourth day a 10% rebate on all the cars."

	|fromDay discount|
	fromDay:=4.
	discount := 0.10.
	(anInteger < fromDay) ifTrue: [^0] ifFalse: [^ aCar price *(anInteger+1 - fromDay )*discount].
]

{ #category : #action }
CarRental >> rent: aCar days: anInteger [
	"A Car as rented from today for a number of days"
	| today|
	today := Date today.
	self rent: aCar from: today to: (today addDays: anInteger -1)   
]

{ #category : #action }
CarRental >> rent: aCar from: initDate to: lastDate [
	"Rent a car from an initialDate to a lastDate. This method will check if the selected car is available on these dates and will propose other choices of cars if it is not. Ideally will interact (UI) with the client and select the car that fits their needs."
	
	((lastDate subtractDate: initDate) <0) ifTrue: [ ^0 ].
	cars detect: [ :car | car == aCar] ifFound: [] ifNone: [^0].
	
	(aCar availableFrom: initDate to: lastDate)
		ifTrue: [ aCar rentFrom: initDate to: lastDate ]
		ifFalse: [ Transcript open;  show: 'The Car is not available for these dates.'; cr;
				show: (self printAvailableCar: initDate  to: lastDate).
					"self interactWithTranscript: initlDate to: lastDate"].
]

{ #category : #accesing }
CarRental >> rentedCars [
	"Returns all the rented cars for today"

	^cars reject: [ :car | car available: Date today ]
]

{ #category : #accesing }
CarRental >> rentedCarsAt: aDate [
	"Returns all the rented cars at this date"

	^cars reject: [ :car | car available: aDate ]
]

{ #category : #accesing }
CarRental >> totalCars [
	"Returns the orderedCollection of Cars"
	^cars
]
