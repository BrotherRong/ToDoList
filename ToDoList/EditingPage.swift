//
//  EditingPage.swift
//  ToDoList
//
//  Created by 荣翔 on 2020/9/8.
//  Copyright © 2020 荣翔. All rights reserved.
//

import SwiftUI

struct EditingPage: View {
    
    @EnvironmentObject var UserData :ToDo
    
    @State var title : String = ""
    @State var dueDate : Date = Date()
    @State var isFavorite : Bool = false

    
    
    var id : Int? = nil
    
    @Environment(\.presentationMode) var  presentation
    
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("事项")){
                    TextField("事项内容", text:self.$title )
                                   DatePicker(selection: self.$dueDate, label: { Text("截止日期") })
                }
                
                Section{
                    Toggle(isOn: self.$isFavorite){
                        Text("收藏")
                    }
                }
                
                Section{
                    Button(action: {
                        if self.id == nil {
                          self.UserData.add(data: SingleTodo(title:self.title,dueDate:self.dueDate,isFavorite: self.isFavorite))
                        }else {
                            self.UserData.edit(id:self.id!,data: SingleTodo(title:self.title,dueDate:self.dueDate,isFavorite: self.isFavorite))
                        }
                        
                        self.presentation.wrappedValue.dismiss()
                    })
                    {
                        Text("确认")

                    }
                    
                    Button(action:{
                        self.presentation.wrappedValue.dismiss()
                    }){
                        Text("取消")

                    }

                }
               

            }.navigationBarTitle("添加")
        }
    }
}

struct EditingPage_Previews: PreviewProvider {
    static var previews: some View {
        EditingPage()
    }
}
