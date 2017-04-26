//
//  CameraViewController.swift
//  Three Eyed Raven
//
//  Created by William Huang on 4/25/17.
//
//

import UIKit

class CameraViewController: UIViewController {
    
    var image: UIImage?
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var cameraButton: UIButton!
    let vc = UIImagePickerController()
    
    override func viewWillAppear(_ animated: Bool) {
        vc.delegate = self
        vc.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            vc.sourceType = .camera
        } else {
            vc.sourceType = .photoLibrary
        }

        if displayLabel.text != nil {
            
        } else {
            self.present(vc, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        self.present(vc, animated: true, completion: nil)
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

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        self.image = editedImage
        GoTClient.getCharacter(from: editedImage, success: { (character: Character) in
            self.displayLabel.text = "\(character.name!) played by \((character.playedBy?.first)!)"
        }) { 
            self.displayLabel.text = "Character could not be recognized"
        }
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.tabBarController?.selectedIndex = 0
        dismiss(animated: true, completion: nil)

    }
    
}
