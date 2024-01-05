//
//  AddReminderViewController.swift
//  Project-8-Reminders
//
//  Created by suhail on 22/09/23.
//

import UIKit

class AddReminderViewController: UIViewController {

    @IBOutlet var vwTitle: UIView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var txtBody: UITextField!
    @IBOutlet var txtTitle: UITextField!
    @IBOutlet var vwBg: UIView!
    public var completion : ((String,String,Date)->(Void))?
    override func viewDidLoad() {
        super.viewDidLoad()
        vwTitle.layer.cornerRadius = 12
       
        
    }
    @IBAction func tappedOnCancel(_ sender: UIButton) {
        dismiss(animated: true)
    }
    @IBAction func tappedOnSave(_ sender: UIButton) {
        guard let title = txtTitle.text, !title.isEmpty, let body = txtBody.text, !body.isEmpty else { return }
        let targetDate = datePicker.date
        self.dismiss(animated: true)
        self.completion?(title,body,targetDate)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.presentationController?.containerView?.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.presentationController?.containerView?.backgroundColor = UIColor.clear
    }
  
    
   
}
