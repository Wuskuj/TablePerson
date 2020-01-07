//
//  SecondViewController.swift
//  TablePerson
//
//  Created by Филипп on 10/19/19.
//  Copyright © 2019 Filipp. All rights reserved.
//

import UIKit
import CoreData

class SecondViewController: UIViewController {
    

    var currentPerson = Person()
    var index : Int?
    var isCurrent = false
    var changePhoto = false

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var surnameTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var surnameNameTF: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var sexSegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.isEnabled = false
        
       //watchTextField()
        
        setupEditScreen()
        nameTF.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
        surnameTF.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
        surnameNameTF.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
        keyboard()
    }
    
    
    private func keyboard() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { (nc) in
            
            self.view.frame.origin.y = -150
            
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { (nc) in
            self.view.frame.origin.y = 0.0
            
        }
    }
    
    
    
    func savePerson() -> Person? {
        
        let image = changePhoto ? imageView.image : #imageLiteral(resourceName: "noMuchPhoto")
        let imageData = image?.pngData()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        if isCurrent {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
            
            do {
                let results = try context.fetch(request) as! [Person]
                
                    let result = results[index!]
                    result.name = nameTF.text
                    result.surname = surnameTF.text
                    result.surnameName = surnameNameTF.text
                    result.imageData = imageData
                    result.phone = phone.text
                    result.sex = sexSegment.selectedSegmentIndex == 0 ? true : false
                
                    try context.save()
                
            }catch {
                print(error.localizedDescription)
            }
            return nil
        } else {
        
        
        
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: context)
     
        let personObject = NSManagedObject(entity: entity!, insertInto: context) as! Person
        
        personObject.name = nameTF.text
        personObject.surname = surnameTF.text
        personObject.surnameName = surnameNameTF.text
        personObject.imageData = imageData
        personObject.phone = phone.text
        personObject.sex = sexSegment.selectedSegmentIndex == 0 ? true : false
        
        
        do {
            try context.save()
        }catch  {
            print(error.localizedDescription)
        }
        
        return personObject
        }
    }
    
    

    @IBAction func cameraButton(_ sender: UIBarButtonItem) {
        createPhoto()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    private func createPhoto() {
        let cameraIcon = #imageLiteral(resourceName: "camera")
        let photoIcon = #imageLiteral(resourceName: "photo")
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { (_) in
                self.chooseImagePicker(source: .camera)
        }
        
        camera.setValue(cameraIcon, forKey: "image")
        camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let library = UIAlertAction(title: "Library", style: .default) { (_) in
            
                self.chooseImagePicker(source: .photoLibrary)
            
        }
        
        library.setValue(photoIcon, forKey: "image")
        library.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(camera)
        alertController.addAction(library)
        alertController.addAction(cancel)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    
    
    
    private func setupEditScreen() {
        if isCurrent {
            changePhoto = true
            setupNavigationBar()
            
            imageView.image = UIImage(data: currentPerson.imageData!)
            imageView.contentMode = .scaleAspectFill
            nameTF.text = currentPerson.name
            surnameTF.text = currentPerson.surname
            surnameNameTF.text = currentPerson.surnameName
            sexSegment.selectedSegmentIndex = currentPerson.sex ? 0 : 1
            phone.text = currentPerson.phone
        }
    }

    
    private func setupNavigationBar() {
        
        
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        navigationItem.leftBarButtonItem = nil
        title = currentPerson.surname
        saveButton.isEnabled = true 
    }

    
 
}







    

    


