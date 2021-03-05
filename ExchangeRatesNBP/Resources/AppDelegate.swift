//
//  AppDelegate.swift
//  ExchangeRatesNBP
//
//  Created by Yevhen Shevchenko on 04.03.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = createTabBarController()
        
        configureNavigationBar()
        
        return true
    }
    
    private func createTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            createConverterVC(), createExchangeRatesNC(), createSettingsVC()
        ]
        
        let images = Constant.TabBarIcon.allCases
        
        for (item, image) in zip(tabBarController.tabBar.items ?? [], images) {
            item.image = UIImage(named: image.rawValue)
        }
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .gold
        appearance.backgroundColor = .customeDarkGray
        tabBarController.tabBar.tintColor = .gold
        tabBarController.tabBar.standardAppearance = appearance
        
        return tabBarController
    }
    
    private func createConverterVC() -> UIViewController {
        let converterNC = UINavigationController(rootViewController: ConverterViewController())
        converterNC.title = Constant.ControllerTitle.converter
        return converterNC
    }
    
    private func createExchangeRatesNC() -> UINavigationController {
        let chartsNC = UINavigationController(rootViewController: ChartsListTableViewController())
        chartsNC.title = Constant.ControllerTitle.charts
        return chartsNC
    }
    
    private func createSettingsVC() -> UIViewController {
        let converterNC = UINavigationController(rootViewController: SettingsViewController())
        converterNC.title = Constant.ControllerTitle.settings
        return converterNC
    }
    
    private func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .gold
        appearance.backgroundColor = .customeDarkGray
        appearance.titleTextAttributes = [.foregroundColor: UIColor.gold]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.gold]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().tintColor = .gold
    }
}
