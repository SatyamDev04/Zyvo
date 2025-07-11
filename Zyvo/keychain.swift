//
//  keychain.swift
//  Zyvo
//
//  Created by ravi on 6/02/25.
//

import Foundation

struct Keychain {
    
    // MARK: Types
    enum KeychainError: Error {
        case noPassword
        case unexpectedPasswordData
        case unexpectedItemData
        case unhandledError
    }
    
    // MARK: Properties
    let service: String
    let accessGroup: String?
    private(set) var account: String
    
    // MARK: Intialization
    init(service: String, account: String, accessGroup: String? = nil) {
        self.service = service
        self.account = account
        self.accessGroup = accessGroup
    }
    
    // MARK: Keychain access
    func readItem() throws -> String {
        // Build a query to find the item that matches the service, account and access group.
        var query = Keychain.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue
        
        // Try to fetch the existing keychain item that matches the query.
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        // Check the return status and throw an error if appropriate.
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        guard status == noErr else { throw KeychainError.unhandledError }
        
        // Parse the password string from the query result.
        guard let existingItem = queryResult as? [String: AnyObject],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8)
            else {
                throw KeychainError.unexpectedPasswordData
        }
        
        return password
    }
    
    func saveItem(_ password: String) throws {
        // Encode the password into an Data object.
        let encodedPassword = password.data(using: String.Encoding.utf8)!
        
        do {
            // Check for an existing item in the keychain.
            try _ = readItem()
            
            // Update the existing item with the new password.
            var attributesToUpdate = [String: AnyObject]()
            attributesToUpdate[kSecValueData as String] = encodedPassword as AnyObject?
            
            let query = Keychain.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            
            // Throw an error if an unexpected status was returned.
            guard status == noErr else { throw KeychainError.unhandledError }
        } catch KeychainError.noPassword {
            //No password was found in the keychain. Create a dictionary to save as a new keychain item.
            var newItem = Keychain.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
            newItem[kSecValueData as String] = encodedPassword as AnyObject?
            
            // Add a the new item to the keychain.
            let status = SecItemAdd(newItem as CFDictionary, nil)
            
            // Throw an error if an unexpected status was returned.
            guard status == noErr else { throw KeychainError.unhandledError }
        }
    }
    
    func deleteItem() throws {
        // Delete the existing item from the keychain.
        let query = Keychain.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
        let status = SecItemDelete(query as CFDictionary)
        
        // Throw an error if an unexpected status was returned.
        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError }
    }
    
    // MARK: Convenience
    private static func keychainQuery(withService service: String, account: String? = nil, accessGroup: String? = nil) -> [String: AnyObject] {
        var query = [String: AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject?
        
        if let account = account {
            query[kSecAttrAccount as String] = account as AnyObject?
        }
        
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
        }
        
        return query
    }
}

//Mark - Demo App Helper
extension Keychain {
    static var bundleIdentifier: String {
        return Bundle.main.bundleIdentifier ?? "abc.PetQuest-Breeder"
    }
    
    //Get and Set Current User Identifier. Set nil to delete.
    static var userid: String? {
        get {
            return try? Keychain(service: bundleIdentifier, account: "userid").readItem()
        }
        set {
            guard let value = newValue else {
                try? Keychain(service: bundleIdentifier, account: "userid").deleteItem()
                return
            }
            do {
                try Keychain(service: bundleIdentifier, account: "userid").saveItem(value)
            } catch {
                print("Unable to save userIdentifier to keychain.")
            }
        }
    }
    
    //Get and Set Current User First Name. Set nil to delete.
    static var firstName: String? {
        get {
            return try? Keychain(service: bundleIdentifier, account: "firstName").readItem()
        }
        set {
            guard let value = newValue else {
                try? Keychain(service: bundleIdentifier, account: "firstName").deleteItem()
                return
            }
            do {
                try Keychain(service: bundleIdentifier, account: "firstName").saveItem(value)
            } catch {
                print("Unable to save userFirstName to keychain.")
            }
        }
    }
    
    //Get and Set Current User Last Name. Set nil to delete.
    static var lastName: String? {
        get {
            return try? Keychain(service: bundleIdentifier, account: "lastName").readItem()
        }
        set {
            guard let value = newValue else {
                try? Keychain(service: bundleIdentifier, account: "lastName").deleteItem()
                return
            }
            do {
                try Keychain(service: bundleIdentifier, account: "lastName").saveItem(value)
            } catch {
                print("Unable to save userLastName to keychain.")
            }
        }
    }
    
    
    //Get and Set Current User Email. Set nil to delete.
    static var email: String? {
        get {
            return try? Keychain(service: bundleIdentifier, account: "email").readItem()
        }
        set {
            guard let value = newValue else {
                try? Keychain(service: bundleIdentifier, account: "email").deleteItem()
                return
            }
            do {
                try Keychain(service: bundleIdentifier, account: "email").saveItem(value)
            } catch {
                print("Unable to save userEmail to keychain.")
            }
        }
    }
}

