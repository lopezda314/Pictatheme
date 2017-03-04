//
//  ViewController.swift
//  poopyApp
//
//  Created by David Caceres on 1/20/17.
//  Copyright © 2017 David Lopez. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase


class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    var myFriends : NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Facebook Button UI
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x:16, y:150, width: view.frame.width - 32, height:50)
        loginButton.delegate = self
        loginButton.readPermissions = ["public_profile", "user_friends"]
        
        
        // appDelegate connection ex.
        //  let appDelegate = UIApplication.shared.delegate as! AppDelegate
    }


    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logged Out")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil{
            print(error)
            return
        }
        //Facebook and Firebase access
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else
        {return}
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil{
                print("Something went wrong with user:", error ?? "")
                return
            }
            print("Successfully logged in with user", user ?? "")
            //find way to implement this at some point
            //UserDefaults.standard.setValue(accessTokenString, forKey: "fbAccessToken")
        })
        print("Successfully logged in with Facebook")
        requestFriends()
    }
    
    //prepare(for...) segues give me control of which date i want to send to which view controllers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loggedIn"{
            if let destination = segue.destination as? HomeScreenViewController {
                destination.myFriends = self.myFriends
            }
    }
    
    }

    
//get friends, switch to list of friends
func requestFriends(){
    let params = ["fields": "friends"]
    //get FB friends info, store result
    let graphRequest = FBSDKGraphRequest(graphPath: "/me", parameters: params)
    graphRequest?.start(completionHandler: { [weak self] connection, result, error in
        if error != nil {
            print(error ?? "")
            return
        }
        else{
            let info = result as! NSDictionary
            self?.myFriends = info
            self?.performSegue(withIdentifier: "loggedIn", sender: self)
        }
        }
    )
}
}
