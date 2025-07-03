//
//  ChatDataModel.swift
//  Zyvo
//
//  Created by ravi on 21/03/25.
//

import TwilioConversationsClient

// MARK: - Datum
struct ChatDataModel: Codable {
    let groupName, receiverID, receiverName, receiverImage: String?
    let senderID, senderName: String?
    let senderProfile: String?
    let propertyTitle: String?
    var isBlocked, isFavorite, isMuted, isArchived: Int?
    var isDeleted : Bool?
    var chatData : TCHConversation?

    enum CodingKeys: String, CodingKey {
        case groupName = "group_name"
        case receiverID = "receiver_id"
        case receiverName = "receiver_name"
        case receiverImage = "receiver_image"
        case senderID = "sender_id"
        case senderName = "sender_name"
        case senderProfile = "sender_profile"
        case propertyTitle = "property_title"
        case isBlocked = "is_blocked"
        case isFavorite = "is_favorite"
        case isMuted = "is_muted"
        case isArchived = "is_archived"
        case isDeleted = "is_deleted"
    }
}

// MARK: - DataClass
struct UserBlockStatusModel: Codable {
    let isBlocked: Bool?
    let blockedTo: Int?
    let blockedBy: String?

    enum CodingKeys: String, CodingKey {
        case isBlocked = "is_blocked"
        case blockedTo = "blocked_to"
        case blockedBy = "blocked_by"
    }
}


// MARK: - DataClass
struct ChatFavouriteModel: Codable {
    let message, senderID, receiverID, groupName: String?
    let favoriteStatus: String?

    enum CodingKeys: String, CodingKey {
        case message
        case senderID = "sender_id"
        case receiverID = "receiver_id"
        case groupName = "group_name"
        case favoriteStatus = "favorite_status"
    }
}

// MARK: - DataClass
struct SetMuteUnmute: Codable {
    let mutedBy, mutedTo: String?
    let muteStatus: Int?

    enum CodingKeys: String, CodingKey {
        case mutedBy = "muted_by"
        case mutedTo = "muted_to"
        case muteStatus = "mute_status"
    }
}

// MARK: - DataClass
struct SetArchiveUnarchiveModel: Codable {
    let status: String?
    let isArchived: Bool?
    let archivedAt: String?

    enum CodingKeys: String, CodingKey {
        case status
        case isArchived = "is_archived"
        case archivedAt = "archived_at"
    }
}


// MARK: - DataClass
struct unreadbookingModel: Codable {
    let unreadBookingCount: Int?

    enum CodingKeys: String, CodingKey {
        case unreadBookingCount = "unread_booking_count"
    }
}
