//
//  AddMainTableViewController.swift
//  Aflama
//
//  Created by Esslam Emad on 27/2/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import RZTransitions
import PromiseKit
import SVProgressHUD
import Kingfisher

class AddMainTableViewController: UITableViewController {

    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 1)
        let imageView = UIImageView(image: UIImage(named: "group_70"))
        imageView.contentMode = .scaleAspectFill
        tableView.backgroundView = imageView
        if Auth.auth.categories != nil {
            categories = Auth.auth.categories
            tableView.reloadData()
        } else {
            SVProgressHUD.show()
        }
        firstly{
            API.CallApi(APIRequests.getCategories)
            }.done {
                let categories = try! JSONDecoder().decode([Category].self, from: $0)
                self.filterMainCategories(categories: categories)
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    }
    
    func filterMainCategories(categories: [Category]){
        for category in categories{
            if category.parent == 0 {
                if self.categories.index( where: {$0.id == category.id}) == nil {
                    self.categories.append(category)
                }
            }
        }
        self.tableView.reloadData()
        if Auth.auth.categories == nil{
            Auth.auth.categories = self.categories
        }
    }
    
    @objc func didPressOnCategory(_ gesture: UITapGestureRecognizer){
        performSegue(withIdentifier: "show subcategories", sender: gesture.view?.tag)
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
        cell.containerView.tag = categories[indexPath.row].id
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didPressOnCategory(_:)))
        cell.containerView.addGestureRecognizer(gestureRecognizer)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 153
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show subcategories"{
            let destination = segue.destination as! SubCategoriesTableViewController
            destination.parentID = (sender as! Int)
        }
    }

}
