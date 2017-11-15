//
//  RewardsViewController.swift
//  moveMingo3
//
//  Created by Sarah MacAdam on 7/26/17.
//  Copyright © 2017 Sarah MacAdam. All rights reserved.
//

import UIKit

class RewardsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, StoreModelProtocal {
    
    @IBOutlet weak var colorStrip: UIImageView!
    @IBOutlet weak var tableTitle: UILabel!
    @IBOutlet weak var storeToggle: UIButton!
    @IBOutlet weak var rewardTable: UITableView!
    
    var feedItems: NSArray = NSArray()
    var selectedLocation : RewardModel = RewardModel()
    var selectedReward: RewardModel!
    var selectedRewardCost: String!
    var storeOpen: Bool!
    var viewStore: Bool!
    
    let URL_GET_STORE:String = "http://apps.healthyinthehills.com/manage_store.php"

    
    
    override func viewDidLoad() {

        
        super.viewDidLoad()
        //set delegates and initialize homeModel
        
        self.rewardTable.delegate = self
        self.rewardTable.dataSource = self
        
        let storeModel = StoreModel()
        storeModel.delegate = self
        storeModel.downloadItems(select_type: "view_user_rewards")
        viewStore = false
        storeToggle.addTarget(self, action:#selector(changeView), for: .touchUpInside)
        
        // load the table
        DispatchQueue.main.async {
            self.rewardTable.reloadData()
            return
        }
    }
    
    
    
    func itemsDownloaded(_ items: NSArray) {
        
        feedItems = items
        
        self.rewardTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of feed items
        print("size of rewards list")
        print(feedItems.count)
        return feedItems.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if(viewStore) {
            // use the store header
            let header = StoreHeaderFooterView()
            let reward = feedItems[section] as! RewardModel
            header.customInit(reward: reward, section: section)
            // add the redeem button
            let redeemButton = UIButton(frame: CGRect(x: 165, y: 25, width: 75, height: 25))
            redeemButton.setTitle("Select", for: [])
            redeemButton.setTitleColor(.white, for: .normal)
            redeemButton.backgroundColor = #colorLiteral(red: 0.4145818852, green: 0.8846340674, blue: 0.8758338858, alpha: 1)
            redeemButton.tag = Int(reward.reward_id!)
            redeemButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
            redeemButton.layer.cornerRadius = 5
            redeemButton.layer.borderWidth = 1
            redeemButton.layer.borderColor = UIColor.white.cgColor
            redeemButton.addTarget(self, action: #selector(makePurchase), for: .touchUpInside)
            
            
            header.addSubview(redeemButton)
            
            return header
        }
        // default use the reward header view
        let header = RewardHeaderView()
        header.customInit(reward: (feedItems[section] as! RewardModel), section: section)
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    
    @objc func changeView(sender:UIButton) {
        // toggle the view store boolean
        
        viewStore = !viewStore
        
        let storeModel = StoreModel()
        storeModel.delegate = self

        if (viewStore){
            // set it to show the store
            storeModel.downloadItems(select_type: "view_all")
            storeToggle.setTitle("View My Rewards", for: .normal)
            tableTitle.text = "Wellness Shop"
            self.colorStrip.image = UIImage(named: "tealStrip")
            
        } else {
            // show their rewards
            storeModel.downloadItems(select_type: "view_user_rewards")
            storeToggle.setTitle("View Store", for: .normal)
            tableTitle.text = "My Rewards"
            self.colorStrip.image = UIImage(named: "brownStrip")
        }
        // load the table
        DispatchQueue.main.async {
            self.feedItems = NSArray()
            self.rewardTable.reloadData()
            return
        }
    
    }
    
    
    // make a new record
    @objc func makePurchase(sender:UIButton){
        
        // add the interested action to the cell
        let alert = UIAlertController(title: "My Purchase", message: "Would you like to redeem your points for this item?", preferredStyle: .actionSheet)
        
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default) { action in
            // create a new record
            print("the user is purchasing something")
            print(sender.tag)
            //created NSURL
            let requestURL:NSURL = NSURL(string: self.URL_GET_STORE)!
            
            
            //creating NSMutableURLRequest
            let request = NSMutableURLRequest(url: requestURL as URL)
            
            //setting the method to post
            request.httpMethod = "POST"
            print("the current user is")
            print(current_user_id)
            
            //getting values for insert
            
            let user_id = "\(current_user_id)"
            let reward_id = "\(sender.tag)"
            
            //creating the post parameter by concatenating the keys and values from text field
            let postParameters = "action=purchase&user_id="+user_id+"&reward_id="+reward_id;
            print(postParameters)
            
            //adding the parameters to request body
            request.httpBody = postParameters.data(using: .utf8)!
            
            //creating a task to send the post request
            let task = URLSession.shared.dataTask(with: request as URLRequest){
                (data, response, error) in
                
                if error != nil{
                    print("error is \(String(describing: error))")
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
                        //printing the response
                        print(msg)
                        print(err)
                        
                    }
                } catch {
                    print(error)
                }
            }
            
            task.resume()
            
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { action in
            // do nothing
        })
        
        self.present(alert, animated: true)
        
        
        return
        
    }
    
    
    

}
