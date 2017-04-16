//
//  CharactersViewController.swift
//  Three Eyed Raven
//
//  Created by Fiona Thompson on 3/27/17.
//
//

import UIKit
import MBProgressHUD
import AFNetworking

class CharactersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    var characters: [Character] = []
    let searchBar = UISearchBar()
    let tabBar = UITabBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tabBar.tintColor = UIColor.darkGray
        self.navigationItem.titleView = searchBar
        MBProgressHUD.showAdded(to: self.tableView, animated: true)
        GoTClient.getCharacters(success: { (characters: [Character]) in
            self.characters = characters
            self.tableView.reloadData()
            MBProgressHUD.hide(for: self.tableView, animated: true)
        }) { 
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell") as! CharacterCell
        let character = characters[indexPath.row]
        cell.characterNameLabel.text = character.name
        if let imageUrl = character.imageUrl {
          cell.characterImageView.setImageWith(imageUrl)
        }
        cell.characterDescriptionLabel.text = character.aliases?.first
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let characterDetailVC = segue.destination as! CharacterDetailViewController
        if let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell) {
            let character = characters[indexPath.row]
            characterDetailVC.character = character
        }
    }
}

extension CharactersViewController: UISearchBarDelegate {
    
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
