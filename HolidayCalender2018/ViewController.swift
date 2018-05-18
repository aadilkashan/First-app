//
//  ViewController.swift
//  HolidayCalender2018
//
//  Created by Apple on 09/04/18.
//  Copyright © 2018 ankit. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var arr = NSArray()

    
    @IBOutlet weak var myTableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let monthDict = arr.object(at: section) as! NSDictionary
        let detailsArr =  monthDict.value(forKey: "details") as! NSArray
        return detailsArr.count

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomTableViewCell
        let monthDict = arr.object(at: indexPath.section) as! NSDictionary
        let detailsArr = monthDict.value(forKey: "details") as! NSArray
        let detailsDict = detailsArr.object(at: indexPath.row) as! NSDictionary
        let date = detailsDict.value(forKey: "date") as! String
        let title = detailsDict.value(forKey: "title") as! String
        let day = detailsDict.value(forKey: "day") as! String
        let numberday = date.characters
        let backcolor = detailsDict.value(forKey: "color") as! String
        print(day)
        print(title)
        let finalday = String(date.prefix(2))
        cell.myLabel.text = "\(finalday) \t \(title) \t \(day)"
        cell.myLabel.font = UIFont.boldSystemFont(ofSize: 20)
        cell.myLabel.backgroundColor = hexStringToUIColor(hex: backcolor)
       /* cell.myLabel.minimumScaleFactor = 0.3
        cell.myLabel.adjustsFontSizeToFitWidth = true
        cell.myLabel.numberOfLines = 1*/
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return arr.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let monthDict = arr.object(at: section) as! NSDictionary
        return monthDict.value(forKey: "month") as? String
    }
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "http://mahindralylf.com/apiv1/getholidays")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, err) in
            if let tempData = data{
                do{
                    let dict = try JSONSerialization.jsonObject(with: tempData, options: .mutableContainers) as! NSDictionary
                   // print("Dict is \(dict)")
                    
                    //print(dict.value(forKey: "response_code") ?? "")
                    //print(dict.value(forKey: "response_msg") ?? "")
                    //print(dict.value(forKey: "holiday_count") ?? "")
                    
                    self.arr = dict.value(forKey: "holidays") as! NSArray
                    //print("arr count is \(self.arr.count)")
                    
                    DispatchQueue.main.async {
                        self.myTableView.reloadData()
                    }
                    
                }catch{
                    print("Exception")
                }
            }else{
                print("no data")
            }
        }
        
        task.resume()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

