import Cocoa

// Declaring Arrays and Initializing
var myArr: [String]
myArr = []

var songs: [String] = []
var moreSongs = [String]()

type(of:songs)

// Appending to Arrays
songs.append("Shake it off")
moreSongs.append("You belong with me")

// Accessing an Array
songs[0]


// Concatenating Arrays
var allSongs = songs + moreSongs
allSongs += ["Back to Decemeber"]

// Modifying contents of an Array
allSongs[2] = "Dear John"
allSongs



// Dictionary - Key-Value pairs. Keys are most commonly strings
var dict = [
	"first": "Jason",
	"middle": "N/A",
	"last:": "Pinlac",
	"month": "May",
	"email": "jasonpinlac@gmail.com"]

dict["first"]
dict["email"]




// Control Flow
var action: String
var person = "Player"

if person == "Hater" {
	action = "hate"
} else if person == "Player" {
	action = "play"
} else {
	action = "cruise"
}

var action2: String
var isStayingOutTooLate = false
var isBored = false

if isStayingOutTooLate && isBored {
	action2 = "Taking a cruise"
}

if !isStayingOutTooLate && !isBored {
	action2 = "Going to bed early for tomorrow"
}



// Loops

for i in 1...10 {
	print("\(i) * 10 is \(i * 10)")
}

var str = "Fakers gonna"
for _ in 1...5 {
	str += " fake"
}
str

for song in allSongs {
	print(song)
}

var people = ["players", "haters", "heart-breakers", "fakers"]
var actions = ["play", "hate", "break", "fake"]

for i in people.indices {
	print("\(people[i]) gonna \(actions[i])")
}



// Nested Loops
for i in 0 ..< people.count {
	var str = "\(people[i]) gonna "
	for i in 0 ..< actions.count {
		str += "\(actions[i]) "
	}
	print(str)
}



// While loops
var counter = 0
while true {
	counter += 1
	
	if counter == 5 {
		continue
	}
	
	if counter == 8 {
		break
	}
	
	print("Counter is now \(counter)")
}



// Switch
var liveAlbums = 2

switch liveAlbums {
case 0:
	print("You're just starting out")
case 1:
	print("You just released iTines Live from SoHo")
case 2:
	print("You just released Spea Now World Tour")
default:
	print("Have you done something new?")
}



// Optionals - Set or Not Set. Has a value that needs to be unwrapped or has nil
func getHaterStatus(weather: String) -> String? {
	if weather == "Sunny" {
		return nil
	} else {
		return "Hate"
	}
}

func takeHaterStatus(status: String) {
	if status == "Hate" {
		print("Hating")
	}
}

var status = getHaterStatus(weather: "Windy")
print(status)

if let unwrappedStatus = getHaterStatus(weather: "Sunny") {
	takeHaterStatus(status: unwrappedStatus)
} 

// Optionals again
func yearAlbumReleased(name: String) -> Int? {
	if name == "Taylor Swift" { return 2006 }
	if name == "Fearless" { return 2008 }
	return nil
}

if let year = yearAlbumReleased(name: "Girls Girls Girls") {
	print(year)
}

// Optionls once more
var items = ["James", "John", "Sally"]

func position(of string: String, in array: [String]) -> Int? {
	for i in array.indices {
		if string == array[i] {
			return i
		}
	}
	return nil
}

if let indexResult = position(of: "James", in: items) {
	print(indexResult)
} else {
	print("Not found")
}




// Handling Optionals - Set or Not Set. Has a value that needs to be unwrapped or has nil

var year = yearAlbumReleased(name: "Taylor Swift")

if year == nil {
	print("There was an error")
} else {
	print("It was releaed in \(year!)")
}

var name: String = "Paul" // Non-Optional String
var name2: String? = "Bob" // Optional String that we must unwrap explicitly
var name3: String! = "Sophie" // Implicitly-Unwrapped optionals - Whenever we use this variable it will always unwrapped already. Becareful and understand that you must always know it will have a value or else it will crash you program

func albumReleased(year: Int) -> String? {
	switch year {
	case 2006:
		return "Taylor Swift"
	case 2008:
		return "Fearless"
	default:
		return nil
	}
}

var album = albumReleased(year: 2008)
print(album!)

// Optional Chaining. Takes the optionals value and performs the chained methods. This does NOT unwrap the optional though.
var album2 = albumReleased(year: 2006)?.uppercased()
print(album2)





