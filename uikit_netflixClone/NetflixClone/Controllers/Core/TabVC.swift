//
//  ViewController.swift
//  ToDoApp_UIKit
//
//  Created by Jaydeep Zala on 02/06/25.
//

import UIKit

class TabVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let vc1 = UINavigationController(rootViewController: HomeVC())
        let vc2 = UINavigationController(rootViewController: UpcomingVC())
        let vc3 = UINavigationController(rootViewController: SearchVC())
        let vc4 = UINavigationController(rootViewController: DownloadsVC())
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "play.circle")
        vc3.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc4.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        
        view.tintColor = .label
        
        setViewControllers([vc1, vc2, vc3, vc4], animated: true)

    }


}

