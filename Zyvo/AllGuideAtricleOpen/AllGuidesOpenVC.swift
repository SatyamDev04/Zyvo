//
//  AllGuidesOpenVC.swift
//  Zyvo
//
//  Created by ravi on 12/11/24.
//

import UIKit
import Combine

class AllGuidesOpenVC: UIViewController {
    
    @IBOutlet weak var stackV: UIStackView!
    private var viewModel = GuideDetailsViewModel()
    private var cancellables = Set<AnyCancellable>()
    var getGuidesDetailsArr : GuideDetailsModel?
    var getArticleDetailsArr : ArticleDetailsModel?
    @IBOutlet weak var lbl_Desc: UILabel!
    @IBOutlet weak var lbl_Category: UILabel!
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbl_AutherName: UILabel!
    @IBOutlet weak var view_Article: UIView!
    @IBOutlet weak var view_author: UIView!
    @IBOutlet weak var view_NeedToTouch: UIView!
    // @IBOutlet weak var rankingViewTopCon: NSLayoutConstraint!
    var comesFrom = ""
    var guideid = ""
    var articleID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stackV.isHidden = true
        bindVC()
        
        print(comesFrom ,"comesFrom")
        if comesFrom == "Guide" {
            viewModel.guideId = self.guideid
            viewModel.apiForGetGuidesDetails()
        }
        if comesFrom == "Article" {
            viewModel.articleId = self.articleID
            viewModel.apiForGetArticleDetails()
        }
        
        view_Article.layer.cornerRadius = 20
        view_Article.layer.borderWidth = 1.5
        view_Article.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0).cgColor
        
        
        view_author.layer.cornerRadius = 20
        view_author.layer.borderWidth = 1.5
        view_author.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0).cgColor
        
        let panel = UserDetail.shared.getlogintType()
        
        if panel != "Host" {
            self.view_NeedToTouch.isHidden = true
        } else {
            self.view_NeedToTouch.isHidden = false
        }
    }
    
    @IBAction func btnBack_Tap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func contactUsBtn(_ sender: UIButton){
        let sb = UIStoryboard(name: "Host", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension AllGuidesOpenVC {
    
    func bindVC(){
        // get Guides Details
        viewModel.$getGuideDetailsResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    // let to = response.data?.token
                    print(response.message ?? "")
                    
                    self.getGuidesDetailsArr = response.data
                    
                    if self.getGuidesDetailsArr == nil {
                        print("Guide details are nil")
                        self.stackV.isHidden = true
                    } else {
                        print("Guide details exist")
                        self.stackV.isHidden = false
                        self.lbl_Date.text = self.getGuidesDetailsArr?.date ?? ""
                        self.lbl_title.text = self.getGuidesDetailsArr?.title ?? ""
                        self.lbl_Category.text = self.getGuidesDetailsArr?.category ?? ""
                        self.lbl_time.text = "\(self.getGuidesDetailsArr?.timeRequired ?? "") read"
                        
                        //self.lbl_Desc.text = (self.getGuidesDetailsArr?.description ?? "").decodedHTML
                        
                        let rawText = (self.getGuidesDetailsArr?.description ?? "").decodedHTML

                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.lineSpacing = 6  // Adjust line spacing as needed
                        paragraphStyle.alignment = .justified  // Or use .left, .center, etc.

                        let attributedString = NSAttributedString(
                            string: rawText,
                            attributes: [
                                .font: UIFont.systemFont(ofSize: 15.5), // Customize font if needed
                                .paragraphStyle: paragraphStyle,
                                .foregroundColor: UIColor.label // Optional: customize color
                            ]
                        )

                        self.lbl_Desc.attributedText = attributedString
                        
                        self.lbl_AutherName.text = self.getGuidesDetailsArr?.authorName ?? ""
                        var image = self.getGuidesDetailsArr?.coverImage ?? ""
                        let imgURL = AppURL.imageURL + image
                        self.img.loadImage(from:imgURL,placeholder: UIImage(named: "img1"))
                    }
                })
            }.store(in: &cancellables)
        
        
        // get Article Details
        
        viewModel.$getArticleDetailsResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    // let to = response.data?.token
                    print(response.message ?? "")
                    
                    self.getArticleDetailsArr = response.data
                    
                    if self.getArticleDetailsArr == nil {
                        print("Guide details are nil")
                        self.stackV.isHidden = true
                    } else {
                        print("Guide details exist")
                        self.stackV.isHidden = false
                        self.lbl_Date.text = self.getArticleDetailsArr?.date ?? ""
                        self.lbl_Category.text = self.getArticleDetailsArr?.category ?? ""
                        self.lbl_title.text = self.getArticleDetailsArr?.title ?? ""
                        self.lbl_time.text = "\(self.getArticleDetailsArr?.timeRequired ?? "") read"
                       // self.lbl_Desc.text = (self.getArticleDetailsArr?.description ?? "").decodedHTML
                        
                        let rawText = (self.getArticleDetailsArr?.description ?? "").decodedHTML

                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.lineSpacing = 6  // Adjust line spacing as needed
                        paragraphStyle.alignment = .justified  // Or use .left, .center, etc.

                        let attributedString = NSAttributedString(
                            string: rawText,
                            attributes: [
                                .font: UIFont.systemFont(ofSize: 15.5), // Customize font if needed
                                .paragraphStyle: paragraphStyle,
                                .foregroundColor: UIColor.label // Optional: customize color
                            ]
                        )

                        self.lbl_Desc.attributedText = attributedString
                        self.lbl_AutherName.text = self.getArticleDetailsArr?.authorName ?? ""
                        var image = self.getArticleDetailsArr?.coverImage ?? ""
                        let imgURL = AppURL.imageURL + image
                        self.img.loadImage(from:imgURL,placeholder: UIImage(named: "img1"))
                    }
                })
            }.store(in: &cancellables)
    }
}

extension String {
    var decodedHTML: String {
        guard let data = self.data(using: .utf8) else { return self }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        if let attributed = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
            return attributed.string
        }
        return self
    }
}
