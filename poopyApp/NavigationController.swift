//
//  NavigationController.Swift
//  poopyApp
//
//  Created by David Caceres on 4/14/17.
//  Copyright © 2017 David Lopez. All rights reserved.
//

import Foundation
import UIKit

class NavigationController: UINavigationController{
    var myFriends : NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.performSegue(withIdentifier: "friendsList", sender: self)
    }
    //prepare(for...) segues give me control of which date i want to send to which view controllers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "friendsList"{
            if let destination = segue.destination as? HomeScreenViewController{
                destination.myFriends = self.myFriends
            }
        }
    }
}
