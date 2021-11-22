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


class CardViewController: UIViewController, SFSafariViewControllerDelegate {
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
    
    
    lazy var scrollview: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.backgroundColor = .blue
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var titleLabel: UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .red
        label.text = "UIStackView inside UIScrollView"
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }
    
    
//    var imageView: UIImageView {
//        let imageView = UIImageView()
//        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
//        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        return imageView
//    }
    
    init(website: String) {
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tryCollectionView()
        tryScrollView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//        runStackVC()
    }
    
    
    func runStackVC() {
        let tabStackVC = StackAsTabsViewController()
        self.present(tabStackVC, animated: true)
    }
    
    
    func tryCollectionView() {
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
    
    
    func tryScrollView() {
        setupViews()
        setupLayout()
    }
    
    func setupViews() {
        scrollview.backgroundColor = .lightGray
        view.addSubview(scrollview)
        scrollview.addSubview(contentView)
        contentView.addSubview(stackView)
        
        for image in data {
//            let imageView = UIImageView()
//            imageView.image = image.websitePreview
//            imageView.contentMode = .scaleAspectFit
//            imageView.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.85).isActive = true
//            stackView.addArrangedSubview(imageView)
            
            var safariAutotrader = SFSafariViewController(url: URL(string: "https://www.autotrader.com/cars-for-sale/all-cars?zip=92570&makeCodeList=ACURA&modelCodeList=ACUCL")!)
            
            addChild(safariAutotrader)
            self.view.addSubview(safariAutotrader.view)
            safariAutotrader.didMove(toParent: self)
            safariAutotrader.view.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.85).isActive = true

            stackView.addArrangedSubview(safariAutotrader.view)

        }
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            scrollview.topAnchor.constraint(equalTo: view.topAnchor),
            scrollview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollview.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollview.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollview.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollview.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollview.bottomAnchor),
            
            contentView.heightAnchor.constraint(equalTo: scrollview.heightAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
    
    // https://www.hackingwithswift.com/forums/swift/problem-with-stackview-and-add-label/122
    func createStack() -> UIStackView {
        var myStack = UIStackView()
        let frameStack = CGRect(x: 100, y: 200, width: 250, height: 200)
        myStack = UIStackView(frame: frameStack)
        myStack.axis = .vertical
        myStack.distribution = .fillEqually
        let addView = createView(positionX: myStack.bounds.minX, positionY: myStack.bounds.minY, paramWidth: myStack.bounds.width, paramHeight: myStack.bounds.height)
        myStack.addSubview(addView)
        return myStack
    }
    func createView(positionX: CGFloat, positionY: CGFloat, paramWidth: CGFloat, paramHeight: CGFloat) -> UIView {
        var myView = UIView()
        let frameView = CGRect(x: positionX, y: positionY, width: paramWidth, height: paramHeight)
        myView = UIView(frame: frameView)
        myView.layer.borderWidth = 1
        return myView
    }
    func createLabel(positionX: CGFloat, positionY: CGFloat, backgroundcolor: UIColor, text: String) -> UILabel {
        var myLabel = UILabel()
        let frameLabel = CGRect(x: positionY, y: positionY, width: 200, height: 30)
        myLabel = UILabel(frame: frameLabel)
        myLabel.layer.borderWidth = 1
        myLabel.layer.cornerRadius = 7
        myLabel.backgroundColor = backgroundcolor
        myLabel.text = text
        myLabel.textAlignment = .center
        myLabel.clipsToBounds = true
        return myLabel
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


class MyTabView: UIView {
    
    let imgView = UIImageView()
    
    init(with image: UIImage) {
        super.init(frame: .zero)
        imgView.image = image
        configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    func configure() {
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.backgroundColor = .lightGray
        addSubview(imgView)
        
        NSLayoutConstraint.activate([
            imgView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imgView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imgView.widthAnchor.constraint(equalToConstant: 50.0),
            imgView.heightAnchor.constraint(equalTo: imgView.widthAnchor)
        ])
        
        clipsToBounds = true
        layer.cornerRadius = 12
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        layer.borderWidth = 1
        layer.borderColor = UIColor.darkGray.cgColor
    }
}


class StackAsTabsViewController: UIViewController {
    
    let stackView: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.distribution = .fill
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let statusLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = 0
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var images = [UIImage]()
    
    var isAdding = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(statusLabel)
        scrollView.addSubview(stackView)
        view.addSubview(scrollView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        let scrollContentLayout = scrollView.contentLayoutGuide
        let scrollFrameLayout = scrollView.frameLayoutGuide
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 58.0),
            
            stackView.topAnchor.constraint(equalTo: scrollContentLayout.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollContentLayout.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollContentLayout.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollContentLayout.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollFrameLayout.heightAnchor),
            
            statusLabel.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 40.0),
            statusLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 40.0),
            statusLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -40.0)
        ])
        
        for i in 1...9 {
            guard let img = UIImage(systemName: "\(i).circle.fill") else {
                fatalError("Could not create images!!!")
            }
            images.append(img)
        }
        
        updateTabs()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(gotTap(_:)))
        view.addGestureRecognizer(tap)

    }
    
    @objc func gotTap(_ g: UITapGestureRecognizer) {
        updateTabs()
    }
    
    func updateTabs() {
        if isAdding {
            let img = images[stackView.arrangedSubviews.count]
            
            let tab = MyTabView(with: img)
            
            stackView.addArrangedSubview(tab)
            let scrollFrameLayout = scrollView.frameLayoutGuide
            
            NSLayoutConstraint.activate([
                tab.widthAnchor.constraint(equalTo: scrollFrameLayout.widthAnchor, multiplier: 1.0 / 3.0),
                tab.heightAnchor.constraint(equalTo: scrollFrameLayout.heightAnchor)
            ])
        } else {
            stackView.arrangedSubviews.last?.removeFromSuperview()
        }
        
        if stackView.arrangedSubviews.count == 1 { // remains false while decreasing until it hits 1
            isAdding = true
        } else if stackView.arrangedSubviews.count == images.count {
            isAdding = false
        }
        
        updateStatusLabels()
    }
    
    func updateStatusLabels() {
        DispatchQueue.main.async {
            let numTabs = self.stackView.arrangedSubviews.count
            var str = ""
            
            if self.isAdding {
                str += "Tap anywhere to ADD a tab"
            } else {
                str += "Tap anywhere to REMOVE a tab"
            }
            
            str += "\n"
            str += "Number of tabs: \(numTabs)"
            str += "\n"
            
            if numTabs > 3 {
                str += "Tabs WILL scroll"
            } else {
                str += "Tabs will NOT scroll"
            }
            
            self.statusLabel.text = str
        }
    }
}
