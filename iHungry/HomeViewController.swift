//
//  HomeViewController.swift
//  iHungry
//
//  Created by Michael Douglas on 17/01/17.
//  Copyright © 2017 Michael Douglas. All rights reserved.
//

import UIKit

//**************************************************************************************************
//
// MARK: - Constants -
//
//**************************************************************************************************

//**************************************************************************************************
//
// MARK: - Definitions -
//
//**************************************************************************************************

//**************************************************************************************************
//
// MARK: - Class -
//
//**************************************************************************************************

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //*************************************************
    // MARK: - IBOutlets
    //*************************************************
    
    @IBOutlet weak var myOrdersTableView: UITableView!
    @IBOutlet weak var noOrdersView: UIView!
    
    //*************************************************
    // MARK: - Properties
    //*************************************************
    
    //Variable that storages the Orders that appears in TableView
    private var orders = [OrderVO]()
    
    //*************************************************
    // MARK: - Override Public Methods
    //*************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set NavigationBarTransparent
        self.setNavigationBarTransparent()
        //Verify if the user has been already logged in
        self.userIsLogged()
        //Remove UITableViewCell separator for empty cells
        self.myOrdersTableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Update the Table View with MyOrders
        self.orders = OrderManager.getAllOrders()
        
        //Verify if ordes is empty to hidden noOrdersView
        if !(orders.isEmpty) {
            self.myOrdersTableView.isHidden = false
            self.noOrdersView.isHidden = true
        } else {
            self.myOrdersTableView.isHidden = true
            self.noOrdersView.isHidden = false
        }
        
        //ReloadData from My Orders Table View
        myOrdersTableView.reloadData()
        
    }
    
    //*************************************************
    // MARK: - Private Methods
    //*************************************************
    
    private func setNavigationBarTransparent() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    //Verify if the user has been already logged in
    private func userIsLogged() {
        if !LoginManager.isLogged {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let loginView = storyBoard.instantiateViewController(withIdentifier: "LoginViewController")
            self.present(loginView, animated: false, completion: nil)
        }
    }
    
    //*************************************************
    // MARK: - Table View Methods
    //*************************************************
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orders.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let customCell = Bundle.main.loadNibNamed("HomeCustomTableViewCell", owner: self, options: nil)?.first as! HomeCustomTableViewCell
        
        let orderDataAtPosition = self.orders[indexPath.row]
        
        if let image = orderDataAtPosition.image {
            customCell.orderImage.image = UIImage(named: image)
        }
        customCell.orderName.text = orderDataAtPosition.name
        customCell.orderPrice.text = orderDataAtPosition.orderPrice?.toReal()
        return customCell
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let orderDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailViewController") as! OrderDetailViewController
        
        orderDetailVC.order = self.orders[indexPath.row]
        
        let modalViewController = orderDetailVC
        modalViewController.modalPresentationStyle = .overFullScreen
        present(modalViewController, animated: true, completion: nil)
    }
    
    internal func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let orderCell = orders[indexPath.row]
            OrderManager.deleteOrder(orderVO: orderCell)
            self.orders = OrderManager.getAllOrders()
        }
        //ReloadOrders
        myOrdersTableView.reloadData()
        //Verify if ordes is empty to hidden noOrdersView
        if !(orders.isEmpty) {
            self.myOrdersTableView.isHidden = false
            self.noOrdersView.isHidden = true
        } else {
            self.myOrdersTableView.isHidden = true
            self.noOrdersView.isHidden = false
        }
    }
    
    //*************************************************
    // MARK: - IBActions
    //*************************************************
    
    @IBAction func addOrder(_ sender: UIButton) {
        FoodMenuManager.getMenu() { foods in
            let foodMenuVC = self.storyboard?.instantiateViewController(withIdentifier: "FoodMenuViewController") as! FoodMenuViewController
            foodMenuVC.foods = foods
            DispatchQueue.main.async {
                if let navControlle = self.navigationController {
                    navControlle.pushViewController(foodMenuVC, animated: true)
                }
            }
        }
    }
    
    @IBAction func openMenu(_ sender: UIBarButtonItem) {
        LoginManager.logout()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let loginView = storyBoard.instantiateViewController(withIdentifier: "LoginViewController")
        self.present(loginView, animated: true, completion: nil)
    }
}
