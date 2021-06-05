import UIKit
// project 24 challenge 1
//extension String {
//    mutating func addPrefixIfNeeded(_ prefix: String, requiredPrefix: String? = nil) {
//        guard !self.hasPrefix(requiredPrefix ?? prefix) else { return }
//        self = prefix + self
//    }
//}
//
//var a = "123"
//a.addPrefixIfNeeded("123")
//a.addPrefixIfNeeded("456")


// project 24 challenge 2
//extension String  {
//    var isNumber: Bool {
//        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
//    }
//}
//
//var b = "1"
//var c = "q"
//b.isNumber
//c.isNumber


// project 24 challenge 3
extension String {
    var lines: [Substring] {
        return self.split(separator: "\n")
    }
}

assert("this\nis\na\ntest".lines == ["this", "is", "a", "test"])
 
var a = "123"
a.lines
