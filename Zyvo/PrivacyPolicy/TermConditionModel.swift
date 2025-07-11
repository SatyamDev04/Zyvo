//
//  TermConditionModel.swift
//  Zyvo
//
//  Created by ravi on 28/01/25.
//

// MARK: - PrivacyPolicy
struct TermConditionModel: Codable {
    let text: String?
    let lastUpdateAt: String?
    
    enum CodingKeys: String, CodingKey {
           case text
           case lastUpdateAt = "last_update_at"
       }
}
