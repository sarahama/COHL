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
    
    
    //URL to our web service
    let URL_CREATE_USER:String = "http://apps.healthyinthehills.com/create_new_user.php"
    
    var fb_name: String!
    var fb_id: String!
    
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
        // and set the current user id
        if FBSDKAccessToken.current() != nil {
            print("user is already logged in")
            // should properly set the current user id
            createNewUser()
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let homeViewController = storyBoard.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
            
            self.present(homeViewController, animated: true, completion: nil)
            return
            
        }
    }
    
    /***
     Makes a post to the php service to create a new
     user if the access token has not already been taken
     ***/
    func createNewUser() -> Bool {
        print("attempting to create new user...")
        //created NSURL
        let requestURL:NSURL = NSURL(string: URL_CREATE_USER)!
        
        
        //creating NSMutableURLRequest
        let request = NSMutableURLRequest(url: requestURL as URL)
        
        //setting the method to post
        request.httpMethod = "POST"
        
        //getting values from text fields
        getFaceBookName(completion: {(result)->Void in
            print(result)
            print(self.fb_name, self.fb_id)
            
            
            print("information has been retrieved")
            let first_name = self.fb_name
            let id = self.fb_id
            
            
            //creating the post parameter by concatenating the keys and values from text field
            let postParameters = "first_name="+first_name!+"&fb_id="+id!;
            print(postParameters)
            
            //adding the parameters to request body
            request.httpBody = postParameters.data(using: .utf8)!
            
            //creating a task to send the post request
            let task = URLSession.shared.dataTask(with: request as URLRequest){
                (data, response, error) in
                
                if error != nil{
                    print("error is \(error)")
                    return;
                }
                print(data!)
                print("parsing response...")
                //parsing the response
                do {
                    //converting resonse to NSDictionary
                    
                    let myJSON =  try JSONSerialization.jsonObject(with: data!, options: .  mutableContainers) as? NSDictionary
                    
                    //parsing the json
                    if let parseJSON = myJSON {
                        
                        //creating a string
                        var msg : String!
                        var err : String!
                        
                        //getting the json response
                        msg = parseJSON["message"] as! String?
                        err = parseJSON["error"] as! String?
                        current_user_id = (parseJSON["user_id"] as! Int?)!
                        //printing the response
                        print(msg)
                        print(err)
                        print(current_user_id)
                        
                    }
                } catch {
                    print(error)
                }
                
            }
            
            task.resume()
        })
        return true
    }
    
    
    
    /***
     Retrieves a user's name
     ***/
    func getFaceBookName(completion:@escaping (_ result:String)->Void) {
        print("retrieve facebook data")
        if(FBSDKAccessToken.current() != nil)
        {
            //print permissions, such as public_profile
            print(FBSDKAccessToken.current().permissions)
            let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "name, id, email"])
            let connection = FBSDKGraphRequestConnection()
            
            connection.add(graphRequest, completionHandler: { (connection, result, error) -> Void in
                
                let fb_data = result as! [String : AnyObject]
                
                self.fb_name = (fb_data["name"] as? String)!
                self.fb_id = (fb_data["id"] as? String)!
                completion("done")
            })
            print("begin connection")
            connection.start()
            print("completed")
        }
        return
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




