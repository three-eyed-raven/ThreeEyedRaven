//
//  HouseDetailViewController.swift
//  Three Eyed Raven
//
//  Created by Fiona Thompson on 4/4/17.
//
//

import UIKit

class HouseDetailViewController: UIViewController {

    @IBOutlet weak var sigilImageView: UIImageView!
    @IBOutlet weak var houseNameLabel: UILabel!
    @IBOutlet weak var houseRegionLabel: UILabel!
    @IBOutlet weak var houseWordsLabel: UILabel!
    @IBOutlet weak var alliesCollectionView: UICollectionView!
    @IBOutlet weak var enemiesCollectionView: UICollectionView!
    @IBOutlet weak var swornMembersCollectionView: UICollectionView!
    var house: House?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.houseNameLabel.text = house?.name
        self.houseRegionLabel.text = house?.region
        self.houseWordsLabel.text = house?.words
        setNavigationBar()
    }
    
    func setNavigationBar() {
        let logoImage = UIImage(named: "TER Icon")
        let logoView = UIImageView(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
        logoView.image = logoImage
        logoView.contentMode = .scaleAspectFit
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
        logoView.frame = titleView.bounds
        titleView.addSubview(logoView)
        
        self.navigationItem.titleView = titleView
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
