//
//  UserData.swift
//  ITinder
//
//  Created by Тимофей Веретнов on 29.10.2021.
//

import Foundation

final class UserSettings {
    private enum SettingsKeys: String {
        case api_token
        case userId
        case chatId
        case ref_token
    }
    static var ref_token: String! {
        get {
            return UserDefaults.standard.string(forKey: SettingsKeys.ref_token.rawValue)
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.ref_token.rawValue
            if let token = newValue {
                defaults.set(token, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    static var api_token: String! {
        get {
            return UserDefaults.standard.string(forKey: SettingsKeys.api_token.rawValue)
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.api_token.rawValue
            if let token = newValue {
                defaults.set(token, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    static var userId: String! {
        get {
            return UserDefaults.standard.string(forKey: SettingsKeys.userId.rawValue)
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.userId.rawValue
            if let id = newValue {
                defaults.set(id, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    static var chatId: String! {
        get {
            return UserDefaults.standard.string(forKey: SettingsKeys.chatId.rawValue)
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.chatId.rawValue
            if let id = newValue {
                defaults.set(id, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
}
