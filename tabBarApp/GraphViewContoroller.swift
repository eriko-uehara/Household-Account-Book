//
//  GraphViewContoroller.swift
//  tabBarApp
//
//  Created by 上原絵里子 on 2016/02/10.
//  Copyright © 2016年 eriko.uehara. All rights reserved.
//

import UIKit
import RealmSwift

class GraphViewContoroller: UIViewController,UITableViewDelegate,UITableViewDataSource{
    var graphView:PieGraphView!
    let realm = try! Realm()
    
    @IBOutlet weak var sumAmount: UILabel!
    @IBOutlet weak var sumIncome: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var objects = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        objects = ["1","2","3"]
        start()
    }
/*
    //画面が表示された直後
    override func viewDidAppear(animated: Bool) {
        

    }
*/    
    //画面が消えた直後
/*    override func viewDidDisappear(animated: Bool) {
        
        var params = [Dictionary<String,AnyObject>]()
        params.append(["value":1,"color":UIColor.whiteColor()])
        graphView = PieGraphView(frame: CGRectMake(0, 30, 320, 320), params: params)
        self.view.addSubview(graphView)
        graphView.startAnimating()
    }

    
    override func viewWillDisappear(animated: Bool) {
        var params = [Dictionary<String,AnyObject>]()
        params.append(["value":1,"color":UIColor.whiteColor()])
        graphView = PieGraphView(frame: CGRectMake(0, 30, 320, 320), params: params)
        self.view.addSubview(graphView)
        graphView.startAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
*/
    //カンマ区切りに変換（表示用）
    func addComma(int:Int) -> String{
        let num = NSNumber(integer: int)
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        
        return formatter.stringFromNumber(num)!
    }
    
    func start(){
        //収入の合計金額取得
        let AllIncome: Int = realm.objects(Income).sum("amount")
        //表示用
        let SumIncome = addComma(AllIncome)
        sumIncome.text = SumIncome + "円"
        
        //支出の合計金額取得(計算用)
        let AllAmount: Double = realm.objects(Spending).sum("amount")
        //表示用
        let SumAmount = addComma(Int(AllAmount))
        sumAmount.text = SumAmount + "円"
        print(String(AllAmount))
        
        //食費の合計金額取得
        let Food: Double = realm.objects(Spending).filter("category = '食費'").sum("amount")
        //交通の合計金額取得
        let Transportation: Double = realm.objects(Spending).filter("category = '交通'").sum("amount")
        //趣味の合計金額取得
        let Hobby: Double = realm.objects(Spending).filter("category = '趣味'").sum("amount")
        //通信費の合計金額取得
        let Communications: Double = realm.objects(Spending).filter("category = '通信'").sum("amount")
        //衣服の合計金額取得
        let Clothes: Double = realm.objects(Spending).filter("category = '美容・衣服'").sum("amount")
        //交際費の合計金額取得
        let Entertainment: Double = realm.objects(Spending).filter("category = '交際費'").sum("amount")
        //日用品の合計金額取得
        let Livingware: Double = realm.objects(Spending).filter("category = '日用雑貨'").sum("amount")
        //住居費の合計金額取得
        let Housing: Double = realm.objects(Spending).filter("category = '住居'").sum("amount")
        //光熱費の合計金額取得
        let Utility: Double = realm.objects(Spending).filter("category = '水道・光熱'").sum("amount")
        
        let FoodPer: Double
        let TransPer: Double
        let HobbyPer: Double
        let CommuPer: Double
        let ClothesPer: Double
        let EnterPer: Double
        let LivingPer: Double
        let HousingPer: Double
        let UtilPer: Double
        
        //合計金額が0なら全てのパーセントテージを0
        if(AllAmount == 0) {
            //食費のパーセンテージ
            FoodPer = 0
            //交通費のパーセンテージ
            TransPer = 0
            //趣味のパーセンテージ
            HobbyPer = 0
            //通信費のパーセンテージ
            CommuPer = 0
            //衣服のパーセンテージ
            ClothesPer = 0
            //交際費のパーセンテージ
            EnterPer = 0
            //日用品のパーセンテージ
            LivingPer = 0
            //住居費のパーセンテージ
            HousingPer = 0
            //光熱費のパーセンテージ
            UtilPer = 0
        } else {
            //食費のパーセンテージ
            FoodPer = (Food / AllAmount) * 100
            print(FoodPer)
            //交通費のパーセンテージ
            TransPer = (Transportation / AllAmount) * 100
            //趣味のパーセンテージ
            HobbyPer = (Hobby / AllAmount) * 100
            //通信費のパーセンテージ
            CommuPer = (Communications / AllAmount) * 100
            //衣服のパーセンテージ
            ClothesPer = (Clothes / AllAmount) * 100
            //交際費のパーセンテージ
            EnterPer = (Entertainment / AllAmount) * 100
            //日用品のパーセンテージ
            LivingPer = (Livingware / AllAmount) * 100
            //住居費のパーセンテージ
            HousingPer = (Housing / AllAmount) * 100
            //光熱費のパーセンテージ
            UtilPer = (Utility / AllAmount) * 100
        }
        
        var params = [Dictionary<String,AnyObject>]()
        params.append(["value":FoodPer,"color":UIColor.redColor()])
        params.append(["value":TransPer,"color":UIColor.blueColor()])
        params.append(["value":HobbyPer,"color":UIColor.greenColor()])
        params.append(["value":CommuPer,"color":UIColor.yellowColor()])
        params.append(["value":ClothesPer,"color":UIColor.cyanColor()])
        params.append(["value":EnterPer,"color":UIColor.brownColor()])
        params.append(["value":LivingPer,"color":UIColor.magentaColor()])
        params.append(["value":HousingPer,"color":UIColor.orangeColor()])
        params.append(["value":UtilPer,"color":UIColor.purpleColor()])
        graphView = PieGraphView(frame: CGRectMake(0, 30, 320, 320), params: params)
        self.view.addSubview(graphView)
        
        graphView.startAnimating()
    }
/*
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objects.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        //セクション数を返す
        return 9
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = self.objects[indexPath.row]
        //Cell.showButton?.tag = indexPath.row
        //Cell.showButton?.addTarget(self,action : "logAction",forControlEvents:.TouchUpInside)
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
*/
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        print(objects)
        //セル番号を表示する
        cell.textLabel?.text = objects[indexPath.row]
        
        //cell.detailTextLabel?.text = String(sortedSpending[indexPath.section].category)
        //
        cell.detailTextLabel?.text = objects[indexPath.row]
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        //セクション数を返す
        return 2
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        //日付をセクションタイトルにする
        return "支出"
    }
}