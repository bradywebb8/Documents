//
//  SecondViewController.swift
//  Documents
//
//  Created by Brady Webb on 8/28/19.
//  Copyright © 2019 Brady Webb. All rights reserved.
//

import UIKit
import CoreData

class SecondViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var documentArea: UITextView!
    
    var document: Document?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        guard let document = document else {
            return
        }
        nameField.text = document.name
        documentArea.text = document.content
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func saveFile(_ sender: Any) {
        guard let fileName = nameField.text, fileName.count > 0, let content = documentArea.text, content.count > 0 else {
            return
        }
       
        navigationController?.popViewController(animated: true)
    }
    @IBAction func nameChanged(_ sender: UITextField) {
        self.title = nameField.text ?? "New Document"
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
