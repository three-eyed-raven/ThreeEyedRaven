//
//  HousesViewController.swift
//  Three Eyed Raven
//
//  Created by Fiona Thompson on 3/28/17.
//
//

import UIKit
import RealmSwift

class HousesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    let searchBar = UISearchBar()
    let tabBar = UITabBar()
    var storedHouses: [RealmHouse] = []
    var houses: [House] = []
    var houseIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.alwaysBounceVertical = true
        let realm = try! Realm()
        self.storedHouses = Array(realm.objects(RealmHouse.self).sorted(byKeyPath: "name"))
        fetchHouses()
    }
    
    func fetchHouses() {
        GoTClient.get(houses: storedHouses, from: houseIndex, success: { (houses: [House]) in
            self.houses += houses
            self.tableView.reloadData()
        }) { 
            print("failed to fetch houses")
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return houses.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HouseCell", for: indexPath) as! HouseCell
        let house = houses[indexPath.row]
        cell.houseNameLabel.text = house.name
        cell.houseWordsLabel.text = house.words
        cell.houseRegionLabel.text = house.region
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
        let house = houses[(indexPath?.row)!]
        houseDetailVC.house = house
    }
    

}

extension HousesViewController: UISearchBarDelegate {
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.tintColor = UIColor.gold
        searchBar.showsCancelButton = true
        searchBar.keyboardAppearance = .dark
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}
