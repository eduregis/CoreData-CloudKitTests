//
//  ViewController.swift
//  CoreDataTests
//
//  Created by Eduardo Oliveira on 13/10/20.
//

import UIKit
import CoreData

class MangakaViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.title = "Mangakás"
    }
    
    var mangakas: [Mangaka] = []
    var selectedMangaka: Mangaka? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadMangakaData()
    }
    
    @IBAction func addButton(_ sender: Any) {
        let firstAlert = UIAlertController(title: "Nome do mangaká:",
                                           message: "Nome do mangaká",
                                           preferredStyle: .alert)
        
        let firstAlertCancelButton = UIAlertAction(title: "Cancelar",
                                                   style: .default)
        
        let firstAlertNextButton = UIAlertAction(title: "Próximo", style: .default) { [unowned self] action in
            if let mangakaName = firstAlert.textFields?.first?.text {
                
                if let mangaka = NSEntityDescription.insertNewObject(forEntityName: "Mangaka", into:  DatabaseController.persistentContainer.viewContext) as? Mangaka {
                    mangaka.name = mangakaName
                    DatabaseController.saveContext()
                    self.reloadMangakaData()
                }
            }
        }
        
        firstAlert.addTextField()
        firstAlert.addAction(firstAlertCancelButton)
        firstAlert.addAction(firstAlertNextButton)
        
        self.present(firstAlert, animated: true)
    }
    
    func reloadMangakaData() {
        do {
            if let mangakas = try DatabaseController.persistentContainer.viewContext.fetch(Mangaka.fetchRequest()) as? [Mangaka] {
                self.mangakas = mangakas
            }
        } catch {
            print("Erro no banco, não conseguiu realizar a busca")
        }
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let grapeToBeDeleted = mangakas[indexPath.row]
            self.mangakas.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            DatabaseController.persistentContainer.viewContext.delete(grapeToBeDeleted)
            DatabaseController.saveContext()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mangakas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath)
        let mangaka = mangakas[indexPath.row]
        cell.textLabel?.text = mangaka.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMangaka = mangakas[indexPath.row]
        performSegue(withIdentifier: "MangaViewSegue", sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tableVC = segue.destination as? MangaTableViewController {
            tableVC.mangaka = selectedMangaka
        }
    }
}

