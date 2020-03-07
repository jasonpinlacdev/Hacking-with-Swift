import UIKit

//https://stackoverflow.com/questions/39676939/how-does-string-index-work-in-swift/39676940#39676940

//Why is String.Index needed?
//It would be much easier to use an Int index for Strings. The reason that you have to create a new String.Index for every String is that Characters in Swift are not all the same length under the hood. A single Swift Character might be composed of one, two, or even more Unicode code points. Thus each unique String must calculate the indexes of its Characters.
//It is possibly to hide this complexity behind an Int index extension, but I am reluctant to do so. It is good to be reminded of what is actually happening.


var str = "Hello, playground"

// | H | e | l | l | o | , | p | l | a | y | g | r | o | u | n | d |
// | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10| 11| 12| 13| 14| 15|

// startIndex is the index of the first character
// endIndex is the index after the last character


str[str.startIndex]
//str[str.endIndex] THIS WILL CRASH BECAUSE INDEX OUT OF BOUNDS
str[str.index(before: str.endIndex)]



// range
let range = str.startIndex ..< str.endIndex
let oneSidedRange = ..<str.endIndex
let anotherOneSidedRange = str.startIndex...
str[range]
str[oneSidedRange]
str[anotherOneSidedRange]


// after
let letter = str[str.index(after: str.startIndex)]
let missingFirstRange = str.index(after: str.startIndex)..<str.endIndex
str[missingFirstRange]



// before
let beforeLastLetter = str[str.index(before: str.endIndex)]
let missingLastRange = str.startIndex..<str.index(before: str.endIndex)
str[missingLastRange]


// offset
str[str.index(str.startIndex, offsetBy: 4)]
let start = str.index(str.startIndex, offsetBy: 7)
let end = str.index(str.index(before: str.endIndex), offsetBy: -6)
let oneMoreRange = start...end
str[oneMoreRange]


// limitedBy
// limitedBy works so that this optional argument makes the return value an optional so if you try to index the string and make the mistake of going out of bounds your program will not crash. Use optional binding IE if-let
if let index = str.index(str.startIndex, offsetBy: 100, limitedBy: str.endIndex) {
    str[index]
}

if let index = str.index(str.startIndex, offsetBy: 10, limitedBy: str.endIndex) {
    str[index]
}
