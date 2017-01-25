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

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    //*************************************************
    // MARK: - IBOutlets
    //*************************************************
    
    @IBOutlet weak var searchConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var menuOpaqueButton: UIButton!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var constraintMenu: NSLayoutConstraint!
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
        self.setupNavigationBarStyle()
        //Setup Search Bar Style
        self.setupSearchBar()
        //Verify if the user has been already logged in
        self.userIsLogged()
        //Remove UITableViewCell separator for empty cells
        self.myOrdersTableView.tableFooterView = UIView(frame: CGRect.zero)
        self.menuView.layer.shadowOpacity = 1
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
        self.myOrdersTableView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchBar.endEditing(true)
    }
    
    //*************************************************
    // MARK: - Search View Methods
    //*************************************************
    
    internal func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchHidden()
    }
    
    //*************************************************
    // MARK: - Private Methods
    //*************************************************
    
    private func setupSearchBar() {
        self.searchBar.backgroundImage = UIImage()
        self.searchBar.backgroundColor = UIColor.white
        self.searchBar.layer.borderColor = UIColor.white.cgColor
        self.searchBar.layer.borderWidth = 1
        self.searchBar.alpha = 0.6
        self.searchBar.layer.cornerRadius = 21
        self.searchBar.clipsToBounds = true
    }
    
    private func searchAppears() {
        //Set hidden keyboard
        self.searchConstraint.constant = 35
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.view.layer.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: 0.3, animations: {
            self.navigationController?.navigationBar.isHidden = true
        })
    }
    
    private func searchHidden() {
        self.searchConstraint.constant = -100
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layer.layoutIfNeeded()
            self.navigationController?.navigationBar.isHidden = false
        })
    }
    
    private func showMenu() {
        self.constraintMenu.constant = 55
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.view.layer.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: 0.2, animations: {
            self.menuOpaqueButton.alpha = 0.5
            self.navigationController?.navigationBar.isHidden = true
        })
    }
    
    private func hiddenMenu() {
        self.constraintMenu.constant = 380
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layer.layoutIfNeeded()
            self.menuOpaqueButton.alpha = 0
            self.navigationController?.navigationBar.isHidden = false
        })
    }
    
    private func setupNavigationBarStyle() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.white
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
        let homeCell = Bundle.main.loadNibNamed("HomeCustomTableViewCell", owner: self, options: nil)?.first as! HomeCustomTableViewCell
        
        let orderDataAtPosition = self.orders[indexPath.row]
        
        if let image = orderDataAtPosition.image {
            homeCell.orderImage.image = UIImage(named: image)
        }
        homeCell.orderName.text = orderDataAtPosition.name
        homeCell.orderPrice.text = orderDataAtPosition.orderPrice?.toReal()
        return homeCell
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let orderDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailViewController") as! OrderDetailViewController
        
        orderDetailVC.order = self.orders[indexPath.row]
        
        self.navigationController?.pushViewController(orderDetailVC, animated: true)

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
            foodMenuVC.receivedFoods = foods
            DispatchQueue.main.async {
                if let navControlle = self.navigationController {
                    navControlle.pushViewController(foodMenuVC, animated: true)
                }
            }
        }
    }
    
    @IBAction func openMenu(_ sender: UIBarButtonItem) {
        self.showMenu()
    }
    
    @IBAction func closeMenu(_ sender: UIButton) {
        self.hiddenMenu()
    }
    
    @IBAction func search(_ sender: UIBarButtonItem) {
        self.searchAppears()
        self.searchBar.becomeFirstResponder()
    }
    
    @IBAction func logout(_ sender: UIButton) {
        LoginManager.logout()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let loginView = storyBoard.instantiateViewController(withIdentifier: "LoginViewController")
        self.hiddenMenu()
        self.present(loginView, animated: true, completion: nil)
    }
    
}
