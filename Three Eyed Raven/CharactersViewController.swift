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
import RealmSwift

class CharactersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    var characterIndex = 0
    var storedCharacters: [RealmCharacter] = []
    var characters: [Character] = []
    let searchBar = UISearchBar()
    let tabBar = UITabBar()
    var isMoreDataLoading = false
    var loadingMoreView: InfiniteScrollActivityView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        
        searchBar.delegate = self
        
        //tabBar.tintColor = UIColor.darkGray
        //self.navigationItem.titleView = searchBar
        setNavigationBarButtons()
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
        MBProgressHUD.showAdded(to: self.tableView, animated: true)
        GoTClient.downloadCharacters(success: { 
            let characters = realm.objects(RealmCharacter.self).sorted(byKeyPath: "name")
            self.storedCharacters = Array(characters)
            MBProgressHUD.hide(for: self.tableView, animated: true)
            self.fetchCharacters()
        }) { 
            print("Error downloading characters")
        }
    }
    
    func setNavigationBarButtons() {
        let logoImage = UIImage(named: "TER Icon")
        
        let logoView = UIImageView(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
        logoView.image = logoImage
        logoView.contentMode = .scaleAspectFit
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
        logoView.frame = titleView.bounds
        titleView.addSubview(logoView)
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: nil)
        
        self.navigationItem.rightBarButtonItem = searchButton
        self.navigationItem.titleView = titleView
    }
    
    func fetchCharacters() {
        MBProgressHUD.showAdded(to: self.tableView, animated: true)
        GoTClient.get(characters: storedCharacters, from: characterIndex, success: { (characters: [Character]) in
            for character in characters {
                character.setHouse()
            }
            //GoTClient.getCharacterPhoto(characters: characters, success: {
                self.characters += characters
                self.isMoreDataLoading = false
                self.loadingMoreView!.stopAnimating()
                self.tableView.reloadData()
                MBProgressHUD.hide(for: self.tableView, animated: true)
            //}, failure: {
            
            
            //})

        }) {
            self.isMoreDataLoading = false
            self.loadingMoreView!.stopAnimating()
            MBProgressHUD.hide(for: self.tableView, animated: true)
            print("fetching characters failed")
        }
        characterIndex += 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell") as! CharacterCell
        cell.characterImageView.image = UIImage(named: "stock-character-image")
        let character = characters[indexPath.row]
        cell.characterNameLabel.text = character.name
        if let imageUrl = character.imageUrl {
            cell.characterImageView.setImageWith(imageUrl)
        }
        cell.characterCultureLabel.text = (character.culture?.isEmpty)! ? "Unknown" : character.culture
        cell.characterHouseLabel.text = character.house?.name ?? "Unknown"
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

extension CharactersViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                fetchCharacters()
            }
            
        }
    }
}
