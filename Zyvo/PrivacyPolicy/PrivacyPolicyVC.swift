//
//  PrivacyPolicyVC.swift
//  Zyvo
//
//  Created by ravi on 13/11/24.
//

import UIKit
import Combine

class PrivacyPolicyVC: UIViewController {
    
    private var viewModel = PrivacyPolicyViewModel()
    private var viewModel2 = TermCondtionViewModel()
    private var cancellables = Set<AnyCancellable>()
    var PrivacyData : PrivacyPolicyModel?
    var TermConditionData : TermConditionModel?
    var comingFrom = ""
    
    @IBOutlet weak var lbl_PrivacyContent: UILabel!
    
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_LastUpdate: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindVC()
        
        print(comingFrom,"comingFrom")
        
        if comingFrom == "Privacy" {
          //  self.lbl_Title.text = "Privacy Policy"
            viewModel.apiforPrivacyPolicy() }
        
        if comingFrom == "TermCondition" {
          //  self.lbl_Title.text = "Term and Conditions"
            viewModel2.apiforTermCondition() }
        
    }
    
    @IBAction func btnBack_Tap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension PrivacyPolicyVC {
    func bindVC() {
        
        viewModel.$getPrivacyPolicyResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    
                    self.PrivacyData = response.data
                    
                    let htmlString = self.PrivacyData?.text ?? ""
                    
                    let lastupdate = self.PrivacyData?.lastUpdateAt ?? ""
                    
                    let dateString = lastupdate

                    // 1. Create ISO8601 Date Formatter
                    let isoFormatter = ISO8601DateFormatter()
                    isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

                    // 2. Parse string to Date
                    if let date = isoFormatter.date(from: dateString) {
                        // 3. Create output formatter
                        let displayFormatter = DateFormatter()
                        displayFormatter.dateFormat = "dd/MM/yyyy"
                        
                        let formattedDate = displayFormatter.string(from: date)
                        print(formattedDate)  // Output: 29/05/2025
                        self.lbl_LastUpdate.text = "Last Updated \(formattedDate)"
                    }
                    
                    print(htmlString,"htmlString")
                    print(lastupdate,"lastupdate")
                    
//                    if let description = self.extractTitleAndDescriptionas(from: htmlString) {
//                        self.lbl_PrivacyContent.text = description
//                    }
                    
                    let result = self.extractTitleAndDescriptionas(from: htmlString)
                    self.lbl_Title.text = result.title
                    self.lbl_PrivacyContent.text = result.description
                    
                    //let (title, description) = self.extractTitleAndDescriptionPrivcy(from: htmlString)

                   //elf..text = title
                  //  self.lbl_PrivacyContent.text = description
                     
                    
                })
            }.store(in: &cancellables)
        
        
        viewModel2.$getTermConditionResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    
                    self.TermConditionData = response.data
                    
                    let lastupdate = self.TermConditionData?.lastUpdateAt ?? ""
                    
                    let dateString = lastupdate

                    // 1. Create ISO8601 Date Formatter
                    let isoFormatter = ISO8601DateFormatter()
                    isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

                    // 2. Parse string to Date
                    if let date = isoFormatter.date(from: dateString) {
                        // 3. Create output formatter
                        let displayFormatter = DateFormatter()
                        displayFormatter.dateFormat = "dd/MM/yyyy"
                        
                        let formattedDate = displayFormatter.string(from: date)
                        print(formattedDate)  // Output: 29/05/2025
                        self.lbl_LastUpdate.text = "Last Updated \(formattedDate)"
                    }
                    
                    let htmlString = self.TermConditionData?.text ?? ""
                    
                    print(htmlString,"htmlString")
                    print(lastupdate,"lastupdate")
                    
                    let (title, description) = self.extractTitleAndDescription(from: htmlString)
                    self.lbl_Title.text = title
                    self.lbl_PrivacyContent.text = description
                   
                    
                })
            }.store(in: &cancellables)
    }
    
    func extractTitleAndDescription(from html: String) -> (String?, String?) {
        // Convert HTML to NSAttributedString
        guard let data = html.data(using: .utf8) else { return (nil, nil) }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
            let plainText = attributedString.string
            let lines = plainText.components(separatedBy: "\n").filter { !$0.isEmpty }

            let title = lines.first
            let description = lines.dropFirst().joined(separator: "\n")
            return (title, description)
        }
        
        return (nil, nil)
    }
    
    
    func extractTitleAndDescriptionas(from html: String) -> (title: String?, description: String?) {
        guard let data = html.data(using: .utf8) else {
            return (nil, nil)
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
            let fullText = attributedString.string.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let parts = fullText.components(separatedBy: .newlines).filter { !$0.isEmpty }
            
            if parts.count == 1 {
                // Try splitting on common words like "Privacy Policy"
                let split = fullText.components(separatedBy: "Privacy Policy")
                if split.count > 1 {
                    return ("Privacy Policy", split[1].trimmingCharacters(in: .whitespacesAndNewlines))
                } else {
                    return (nil, fullText) // fallback
                }
            } else if parts.count >= 2 {
                return (parts[0], parts[1])
            } else {
                return (nil, nil)
            }
        }

        return (nil, nil)
    }

    
    
    
//
//    func extractDescriptionOnly(from html: String) -> String? {
//        guard let data = html.data(using: .utf8) else { return nil }
//
//        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
//            .documentType: NSAttributedString.DocumentType.html,
//            .characterEncoding: String.Encoding.utf8.rawValue
//        ]
//
//        if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
//            let fullText = attributedString.string.trimmingCharacters(in: .whitespacesAndNewlines)
//            
//            // Try splitting on line breaks or space if <br> did not convert to \n
//            if fullText.contains("\n") {
//                let parts = fullText.components(separatedBy: "\n")
//                return parts.count > 1 ? parts[1].trimmingCharacters(in: .whitespaces) : nil
//            } else if fullText.contains("Privacy Policy") {
//                let parts = fullText.components(separatedBy: "Privacy Policy")
//                return parts.count > 1 ? parts[1].trimmingCharacters(in: .whitespacesAndNewlines) : nil
//            } else {
//                return fullText // fallback
//            }
//        }
//
//        return nil
//    }


}
