//
//  CameraViewController.swift
//  Three Eyed Raven
//
//  Created by William Huang on 4/25/17.
//
//

import UIKit
import MBProgressHUD

class CameraViewController: UIViewController {
    
    var image: UIImage?
    var character: Character?
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var cameraButton: UIButton!
    let vc = UIImagePickerController()
    
    override func viewWillAppear(_ animated: Bool) {
        vc.delegate = self
        vc.allowsEditing = true
        self.displayLabel.isHidden = true
        self.cameraButton.isHidden = true
        self.cameraButton.layer.cornerRadius = 3
        self.cameraButton.clipsToBounds = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            vc.sourceType = .camera
        } else {
            vc.sourceType = .photoLibrary
        }

        if image == nil {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.image = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
    }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        self.present(vc, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let characterDetailVC = segue.destination as! CharacterDetailViewController
        characterDetailVC.character = self.character
    }
 

}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let group = DispatchGroup()
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        self.image = editedImage
        MBProgressHUD.showAdded(to: self.view, animated: true)
        group.enter()
        GoTClient.getCharacter(from: editedImage, success: { (character: Character) in
            group.enter()
            GoTClient.setHouse(for: character, success: { 
                group.leave()
            }, failure: { 
                group.leave()
            })
            
            group.enter()
            GoTClient.getCharacterPhoto(characters: [character], success: {
                self.character = character
                group.leave()
            }, failure: {
                self.character = character
                group.leave()
            })
            group.leave()
        }) {
            self.showError()
        }
        
        group.notify(queue: .main) {
            MBProgressHUD.hide(for: self.view, animated: true)
            self.performSegue(withIdentifier: "CameraCharacterSegue", sender: self)
        }
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }
    
    func showError() {
        self.displayLabel.isHidden = false
        self.cameraButton.isHidden = false
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.tabBarController?.selectedIndex = 0
        dismiss(animated: true, completion: nil)

    }
    
}
