import UIKit


extension String {
    func withPrefix(_ prefix: String) -> String {
        if self.hasPrefix(prefix) { return self }
        else {
            return prefix + self
        }
    }
}

let str = "thisisateststring"
var result = str.withPrefix("whoa")
str
result



extension String {
    var isNumeric: Bool {
        var numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        for number in numbers {
            if self.contains(String(number)) {
                return true
            }
        }
        return false
    }
}

let aStr = "This is number one string!"
var aResult = aStr.isNumeric
aResult


extension String {
    var lines: [String] {
        return self.components(separatedBy: "\n")
    }
}

let anotherString = "this\nis\na\ntest"
var anotherResult = anotherString.lines


//
//// Strings are not arrays of characters. They are a series of characters, symbols, or even emojies.
//// Strings are iterable with for-in loop
//// Strings are accessible using [] but you cannot use an integer. You must use String.index
//
//let name = "jason"
//for letter in name {
//    print(letter)
//}
//
//let thirdLetter = name[name.index(name.startIndex, offsetBy: 2)]
//print(thirdLetter)
//
//
//
//extension String {
//    func deletePrefix(_ prefix: String) -> String {
//        guard self.hasPrefix(prefix) else { return self }
//        return String(self.dropFirst(prefix.count))
//
//    }
//
//    func deleteSuffix(_ suffix: String) -> String {
//        guard self.hasSuffix(suffix) else { return self }
//        return String(self.dropLast(suffix.count))
//    }
//}
//
//
//let password = "12345"
//password.hasPrefix("123")
//password.hasSuffix("45")
//
//let remainingWord = password.deletePrefix("123")
//print(remainingWord)
//
//
//
//
//
//extension String {
//    // computed property
//    var capitalizeFirst: String {
//        guard let firstLetter = self.first else { return "" }
//        return firstLetter.uppercased() + self.dropFirst()
//    }
//}
//
//let weather = "it's going to rain."
//print(weather.capitalized)
//
//let result = weather.capitalizeFirst
//print(result)
//
//
//
//
//
//extension String {
//    func containsAny(of array:[String]) -> Bool {
//        for item in array {
//            if self.contains(item) {
//                return true
//            }
//        }
//        return false
//    }
//
//}
//
//
//let input = "Swift is like Objective-C without the C"
//print(input.contains("Objective-C"))
//
//let languages = ["Python", "Ruby", "Swift"]
//print(languages.contains("Swift"))
//
//
//input.containsAny(of: languages)
//
//languages.contains(where: input.contains) //THIS IS SIMILAR TO HOW USING MAP TO TRANSFORM AN ARRAY like example below
//
//
//var numbers = [1,2,3,4]
//var doubledNumbes = numbers.map {
//    $0 * 2
//}
//
//
//// Attributed Strings - NSAttributedSTring
//// made up of 2 parts - a plain swift String and a dictionary describing how various segments of the string are formatted
//
//let myStr = "This is a test string"
//
//let attributes: [NSAttributedString.Key : Any] = [
//    .foregroundColor: UIColor.white,
//    .backgroundColor: UIColor.red,
//    .font: UIFont.boldSystemFont(ofSize: 36)
//]
//
//let attributedStr = NSAttributedString(string: myStr, attributes: attributes)
//
//
//
//let anotherString = "ThisIsATestString"
//let mutableAttributedString = NSMutableAttributedString(string: anotherString)
//mutableAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
//mutableAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 4, length: 2))
//mutableAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 6, length: 1))
//mutableAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 7, length: 4))
//mutableAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 11, length: 6))
//mutableAttributedString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: anotherString.count))





