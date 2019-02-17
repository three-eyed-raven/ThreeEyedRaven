//
//  HousesViewController.swift
//  Three Eyed Raven
//
//  Created by Fiona Thompson on 3/28/17.
//
//

import UIKit
import RealmSwift
import MBProgressHUD

class HousesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    let searchBar = UISearchBar()
    var searchButton = UIBarButtonItem()
    let tabBar = UITabBar()
    var titleView = UIView()
    var storedHouses: [RealmHouse] = []
    var houses: [House] = []
    var filteredHouses: [House] = []
    var houseIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        self.tableView.alwaysBounceVertical = true
        let realm = try! Realm()
        self.storedHouses = Array(realm.objects(RealmHouse.self).sorted(byKeyPath: "name"))
        setNavigationBarButtons()
        fetchHouses()
    }
    
    func setNavigationBarButtons() {
        let logoImage = UIImage(named: "TER Icon")
        let logoView = UIImageView(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
        logoView.image = logoImage
        logoView.contentMode = .scaleAspectFit
        self.titleView = UIView(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
        logoView.frame = titleView.bounds
        titleView.addSubview(logoView)
        
        self.searchButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.search, target: self, action: #selector(searchIconPressed(sender:)))
        
        self.navigationItem.rightBarButtonItem = searchButton
        self.navigationItem.titleView = titleView
    }
    
    func fetchHouses() {
        MBProgressHUD.showAdded(to: self.tableView, animated: true)
        GoTClient.get(houses: storedHouses, from: houseIndex, success: { (houses: [House]) in
            self.houses += houses
            self.filteredHouses += houses
            self.tableView.reloadData()
            MBProgressHUD.hide(for: self.tableView, animated: true)
        }) { 
            print("failed to fetch houses")
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredHouses.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HouseCell", for: indexPath) as! HouseCell
        let house = filteredHouses[indexPath.row]
        cell.houseNameLabel.text = house.name
        cell.houseWordsLabel.text = house.words
        cell.houseRegionLabel.text = (house.region?.isEmpty)! ? "Unknown" : house.region
        return cell
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        let houseDetailVC = segue.destination as! HouseDetailViewController
        let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
        let house = filteredHouses[(indexPath?.row)!]
        houseDetailVC.house = house
        self.searchBar.resignFirstResponder()
    }
    

}

extension HousesViewController: UISearchBarDelegate {
    
    @objc func searchIconPressed(sender: UIBarButtonItem) {
        self.navigationItem.rightBarButtonItem = nil
        self.searchBar.becomeFirstResponder()
        self.navigationItem.titleView = self.searchBar
    }
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.tintColor = UIColor.gold
        searchBar.showsCancelButton = true
        searchBar.keyboardAppearance = .dark
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.navigationItem.titleView = self.titleView
        self.navigationItem.rightBarButtonItem = self.searchButton
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("text changing")
        
        filteredHouses = searchText.isEmpty ? houses : houses.filter({(house: House) -> Bool in
            let name = house.name!
            return name.range(of: searchText, options: .caseInsensitive) != nil
        })
        self.tableView.reloadData()
    }
    
}
