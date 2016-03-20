//
//  EditViewController.swift
//  tabBarApp
//
//  Created by 上原絵里子 on 2015/12/11.
//  Copyright © 2015年 eriko.uehara. All rights reserved.
//

import UIKit
import RealmSwift

//ピッカーに表示されるアイテム
let picker1Items = ["食費", "交通", "趣味", "通信", "美容・衣服", "交際費", "日用雑貨", "住居", "水道・光熱","給料", "お小遣い", "賞与", "立替金返済", "臨時収入"]

class EditViewController: UIViewController {
    
    @IBOutlet weak var keima: UILabel!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var categoryText: UITextField!
    @IBOutlet weak var dateText: UITextField!
    var toolBar:UIToolbar!
    var datePicker:UIDatePicker!
    var firstPicker: UIPickerView!
    var firstPickerDelegate:FirstPickerDelegate!
    var changeNo:Int = 0
    let formatter = NSNumberFormatter()

    @IBAction func editChanged(sender: UITextField) {
        sender.text = addComma(sender.text!)
    }
    
    //支出、収入切り替え
    @IBAction func chanegd(sender: UISegmentedControl) {
        
        switch (sender.selectedSegmentIndex) {
        case 0:
            self.keima.text = "支出"
            changeNo = 0
            break;
            
        case 1:
            self.keima.text = "収入"
            changeNo = 1
            break;
            
        default:
            break;
        }
    }
    
    //登録処理
    @IBAction func add(sender: AnyObject) {
        
        switch (changeNo) {
        //支出登録
        case 0:
            let spend = Spending.create()

            if(amount != nil){
                let i_amount = Int(removeComma(amount.text!))!
                //金額を文字列から数値に変換
                spend.amount = i_amount
                spend.category = categoryText.text!
                spend.date = dateText.text!
                
                do {
                    let realm = try Realm()
                
                    //DBに追加
                    try realm.write{ realm.add(spend) }
                
                    //アラート表示
                    let alertController = UIAlertController(title: "入力完了", message: "支出の入力が完了しました", preferredStyle: .ActionSheet)
                
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alertController.addAction(defaultAction)
                
                    alertController.popoverPresentationController?.sourceView = sender as! UIView;
                    alertController.popoverPresentationController?.sourceRect = CGRect(x: (sender.frame.width/2), y: sender.frame.height, width: 0, height: 0)
                
                    presentViewController(alertController, animated: true, completion: nil)
                
                    //amountクリア
                    amount.text = ""
                } catch {
                    print(error)
                }
            break;
            }else{
                //アラート表示
                let alertController = UIAlertController(title: "エラー", message: "金額が入力されていません", preferredStyle: .ActionSheet)
                
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                
                alertController.popoverPresentationController?.sourceView = sender as! UIView;
                alertController.popoverPresentationController?.sourceRect = CGRect(x: (sender.frame.width/2), y: sender.frame.height, width: 0, height: 0)
                
                presentViewController(alertController, animated: true, completion: nil)
            }
        //収入登録
        case 1:
            let income = Income.create()
            
            if(amount != nil){
                //金額を文字列から数値に変換
                let i_amount = Int(removeComma(amount.text!))!
                income.amount = i_amount
                income.category = categoryText.text!
                income.date = dateText.text!
            
                do {
                    let realm = try Realm()
                
                    //DBに追加
                    try realm.write{ realm.add(income) }
                
                    //アラート表示
                    let alertController = UIAlertController(title: "入力完了", message: "収入の入力が完了しました", preferredStyle: .ActionSheet)
                
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alertController.addAction(defaultAction)
                
                    alertController.popoverPresentationController?.sourceView = sender as! UIView;
                    alertController.popoverPresentationController?.sourceRect = CGRect(x: (sender.frame.width/2), y: sender.frame.height, width: 0, height: 0)
                
                    presentViewController(alertController, animated: true, completion: nil)
                
                    //amountクリア
                    amount.text = ""
                } catch {
                print(error)
                }
            break;
            }else{
                //アラート表示
                let alertController = UIAlertController(title: "エラー", message: "金額が入力されていません", preferredStyle: .ActionSheet)
                
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                
                alertController.popoverPresentationController?.sourceView = sender as! UIView;
                alertController.popoverPresentationController?.sourceRect = CGRect(x: (sender.frame.width/2), y: sender.frame.height, width: 0, height: 0)
                
                presentViewController(alertController, animated: true, completion: nil)
            }
            
        default:
            break;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //金額入力時キーボードを数値入力に指定
        amount.keyboardType = UIKeyboardType.DecimalPad
        
        //3桁ごとにカンマ区切りするフォーマット
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        
        //現在日付設定
        let today = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let dateString: String = dateFormatter.stringFromDate(today)
        dateText.text = dateString
        
        //ピッカーの生成
        firstPicker = UIPickerView()
        firstPicker.showsSelectionIndicator = true
            
        //自作Delegateをdelegateおよびdatasourceとして設定
        firstPickerDelegate = FirstPickerDelegate(items: picker1Items, text: categoryText, childTF: categoryText)
        firstPicker.delegate = firstPickerDelegate
        firstPicker.dataSource = firstPickerDelegate
            
        //UITextFieldの入力としてこのピッカーを使用するよう設定
        categoryText.inputView = firstPicker

        let datepicker = UIDatePicker()
        dateText.inputView = datepicker
        
        //表示の形式
        datepicker.datePickerMode = UIDatePickerMode.Date
        //選択時のイベント登録
        datepicker.addTarget(self, action: "onDidChangeDate:", forControlEvents: .ValueChanged)
        
        //ツールバーの作成
        let toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar.barStyle = UIBarStyle.BlackTranslucent
        
        toolBar.tintColor = UIColor.whiteColor()
        
        toolBar.backgroundColor = UIColor.blackColor()
        
        let defaultButton = UIBarButtonItem(title: "今日", style: UIBarButtonItemStyle.Plain, target: self, action: "tappedToolBarBtn:")
        
        let doneButton = UIBarButtonItem(title: "決定", style: .Plain, target: self, action: "donePressed:")

        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label.font = UIFont(name: "Helvetica", size: 12)
        
        label.backgroundColor = UIColor.clearColor()
        
        label.textColor = UIColor.whiteColor()
        
        label.text = ""
        
        label.textAlignment = NSTextAlignment.Center
        
        let textBtn = UIBarButtonItem(customView: label)
        
        toolBar.setItems([defaultButton,flexSpace,textBtn,flexSpace,doneButton], animated: true)
        
        dateText.inputAccessoryView = toolBar
        
    }
    
    func donePressed(sender: UIBarButtonItem) {
        
        dateText.resignFirstResponder()
        
    }
    
    func tappedToolBarBtn(sender: UIBarButtonItem) {
        
        let today = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let dateString: String = dateFormatter.stringFromDate(today)
        dateText.text = dateString
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //選択時のイベント
    internal func onDidChangeDate(sender: UIDatePicker){
        
        //フォーマットを生成.
        let myDateFormatter: NSDateFormatter = NSDateFormatter()
        myDateFormatter.dateFormat = "yyyy/MM/dd"
        
        //日付をフォーマットに則って取得.
        let mySelectedDate: NSString = myDateFormatter.stringFromDate(sender.date)
        dateText.text = mySelectedDate as String
    }
    
    override func viewDidAppear(animated: Bool) {
        //1初期選択値
        firstPicker.selectRow(0, inComponent: 0, animated: false)
        categoryText.text = picker1Items[0]

    }
    
    //選択
    class FirstPickerDelegate : NSObject, UIPickerViewDelegate, UIPickerViewDataSource{
        //表示項目
        var items : [String]
        //関連付けられたUITextField
        var text: UITextField!
        //子のUITextFieldとピッカー
        var childTF: UITextField!

        
        //イニシャライザで関連付けられたUITextFieldと子のUITextFieldを受け取り変数にセット
        init(items:[String]!, text: UITextField, childTF: UITextField) {
            self.text = text
            self.childTF = childTF
            self.items = items
        }
        
        //ピッカーの数（日時選択などで複数を横に並べる場合の数。今回は1固定）
        func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
            return 1
        }
        
        //総行数
        func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return items.count
        }
        
        //表示名
        func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return items[row]
        }
        
        //選択時動作
        func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            //選択内容をUITextFieldに反映
            text.text = items[row]
            
            //「すべて」選択時
            if(row == 0) {
                //未指定の場合は子をリセット、使用不可に
                childTF.text = nil
                childTF.enabled = false
            } else {
                
                //子を使用可能に
                childTF.enabled = true
            }
            //ピッカーを閉じる
            text.resignFirstResponder()
        }
    }
    
    //カンマ区切りに変換（表示用）
    func addComma(str:String) -> String{
        if(str != "") {
            return formatter.stringFromNumber(Double(str)!)!
        }else{
            return ""
        }
    }
    
    //カンマ区切りを削除
    func removeComma(str:String) -> String{
        let tmp = str.stringByReplacingOccurrencesOfString(",", withString: "")
        return tmp
    }
}