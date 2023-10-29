//
//  Auth.swift
//  RS Driver
//
//  Created by Filip Karas on 26/03/2023.
//

import Foundation
import KeychainAccess

class Auth: NSObject {
    
    static let shared = Auth()
    let keychain = Keychain(service: K.Keychain.Credentails).synchronizable(true)
    var loggedIn: Bool { return self.token != nil }
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    var user: UserModel? {
        get {
            if let userJSON = UserDefaults.standard.data(forKey: "user") {
                return try? decoder.decode(UserModel.self, from: userJSON)
            }
            return nil
        }
        set {
            if let data = try? encoder.encode(newValue) {
                UserDefaults.standard.set(data, forKey: "user")
            }
        }
    }
    
    var token: String? {
        get {
            if let archive = try? self.keychain.getData("token") {
                return try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSString.self, from: archive) as? String
            }
            return nil
        }
        set {
            if newValue != nil, let archive = try? NSKeyedArchiver.archivedData(withRootObject: newValue!, requiringSecureCoding: false) {
                try? self.keychain.set(archive, key: "token")
            } else {
                try? self.keychain.remove("token")
            }
        }
    }
    
    var selectedMapApplicationType: MapApplicationType? {
        get {
            if let archive = try? self.keychain.getData("map-application"),
            let mapApplicationTypeString = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSString.self, from: archive) as? String,
            let mapApplicationType = MapApplicationType(rawValue: mapApplicationTypeString) {
                // ak mam v default ulozenu defaultnu map aplikaciu a viem ju otvorit, vrat tu
                if MapApplication.shared.canOpen(mapApplicationType) { return mapApplicationType }
            }
            // ak nemam default, alebo default neviem otvorit, zvolim prvu dostupnu
            var defaultMapApplicationType: MapApplicationType?
            MapApplicationType.allCases.forEach { mapApplicationType in
                if MapApplication.shared.canOpen(mapApplicationType) { defaultMapApplicationType = mapApplicationType }
            }
            return defaultMapApplicationType
        }
        set {
            if newValue != nil, let archive = try? NSKeyedArchiver.archivedData(withRootObject: newValue!.rawValue, requiringSecureCoding: false) {
                try? self.keychain.set(archive, key: "map-application")
            } else {
                try? self.keychain.remove("map-application")
            }
        }
    }
    
    func signOut() {
        self.token = nil
        self.user = nil
    }
}
