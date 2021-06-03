import UIKit

//1

//let password = "12345"
//password.hasPrefix("123")
//password.hasSuffix("456")
//
//extension String {
//    func deletingPrefix(_ prefix: String) -> String {
//        guard self.hasPrefix(prefix) else { return self}
//        return String(self.dropFirst(prefix.count))
//    }
//
//    func deleteSuffix(_ suffix: String) -> String {
//        guard self.hasSuffix(suffix) else { return self }
//        return String(self.dropLast(suffix.count))
//    }
//}

//2

//let weather = "it's going to rain"
//print(weather.capitalized)
//
//extension String {
//    var capitalizedFirst: String {
//        guard let firstLetter = self.first else { return "" }
//        return firstLetter.uppercased() + self.dropFirst()
//    }
//}

//3

let input = "Swift is like Objective-C without the C"
input.contains("Swift")

let languages = ["Python", "Ruby", "Swift"]
languages.contains("Swift")

extension String {
    func containsAny(of array: [String]) -> Bool {
        for item in array {
            if self.contains(item) {
                return true
            }
        }
        return false
    }
}

input.containsAny(of: languages)

languages.contains(where: input.contains)
