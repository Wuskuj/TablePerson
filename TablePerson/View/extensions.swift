//
//  extensions.swift
//  TablePerson
//
//  Created by Филипп on 10/22/19.
//  Copyright © 2019 Filipp. All rights reserved.
//

import UIKit



extension SecondViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true //разрешаем редактировать
            imagePicker.sourceType = source
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.editedImage] as? UIImage
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        changePhoto = true
        
        dismiss(animated: true, completion: nil)
    }
}


//MARK: -UITextFieldDelegate
extension SecondViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc  func textFieldChange() {
        if nameTF.text?.isEmpty == false && surnameTF.text?.isEmpty == false && surnameNameTF.text?.isEmpty == false{
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    
}



//MARK: -UITableViewDataSource, UITableViewDelegate
extension ViewController :  UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableTableViewCell
        
        cell.name.text = array[indexPath.row].name
        cell.surname.text = array[indexPath.row].surname
        cell.surnameName.text = array[indexPath.row].surnameName
        cell.imageViewCell.image = UIImage(data: array[indexPath.row].imageData!)
        
        let sex = array[indexPath.row].sex ? "мужской" : "женский"
        cell.sexLabel.text = "Пол: \(sex)"
        
        if let phone = array[indexPath.row].phone{
            if phone == "" {
                cell.phoneLabel.text = "Тел: отсутствует"
            } else {
                cell.phoneLabel.text = "Тел: \(phone)"
            }
        }
        
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //убираем выделение ячейки при возврате
    }
    
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if editingStyle == .delete {
            context.delete(array[indexPath.row])
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            
            do {
                array = try context.fetch(Person.fetchRequest())
            }catch let error as NSError {
                print("Could not save \(error)")
            }
        }
        
        tableView.reloadData()
    }
}
