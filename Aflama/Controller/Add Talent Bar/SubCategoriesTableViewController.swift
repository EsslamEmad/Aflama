//
//  SubCategoriesTableViewController.swift
//  Aflama
//
//  Created by Esslam Emad on 27/2/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import SVProgressHUD
import PromiseKit
import RZTransitions

class SubCategoriesTableViewController: UITableViewController {

    var categories = [Category]()
    var parentID: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 1)
        let imageView = UIImageView(image: UIImage(named: "group_70"))
        imageView.contentMode = .scaleAspectFill
        tableView.backgroundView = imageView
        if let parent  = Auth.auth.categories.index(where: {$0.id == parentID }){
            if Auth.auth.categories[parent].subCategories.count != 0 {
                categories = Auth.auth.categories[parent].subCategories
                tableView.reloadData()
            } else {
                SVProgressHUD.show()
            }
        }else {
            SVProgressHUD.show()
        }
        
        firstly{
            API.CallApi(APIRequests.getCategoriesBy(parentID: parentID))
            }.done {
                self.categories = try! JSONDecoder().decode([Category].self, from: $0)
                if let parent  = Auth.auth.categories.index(where: {$0.id == self.parentID }){
                    Auth.auth.categories[parent].subCategories = self.categories
                }
                self.tableView.reloadData()
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    }
    
    @objc func didPressOnCategory(_ gesture: UITapGestureRecognizer){
        if categories[gesture.view!.tag].parent == 3{
            performSegue(withIdentifier: "add voice", sender: categories[gesture.view!.tag])
        }else {
            performSegue(withIdentifier: "add fashion", sender: categories[gesture.view!.tag])}
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CategoryTableViewCell
        
        if let imgurl = URL(string: categories[indexPath.row].photo) {
            cell.categoryImage.kf.setImage(with: imgurl)
            cell.categoryImage.kf.indicatorType = .activity
        }
        cell.categoryName.text = categories[indexPath.row].title
        cell.containerView.tag = indexPath.row
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didPressOnCategory(_:)))
        cell.containerView.addGestureRecognizer(gestureRecognizer)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 153
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "add fashion"{
            let destination = segue.destination as! AddFashionTableViewController
            destination.category = (sender as! Category)
        }
        else if segue.identifier == "add voice"{
            let destination = segue.destination as! AddVoiceTableViewController
            destination.category = (sender as! Category)
        }
    }

}
