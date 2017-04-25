//
//  HousesViewController.swift
//  Three Eyed Raven
//
//  Created by Fiona Thompson on 3/28/17.
//
//

import UIKit
import RealmSwift

class HousesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    let searchBar = UISearchBar()
    let tabBar = UITabBar()
    var storedHouses: [RealmHouse] = []
    var houses: [House] = []
    var houseIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView.alwaysBounceVertical = true
        let realm = try! Realm()
        self.storedHouses = Array(realm.objects(RealmHouse.self).sorted(byKeyPath: "name"))
        fetchHouses()
    }
    
    func fetchHouses() {
        GoTClient.get(houses: storedHouses, from: houseIndex, success: { (houses: [House]) in
            self.houses += houses
            self.collectionView.reloadData()
        }) { 
            print("failed to fetch houses")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return houses.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HouseCell", for: indexPath) as! HouseCell
        let house = houses[indexPath.row]
        cell.houseNameLabel.text = house.name
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
        let indexPath = self.collectionView.indexPath(for: sender as! UICollectionViewCell)
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
