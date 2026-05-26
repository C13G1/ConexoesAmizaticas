//
//  TabBarComponent.swift
//  ConexoesAmizaticas
//
//  Created by Jonas Fernando Nascimento Melo on 25/05/26.
//
import UIKit
import SwiftUI

class TabBarComponent: UIViewController{
    let backgrounCircle: UIView = {
        let circle = UIView()
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.backgroundColor = .black
        circle.layer.cornerRadius = circle.frame.width / 1.5
        circle.clipsToBounds = true
        circle.cornerConfiguration = .capsule()
       
        return circle
    }()

    let searchButton: UIButton = {
        let button = UIButton()
        
        let circularBorder = UIView()
        circularBorder.translatesAutoresizingMaskIntoConstraints = false
        circularBorder.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.1832, height: UIScreen.main.bounds.width * 0.1832)
        circularBorder.backgroundColor = .black
        circularBorder.cornerConfiguration = .capsule()
        circularBorder.layer.cornerRadius = circularBorder.frame.size.width / 2
        circularBorder.clipsToBounds = true
        
        
        let circularView = UIView()
        circularView.translatesAutoresizingMaskIntoConstraints = false
        circularView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.1475, height: UIScreen.main.bounds.width * 0.1475)
        circularView.backgroundColor = .white
        circularView.center = circularBorder.center
        
        circularView.layer.cornerRadius = circularView.frame.size.width / 2
        circularView.clipsToBounds = true

        
        let configImage = UIImage.SymbolConfiguration(pointSize: 32,weight: .semibold)
        let image = UIImage(systemName: "magnifyingglass", withConfiguration: configImage)?.withTintColor(UIColor.black ?? .systemGray4, renderingMode: .alwaysOriginal)
        let imageView = UIImageView(image: image)
        imageView.center = circularView.center
        circularBorder.addSubview(circularView)
        
        
        button.addSubview(circularBorder)
        button.addSubview(imageView)
        
        return button
    }()
    
    let addFriendsButton: UIButton = {
        let button = UIButton()
        
        let circularBorder = UIView()
        circularBorder.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.1832, height: UIScreen.main.bounds.width * 0.1832)
        
        circularBorder.backgroundColor = .black
        circularBorder.cornerConfiguration = .capsule()
        circularBorder.layer.cornerRadius = circularBorder.frame.size.width / 2
        circularBorder.clipsToBounds = true
        circularBorder.translatesAutoresizingMaskIntoConstraints = false
        
        let circularView = UIView()
        circularView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.1475, height: UIScreen.main.bounds.width * 0.1475)
        circularView.backgroundColor = .white
        circularView.center = circularBorder.center
        
        circularView.layer.cornerRadius = circularView.frame.size.width / 2
        circularView.clipsToBounds = true
        circularView.translatesAutoresizingMaskIntoConstraints = false

        circularBorder.addSubview(circularView)
        
        let configImage = UIImage.SymbolConfiguration(pointSize: 32,weight: .semibold)
        let image = UIImage(systemName: "person.2.badge.plus", withConfiguration: configImage)?.withTintColor(UIColor.black ?? .systemGray4, renderingMode: .alwaysOriginal)
        let imageView = UIImageView(image: image)
        imageView.center = circularBorder.center
        
        button.addSubview(circularBorder)
        button.addSubview(imageView)

        return button
    }()
    
    let zeluImage: UIImageView = {
        var image = UIImageView(image: UIImage(named: "zelu"))
        image.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.27, height: UIScreen.main.bounds.height * 0.04)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override func viewDidLoad() {
        setupController()
    }
    
    func setupController(){
        //setup views
        backgrounCircle.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        addFriendsButton.translatesAutoresizingMaskIntoConstraints = false
        zeluImage.translatesAutoresizingMaskIntoConstraints = false
        //add views
        view.addSubview(backgrounCircle)
        view.addSubview(searchButton)
        view.addSubview(addFriendsButton)
        view.addSubview(zeluImage)
        
        //setup constrains
        NSLayoutConstraint.activate([
            backgrounCircle.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.129),
            backgrounCircle.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.129),
            backgrounCircle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -22.88),
            backgrounCircle.topAnchor.constraint(equalTo: view.topAnchor, constant: 725.75),
            backgrounCircle.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            searchButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1832),
            searchButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1832),
            searchButton.topAnchor.constraint(equalTo: backgrounCircle.topAnchor, constant: 25.25),
            searchButton.leadingAnchor.constraint(equalTo: backgrounCircle.leadingAnchor, constant: 39.88),
            
            addFriendsButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1832),
            addFriendsButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1832),
            addFriendsButton.topAnchor.constraint(equalTo: searchButton.topAnchor),
            addFriendsButton.leadingAnchor.constraint(equalTo: searchButton.trailingAnchor, constant: 215),
            
            zeluImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.27),
            zeluImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.04),
            zeluImage.topAnchor.constraint(equalTo: backgrounCircle.topAnchor, constant: 15.5),
            zeluImage.centerXAnchor.constraint(equalTo: backgrounCircle.centerXAnchor)
            
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
}

#Preview {
    TabBarComponent()
}
