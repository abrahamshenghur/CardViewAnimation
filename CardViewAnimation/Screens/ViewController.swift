//
//  ViewController.swift
//  CardViewAnimation
//
//  Created by Brian Advent on 26.10.18.
//  Copyright © 2018 Brian Advent. All rights reserved.
//

import UIKit
import SafariServices
import WebKit


class ViewController: UIViewController, SFSafariViewControllerDelegate  {
    
    var webViews = [WKWebView]()

    var cardVisible = false
    
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cpc-logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    
    let parentContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let childViewForHideCardButton: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Search for Vehicles", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.10656894, green: 0.3005332053, blue: 0.2772833705, alpha: 1)
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    let hideCardButton: UIButton = {
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 70, weight: .regular, scale: .medium)
        let chevronCompactDown = UIImage(systemName: "chevron.compact.down", withConfiguration: symbolConfiguration)?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setImage(chevronCompactDown, for: .normal)
        button.addTarget(self, action: #selector(hideCard), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .lightGray
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.backgroundColor = .blue
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebviews()
        addSubViews()
        layoutUI()
    }
    
    
    func loadWebviews() {
        var webViews = [WKWebView]()
        var requests = [URLRequest]()
        requests = makeURLRequest("acura", "cl")

        for request in requests {
            let webview = WKWebView()
            webview.load(request)
            webViews.append(webview)
        }
        
        self.webViews = webViews
    }
    
    
    func makeURLRequest(_ make: String, _ model: String) -> [URLRequest] {
        let websites: [Website] = [.autotrader, .carsDotCom, .carGurus, .craigslist, .truecar]
        var requests = [URLRequest]()
        var urlString = String()

        for website in websites {
            switch website {
            case .autotrader:
                let make = "ACURA"
                let model = "ACUCL"
                urlString = "https://www.autotrader.com/cars-for-sale/all-cars?zip=92570&makeCodeList=\(make)&modelCodeList=\(model)"
            case .carsDotCom:
                let make = "20001"
                let model = "20773"
                urlString = "https://www.cars.com/for-sale/searchresults.action/?mdId=\(model)&mkId=\(make)&rd=20&searchSource=QUICK_FORM&stkTypId=28881&zc=92571"
            case .carGurus:
                let makeAndModel = "d191"
                urlString = "https://www.cargurus.com/Cars/inventorylisting/viewDetailsFilterViewInventoryListing.action?zip=92501&showNegotiable=true&sortDir=DESC&sourceContext=untrackedWithinSite_false_0&distance=50000&sortType=NEWEST_CAR_YEAR&entitySelectingHelper.selectedEntity=\(makeAndModel)"
            case .craigslist:
                urlString = "https://inlandempire.craigslist.org/search/cta?query=\(make)+\(model)&purveyor-input=all"
            case .truecar:
                urlString = "https://www.truecar.com/used-cars-for-sale/listings/\(make)/\(model)/location-perris-ca/?searchRadius=5000&sort[]=year_asc"
            }
            
            let url = URL(string: urlString)!
            let request = URLRequest(url: url)
            
            requests.append(request)
        }
                
        return requests
    }
    
    
    func addSubViews() {
        view.addSubview(logoImageView)
        view.addSubview(searchButton)
        view.addSubview(parentContainerView)
        parentContainerView.addSubview(childViewForHideCardButton)
        parentContainerView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        childViewForHideCardButton.addSubview(hideCardButton)

        for webView in webViews {
            stackView.addArrangedSubview(webView)
        }
    }
    
    
    func layoutUI() {
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
            
            scrollView.topAnchor.constraint(equalTo: childViewForHideCardButton.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: parentContainerView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: parentContainerView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: parentContainerView.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            webViews[0].widthAnchor.constraint(equalToConstant: view.bounds.width * 0.85),

            hideCardButton.topAnchor.constraint(equalTo: childViewForHideCardButton.topAnchor),
            hideCardButton.centerXAnchor.constraint(equalTo: childViewForHideCardButton.centerXAnchor),
            hideCardButton.widthAnchor.constraint(equalToConstant: 100),
            hideCardButton.heightAnchor.constraint(equalToConstant: 45),
        ])
    }

    
    @objc func searchButtonTapped() {
        showCard()
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
}
