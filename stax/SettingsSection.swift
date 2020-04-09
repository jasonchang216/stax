//
//  SettingsSection.swift
//  stax
//
//  Created by Jason Chang on 4/8/20.
//  Copyright © 2020 Jason Chang. All rights reserved.
//

protocol SectionType: CustomStringConvertible {
    var containsSwitch: Bool { get }
}

enum SettingsSection: Int, CaseIterable, CustomStringConvertible {
    
    case Social
    case Communications
    
    var description: String {
        switch self {
        case .Social: return "Social"
        case .Communications: return "Communications"
        }
    }
    
}

enum SocialOptions: Int, CaseIterable, SectionType {
    
    case editProfile
    case logOut
    
    var containsSwitch: Bool { return true}
    
    var description: String {
        switch self {
        case .editProfile: return "Edit Profile"
        case .logOut: return "Log Out"
        }
    }
    
}

enum CommunicationOptions: Int, CaseIterable, SectionType {
    
    case notifications
    case email
    case reportCrashes
    
    var containsSwitch: Bool { return true}
    
    var description: String {
        switch self {
        case .notifications: return "Notifications"
        case .email: return "Email"
        case .reportCrashes: return "Report Crashes"
        }
    }
    
}
