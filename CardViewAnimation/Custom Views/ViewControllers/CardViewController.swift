//
//  CardViewController.swift
//  CardViewAnimation
//
//  Created by Brian Advent on 26.10.18.
//  Copyright © 2018 Brian Advent. All rights reserved.
//

import UIKit
import SafariServices

let spacingStrategy = SpacingStrategy.proportional(1/16)

enum SpacingStrategy {
    case fixed(CGFloat)
    case proportional(CGFloat)
    
    func constrain(viewWidthAnchor: NSLayoutDimension, superviewWidthAnchor: NSLayoutDimension) -> NSLayoutConstraint {
        switch self {
        case .fixed(let constant):
            return viewWidthAnchor.constraint(equalTo: superviewWidthAnchor, constant: -constant)
        case .proportional(let multiplier):
            return viewWidthAnchor.constraint(equalTo: superviewWidthAnchor, multiplier: 1 - multiplier)
        }
    }
    
    func spacing(collectionViewWidth: CGFloat) -> CGFloat {
        switch self {
        case .fixed(let spacing):
            return spacing
        case .proportional(let factor):
            return collectionViewWidth * factor
        }
    }
}


class CardViewController: UIViewController, SFSafariViewControllerDelegate, ScreenShotDelegate {
    func getScreenShot() {
        print("✳️")
    }

        
        
    fileprivate let data = [
        CustomData(websitePreview: #imageLiteral(resourceName: "autotrader")),
        CustomData(websitePreview: #imageLiteral(resourceName: "carGurus")),
        CustomData(websitePreview: #imageLiteral(resourceName: "carsDotCom")),
        CustomData(websitePreview: #imageLiteral(resourceName: "craigslist")),
        CustomData(websitePreview: #imageLiteral(resourceName: "trueCar")),
    ]
    
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CustomCell.self, forCellWithReuseIdentifier: CustomCell.reuseID)
        return cv
    }()
    
    
    init(website: String) {
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        collectionView.backgroundColor = .lightGray
        collectionView.delegate = self
        collectionView.dataSource = self
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    var currentIndex = 0
    var lastTargetContentOffsetX: CGFloat?
    
    var insets: CGFloat = 0 {
        didSet {
            if insets != oldValue {
                collectionView.collectionViewLayout.invalidateLayout()
            }
        }
    }
    
    var spacing: CGFloat {
        return spacingStrategy.spacing(collectionViewWidth: collectionView.bounds.width).rounded()
    }
    
    var peek: CGFloat {
        return spacing * 2.5 // not necessarily a multiple of spacing; can be anything (but should be greater than spacing).
    }
    
    var cellSize: CGSize {
        return CGSize(width: collectionView.bounds.width - peek, height: collectionView.bounds.height)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //        configureCollectionView()
        
        insets = (peek / 2).rounded()
    }
    
    @objc func lowerCardVC() {
        print("POPUP")
    }
    
    
}


extension CardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let url = URL(string: "https://www.autotrader.com/cars-for-sale/all-cars?zip=92570&makeCodeList=ACURA&modelCodeList=ACUCL")
            let safariVC = SFSafariViewController(url: url!)
            safariVC.delegate = self
            self.present(safariVC, animated: true)
            
        } else if indexPath.row == 1 {
            let url = URL(string: "https://www.cargurus.com/Cars/inventorylisting/viewDetailsFilterViewInventoryListing.action?zip=92501&showNegotiable=true&sortDir=DESC&sourceContext=untrackedWithinSite_false_0&distance=50000&sortType=NEWEST_CAR_YEAR&entitySelectingHelper.selectedEntity=d191")
            let safariVC = SFSafariViewController(url: url!)
            safariVC.delegate = self
            self.present(safariVC, animated: true)
            
        } else if indexPath.row == 2 {
            let url = URL(string: "https://www.cars.com/for-sale/searchresults.action/?mdId=20773&mkId=20001&rd=20&searchSource=QUICK_FORM&stkTypId=28881&zc=92571")
            let safariVC = SFSafariViewController(url: url!)
            safariVC.delegate = self
            self.present(safariVC, animated: true)
            
        } else if indexPath.row == 3 {
            let url = URL(string: "https://inlandempire.craigslist.org/search/cta?query=Acura+cl&purveyor-input=all")
            let safariVC = SFSafariViewController(url: url!)
            safariVC.delegate = self
            self.present(safariVC, animated: true)
            
        } else if indexPath.row == 4 {
            let url = URL(string: "https://www.truecar.com/used-cars-for-sale/listings/acura/cl/location-perris-ca/?searchRadius=5000&sort[]=year_asc")
            let safariVC = SFSafariViewController(url: url!)
            safariVC.delegate = self
            self.present(safariVC, animated: true)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCell.reuseID, for: indexPath) as! CustomCell
        
//        cell.backgroundColor = .yellow
        cell.data = data[indexPath.row]
        
        return cell
    }
}


extension CardViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.frame.width * 0.8, height: collectionView.frame.height)
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: insets, bottom: 0, right: insets)
    }
}


extension CardViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let proposedIndex = Int((targetContentOffset.pointee.x + cellSize.width / 2) / cellSize.width)
        currentIndex = proposedIndex.clamped(byMin: currentIndex - 1, max: currentIndex + 1)
        targetContentOffset.pointee.x = CGFloat(currentIndex) * cellSize.width
        
        // To fix choppiness on small quick swipes
        if velocity.x != 0 && lastTargetContentOffsetX == targetContentOffset.pointee.x {
            scrollView.setContentOffset(targetContentOffset.pointee, animated: true)
        }
        
        lastTargetContentOffsetX = targetContentOffset.pointee.x
    }
}

extension Numeric where Self: Comparable {
    func clamped(byMin min: Self, max: Self) -> Self {
        return Swift.min(Swift.max(min, self), max)
    }
}
