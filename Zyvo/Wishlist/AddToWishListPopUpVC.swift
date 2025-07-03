//
//  AddToWishListPopUpVC.swift
//  Zyvo
//
//  Created by ravi on 20/11/24.
//

import UIKit
import Combine



class AddToWishListPopUpVC: UIViewController {
    
    var backAction:(_ str : String ) -> () = { str in}
    
    var arr = ["Sea view","Cabin in Peshastin"]
    var imgArr = ["img1","img2"]
    
    var propertyID = ""
    
    
    private var viewModel = WishlistDataViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    var getWishlistArr : [WishlistDataModel]?
    
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collecV: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collecV.isHidden = true
        bindVC()
        viewModel.apiForGetCreatedWishList()
        
        // Register the WishlistCell nib file
        let nib = UINib(nibName: "WishlistCell", bundle: nil)
        collecV.register(nib, forCellWithReuseIdentifier: "WishlistCell")
        
        collecV.delegate = self
        collecV.dataSource = self
        
        // Style the collection view
        collecV.layer.cornerRadius = 10
    }
    
   
    
    @IBAction func btnCross_Tap(_ sender: UIButton) {
        
        self.dismiss(animated: false) 
        
    }
    
    @IBAction func btnCreate_Tap(_ sender: UIButton) {
        
        self.dismiss(animated: false) {
            self.backAction("Ravi")
        }
    }
}

// MARK: - UICollectionView Delegate and DataSource
extension AddToWishListPopUpVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(getWishlistArr?.count,"Count")
        return getWishlistArr?.count ?? 0 //arr.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collecV.dequeueReusableCell(withReuseIdentifier: "WishlistCell", for: indexPath) as! WishlistCell
        let data = getWishlistArr?[indexPath.item]
        // Configure the cell here if needed
        cell.lbl_name.text =  data?.wishlistName ?? "" //arr[indexPath.item]
        
        var image = data?.lastSavedPropertyImage ?? ""
        let imgURL = AppURL.imageURL + image
        cell.img.loadImage(from:imgURL,placeholder: UIImage(named: "img1"))
        cell.lbl_SavedCount.text = "\(data?.itemsInWishlist ?? 0)" + " Saved"
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let data  = getWishlistArr?[indexPath.item]
        
        viewModel.propertyID = self.propertyID
        viewModel.wishlistID = "\(data?.wishlistID ?? 0)"
        viewModel.apiForAddItemInWishlist()
        
    }
}

// MARK: - UICollectionViewDelegateFlowLayout


// MARK: - UICollectionViewDelegateFlowLayout
extension AddToWishListPopUpVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 20 // Spacing between cells
        let itemsPerRow: CGFloat = 2 // 1
        let totalPadding = (itemsPerRow - 1) * padding
        let availableWidth = collectionView.frame.width - totalPadding
        let cellWidth = availableWidth / itemsPerRow
        
        return CGSize(width: cellWidth, height: 250) // 400
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5 // Vertical spacing between rows
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Horizontal spacing between cells
    }
}

extension AddToWishListPopUpVC {
    
    func bindVC(){
        viewModel.$getWishListResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    //self.showToast(response.message ?? "")
                    
                    self.getWishlistArr = response.data
                    
                    if self.getWishlistArr?.count == 0 {
                        self.collecV.isHidden = true
                    } else {
                        self.collecV.isHidden = false
                        print(self.getWishlistArr,"getWishlistArr")
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.collecV.reloadData()
                        }
                    }
                })
            }.store(in: &cancellables)
        
        
        // ADDItemInWishListResult
        
        viewModel.$AddItemInWishlistResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.dismiss(animated: false) {
                            self.backAction("SaveItemInWishlist")
                        }
                    }
                    
                })
            }.store(in: &cancellables)
    }
}
