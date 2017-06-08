//
//  ViewController.swift
//  [laba 5] ios
//
//  Created by Vladislav Shilov on 04.06.17.
//  Copyright © 2017 Vladislav Shilov. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 10.0, *)
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITabBarDelegate {

    var busStation = [BusStation]()
    var managedObjectContext : NSManagedObjectContext!
    var hasSearched = false
    var searchedArray = [BusStation]()
    

    @IBOutlet weak var consoleLabel: UILabel!
    @IBOutlet weak var switchController: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControll: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //createSearchBar()
        
        managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        
        loadData(choice: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData(choice: 1)
    }
    
    // MATK: - SearchBar
    
    func createSearchBar(){
        
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Enter your search here!"
        searchBar.barStyle = .default
        //searchBar.barTintColor = UIColor(red: 0/255, green: 130/255, blue: 255/255, alpha: 1)
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        return true;
    }
    
    
    // MARK: - CoreData

    func loadData(choice will: Int){
        let presentRequest:NSFetchRequest<BusStation> = BusStation.fetchRequest()
        
        switch will {
        case 1:
            
            let sort = NSSortDescriptor(key: "departureTime", ascending: true)
            presentRequest.sortDescriptors = [sort]

        case 2:
            break
        case 3:
            
            let sort = NSSortDescriptor(key: "busNumber", ascending: true)
            //reversedSortDescriptor
            presentRequest.sortDescriptors = [sort]
            
        default:
            break
        }
        
        do{
            busStation = try managedObjectContext.fetch(presentRequest)
            self.tableView.reloadData()
        }catch{
            print("Couldnt load data from database \(error.localizedDescription)")
        }
        
    }
    
//    func loadSortedData() {
//        
//        let request:NSFetchRequest<BusStation> = BusStation.fetchRequest()
//        let sort = NSSortDescriptor(key: "destinationTime", ascending: false)
//        request.sortDescriptors = [sort]
//        
//        do {
//            busStation = try managedObjectContext.fetch(request)
//            print("Got \(busStation.count) commits")
//            tableView.reloadData()
//        } catch {
//            print("Fetch failed")
//        }
//    }


    // MARK: - TableView
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return busStation.count
        
        if !hasSearched {
            return busStation.count
        } else {
            return searchedArray.count
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        let busStationItem: BusStation
        
        if !hasSearched {
            
            busStationItem = busStation[indexPath.row]
            
        } else{
            hasSearched = false
            busStationItem = searchedArray[indexPath.row]
            
        }
        
        //cell.numberOfBusLabel.text = String(numbers[indexPath.row])

        cell.numberOfBusLabel.text = busStationItem.busNumber
        cell.departureLabel.text = busStationItem.departure
        cell.destinationLabel.text = busStationItem.destination
        cell.timeDepartureLabel.text = busStationItem.departureTime
        cell.timeDestinationLabel.text = busStationItem.destinationTime
        //cell.textLabel?.text = item.value(forKey: "item") as? String
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            managedObjectContext.delete(busStation[indexPath.row])

            busStation.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            do {
                try managedObjectContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    // MARK: - Buttons
    
    
    @available(iOS 10.0, *)
    @IBAction func addAction(_ sender: Any) {
        
        let stationItem = BusStation(context: managedObjectContext)
        
        let inputAlert = UIAlertController(title: "New Bus", message: "Enter an information...", preferredStyle: .alert)
        inputAlert.addTextField { (textField:UITextField) in
            textField.placeholder = "Bus Number"
        }
        inputAlert.addTextField { (textField:UITextField) in
            textField.placeholder = "From:"
        }
        inputAlert.addTextField { (textField:UITextField) in
            textField.placeholder = "To:"
        }
        inputAlert.addTextField { (textField:UITextField) in
            textField.placeholder = "Departure Time"
        }
        inputAlert.addTextField { (textField:UITextField) in
            textField.placeholder = "Destination Time"
        }
        
        inputAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action:UIAlertAction) in
            
            let busTextField = inputAlert.textFields?.first
            let departureField = inputAlert.textFields?[1]
            let destinationField = inputAlert.textFields?[2]
            let departureTimeField = inputAlert.textFields?[3]
            let destinationTimeField = inputAlert.textFields?.last
            
            if busTextField?.text != "" && departureField?.text != "" && destinationField?.text != "" && departureTimeField?.text != "" && destinationTimeField?.text != ""{
                
                stationItem.busNumber = busTextField?.text
                stationItem.departure = departureField?.text
                stationItem.destination = destinationField?.text
                stationItem.departureTime = departureTimeField?.text
                stationItem.destinationTime = destinationTimeField?.text
                
                do {
                    try self.managedObjectContext.save()
                    self.loadData(choice: 1)
                }catch{
                    print("Couldnt save data \(error.localizedDescription)")
                }
                
            }
            
        }))
        
        inputAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(inputAlert, animated: true, completion: nil)
    }
    
    
    @IBAction func sortAction(_ sender: Any) {
        
        tableView.reloadData()
        
        switch segmentControll.selectedSegmentIndex {
        case 0:
            loadData(choice: 1)
        case 1:
            loadData(choice: 2)
        case 2:
            loadData(choice: 3)
        default:
            break
        }
        
        tableView.reloadData()

        
    }

    
    @IBAction func taskAction(_ sender: Any) {
        
        let inputAlert = UIAlertController(title: "Your attention please", message: "Insert destination..", preferredStyle: .alert)
        inputAlert.addTextField { (textField:UITextField) in
            textField.placeholder = "Destination:"
        }
        
        
        inputAlert.addAction(UIAlertAction(title: "Search", style: .default, handler: { action in
            if inputAlert.textFields?.first?.text != "" {
                self.showNewTableView(with: (inputAlert.textFields?.first?.text)!)
                print("It's here!")
            }
        }))
        
        
        
        self.present(inputAlert, animated: true, completion: nil)
        
    }
    
    
    func showNewTableView(with searchText: String){
        
        //Брать место назначения из searchBar
        //сверять его
        //выдавать алерт если его нет
        //если есть, то сделтаь поиск по таблице
        //обновить таблицу
        
        searchedArray.removeAll()
        var searched = false
        
        for item in busStation{
            if item.destination == searchText{
                searchedArray.append(item)
                searched = true
            }
        }
        
        if !searched{
            showCustomAlert(with: "There is no this element!")
        } else{
        
            for first in searchedArray{
                for second in searchedArray{
                    if first.destinationTime! < second.destinationTime!{
                        let index = searchedArray.index(of: second)
                        searchedArray.remove(at: index!)
                    }
                }
            }
            
            hasSearched = true
            tableView.reloadData()
            
        }
        
    }
    
    func showCustomAlert(with text: String){
        
        let customAlert = UIAlertController(title: "Your attention please", message: text, preferredStyle: .alert)
        customAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(customAlert, animated: true, completion: nil)
    }
    
}

