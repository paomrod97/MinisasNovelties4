//
//  CalendarViewController.swift
//  MinisasNovelties
//
//  Created by Paola Rodriguez on 3/31/21.
//  Copyright © 2021 Paola Rodriguez. All rights reserved.
//

import Foundation
import UIKit
import FSCalendar

class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
//MARK: IBOutlets * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
//MARK: Variables * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

    var calendar: FSCalendar!
    var formatter = DateFormatter()
    var eventArray: [Event] = []
    
    //var datesWithMultipleEvents = ["2021-04-08", "2021-04-16", "2021-04-20", "2021-04-28"]
//MARK: View Lifecycle * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadEvents()
        //loadAdminUserInfo()
                
        calendar = FSCalendar(frame: CGRect(x: 0.0, y: 100.0, width: self.view.frame.size.width, height: 300))
        
        calendar.scrollDirection = .vertical
        calendar.scope = .month
        //calendar.scope = .week
        //calendar.locale = Locale(identifier: "")
        self.view.addSubview(calendar)
        
        calendar.dataSource = self
        calendar.delegate = self
        
        calendar.allowsMultipleSelection = true
        
        //Format to see events
        //calendar.
        
//MARK: Font & Color * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
        
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 17.0)
        calendar.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 18.0)
        calendar.appearance.weekdayFont = UIFont.boldSystemFont(ofSize: 16.0)
        
        //Header Color
        calendar.appearance.headerTitleColor = #colorLiteral(red: 0.7803921569, green: 0.1882352941, blue: 0.4509803922, alpha: 1)
        
        //Weekdays Color
        calendar.appearance.weekdayTextColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)

        //Dot Day Selected Color
        calendar.appearance.todayColor = #colorLiteral(red: 0.7803921569, green: 0.1882352941, blue: 0.4509803922, alpha: 1)
        
        //Number Day Selected Color
        calendar.appearance.titleTodayColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        // What's this??
        calendar.appearance.titleDefaultColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        //Past dates
        calendar.appearance.titlePlaceholderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        //Future dates
        calendar.appearance.titleDefaultColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       
            loadEvents()
            
        
    }

    
//MARK: - Data Source * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private func loadEvents() {
        //allEvents(<#T##completion: ([Event]) -> Void##([Event]) -> Void#>)
        downloadAllEventsFromFirebase() { (allEvents) in
            
            //print("We have \(allItems.count) items for this category")
            self.eventArray = allEvents
            self.calendar.reloadData()
//            print("Event loaded")
//            
//            for x in eventArray {
//                
//                print(eventArray.count)
//                
//            }
            //self.tableView.reloadData()
        }
    }
    
    
    
//    private func loadItems() {
//        downloadItemsFromFirebase(category!.id) { (allItems) in
//
//            //print("We have \(allItems.count) items for this category")
//            self.itemArray = allItems
//            self.tableView.reloadData()
//        }
//    }
    
//    func allEvents(_ withCategoryId: String, completion: @escaping (_ eventArray: [Item]) -> Void) {
//
//        var eventArray: [Event] = []
//
//        FirebaseReference(.Items).whereField(kCATEGORYID, isEqualTo: withCategoryId).getDocuments { (snapshot, error) in
//
//            guard let snapshot = snapshot else {
//                completion(eventArray)
//                return
//            }
//
//            if !snapshot.isEmpty {
//
//                for itemDict in snapshot.documents {
//
//                    eventArray.append(Item(_dictionary: itemDict.data() as NSDictionary))
//                }
//            }
//    //
//            completion(eventArray)
//        }
//    //
//    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {

        return Date()

    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {

        return Date().addingTimeInterval((24*60*60)*150)

    }
    
    
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {

        let dateFormatter = DateFormatter()

        formatter.dateFormat = "yyyy-MM-dd HH:mm"


        for dia in eventArray {
            if(dateFormatter.string(from: date) == dia.date) {

                return 1

            }

        }

        return 0
        
        }
//        
//    dateFormatter.locale = Locale.init(identifier: "US")
//        guard let eventDate = formatter.date(from: "29-03-2021") else {return 0}
//
//        
//        
//        if date.compare(eventDate) == .orderedSame {
//
//            return 2
//
//        }
//
//        return 0
//    }
//
////MARK: - Delegate * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
//
//    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//
//        formatter.dateFormat = "dd-MM-yyyy"
//        print("Date Selected == \(formatter.string(from: date)) ")
//
//    }
//
//    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
//
//        print("Date Selected == \(formatter.string(from: date)) ")
//
//    }
//
//    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
//
//        formatter.dateFormat = "dd-MM-yyyy"
//
//        guard let excludedDate = formatter.date(from: "30-03-2021") else {return true}
//
//        if date.compare(excludedDate) == .orderedSame {
//
//            return false
//
//        }
//
//        return true
//
//    }
//
////MARK: Calendar Delegate Appearance * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
//
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
//
//        formatter.dateFormat = "dd-MM-yyyy"
//
//        guard let excludedDate = formatter.date(from: "30-03-2021") else {return nil}
//
//        if date.compare(excludedDate) == .orderedSame {
//
//            return .red
//
//        }
//
//        return nil
//    }
//
//    private func loadAdminUserInfo() {
//
//
//
//        if MUser.currentUser() != nil {
//
//            let currentUser = MUser.currentUser()!
//
//            print(currentUser.isAdmin)
//
//            if currentUser.isAdmin == true {
//
//
//                print("CUENTA DE ADMINISTRADOR")
//
//            } else {
//
//
//
//                print("CUENTA DE USUARIO")
//            }
//
//            //print(currentUser.isAdmin)
//        }
//    }
    
}
