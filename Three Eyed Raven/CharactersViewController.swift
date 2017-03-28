//
//  CharactersViewController.swift
//  Three Eyed Raven
//
//  Created by Fiona Thompson on 3/27/17.
//
//

import UIKit

class CharactersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITabBarDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    let searchBar = UISearchBar()
    let tabBar = UITabBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        tabBar.delegate = self
        self.tabBar.barTintColor = UIColor.black
        
        self.navigationItem.titleView = searchBar


        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell") as! CharacterCell
        return cell
    }
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.tintColor = UIColor.black
        searchBar.showsCancelButton = true
    }
   
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
