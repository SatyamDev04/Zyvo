//
//  ShareFeedbackVC.swift
//  Zyvo
//
//  Created by ravi on 21/11/24.
//

import UIKit
import DropDown
import Combine
import IQKeyboardManagerSwift

class ShareFeedbackVC: UIViewController,UITextViewDelegate {
    @IBOutlet weak var view_AddDetails1: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var view_AddDetails: UIView!
    @IBOutlet weak var view_Details: UIView!
    @IBOutlet weak var btnContactUs: UIButton!
    @IBOutlet weak var contactUsBtnO: UIButton!
    @IBOutlet weak var view_Select: UIView!
    @IBOutlet weak var txt_Type: UITextField! {
        didSet {
            txt_Type.attributedPlaceholder = NSAttributedString(
                string: "Please select",
                attributes: [.foregroundColor: UIColor.black]
            )
        }
    }
    @IBOutlet weak var txtV_AddDetails: UITextView!
    @IBOutlet weak var btnStack: UIStackView!
    @IBOutlet weak var btnVGuest: UIView!
    @IBOutlet weak var btnVHost: UIView!
    // MARK: - Properties
       let dropDown = DropDown()
       private let userTypes = ["Guest", "Host"]
       private var userType: String = ""
       private var cancellables = Set<AnyCancellable>()
       private let placeholderText = "Type a message..."
       private let viewModel = FeebackViewModel()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboardNotifications()
        bindVC()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Setup
    private func setupUI() {
        scrollView.alwaysBounceVertical = true
        txtV_AddDetails.delegate = self
        txtV_AddDetails.text = placeholderText
        txtV_AddDetails.textColor = .lightGray

        [view_Details, view_Select].forEach {
            $0?.layer.cornerRadius = 10
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.lightGray.cgColor
        }

        btnContactUs.layer.cornerRadius = 22.5
        btnContactUs.layer.borderWidth = 1
        btnContactUs.layer.borderColor = UIColor(red: 74/255, green: 234/255, blue: 177/255, alpha: 1).cgColor

        contactUsBtnO.layer.cornerRadius = 6
        contactUsBtnO.layer.borderWidth = 1
        contactUsBtnO.layer.borderColor = UIColor.darkGray.cgColor

        view_AddDetails1.isHidden = true
        view_AddDetails.isHidden = true

//        userType = UserDetail.shared.getlogintType().lowercased()
//        btnVGuest.isHidden = userType == "host"
//        btnVHost.isHidden = userType != "host"
        
        btnVGuest.isHidden = true
        btnVHost.isHidden = false

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Keyboard Handling
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let bottomInset = keyboardFrame.height - view.safeAreaInsets.bottom

        scrollView.contentInset.bottom = bottomInset + 20
        scrollView.scrollIndicatorInsets.bottom = bottomInset + 20

        if let activeView = view.currentFirstResponder() {
            let convertedFrame = scrollView.convert(activeView.bounds, from: activeView)
            scrollView.scrollRectToVisible(convertedFrame, animated: true)
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        let textViewFrame = textView.convert(textView.bounds, to: scrollView)
        scrollView.scrollRectToVisible(textViewFrame, animated: true)

        if textView.text == placeholderText {
            textView.text = ""
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = .lightGray
        }
    }

    // MARK: - Actions
    @IBAction func backBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func btnSelect_Tap(_ sender: UIButton) {
        dropDown.anchorView = sender
        dropDown.dataSource = userTypes
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 3, y: sender.bounds.height)

        dropDown.selectionAction = { [weak self] index, item in
            guard let self = self else { return }
            self.txt_Type.text = item
            self.userType = item.lowercased()
            self.view_AddDetails1.isHidden = false
            self.view_AddDetails.isHidden = false
        }

        dropDown.show()
    }

    @IBAction func btnContactUs_Tap(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Host", bundle: nil)
        if let vc = sb.instantiateViewController(withIdentifier: "ContactUsVC") as? ContactUsVC {
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func btnSubmit_Tap(_ sender: UIButton) {
        guard let type = txt_Type.text, !type.isEmpty else {
            showAlert(for: "Please select your account")
            return
        }

        let details = txtV_AddDetails.text ?? ""
        if details.isEmpty || details == placeholderText {
            showAlert(for: "Please add additional details")
            return
        }

        viewModel.apiForShareFeedback(userType: userType, details: details)
    }
}

// MARK: - ViewModel Binding
extension ShareFeedbackVC {
    func bindVC() {
        viewModel.$shareFeedbackResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self, let result = result else { return }
                result.handle(success: { response in
                    print(response.message ?? "")
                    
                    self.showToast(response.message ?? "")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        if self.userTypes.contains(self.txt_Type.text ?? "") {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    
                    
                    
                })
            }
            .store(in: &cancellables)
    }
}

// MARK: - Find Current First Responder
extension UIView {
    func currentFirstResponder() -> UIView? {
        if isFirstResponder { return self }
        return subviews.compactMap { $0.currentFirstResponder() }.first
    }
}
