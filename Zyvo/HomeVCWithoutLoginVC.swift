//
//  HomeVCWithoutLoginVC.swift
//  Zyvo
//
//  Created by ravi on 11/10/24.
//

import UIKit
import Combine


class HomeVCWithoutLoginVC: UIViewController {
    
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var lbl_Where: UILabel!
    @IBOutlet weak var lbl_Activity: UILabel!
    @IBOutlet weak var collecV: UICollectionView!
    @IBOutlet weak var view_Search: UIView!
    
    private var cancellables = Set<AnyCancellable>()
    private var viewModel = HomeDataViewModel()
    var getHomeDataArr : [HomeDataModel]?
    
    var comingFrom = ""
    var timess: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindVC()
       
        lbl_time.font = UIFont(name: "Poppins-SemiBold", size: 15)
        lbl_Where.font = UIFont(name: "Poppins-SemiBold", size: 15)
        lbl_Activity.font = UIFont(name: "Poppins-SemiBold", size: 15)
        let userID = UserDetail.shared.getUserId()
        let isProfileCompleted = UserDetail.shared.getisCompleteProfile()
        let isKeepMeLogin = UserDetail.shared.getKeepMeLogin()
        let fullName = UserDetail.shared.getName()
        if userID != "" {
            if isKeepMeLogin == "Yes" {
                if isProfileCompleted == "" || isProfileCompleted == "false" {
                    let stryB = UIStoryboard(name: "Main", bundle: nil)
                    let vc = stryB.instantiateViewController(withIdentifier: "CreateProfileVC") as! CreateProfileVC
                    vc.fullName = fullName
                    self.navigationController?.pushViewController(vc, animated: false)
                } else {
                    let logintype =  UserDetail.shared.getlogintType()
                    if logintype == "Host" {
                        let stryB = UIStoryboard(name: "Host", bundle: nil)
                        let vc = stryB.instantiateViewController(withIdentifier: "HostMyTabVC") as! HostMyTabVC
                        self.navigationController?.pushViewController(vc, animated: false)
                    } else {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabVC") as! MainTabVC
                        self.navigationController?.pushViewController(vc, animated: false) }
                }
            }
        }
        
        view_Search.layer.borderWidth = 1.5
        view_Search.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        view_Search.layer.cornerRadius = view_Search.layer.frame.height / 2
        
        let nib2 = UINib(nibName: "HomeCell", bundle: nil)
        collecV?.register(nib2, forCellWithReuseIdentifier: "HomeCell")
        collecV.delegate = self
        collecV.dataSource = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel.apiforGetHomeDataWithoutLogin()
    }
    @IBAction func btnWhereTap(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WhereVC") as! WhereVC
        //        vc.timess = self.timess
        vc.comeFrom = "Where"
        vc.backAction = { str, str1 in
            print( str, str1,"data Recieved")
            if str1 == "Clear" {
                self.viewModel.apiforGetHomeData()
            } else if str1 == "" {
                self.viewModel.apiforGetHomeData()
            } else {
                self.comingFrom = "Filter"
                if str?.count == nil {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SorryVC") as! SorryVC
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.getHomeDataArr?.removeAll()
                    self.getHomeDataArr = str
                    self.collecV.reloadData()
                }
            }
        }
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    @IBAction func btnTime_Tap(_ sender: UIButton) {
       
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WhereVC") as! WhereVC
        //        vc.timess = self.timess
        vc.comeFrom = "Time"
        vc.backAction = { str, str1 in
            print( str, str1,"data Recieved")
            if str1 == "Clear" {
                self.viewModel.apiforGetHomeData()
            } else if str1 == "" {
                self.viewModel.apiforGetHomeData()
            } else {
                self.comingFrom = "Filter"
                if str?.count == nil {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SorryVC") as! SorryVC
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.getHomeDataArr?.removeAll()
                    self.getHomeDataArr = str
                    self.collecV.reloadData()
                }
            }
        }
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    @IBAction func btnActivity_Tap(_ sender: UIButton) {
      
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WhereVC") as! WhereVC
        //        vc.timess = self.timess
        vc.comeFrom = "Activity"
        vc.backAction = { str, str1 in
            print( str, str1,"data Recieved")
            if str1 == "Clear" {
                self.viewModel.apiforGetHomeData()
            } else if str1 == "" {
                self.viewModel.apiforGetHomeData()
            } else {
                self.comingFrom = "Filter"
                if str?.count == nil {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SorryVC") as! SorryVC
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.getHomeDataArr?.removeAll()
                    self.getHomeDataArr = str
                    self.collecV.reloadData()
                }
            }
        }
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    @IBAction func btnSearch_Tap(_ sender: UIButton) {
    }
    @IBAction func btnFilter_Tap(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        
        vc.timess = self.timess
        
        vc.backAction = { str, str1 in
            print( str, str1,"data Recieved")
            if str1 == "Clear" {
                self.viewModel.apiforGetHomeData()
            } else if str1 == "" {
                self.viewModel.apiforGetHomeData()
            } else {
                self.comingFrom = "Filter"
                if str?.count == nil {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SorryVC") as! SorryVC
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.getHomeDataArr?.removeAll()
                    self.getHomeDataArr = str
                    self.collecV.reloadData()
                }
            }
        }
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    @IBAction func btnLogin_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
}
extension HomeVCWithoutLoginVC :UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getHomeDataArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collecV.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
        let data = getHomeDataArr?[indexPath.item]
        cell.view_Instant.isHidden = true
        cell.btnCross.isHidden = true
        
        let isInstantBookStatus =  data?.isInstantBook ?? 0
        if isInstantBookStatus == 0 {
            cell.view_Instant.isHidden = true
        } else {
            cell.view_Instant.isHidden = true
        }
        
        cell.lbl_name.text = data?.title ?? ""
        
        let rating = data?.rating ?? ""
        if rating != "" {
            cell.lbl_Rating.text = rating
        } else {
            cell.lbl_Rating.text = ""
        }
        let hour = data?.hourlyRate ?? ""
        let price = hour.formattedPrice()
        if price != "" {
            cell.lbl_Time.text = "$ \(price) / h"
        } else {
            cell.lbl_Time.text = ""
        }
        
        cell.imgArr = data?.images ?? []
        cell.pageV.currentPage = 0
        cell.pageV.numberOfPages = data?.images?.count ?? 0
        cell.CollecV.reloadData()
        cell.view_Instant.isHidden = true
        cell.btnHeart.tag = indexPath.row
        cell.btnHeart.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        cell.btnInstantBook.tag = indexPath.row
        cell.btnInstantBook.addTarget(self, action: #selector(InstantBook(_:)), for: .touchUpInside)
        cell.btnCross.isHidden = true
        if indexPath.row == 0 {
            cell.view_Instant.isHidden = false
        }
        if indexPath.row == 3 {
            cell.view_Instant.isHidden = false
        }
        
        // Handle selection from inner collection view
        cell.didSelectItem = { [weak self] innerIndexPath in
            guard let self = self else { return }
            print("Selected item at outer index: \(indexPath.item), inner index: \(innerIndexPath.item)")
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LocationVC") as! LocationVC
            vc.propertyID = "\(data?.propertyID ?? 0)"
            vc.comingFrom = "WithoutLogin"
            self.navigationController?.pushViewController(vc, animated: true)
         
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc func InstantBook(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
}

extension HomeVCWithoutLoginVC:UICollectionViewDelegateFlowLayout {
    // UICollectionViewDelegateFlowLayout method to set cell size
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Calculate the width based on screen size, subtracting padding or spacing as needed
        let padding: CGFloat = 5  // Example padding (adjust as needed)
        let collectionViewWidth = collectionView.frame.width - padding
        let cellWidth = collectionViewWidth / 1  // Display 2 cells per row
        
        // Return the size with fixed height of 120
        return CGSize(width: cellWidth, height: 370)
    }
}

extension HomeVCWithoutLoginVC {
    func bindVC() {
        viewModel.$getHomeDataResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    self.getHomeDataArr?.removeAll()
                    self.getHomeDataArr = response.data
                    print(self.getHomeDataArr ?? [],"HOME DATA YAHI HAI")
                    self.collecV.reloadData()
                })
            }.store(in: &cancellables)
    }
}
