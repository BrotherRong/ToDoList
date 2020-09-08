//
//  UserDate.swift
//  ToDoList
//
//  Created by 荣翔 on 2020/9/8.
//  Copyright © 2020 荣翔. All rights reserved.
//


import Foundation
import UserNotifications

var encoder = JSONEncoder()
var decoder = JSONDecoder()

let NotificationContent = UNMutableNotificationContent()

class ToDo :ObservableObject{
    @Published var ToDoList:[SingleTodo]
    var count = 0
    
    init() {
        self.ToDoList = []
    }
    
    init(data : [SingleTodo]) {
        self.ToDoList = []
        
        for item in  data{
            self.ToDoList.append(SingleTodo(title: item.title,dueDate: item.dueDate,isChecked: item.isChecked, isFavorite: item.isFavorite, id:self.count))
            count += 1
        }
    }
    
    
    func check(id :Int) {
        self.ToDoList[id].isChecked.toggle()
        self.dataStore()

    }
    
    func add(data:SingleTodo) {
        self.ToDoList.append(SingleTodo(title: data.title,dueDate: data.dueDate, isFavorite: data.isFavorite, id:self.count))
        self.count += 1
        self.sort()
        self.dataStore()
        self.sendNotification(id: self.ToDoList.count - 1)
    }
    
    func edit(id : Int ,data : SingleTodo) {
        self.withdrawNotification(id: id)
        self.ToDoList[id].title = data.title
        self.ToDoList[id].dueDate = data.dueDate
        self.ToDoList[id].isChecked = false
        self.ToDoList[id].isFavorite = data.isFavorite
        self.sort()
        self.dataStore()
        self.sendNotification(id: id)

    }
    
    func sendNotification
        (id: Int) {
        NotificationContent.title = self.ToDoList[id].title
        NotificationContent.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: self.ToDoList[id].dueDate.timeIntervalSinceNow, repeats: false)
        
        let request = UNNotificationRequest(identifier: self.ToDoList[id].title+self.ToDoList[id].dueDate.description, content: NotificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func withdrawNotification(id:Int) {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [self.ToDoList[id].title+self.ToDoList[id].dueDate.description])
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [self.ToDoList[id].title+self.ToDoList[id].dueDate.description])
    }
    
    func delete(id : Int) {
        self.withdrawNotification(id: id)
        self.ToDoList[id].deleted = true
        self.sort()
        self.dataStore()
    }
    
    
    func  sort(){
        self.ToDoList.sort(by: {(data1,data2) in
            return data1.dueDate.timeIntervalSince1970 < data2.dueDate.timeIntervalSince1970
        })
        
        for i in 0 ..< self.ToDoList.count {
            self.ToDoList[i].id = i
        }
    }
    
    
    func dataStore()  {
        let dataStored = try! encoder.encode(self.ToDoList)
        UserDefaults.standard.set(dataStored, forKey: "ToDoList")
    }

}

struct SingleTodo : Identifiable ,Codable{
    var title : String = ""
    var dueDate : Date = Date()
    var isChecked : Bool = false
    var isFavorite :Bool = false
    var deleted : Bool = false
    var id : Int = 0
}

