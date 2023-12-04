//
//  ExtensionString.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 10/11/23.
//

extension String {
    
    func toJsonData() -> Data {
        return Data(self.utf8)
    }
    
    func isValid(regex pattern: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let range = NSRange(location: 0, length: self.utf16.count)
            return regex.firstMatch(in: self, options: [], range: range) != nil
        } catch {
            return false
        }
    }
    
    /*
     ^[A-Za-z0-9._%+-]+: Requires one or more characters that can be uppercase letters, lowercase letters, digits, dots, underscores, percent signs, plus signs, or hyphens before the '@'.
     @: Requires the presence of the '@' symbol.
     [A-Za-z0-9.-]+: Requires one or more characters that can be uppercase letters, lowercase letters, digits, dots, or hyphens after the '@'.
     \\.: Requires a dot '.' immediately after the '@'.
     [A-Za-z]{1,}$: Requires at least one uppercase or lowercase letters after the dot.
     */
    func isValidEmail() -> Bool {
        return self.isValid(regex: "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,}$")
    }
    
    /*
     ^[0-9]{7,}$: Requires the string to start (^) and end ($) with numeric characters ([0-9]), and have a minimum length of 7 ({7,}).
     */
    func isValidPhone() -> Bool {
        return self.isValid(regex: "^[0-9]{7,}$")
    }
    
    /*
     ^(?=.*[a-z]): Requires at least one lowercase letter.
     (?=.*[A-Z]): Requires at least one uppercase letter.
     (?=.*\d): Requires at least one digit.
     .{8,}$: Requires a minimum length of 8 characters.
     */
    func isValidPassword() -> Bool {
        return self.isValid(regex: "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{8,}$")
    }
    
    func isNumeric() -> Bool {
        return self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    func replacePrefix(oldPrefix: String, newPrefix: String) -> String {
        if self.hasPrefix(oldPrefix) {
            let index = self.index(self.startIndex, offsetBy: oldPrefix.count)
            return newPrefix + self[index...]
        }
        return self
    }
    
    func addCountryCode(code: String) -> String {
        if self.hasPrefix(code) {
          return self
        } else if self.hasPrefix("0") {
            return replacePrefix(oldPrefix: "0", newPrefix: code)
        } else if ("+" + self).hasPrefix(code) {
            return "+" + self
        }
        return code + self
    }
    
}

extension Optional where Wrapped == String {
    
    var orEmpty: String {
        return self ?? ""
    }
    
}
