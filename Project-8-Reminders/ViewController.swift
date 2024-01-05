//
//  ViewController.swift
//  Project-8-Reminders
//
//  Created by suhail on 22/09/23.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var tblReminders: UITableView!
    var reminderModel = [Reminder]()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Reminders"
        tblReminders.dataSource = self
        tblReminders.delegate = self
        
        let defaults = UserDefaults.standard
        
        if let savedReminders = defaults.object(forKey: "reminders") as? Data{
            
            let jsonDecoder = JSONDecoder()
            do{
                reminderModel = try jsonDecoder.decode([Reminder].self, from: savedReminders)
            }catch{
                print("Failed to load reminders")
            }
            
            
        }
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            DispatchQueue.main.async {
                self.reminderModel.remove(at: indexPath.row)
                self.tblReminders.deleteRows(at: [indexPath], with: .fade)
                self.save()
            }
           
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminderModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = reminderModel[indexPath.row].title
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        cell.detailTextLabel?.text = formatter.string(from: reminderModel[indexPath.row].date)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ac = UIAlertController(title: reminderModel[indexPath.row].title, message: reminderModel[indexPath.row].body, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .cancel,handler: { _ in
            tableView.deselectRow(at: indexPath, animated: true)
        }))
        present(ac, animated: true)
    }
    @IBAction func addReminderTapped(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "add") as? AddReminderViewController else { return }
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.completion = { name,detail,time in
           
            DispatchQueue.main.async{
               
                self.reminderModel.append(Reminder(title: name, body: detail, date: time))
                self.save()
                self.tblReminders.reloadData()
            }
        }
        present(vc,animated: true)
    }
    
    func save(){
        let jsonEncoder = JSONEncoder()
        
        if let savedReminders = try? jsonEncoder.encode(reminderModel){
            let defaults = UserDefaults.standard
            defaults.set(savedReminders,forKey: "reminders")
        }else{
            print("Failed to save reminders.")
        }
    }
    
}

struct Reminder: Codable{
var title: String
var body: String
var date: Date
    
    
}
