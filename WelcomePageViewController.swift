//
//  WelcomePageViewController.swift
//  moveMingo3
//
//  Created by Sarah MacAdam on 1/7/17.
//  Copyright © 2017 Sarah MacAdam. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class WelcomePageViewController: UIPageViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self

        // show the sign in pages
        print ("display sign in options")
        if let firstViewController = orderedViewControllers.first {
                setViewControllers([firstViewController],
                    direction: .forward,
                    animated: true,
                    completion: nil)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // super.viewDidAppear()
        
        // if the user is already logged in redirect them to the home page
        if FBSDKAccessToken.current() != nil {
            print("user is already logged in")
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let homeViewController = storyBoard.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
            
            self.present(homeViewController, animated: true, completion: nil)
            return
            
        }
    }
    
}

// MARK: UIPageViewControllerDataSource

extension WelcomePageViewController: UIPageViewControllerDataSource {
    
    
    func pageViewController(_ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
                return nil
            }
            
            let previousIndex = viewControllerIndex - 1
            
            guard previousIndex >= 0 else {
                return nil
            }
            
            guard orderedViewControllers.count > previousIndex else {
                return nil
            }
            
            return orderedViewControllers[previousIndex]
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
                return nil
            }
            
            let nextIndex = viewControllerIndex + 1
            let orderedViewControllersCount = orderedViewControllers.count
            
            guard orderedViewControllersCount != nextIndex else {
                return nil
            }
            
            guard orderedViewControllersCount > nextIndex else {
                return nil
            }
            
            return orderedViewControllers[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = orderedViewControllers.index(of: firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }
    
}

private(set) var orderedViewControllers: [UIViewController] = {
    return [newLoginViewController("Welcome"),
        newLoginViewController("SignIn"),
        newLoginViewController("SignUp")]
}()

private func newLoginViewController(_ signin: String) -> UIViewController {
    return UIStoryboard(name: "Main", bundle: nil) .
        instantiateViewController(withIdentifier: "\(signin)ViewController")
}




