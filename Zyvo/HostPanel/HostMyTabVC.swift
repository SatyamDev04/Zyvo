//
//  HostMyTabVC.swift
//  Zyvo
//
//  Created by ravi on 26/12/24.
//

import UIKit
import Combine
import TwilioConversationsClient

//var isNotiComing = "no"
class HostMyTabVC: UITabBarController, UITabBarControllerDelegate {
    
    var tabBarHeight = CGFloat()
    private var chatDataArr: [ChatDataModel] = []
    private var totalUnreadCount = 0
    public var viewModel = ChatDataViewModel()
    private var conversationsManager = QuickstartConversationsManager.shared
    private var listOfChannel: [TCHConversation] = []
    private var listOfChannel_bal = false
    private let debouncer = Debouncer()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindVC()
        
      viewModel.apiForGetUnreadCount()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: NSNotification.Name("CustomNotification"), object: nil)
        
        
        // Listen for badge updates
         NotificationCenter.default.addObserver(self, selector: #selector(updateBookingBadge(_:)), name: NSNotification.Name("UpdateBookingBadge"), object: nil)
        
        
//        if let notiData = notiData {
//
//            handleCustomNotification(notificationData: notiData)
//
//        }
        
        let token = UserDetail.shared.getChatToken()
        QuickstartConversationsManager.shared.loginWithAccessToken(token) { [weak self] _ in
            guard let self = self else { return }
            print("Login with Access Token")
            self.viewModel.apiForGetChatDataTab(userType: "host")
        }
        conversationsManager.delegate = self
        self.delegate = self
        configureTabBarAppearance()
        setProfileTabImage()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//
//    }
    
    @objc func updateBookingBadge(_ notification: Notification) {
           if let userInfo = notification.userInfo,
              let unreadCount = userInfo["unread_booking_count"] as? Int {
               print("🔵 BookingVC received unread count: \(unreadCount)")
               
                   DispatchQueue.main.async {
                       if let tabItems = self.tabBar.items, tabItems.count > 3 {
                           let chatTabBarItem = tabItems[2] // Assuming Chat is at index 1
                           chatTabBarItem.badgeValue = unreadCount > 0 ? "\(unreadCount)" : nil
                    }
                }
           }
       }
       deinit {
           NotificationCenter.default.removeObserver(self, name: NSNotification.Name("UpdateBookingBadge"), object: nil)
       }
    
    @objc func handleNotification(_ notification: Notification) {
        
        print(notification,"notification")
//            if let model = notification.object as? NotificationData {
//                print("Received Notification Data: \(model)")
//               // handleCustomNotification(notificationData: model)
//               // handleCustomNotification(notificationData: model)
//            }
        }
    
    
    
    func setProfileTabImage() {
        guard let tabItems = self.tabBar.items, tabItems.count > 3 else { return }

        let profileTabItem = tabItems[3]
       
        profileTabItem.title = "Profile"

        if let imageUrl = URL(string: UserDetail.shared.getProfileimg()) {
            URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                guard let data = data, let image = UIImage(data: data), error == nil else {
                    print("Failed to load profile image")
                    return
                }

                // Resize and make it circular
                let resized = image.resizeImageTo(size: CGSize(width: 30, height: 30)).circularImage()

                DispatchQueue.main.async {
                    profileTabItem.image = resized.withRenderingMode(.alwaysOriginal)
                    profileTabItem.selectedImage = resized.withRenderingMode(.alwaysOriginal)
                }
            }.resume()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.frame.size.height = 90
        tabBar.frame.origin.y = view.frame.height - 90
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let navigationController = viewController as? UINavigationController {
            let token = UserDetail.shared.getChatToken()
            //let token = UserDetail.shared.getChatToken()
//            QuickstartConversationsManager.shared.loginWithAccessToken(token) { [weak self] _ in
//                guard let self = self else { return }
//                print("Login with Access Token")
//                self.viewModel.apiForGetChatData(userType: "host")
//            }

            navigationController.popToRootViewController(animated: false)
        }
    }
    
    private func configureTabBarAppearance() {
        if #available(iOS 13.0, *) {
            let appearance = tabBar.standardAppearance.copy()
            appearance.backgroundColor = UIColor.white
            
            let font = UIFont.systemFont(ofSize: 14)
            let normalTitleAttributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.lightGray
            ]
            let selectedTitleAttributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.black
            ]
            
            for itemAppearance in [appearance.stackedLayoutAppearance, appearance.inlineLayoutAppearance, appearance.compactInlineLayoutAppearance] {
                itemAppearance.normal.titleTextAttributes = normalTitleAttributes
                itemAppearance.selected.titleTextAttributes = selectedTitleAttributes
                setTabBarItemBadgeAppearance(itemAppearance)
            }
            
            tabBar.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                tabBar.scrollEdgeAppearance = appearance
            }
        }
    }
    
    @available(iOS 13.0, *)
    private func setTabBarItemBadgeAppearance(_ itemAppearance: UITabBarItemAppearance) {
        itemAppearance.normal.badgeBackgroundColor = UIColor(red: 74/255, green: 234/255, blue: 177/255, alpha: 1)
        let badgeTextAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black]
        itemAppearance.normal.badgeTextAttributes = badgeTextAttributes
        itemAppearance.selected.badgeTextAttributes = badgeTextAttributes
    }
}

// MARK: - ViewModel Binding
extension HostMyTabVC {
    func bindVC() {
        viewModel.$getChatDataResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                result?.handle(success: { response in
                    self.chatDataArr = response.data ?? []
                    self.reloadAllData()
                   // self.fetchUnreadMessageCounts()
                })
            }.store(in: &cancellables)
        
        viewModel.$getUnreadBookingCount
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                result?.handle(success: { response in
                    let count = response.data?.unreadBookingCount ?? 0
                    DispatchQueue.main.async {
                        if let tabItems = self.tabBar.items, tabItems.count > 3 {
                            let chatTabBarItem = tabItems[2] // Assuming Chat is at index 1
                            chatTabBarItem.badgeValue = count > 0 ? "\(count)" : nil
                        }
                    }
                    
                })
            }.store(in: &cancellables)
    }
    
    private func fetchUnreadMessageCounts() {
        var totalUnreadCount = 0
        let group = DispatchGroup()
        for data in chatDataArr {
            if let uniqueName = data.groupName, let conversation = data.chatData, uniqueName == conversation.uniqueName {
                group.enter()
                conversation.getUnreadMessagesCount { [weak self] (_, unreadCount) in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        if let unread = unreadCount {
                            totalUnreadCount += Int(truncating: unread)
                        }
                        group.leave()
                    }
                }
            }
        }
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.totalUnreadCount = totalUnreadCount
            self.updateBadgeCount(self.totalUnreadCount)
        }
    }
    
    func updateBadgeCount(_ totalUnreadCount: Int) {
        DispatchQueue.main.async {
            if let tabItems = self.tabBar.items, tabItems.count > 2 {
                let chatTabBarItem = tabItems[1] // Assuming Chat is at index 1
                chatTabBarItem.badgeValue = totalUnreadCount > 0 ? "\(totalUnreadCount)" : nil
            }
        }
    }
    
    func updateBookingBadgeCount(_ totalUnreadCount: Int) {
        let count = totalUnreadCount
        DispatchQueue.main.async {
            if let tabItems = self.tabBar.items, tabItems.count > 3 {
                let chatTabBarItem = tabItems[2] // Assuming Chat is at index 1
                chatTabBarItem.badgeValue = count > 0 ? "\(count)" : nil
            }
        }
    }
}

// MARK: - QuickstartConversationsManagerDelegate
extension HostMyTabVC: QuickstartConversationsManagerDelegate {
    
    func reloadAllData() {
        debouncer.debounce(1.0) { [weak self] in
            guard let self = self else { return }
            DispatchQueue.global(qos: .userInitiated).async {
                for item in 0..<self.chatDataArr.count {
                    let name = self.chatDataArr[item].groupName
                    if let conversation = self.listOfChannel.first(where: { $0.uniqueName == name }) {
                        self.chatDataArr[item].chatData = conversation
                    }
                }
                
                self.chatDataArr.sort {
                    ($0.chatData?.lastMessageDate ?? Date.distantPast) > ($1.chatData?.lastMessageDate ?? Date.distantPast)
                }
                
                DispatchQueue.main.async {
                    self.fetchUnreadMessageCounts()
                }
            }
        }
    }
    
    func displayStatusMessage(_ statusMessage: String) {
        print(statusMessage)
    }
    
    func displayErrorMessage(_ errorMessage: String) {
        print(errorMessage)
    }
    
    func startTyping(participant: TCHParticipant) {
        print("Start Typing")
    }
    
    func endTyping(participant: TCHParticipant) {
        print("End Typing")
    }
    
    func getClient(client: TwilioConversationsClient?) {
        if let client = client, let list = client.myConversations() {
            DispatchQueue.main.async {
                self.listOfChannel = list
                self.listOfChannel_bal = true
                self.reloadAllData()
            }
        }
    }
    
    func reloadMessages() {
        let token = UserDetail.shared.getChatToken()
        QuickstartConversationsManager.shared.loginWithAccessToken(token) { [weak self] _ in
            self?.viewModel.apiForGetChatData(userType: "host")
        }
    }
    
    func receivedNewMessage(message: TCHMessage) {
        if let client = conversationsManager.client, let list = client.myConversations() {
            DispatchQueue.main.async {
                self.listOfChannel = list
                self.listOfChannel_bal = true
                self.fetchUnreadMessageCounts()
                self.reloadAllData()
            }
        }
    }
}



