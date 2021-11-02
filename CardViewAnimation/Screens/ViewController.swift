//
//  ViewController.swift
//  CardViewAnimation
//
//  Created by Brian Advent on 26.10.18.
//  Copyright © 2018 Brian Advent. All rights reserved.
//

import UIKit

protocol ScreenShotDelegate: class {
    func getScreenShot()
}


class ViewController: UIViewController  {
    
    enum CardState {
        case expanded
        case collapsed
    }
    
    weak var delegate: ScreenShotDelegate?

    let logoImageView = UIImageView()

    let parentContainerView = UIView(frame: .zero)
    let childViewForHideCardButton = UIView(frame: .zero)
    let childViewForCollectionView = UIView(frame: .zero)
    
    let cardViewController: CardViewController = {
        let vc = CardViewController(website: "cars")
//        self.add(childVC: vc, to: self.containerView)
        return vc
    }()
    
    let cardHeight: CGFloat = 600
    let cardHandleAreaHeight: CGFloat = 0
    
    var cardVisible = false
    var nextState: CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    var runningAnimations = [UIViewPropertyAnimator]()
    
    let searchButton = Button(title: "Search for Vehicles")
    let hideCardButton = Button(title: "")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLogo()
        
        configureSearchButton()
        
        configureParentContainerView()
        configureChildViewForHideCardButton()
        configureChildViewForCollectionView()

        configureHideCardButton()
        loadWebpagePreviews()
        
        layoutUI()
    }

    func configureLogo() {
        view.addSubview(logoImageView)
        logoImageView.image = UIImage(named: "cpc-logo")
        logoImageView.backgroundColor = #colorLiteral(red: 0.1091164276, green: 0.3069898784, blue: 0.2836051285, alpha: 1)
        
    }
    
    func configureSearchButton() {
        view.addSubview(searchButton)
        searchButton.backgroundColor = #colorLiteral(red: 0.10656894, green: 0.3005332053, blue: 0.2772833705, alpha: 1)
        searchButton.layer.cornerRadius = 10
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
    }
    
    
    func configureParentContainerView() {
        parentContainerView.backgroundColor = .white
        parentContainerView.layer.cornerRadius = 12
        view.addSubview(parentContainerView)
    }
    
    
    func configureChildViewForHideCardButton() {
        childViewForHideCardButton.backgroundColor = .white
        parentContainerView.addSubview(childViewForHideCardButton)
    }
    
    
    func configureChildViewForCollectionView() {
//        childViewForCollectionView.backgroundColor = .brown
        parentContainerView.addSubview(childViewForCollectionView)
    }

    
    func configureHideCardButton() {
//        let largeFont = UIFont.systemFont(ofSize: 75)
//        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 70, weight: .regular, scale: .medium)
        
        let chevronCompactDown = UIImage(systemName: "chevron.compact.down", withConfiguration: symbolConfiguration)?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
//        let iconImage = UIImage(systemName: "chevron.right",withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .regular, scale: .medium))?.withTintColor(.systemGreen)
        hideCardButton.setImage(chevronCompactDown, for: .normal)
        hideCardButton.addTarget(self, action: #selector(hideCard), for: .touchUpInside)
        childViewForHideCardButton.addSubview(hideCardButton)
    }
    
    
    func loadWebpagePreviews() {
        self.add(childVC: cardViewController, to: self.childViewForCollectionView)
    }

    
    @objc func searchButtonTapped() {
        showCard()
        updateView()  // CocoaCasts Tutorial //
    }
    
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }

    
    func updateView() {
        if cardVisible {
            print("call add Function")
        } else {
            print("LOWERING CARD")
        }
    }

    
    @objc func showCard() {
        searchButton.isHidden = true
        cardVisible = !cardVisible
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseOut, animations: {
            self.parentContainerView.frame.origin.y = self.view.frame.height - self.parentContainerView.frame.height
        })
    }
    
    
    @objc func hideCard() {
        cardVisible = !cardVisible
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseOut, animations: {
            self.parentContainerView.frame.origin.y = self.view.frame.height
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
            self.searchButton.isHidden = false
        })
    }
    

    func layoutUI() {
        logoImageView.translatesAutoresizingMaskIntoConstraints                 = false
        parentContainerView.translatesAutoresizingMaskIntoConstraints           = false
        childViewForHideCardButton.translatesAutoresizingMaskIntoConstraints    = false
        childViewForCollectionView.translatesAutoresizingMaskIntoConstraints    = false
        hideCardButton.translatesAutoresizingMaskIntoConstraints                = false
        searchButton.translatesAutoresizingMaskIntoConstraints                  = false
        
        let padding = CGFloat(20)

        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 220),
            logoImageView.heightAnchor.constraint(equalToConstant: 220),
            
            searchButton.heightAnchor.constraint(equalToConstant: 60),
            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            searchButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -85),
            
            parentContainerView.topAnchor.constraint(equalTo: view.bottomAnchor),
            parentContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            parentContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            parentContainerView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.90),
            
            childViewForHideCardButton.topAnchor.constraint(equalTo: parentContainerView.topAnchor),
            childViewForHideCardButton.leadingAnchor.constraint(equalTo: parentContainerView.leadingAnchor, constant: padding),
            childViewForHideCardButton.trailingAnchor.constraint(equalTo: parentContainerView.trailingAnchor, constant: -padding),
            childViewForHideCardButton.heightAnchor.constraint(equalToConstant: 45),
            
            childViewForCollectionView.topAnchor.constraint(equalTo: childViewForHideCardButton.bottomAnchor),
            childViewForCollectionView.leadingAnchor.constraint(equalTo: parentContainerView.leadingAnchor, constant: 0),
            childViewForCollectionView.trailingAnchor.constraint(equalTo: parentContainerView.trailingAnchor, constant: 0),
            childViewForCollectionView.bottomAnchor.constraint(equalTo: parentContainerView.bottomAnchor),
            
            hideCardButton.topAnchor.constraint(equalTo: childViewForHideCardButton.topAnchor),
            hideCardButton.centerXAnchor.constraint(equalTo: childViewForHideCardButton.centerXAnchor),
            hideCardButton.widthAnchor.constraint(equalToConstant: 100),
            hideCardButton.heightAnchor.constraint(equalToConstant: 45),
        ])
    }
}






                                ////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                ////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                ////////////////////////////////////////////////////////////////////////////////////////////////////////////

//class HorizontalPeekingPagesCollectionViewController: UICollectionViewController {
//
//    private var indexOfCellBeforeDragging = 0
//    private var collectionViewFlowLayout: UICollectionViewFlowLayout {
//        return collectionViewLayout as! UICollectionViewFlowLayout
//    }
//
//    // Alternative using MoodViewController
//    private var cellSize: CGSize = .zero
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        collectionViewFlowLayout.minimumLineSpacing = 0
//    }
//
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        configureCollectionViewLayoutItemSize()
//    }
//
//
//    private func configureCollectionViewLayoutItemSize() {
//        let inset: CGFloat = calculateSectionInset()
//        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
//
//        collectionViewFlowLayout.itemSize = CGSize(width: collectionViewLayout.collectionView!.frame.size.width - inset * 2, height: collectionViewLayout.collectionView!.frame.size.height)
//    }
//
//
//    func calculateSectionInset() -> CGFloat { // should be overridden
//        return 100
//    }
//
//
//
//    private func indexOfMajorCell() -> Int {
//        let itemWidth = collectionViewFlowLayout.itemSize.width
//        let proportionalOffset = collectionViewLayout.collectionView!.contentOffset.x / itemWidth
//        let index = Int(round(proportionalOffset))
//        let numberOfItems = collectionView.numberOfItems(inSection: 0)
//        let safeIndex = max(0, min(numberOfItems - 1, index))
//
//        return safeIndex
//    }
//
//
//    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        indexOfCellBeforeDragging = indexOfMajorCell()
//    }
//
//
//    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        //
//
//        // Stop scrollView sliding:
//        targetContentOffset.pointee = scrollView.contentOffset
//
//        // calculate where scrollView should snap to:
//        let indexOfMajorCell = self.indexOfMajorCell()
//
//        // calculate conditions:
//        let dataSourceCount = collectionView(collectionView!, numberOfItemsInSection: 0)
//        let swipeVelocityThreshold: CGFloat = 0.5 // after some trail and error
//        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < dataSourceCount && velocity.x > swipeVelocityThreshold
//        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
//        let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
//        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
//
//        if didUseSwipeToSkipCell {
//
//            let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
//            let toValue = collectionViewFlowLayout.itemSize.width * CGFloat(snapToIndex)
//
//            // Damping equal 1 => no oscillations => decay animation:
//            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
//                scrollView.contentOffset = CGPoint(x: toValue, y: 0)
//                scrollView.layoutIfNeeded()
//            }, completion: nil)
//
//        } else {
//            // This is a much better way to scroll to a cell:
//            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
//            collectionViewLayout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//        }
//
//
//        /////////////
//        // Alternative Method from MoodViewController Example
//        /////////////
//
//        var targetIndex = (targetContentOffset.pointee.x * cellSize.width / 2) / cellSize.width
//        targetIndex = velocity.x > 0 ? ceil(targetIndex) : floor(targetIndex)
//        targetIndex = targetIndex.clamped(minValue: 0, maxValue: CGFloat(100 - 1))
//        targetContentOffset.pointee.x = targetIndex * cellSize.width
//
//        indexOfCellBeforeDragging = Int(targetIndex)
//    }
//}

//fileprivate extension CGFloat {
//    func clamped(minValue: CGFloat, maxValue: CGFloat) -> CGFloat {
//        return Swift.min(maxValue, Swift.max(minValue, self))
//    }
//}




/*

////////////////////////////////////////////////////// CocoaCasts Tutorial //////////////////////////////////////////////////////
private lazy var pupupCardViewController: CardViewController = {
    // Load Storyboard
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    
    // Instantiate View Controller
    var viewController = storyboard.instantiateViewController(withIdentifier: cellID) as! CardViewController
    
    // Add View Controller as Child View Controller
    self.add(asChildViewController: viewController)
    
    return viewController
}()

func add(asChildViewController viewController: UIViewController) {
    // Add Child View Controller
    addChild(viewController)
    
    // Add Child View as Subview
    view.addSubview(viewController.view)
    
    // Configure Child View
    viewController.view.frame = view.bounds
    viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    // Notify Child View Controller
    viewController.didMove(toParent: self)
}

func add(childVC: UIViewController, to containerView: UIView) {
    addChild(childVC)
    containerView.addSubview(childVC.view)
    childVC.view.frame = containerView.bounds
    childVC.didMove(toParent: self)
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////

func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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
 */


/*
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////     PeekingPagedCollectionView      //////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    //        configureCollectionView()
    
    insets = (peek / 2).rounded()
}

func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    
    //        targetContentOffset.pointee = scrollView.contentOffset
    //
    //        // calculate where scrollView should snap to:
    //        let indexOfMajorCell = self.indexOfMajorCell()
    //
    //        // calculate conditions:
    //        let dataSourceCount = collectionView(collectionView!, numberOfItemsInSection: 0)
    //        let swipeVelocityThreshold: CGFloat = 0.5 // after some trail and error
    //        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < dataSourceCount && velocity.x > swipeVelocityThreshold
    //        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
    //        let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
    //        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
    //        let flowLayout                  = UICollectionViewFlowLayout()
    //
    //        if didUseSwipeToSkipCell {
    //
    //            let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
    //            let toValue = flowLayout.itemSize.width * CGFloat(snapToIndex)
    //
    //            // Damping equal 1 => no oscillations => decay animation:
    //            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
    //                scrollView.contentOffset = CGPoint(x: toValue, y: 0)
    //                scrollView.layoutIfNeeded()
    //            }, completion: nil)
    //
    //        } else {
    //            // This is a much better way to scroll to a cell:
    //            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
    //            flowLayout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    //        }
    
    /////////////
    // Alternative Method from MoodViewController Example
    /////////////
    
    //        var targetIndex = (targetContentOffset.pointee.x * cellSize.width / 2) / cellSize.width
    //        targetIndex = velocity.x > 0 ? ceil(targetIndex) : floor(targetIndex)
    //        targetIndex = targetIndex.clamped(minValue: 0, maxValue: CGFloat(100 - 1))
    //        targetContentOffset.pointee.x = targetIndex * cellSize.width
    //
    //        indexOfCellBeforeDragging = Int(targetIndex)
    
    
    /////////////
    // Alternative Method from PeekingPagedCollectionView Example
    /////////////
    
    let proposedIndex = Int((targetContentOffset.pointee.x + cellSize.width / 2) / cellSize.width)
    currentIndex = proposedIndex.clamped(byMin: currentIndex - 1, max: currentIndex + 1)
    targetContentOffset.pointee.x = CGFloat(currentIndex) * cellSize.width
    
    // To fix choppiness on small quick swipes
    if velocity.x != 0 && lastTargetContentOffsetX == targetContentOffset.pointee.x {
        scrollView.setContentOffset(targetContentOffset.pointee, animated: true)
    }
    
    lastTargetContentOffsetX = targetContentOffset.pointee.x
}
*/



//    var collectionView: UICollectionView!
//    var cellID = "Cell"


//    let leftAndRightPaddings: CGFloat = 80.0
//    let numberOfItemsPerRow: CGFloat = 7.0
//    let screenSize = UIScreen.main.bounds.size
//    let cellScale: CGFloat = 0.8

//    var indexOfCellBeforeDragging = 0
//    var cellSize: CGSize = .zero


//    var items = ["autotrader", "carsdotcom", "cargurus", "craigslist", "truecar"]


//        configureCollectionView()
//        setupCard()


//    func configureCollectionView() {
//        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: createFlowLayout())
//        collectionView.register(Cell.self, forCellWithReuseIdentifier: cellID)
//        collectionView.backgroundColor = UIColor.yellow
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        self.containerView.addSubview(collectionView)
//    }


//    func createFlowLayout() -> UICollectionViewLayout {
////        let width                       = view.bounds.width * 0.8
////        let padding: CGFloat            = 12
////        let minimumItemSpacing: CGFloat = 10
////        let availableWidth              = width - (padding * 2) - (minimumItemSpacing * 2)
////        let itemWidth                   = availableWidth / 3
//
//        let cellWidth                   = screenSize.width * 0.8     //Ductran
//        let cellHeight                  = screenSize.height * 0.65
//        let insetX                      = CGFloat(12)
//        let insetY                      = CGFloat(12)
//
//        let flowLayout                  = UICollectionViewFlowLayout()
//        flowLayout.itemSize             = CGSize(width: cellWidth, height: cellHeight)
//        flowLayout.sectionInset         = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
//        flowLayout.scrollDirection      = .horizontal
//
////        let inset: CGFloat = calculateSectionInset()
////        flowLayout.itemSize = CGSize(width: flowLayout.collectionView!.frame.size.width - inset * 2, height: flowLayout.collectionView!.frame.size.height)
////        flowLayout.sectionInset = UIEdgeInsets(top: insetY, left: inset, bottom: insetY, right: inset)
////        flowLayout.scrollDirection = .horizontal
//
//        return flowLayout
//    }


//    func calculateSectionInset() -> CGFloat { // should be overridden
//        return 10
//    }


//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return items.count
//    }


//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! Cell
//        cell.backgroundColor = .red
//        cell.layer.cornerRadius = 10
//
//        // You can color the cells so you could see how they behave:
//        let isEvenCell = CGFloat(indexPath.row).truncatingRemainder(dividingBy: 2) == 0
//        cell.backgroundColor = isEvenCell ? UIColor(white: 0.7, alpha: 1) : .red
//
//        return cell
//    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = (collectionView.frame.width-leftAndRightPaddings)/numberOfItemsPerRow
//
//        return CGSize(width: width, height: width)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//    }


//    func snapToCenter() {
//        let centerPoint = view.convert(view.center, to: collectionView)
//        guard let centerIndexPath = collectionView.indexPathForItem(at: centerPoint) else { return }
//        collectionView.scrollToItem(at: centerIndexPath, at: .centeredHorizontally, animated: true)
//    }


//    func setupCard() {
//        cardViewController = CardViewController(website: "cars")
//        addChild(cardViewController)
//        view.addSubview(cardViewController.view)
//
//        cardViewController.view.frame = CGRect(x: 0, y: view.frame.height - cardHandleAreaHeight, width: view.bounds.width, height: cardHeight)
//
//        cardViewController.view.clipsToBounds = true
//
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleCardTap(recognzier:)))
//
//        cardViewController.handleArea.addGestureRecognizer(tapGestureRecognizer)
//    }


//    @objc func handleCardTap(recognzier:UITapGestureRecognizer) {
//        switch recognzier.state {
//        case .ended:
//            delegate?.getScreenShot()
//            animateTransitionIfNeeded(state: nextState, duration: 0.9)
//        default:
//            break
//        }
//    }



//    func animateTransitionIfNeeded (state: CardState, duration: TimeInterval) {
//        if runningAnimations.isEmpty {
//            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
//                switch state {
//                case .expanded:
//                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight
//                    self.searchButton.isHidden = true
//                case .collapsed:
//                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.9, execute: {
//                        self.searchButton.isHidden = false
//                    })
//                }
//            }
//
//            frameAnimator.addCompletion { _ in
//                self.cardVisible = !self.cardVisible
//                self.runningAnimations.removeAll()
//            }
//
//            frameAnimator.startAnimation()
////            runningAnimations.append(frameAnimator)
//
//            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
//                switch state {
//                case .expanded:
//                    self.cardViewController.view.layer.cornerRadius = 12
//                case .collapsed:
//                    self.cardViewController.view.layer.cornerRadius = 0
//                }
//            }
//
//            cornerRadiusAnimator.startAnimation()
////            runningAnimations.append(cornerRadiusAnimator)
//        }
//    }

//        collectionView.translatesAutoresizingMaskIntoConstraints = false

//            collectionView.topAnchor.constraint(equalTo: hideCardButton.bottomAnchor, constant: padding),
//            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
//            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),


extension ViewController: UIScrollViewDelegate {
    //    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    //        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    //        let itemSpace = layout.itemSize.width + layout.minimumLineSpacing
    //
    //        var offset = targetContentOffset.pointee
    //        let index = (offset.x + scrollView.contentInset.left) / itemSpace
    //        let roundIndex = round(index)
    //
    //        offset = CGPoint(x: roundIndex * itemSpace - scrollView.contentInset.left, y: -scrollView.contentInset.top)
    //
    //        targetContentOffset.pointee = offset
    //    }
    
    
    
    //    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    //        snapToCenter()
    //    }
    
    //    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    //        if !decelerate {
    //            snapToCenter()
    //        }
    //    }
    
    //    private func indexOfMajorCell() -> Int {
    //        let flowLayout                  = UICollectionViewFlowLayout()
    //        let itemWidth = flowLayout.itemSize.width
    //        let proportionalOffset = flowLayout.collectionView!.contentOffset.x / itemWidth
    //        let index = Int(round(proportionalOffset))
    //        let numberOfItems = collectionView.numberOfItems(inSection: 0)
    //        let safeIndex = max(0, min(numberOfItems - 1, index))
    //
    //        return safeIndex
    //    }
    
    //    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    //        indexOfCellBeforeDragging = indexOfMajorCell()
    //    }
    
    
}

class Cell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
