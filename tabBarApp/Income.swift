//
//  income.swift
//  tabBarApp
//
//  Created by 上原絵里子 on 2016/01/12.
//  Copyright © 2016年 eriko.uehara. All rights reserved.
//

import Foundation
import RealmSwift

class Income: Object {
    
    //カラム定義
    dynamic var id: Int = 0
    dynamic var amount: Int = 0
    dynamic var category: String = ""
    dynamic var date: String = ""
    
    //primary key設定
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func create() -> Income {
        let income = Income()
        income.id = lastId()
        return income
    }
    
    //auto increment
    static func lastId() -> Int {
        
        do {
            let realm = try Realm()
            if let income = realm.objects(Income).last {
                return income.id + 1
            } else {
                return 1
            }
        } catch {
            print(error)
        }
        return 1
    }
}