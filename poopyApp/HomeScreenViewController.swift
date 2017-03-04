//
//  HomeScreenViewController.swift
//  poopyApp
//
//  Created by David Caceres on 3/2/17.
//  Copyright © 2017 David Lopez. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class HomeScreenViewController: UITableViewController {
    var user: FIRUser!
    var myFriends : NSDictionary?
    var ref: FIRDatabaseReference!
    var gamesList = [String]()
    private var databaseHandle: FIRDatabaseHandle!

    override func viewDidLoad() {
        super.viewDidLoad()
        user = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference()
        observeDatabase()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gamesList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "game", for: indexPath)
        let game = gamesList[indexPath.row]
        cell.textLabel?.text = game
        return cell
    }
    
    //get friends, switch to list of friends
    @IBAction func friendsList(_ sender: UIButton) {
        self.performSegue(withIdentifier: "friendsList", sender: self)
    }
    
    //prepare(for...) segues give me control of which date i want to send to which view controllers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "friendsList"{
            if let destination = segue.destination as? InviteFriendsViewController {
                destination.myFriends = self.myFriends
            }
        }
        
    }
    
    func getQuery() -> FIRDatabaseQuery {
        return self.ref
    }
    
    func observeDatabase() {
        databaseHandle = ref.child("Users/\(self.user.uid)/Games").observe(.value, with:{ (snapshot) in
            var listOfGames = [String]()
            for gameSnapShot in snapshot.children{
                let game = (snapshot: gameSnapShot as! FIRDataSnapshot)
                listOfGames.append(game.value as! String)
            }
            self.gamesList = listOfGames
            self.tableView.reloadData()
        }
            )
        
    }
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
