//
//  FuelCalculator.swift
//  Geofencing
//
//  Created by Aakash on 15/02/18.
//  Copyright © 2018 Aakash. All rights reserved.
//

import UIKit
import Foundation
import CoreData


class FuelCalculator: UIViewController, UITextFieldDelegate {
    


    @IBOutlet weak var ScrollView: UIScrollView!


    @IBOutlet weak var TextField1: UITextField!

    @IBOutlet weak var TextField2: UITextField!
 

    @IBOutlet weak var TextField3: UITextField!

    @IBOutlet weak var Label1: UILabel!

    @IBOutlet weak var Label2: UILabel!

    @IBOutlet weak var DatePicker: UITextField!
   
    
    @IBAction func Button1(_ sender: Any) {
        Label1.isHidden = false
        let firstvalue = Double(TextField2.text!)
        let secondvalue = Double(TextField3.text!)
        if firstvalue != nil && secondvalue != nil {
            
            let travel = Double(firstvalue! * secondvalue!)
            Label1.text = "\(travel)"
        } else {
            Label1.text = "Enter a number."
        }
    }
  
    @IBAction func Button2(_ sender: Any) {
        Label2.isHidden = false
        let firstvalue = Double(TextField2.text!)
        //let secondvalue = Double(TextField3.text!)
        let thirdvalue = Double(TextField1.text!)
        if firstvalue != nil  && thirdvalue != nil{
            
            let trave2 = Double(firstvalue! * thirdvalue!)
            Label2.text = "\(trave2)"
        } else {
            Label2.text = "Enter a number."
        }

    }
    
    
    
    @IBAction func Save(_ sender: Any) {
        
        //1 - Validate your data
        //2 - get the values from the screens
           textfield1   =   TextField1.text
           textfield2   =   TextField2.text
           textfield3   =   TextField3.text
           totalamount  =   Label1.text
           distancetogo =   Label2.text
            date        =   DatePicker.text
        
        //3 - get refrence to the manage contacts 
        //4 - get the disription of entity
        //5 - create a manage object using the description above
        //6 - update the attributes in the entity
        //7 - save object  
        
        if saveNew() == true
        {
            let alert = UIAlertView(title :"Success" , message : "Record is saved", delegate : self, cancelButtonTitle : "OK" )
            alert.show()
        } else{
            let alert = UIAlertView(title :"Error" , message : "Record is not saved", delegate : self, cancelButtonTitle : "OK" )
            alert.show()
            
        }
    }
    
    // 1 - Define attributes
    
    var  textfield1     :   String!
    var  textfield2     :   String!
    var  textfield3     :   String!
    var  totalamount    :   String!
    var  distancetogo   :   String!
    var  date           :   String!
    // 2 - Define Core Data elements
    
    var  contacts   :  [NSManagedObject] = []
    var  contact    :  NSManagedObject!
    
    
    // The Managed Object Context retrieved from the app delegate
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

let  datepicker = UIDatePicker()

    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        if contact  != nil
        {
         getData()
        }
        
        Label1.isHidden = true
        Label2.isHidden = true
        
        //Looks for single or multiple taps.
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FuelCalculator.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not  interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        
        
        self.TextField1.delegate = self
        self.TextField2.delegate = self
        self.TextField3.delegate = self
        createDatePicker()
        // Do any additional setup after loading the view.
    }
    func createDatePicker() {
        
        //format for picker
        
        datepicker.datePickerMode = .date
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //Creating DONE BUTTON
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed)) //action we have to assign the DONE button
        toolbar.setItems([doneButton], animated: false) //ITEMS is an collection of array of UI bar button items
        
        DatePicker.inputAccessoryView = toolbar // ADD toolbar datepicker textfield
        
        //assigning date picker to textfield
        
        DatePicker.inputView = datepicker
        
        
    }
    func donePressed() {
        
        //format date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        DatePicker.text = dateFormatter.string(from: datepicker.date)
        
        self.view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /***********************************************************************
     *
     * This function save a new record to the databasea and returns
     * true if the record is saved and false if not.
     *
     **********************************************************************/
    
    func saveNew() -> Bool {
        
        if contact == nil {
        
            let entity = NSEntityDescription.entity(forEntityName: "ContactsEntity", in: managedContext)!
        
        contact = NSManagedObject(entity: entity, insertInto: managedContext)
        }
        
        self.putData()  // this function update the fields or update the record
        // Save Context
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
            
        }
    }
    /***********************************************************************
     *
     * This function update a mamange object with values from variables
     *
     **********************************************************************/
    
    func putData()
    {
        
       // let img = UIImage(named: "logo.jpeg")
        //image = UIImageJPEGRepresentation(img!, 1)
        contact.setValue(textfield1, forKeyPath: "textfield1")
        contact.setValue(textfield2, forKeyPath: "textfield2")
        contact.setValue(textfield3, forKeyPath: "textfield3")
        contact.setValue(distancetogo, forKeyPath: "distancetogo")
        contact.setValue(totalamount, forKeyPath: "totalamount")
        contact.setValue(date, forKeyPath: "date")
    }
    
    func getData()
    {
        
        
        textfield1   =   contact.value(forKeyPath: "textfield1") as! String
        textfield2   =   contact.value(forKeyPath: "textfield2") as! String
        textfield3   =   contact.value(forKeyPath: "textfield3") as! String
        totalamount  =   contact.value(forKeyPath: "totalamount") as! String
        distancetogo =   contact.value(forKeyPath: "distancetogo") as! String
        date         =   contact.value(forKeyPath: "date") as! String
        
        
        TextField1.text = textfield1
        TextField2.text = textfield2
        TextField3.text = textfield3
        Label1.text     = totalamount
        Label2.text     = distancetogo
        DatePicker.text = date
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       // UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeLeft
    }
  

}
