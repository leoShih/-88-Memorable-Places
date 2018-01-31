//
//  PlacesTableViewController.swift
//  #88 Memorable Places
//
//  Created by Leo on 17/01/2018.
//  Copyright © 2018 Leo. All rights reserved.
//

import UIKit


//create an empty Dictionary, 將Dictionary變成array
//另一種寫法places = [[String: String]()]
var places = [Dictionary<String, String>()]

var activePlace = -1

class PlacesTableViewController: UITableViewController {

    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        
        //呼叫資料
        if let tempPlaces = UserDefaults.standard.object(forKey: "places") as? [Dictionary<String, String>] {
            
            places = tempPlaces
            
        }
        
        
        
        //確認place Array裡有一個Dictionary 且[0]為空值
        if places.count == 1 && places[0].count == 0 {
            
            //empty array dictionary 會有個空的array，先移除掉
            places.remove(at: 0)
            
            //後續新增項目的順位為0
            places.append(["name" : "Taj", "lat" : "27.175277", "lon" : "78.04218"])
            
            //將資料儲存
            UserDefaults.standard.set(places, forKey: "places")
        }
        
        //區分新增／tableview 項目
        activePlace = -1
        
        table.reloadData()
        
    }
    
    //將row可編輯
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
        
    }
    
    //編輯模式設定
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            places.remove(at: indexPath.row)
            //將刪除的資料儲存
            UserDefaults.standard.set(places, forKey: "places")
            
            table.reloadData()
            
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return places.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        
        if places[indexPath.row]["name"] != nil {
            
            cell.textLabel?.text = places[indexPath.row]["name"]
            
        }

        return cell
        
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        activePlace = indexPath.row
        
        performSegue(withIdentifier: "toMap", sender: nil)
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
