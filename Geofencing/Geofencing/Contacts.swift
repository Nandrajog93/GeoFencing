//
//  Contacts.swift
//  Geofencing
//
//  Created by Aakash on 16/02/18.
//  Copyright © 2018 Aakash. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class Contacts: UITableViewController {  // 2 - Define Core Data elements
    
    var  contacts   :  [NSManagedObject] = []
    var  contact    :  NSManagedObject!
    
    
    // The Managed Object Context retrieved from the app delegate
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveContext () {
        let context =  managedContext
        if context.hasChanges {
            do {
                try context.save()
                
            } catch{
                let nserror = error as NSError
                fatalError("usersolved error \(nserror),\(nserror.userInfo)")
            }
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {  //  this executed after ViewDidLoad //updating of screen
        self.gettAllRecords()  // fetch the request against database and reload the data
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
        return contacts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        
        
        // Configure the cell...
        contact = contacts[indexPath.row]
        
        let   textfield1   =   contact.value(forKeyPath: "textfield1") as! String
        let   textfield2   =   contact.value(forKeyPath: "textfield2") as! String
        let   textfield3     =   contact.value(forKeyPath: "textfield3") as! String
        let    date           =   contact.value(forKeyPath: "date") as! String
        

        cell.textLabel?.text = "\(date)"
        return cell
    }
    
    /***********************************************************************
     *
     * This function gets all records from the database and returns
     * an array of ManagedObject
     *
     **********************************************************************/
    
    // Del records creating a func (editing style)
    
   
    
      override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if editingStyle == .delete {
            
            let user = contacts[indexPath.row]
            context.delete(user)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
                contacts = try context.fetch(ContactsEntity.fetchRequest())
            }
            catch{
                print(error)
            }
            tableView.reloadData()
        }
    }
    
    
    
    
    
    
    func gettAllRecords()
    {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ContactsEntity")  //create request
        
        do {
            contacts  = try managedContext.fetch(fetchRequest)  //fetching request
            
            
           /* for contact in contacts
            {
                // Do something with the data
            } */
            
            self.tableView.reloadData()   // this will reload the data
            
        } catch let error as NSError {
            
            print("Could not fetch. \(error), \(error.userInfo)")
            
        }
        
    
    
        
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


     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        
        // 1 identify which segue you clicked on 
        
        if segue.identifier == "edit"
        {
            //2 - get the cell that was selected
            
            let indexpath = tableView.indexPathForSelectedRow
            
            //3 - get the object from array and pass it to view controller
                let vc = segue.destination as! FuelCalculator
            
            //4 - assign the contact attribute to the selected object
            
            let contact = contacts[(indexpath?.row)!]
            
            vc.contact = contact
        
        }
        
     }

    
    /*********************************************************************
     *
     * This function Display Action Controller to get a contact name
     *
     *********************************************************************/
}
