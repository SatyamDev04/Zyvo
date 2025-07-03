//
//  ImagePopUpVC.swift
//  Zyvo
//
//  Created by ravi on 12/12/24.
//

import UIKit

class ImagePopUpVC: UIViewController {
    @IBOutlet weak var pageV: UIPageControl!
    @IBOutlet weak var collecV: UICollectionView!
    
    var imagesArr = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib3 = UINib(nibName: "imgCell", bundle: nil)
        collecV?.register(nib3, forCellWithReuseIdentifier: "imgCell")
        collecV.delegate = self
        collecV.dataSource = self
        collecV.layer.cornerRadius = 20
        pageV.currentPage = 0
        pageV.numberOfPages = imagesArr.count
        
    }
    
    @IBAction func btnBack_Tap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension ImagePopUpVC :UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collecV.dequeueReusableCell(withReuseIdentifier: "imgCell", for: indexPath) as! imgCell
        let data = imagesArr[indexPath.row]
        let imgURL2 = AppURL.imageURL + data
        cell.img.loadImage(from:imgURL2,placeholder: UIImage(named: "img1"))
        
        return cell
    }
    
}
extension ImagePopUpVC:UICollectionViewDelegateFlowLayout {
    // UICollectionViewDelegateFlowLayout method to set cell size
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Calculate the width based on screen size, subtracting padding or spacing as needed
        let padding: CGFloat = 5  // Example padding (adjust as needed)
        let collectionViewWidth = collectionView.frame.width - padding
        let cellWidth = collectionViewWidth / 1  //Display 2 cells per row
        // Return the size with fixed height of 120
        print(collectionView.bounds.size.width,"width")
        print((collectionView.bounds.size.width*0.9),"height")
        return CGSize(width: collectionView.bounds.size.width, height: (collectionView.bounds.size.width*0.9).rounded(.up))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: self.collecV.contentOffset, size: self.collecV.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = self.collecV.indexPathForItem(at: visiblePoint) {
            self.pageV.currentPage = visibleIndexPath.row
            
        }
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset
        var indexes = self.collecV.indexPathsForVisibleItems
        indexes.sort()
        var index = indexes.first!
        let cell = self.collecV.cellForItem(at: index)!
        let position = self.collecV.contentOffset.x - cell.frame.origin.x
        if position > cell.frame.size.width/2{
            index.row = index.row+1
        }
        self.collecV.scrollToItem(at: index, at: .left, animated: true )
    }
}


