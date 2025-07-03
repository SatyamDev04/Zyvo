//
//  PhoneNumberValidator.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 04/06/25.
//

import Foundation
import PhoneNumberKit

class PhoneNumberValidator {
    
    private let phoneNumberKit = PhoneNumberKit()
    
    /// Validates if the given number is a valid mobile or fixedOrMobile number for the specified country code.
    /// - Parameters:
    ///   - countryCode: The country code string (e.g., "+91" or "91")
    ///   - number: The national number string
    /// - Returns: `true` if the number is valid, else `false`
    func isValidMobileNumber(countryCode: String, number: String) -> Bool {
        let cleanCode = countryCode.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: "+", with: "")
        
        guard let codeInt = UInt64(cleanCode) else {
            print("Invalid country code format")
            return false
        }
        
        guard let region = phoneNumberKit.mainCountry(forCode: codeInt) else {
            print("Could not determine region for code +\(codeInt)")
            return false
        }
        
        let nationalNumber = number.trimmingCharacters(in: .whitespaces)
        
        // First: validate basic regional format
        guard phoneNumberKit.isValidPhoneNumber(nationalNumber, withRegion: region) else {
            print("Not a valid number in region: \(region)")
            return false
        }
        
        do {
            let parsed = try phoneNumberKit.parse(nationalNumber, withRegion: region, ignoreType: false)
            
            // Ensure country code matches expected
            guard parsed.countryCode == codeInt else {
                print("Country mismatch: expected +\(codeInt), got +\(parsed.countryCode)")
                return false
            }
            
            // Check if type is mobile or fixedOrMobile
            let type = parsed.type
            print("Number type: \(type)")
            return type == .mobile || type == .fixedOrMobile
        } catch {
            print("Failed to parse: \(error)")
            return false
        }
    }
}
