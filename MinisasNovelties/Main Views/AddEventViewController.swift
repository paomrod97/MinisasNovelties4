//
//  AddEventViewController.swift
//  MinisasNovelties
//
//  Created by Paola Rodriguez on 4/25/21.
//

import UIKit

//MARK: - IBOutlets
class AddEventViewController: UIViewController {

    
    @IBOutlet weak var eventTitle: UITextField!
    
    @IBOutlet weak var eventDatePicker: UIDatePicker!
    
    @IBOutlet weak var eventDescription: UITextView!
     
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func addEventBtn(_ sender: Any) {
        
        //print (self.eventDatePicker.date.dateStringWith(strFormat: "dd/MM/yyyy"))
        
        let event = Event()
        
        event.eventId = UUID().uuidString
        event.title = eventTitle.text
        event.description = eventDescription.text
        event.date = self.eventDatePicker.date.dateStringWith(strFormat: "yyyy-MM-dd HH:mm")
        
        saveEventToFirestore(event)
        
    }
}

//MARK: - Extension * * * * * * * * * * * * * * * * * * * 

extension Date {
    
 func dateStringWith(strFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        dateFormatter.dateFormat = strFormat
        return dateFormatter.string(from: self)
    
    }
    
}
