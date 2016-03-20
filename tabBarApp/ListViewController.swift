//
//  ListViewController.swift
//  tabBarApp
//
//  Created by 上原絵里子 on 2015/12/11.
//  Copyright © 2015年 eriko.uehara. All rights reserved.
//

import UIKit
import RealmSwift

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet var tableView: UITableView!
    var timelineData:NSMutableArray = NSMutableArray()
    
    var changeNo:Int = 0
    @IBAction func chanegd(sender: AnyObject) {

        switch (sender.selectedSegmentIndex) {
        case 0:
            changeNo = 0
            break;
            
        case 1:
            changeNo = 1
            break;
            
        default:
            break;
        }
    }

    //全件検索
    var sortedSpending = try! Realm().objects(Spending).sorted("date",ascending: false)
    let sortedIncome = try! Realm().objects(Income).sorted("date",ascending: false)
    var refresh = UIRefreshControl!()
    let formatter = NSNumberFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().backgroundColor = UIColor(red: 0.702, green: 0.898, blue: 0.988, alpha: 1.0)

        self.refresh = UIRefreshControl()
        self.refresh.attributedTitle = NSAttributedString(string: "Loading…")
        self.refresh.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresh)
    }
    
    func pullToRefresh(){
        sortedSpending = try! Realm().objects(Spending).sorted("date",ascending: false)
        
        // データが取れたら更新を終える
        refresh.endRefreshing()
        // tableView自身を再読み込み
        self.tableView.reloadData()
    }
    
    //Controller読み込み時にデータを取得
    override func viewDidAppear(animated: Bool) {
        
        //データ取得
        sortedSpending = try! Realm().objects(Spending).sorted("date",ascending: false)
        //更新終了
        refresh.endRefreshing()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        //セル番号を表示する
        let c_amount = addComma(sortedSpending[indexPath.section].amount)
        cell.textLabel?.text = c_amount + String("円")
        
        cell.detailTextLabel?.text = String(sortedSpending[indexPath.section].category)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //セクションが選択されたときの処理
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        //セクション数を返す
        return sortedSpending.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        //日付をセクションタイトルにする
        return sortedSpending[section].date
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
           /*
            try! Realm().write {
                Realm.delete(cheeseBook)
            }*/
        }
    }
    
    //カンマ区切りに変換（表示用）
    func addComma(int:Int) -> String{
        let num = NSNumber(integer: int)
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        
        return formatter.stringFromNumber(num)!
    }
    //カンマ区切りを削除
    func removeComma(str:String) -> String{
        let tmp = str.stringByReplacingOccurrencesOfString(",", withString: "")
        return tmp
    }
}