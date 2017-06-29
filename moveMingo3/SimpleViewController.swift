//
//  SimpleViewController.swift
//  moveMingo3
//
//  Created by Sarah MacAdam on 6/13/17.
//  Copyright © 2017 Sarah MacAdam. All rights reserved.
//

import UIKit

class SimpleViewController: UIViewController {

    @IBOutlet weak var movieImage: UIImageView!
    
    var imageName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.movieImage.image = UIImage(named: imageName)
        self.title = imageName
    }
    
    func customInit(imageName: String) {
        self.imageName = imageName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
