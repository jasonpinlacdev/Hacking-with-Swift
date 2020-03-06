import UIKit

// Strings are not arrays of characters. They are a series of characters, symbols, or even emojies.
// Strings are iterable with for-in loop
// Strings are accessible using [] but you cannot use an integer. You must use String.index

let name = "jason"
for letter in name {
    print(letter)
}

let thirdLetter = name[name.index(name.startIndex, offsetBy: 2)]
print(thirdLetter)



extension String {
    func deletePrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
        
    }
    
    func deleteSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
}


let password = "12345"
password.hasPrefix("123")
password.hasSuffix("45")

let remainingWord = password.deletePrefix("123")
print(remainingWord)





extension String {
    // computed property
    var capitalizeFirst: String {
        guard let firstLetter = self.first else { return "" }
        return firstLetter.uppercased() + self.dropFirst()
    }
}

let weather = "it's going to rain."
print(weather.capitalized)

let result = weather.capitalizeFirst
print(result)





extension String {
    
    func containsAny(of array:[String]) -> Bool {
        for item in array {
            if self.contains(item) {
                return true
            }
        }
        return false
    }
    
}


let input = "Swift is like Objective-C without the C"
print(input.contains("Objective-C"))

let languages = ["Python", "Ruby", "Swift"]
print(languages.contains("Swift"))


input.containsAny(of: languages)

languages.contains(where: input.contains) //THIS IS SIMILAR TO HOW USING MAP TO TRANSFORM AN ARRAY like example below


var numbers = [1,2,3,4]
var doubledNumbes = numbers.map {
    $0 * 2
}

