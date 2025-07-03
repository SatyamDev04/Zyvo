//
//  ListingVC.swift
//  Zyvo
//
//  Created by ravi on 25/11/24.
//

import UIKit

class ListingVC: UIViewController {
    
    var propertyArr = [Property]()

    @IBOutlet weak var collecV: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "HomeCell", bundle: nil)
        collecV?.register(nib, forCellWithReuseIdentifier: "HomeCell")
        collecV.delegate = self
        collecV.dataSource = self
        collecV.layer.cornerRadius = 10
       
    }
    @IBAction func btnBack_Tap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension ListingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return propertyArr.count
       
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collecV.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
        let data = propertyArr[indexPath.row]
            cell.view_Instant.isHidden = true
            cell.btnCross.isHidden = true
            cell.btnHeart.isHidden = true
            cell.imgBookMark.isHidden = true
            
            cell.view_Instant.isHidden = true
            cell.btnCross.isHidden = true
            if indexPath.row == 0 {
                cell.view_Instant.isHidden = false
            }
            if indexPath.row == 3 {
                cell.view_Instant.isHidden = false
            }
        cell.lbl_name.text = data.title ?? ""
         let rating = data.reviewsTotalRating ?? ""
            if rating != "" {
                cell.lbl_Rating.text = rating
            } else {
                cell.lbl_Rating.text = ""
            }
         let hour = data.hourlyRate ?? ""
            if hour != "" {
                cell.lbl_Time.text = "$ \(hour) / h"
            } else {
                cell.lbl_Time.text = ""
            }
            cell.imgArr = data.propertyImages ?? []
            cell.pageV.currentPage = 0
            cell.pageV.numberOfPages = data.propertyImages?.count ?? 0
            cell.CollecV.reloadData()
         let reviewCount = "\(data.reviewsTotalCount?.value ?? "0")"
            cell.lbl_NumberOfUser.text = reviewCount > "0" ? "(\(reviewCount))" : ""
         
         let distanceInMiles = data.distanceMiles ?? "0"
            cell.lbl_Distance.text = "\(distanceInMiles) miles away"
            cell.view_Instant.isHidden = true
            cell.btnHeart.isHidden = true
         
            return cell
        
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 10 // Adjust spacing as needed
        let numberOfColumns: CGFloat = 1
        let totalSpacing = (numberOfColumns - 1) * spacing

        let itemWidth = (collecV.bounds.width - totalSpacing) / numberOfColumns
        let itemHeight: CGFloat = 370 // Fixed height as per your code
        print(itemWidth,itemHeight,"itemWidth,itemHeight")
        return CGSize(width: itemWidth, height: itemHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Spacing between rows
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Spacing between columns
    }
}

