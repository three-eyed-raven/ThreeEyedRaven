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
    @IBOutlet weak var searchTableView: UITableView!
    var characterIndex = 0
    var storedCharacters: [RealmCharacter] = []
    var filteredCharacters: [RealmCharacter] = []
    var characterForSearch: Character?
    var characters: [Character] = []
    let searchBar = UISearchBar()
    var searchButton = UIBarButtonItem()
    var titleView = UIView()
    let tabBar = UITabBar()
    var isMoreDataLoading = false
    var loadingMoreView: InfiniteScrollActivityView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()
        tableView.delegate = self
        tableView.dataSource = self
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        searchTableView.rowHeight = UITableViewAutomaticDimension
        searchTableView.estimatedRowHeight = 200
        
        searchBar.delegate = self
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
            self.filteredCharacters = self.storedCharacters
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
        self.titleView = UIView(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
        logoView.frame = titleView.bounds
        titleView.addSubview(logoView)
        
        self.searchButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(searchIconPressed(sender:)))
        
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
        if tableView == self.searchTableView {
            return filteredCharacters.count
        }
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.searchTableView {
            let cell = searchTableView.dequeueReusableCell(withIdentifier: "CharacterSearchCell") as! CharacterSearchCell
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(searchCellPressed(sender:)))
            cell.addGestureRecognizer(tapGestureRecognizer)
            let character = filteredCharacters[indexPath.row]
            cell.characterNameLabel.text = character.name
            return cell
        }
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
    
    func searchCellPressed(sender: UITapGestureRecognizer) {
        MBProgressHUD.showAdded(to: self.searchTableView, animated: true)
        let group = DispatchGroup()
        let cell = sender.view as! CharacterSearchCell
        if let indexPath = self.searchTableView.indexPath(for: cell) {
            let character = filteredCharacters[indexPath.row]
            group.enter()
            GoTClient.getCharacter(fromUrlString: character.urlString, success: { (character: Character) in
                self.characterForSearch = character
                group.enter()
                GoTClient.setHouse(for: character, success: {
                    group.leave()
                }, failure: {
                    group.leave()
                })
                group.enter()
                GoTClient.getCharacterPhoto(characters: [character], success: {
                    group.leave()
                }, failure: {
                    group.leave()
                })
                group.leave()
            }, failure: { 
                print("Character search failed")
            })
        }
        group.notify(queue: .main) {
            
            MBProgressHUD.hide(for: self.searchTableView, animated: true)
            self.performSegue(withIdentifier: "CharacterDetailSegue", sender: cell)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let characterDetailVC = segue.destination as! CharacterDetailViewController
        self.searchBar.resignFirstResponder()

        if ((sender as? CharacterSearchCell) != nil) {
            characterDetailVC.character = self.characterForSearch
        }
        if let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell) {
            let character = characters[indexPath.row]
            characterDetailVC.character = character
        }
    }
}

extension CharactersViewController: UISearchBarDelegate {
    
    func searchIconPressed(sender: UIBarButtonItem) {
        self.navigationItem.rightBarButtonItem = nil
        self.searchBar.becomeFirstResponder()
        self.navigationItem.titleView = self.searchBar
        self.tableView.isHidden = true
        self.searchTableView.isHidden = false
        self.searchTableView.reloadData()
    }
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.tintColor = UIColor.gold
        searchBar.showsCancelButton = true
        searchBar.keyboardAppearance = .dark

    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("text changing")
        
        filteredCharacters = searchText.isEmpty ? storedCharacters : storedCharacters.filter({(character: RealmCharacter) -> Bool in
            let name = character.name
            return name.range(of: searchText, options: .caseInsensitive) != nil
        })
        self.searchTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.navigationItem.titleView = self.titleView
        self.navigationItem.rightBarButtonItem = self.searchButton
        self.tableView.isHidden = false
        self.searchTableView.isHidden = true
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
