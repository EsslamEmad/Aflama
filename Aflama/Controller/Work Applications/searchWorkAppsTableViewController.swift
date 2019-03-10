//
//  searchWorkAppsTableViewController.swift
//  Aflama
//
//  Created by Esslam Emad on 9/3/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import SVProgressHUD
import PromiseKit

class searchWorkAppsTableViewController: UITableViewController, UISearchBarDelegate {
    
    
    lazy   var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 300, height: 20))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 1)
        let imageView = UIImageView(image: UIImage(named: "group_70"))
        imageView.contentMode = .scaleAspectFill
        tableView.backgroundView = imageView
        
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        
        
    }
    
    var data = [WorkApplication]()
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard searchBar.text != "" else {
            return
        }
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.searchWorkApps(search: searchBar.text ?? ""))
            }.done {
                self.data = try! JSONDecoder().decode([WorkApplication].self, from: $0)
                self.tableView.reloadData()
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WorkAppTableViewCell
        
        if let img = data[indexPath.row].company.photo {
            if let imgurl = URL(string: img){
                cell.photo.kf.setImage(with: imgurl)
                cell.photo.kf.indicatorType = .activity
            }
        }
        cell.titleLabel.text = data[indexPath.row].title
        cell.dateLabel.text = data[indexPath.row].startDate
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
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
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
