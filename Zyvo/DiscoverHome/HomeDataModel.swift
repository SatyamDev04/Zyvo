//
//  HomeDataModel.swift
//  Zyvo
//
//  Created by ravi on 30/01/25.
//


//// MARK: - Datum
//struct HomeDataModel: Codable {
//    let title: String?
//    let isInstantBook: Int?
//    let hourlyRate: String?
//    let images: [String]?
//    let propertyID, isInWishlist, reviewCount: Int?
//    let rating: String?
//
//    enum CodingKeys: String, CodingKey {
//        case title
//        case isInstantBook = "is_instant_book"
//        case hourlyRate = "hourly_rate"
//        case images
//        case propertyID = "property_id"
//        case isInWishlist = "is_in_wishlist"
//        case reviewCount = "review_count"
//        case rating
//    }
//}

// MARK: - Datum



// MARK: - Datum


// MARK: - Datum
struct HomeDataModel: Codable {
    let distanceMiles: String?
    let hourlyRate, reviewCount: String?
    let isInWishlist: Int?
    let title, rating: String?
    let propertyID: Int?
    let longitude, latitude: String?
    let isInstantBook: Int?
    let images: [String]?
    let isStarHost: Bool?

    enum CodingKeys: String, CodingKey {
        case distanceMiles = "distance_miles"
        case hourlyRate = "hourly_rate"
        case reviewCount = "review_count"
        case isInWishlist = "is_in_wishlist"
        case title, rating
        case propertyID = "property_id"
        case longitude, latitude
        case isInstantBook = "is_instant_book"
        case images
        case isStarHost = "is_star_host"
    }
}
//struct HomeDataModel: Codable {
//    let latitude, title: String?
//    let propertyID: Int?
//    let rating, longitude: String?
//    let isInWishlist: Int?
//    let images: [String]?
//    let hourlyRate: String?
//    let isInstantBook: Int?
//    let reviewCount, distanceMiles: String?
//
//    enum CodingKeys: String, CodingKey {
//        case latitude, title
//        case propertyID = "property_id"
//        case rating, longitude
//        case isInWishlist = "is_in_wishlist"
//        case images
//        case hourlyRate = "hourly_rate"
//        case isInstantBook = "is_instant_book"
//        case reviewCount = "review_count"
//        case distanceMiles = "distance_miles"
//    }
//}

// MARK: - chatTokenModel
struct chatTokenModel: Codable {
    let token, identity: String?
}


