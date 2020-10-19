//
//  TableViewController.swift
//  CoreDataTests
//
//  Created by Eduardo Oliveira on 13/10/20.
//

import UIKit
import CoreData

class MangaTableViewController: UITableViewController {

    var mangaka: Mangaka?
    var mangas: [Manga] = []
    
    @IBAction func editMangaka(_ sender: Any) {
        let firstAlert = UIAlertController(title: "Nome do mangaká:",
                                           message: "Nome do mangaká",
                                           preferredStyle: .alert)
        
        let firstAlertCancelButton = UIAlertAction(title: "Cancelar",
                                                   style: .default)
        
        let firstAlertNextButton = UIAlertAction(title: "Próximo", style: .default) { [unowned self] action in
            if let mangakaName = firstAlert.textFields?.first?.text {
                self.mangaka?.name = mangakaName
                DatabaseController.saveContext()
                self.reloadMangaData()
            }
        }
        
        firstAlert.addTextField()
        firstAlert.addAction(firstAlertCancelButton)
        firstAlert.addAction(firstAlertNextButton)

        self.present(firstAlert, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadMangaData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 62))
        let addMangaButton = UIButton(type: .contactAdd)
        addMangaButton.titleLabel?.font = .systemFont(ofSize: 32)
        addMangaButton.frame = CGRect(x: headerView.frame.size.width - 62, y: 0, width: 62, height: 62)
        addMangaButton.addTarget(self, action: #selector(addManga), for: .touchUpInside)
        let editMangaButton = UIButton()
        editMangaButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        editMangaButton.frame = CGRect(x: headerView.frame.size.width - 93, y: 0, width: 62, height: 62)
        editMangaButton.addTarget(self, action: #selector(removeManga), for: .touchUpInside)
        let label = UILabel(frame: CGRect(x: 31, y: headerView.frame.size.height/3, width: 200, height: 21))
        label.text = "Mangás: "
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
        headerView.addSubview(addMangaButton)
        headerView.addSubview(editMangaButton)
        headerView.addSubview(label)
        return headerView
    }
    
    @objc func addManga () {
        let firstAlert = UIAlertController(title: "Adicionar mangá",
                                           message: "Nome do mangá",
                                           preferredStyle: .alert)
        
        let firstAlertCancelButton = UIAlertAction(title: "Cancelar",
                                                   style: .default)
        
        let firstAlertNextButton = UIAlertAction(title: "Próximo", style: .default) { [unowned self] action in
            
            let secondAlert = UIAlertController(title: "Adicionar mangá",
                                                message: "Demografia",
                                                preferredStyle: .alert)
            
            let secondAlertCancelButton = UIAlertAction(title: "Cancelar",
                                                        style: .default)
            
            let secondAlertNextButton = UIAlertAction(title: "Próximo", style: .default) { [unowned self] action in
                if let mangaName = firstAlert.textFields?.first?.text {
                    if let mangaDemography = secondAlert.textFields?.first?.text {
                        if let manga = NSEntityDescription.insertNewObject(forEntityName: "Manga", into: DatabaseController.persistentContainer.viewContext) as? Manga {
                            manga.name = mangaName
                            manga.demography = mangaDemography
                            self.mangaka?.addToMangas(manga)
                            DatabaseController.saveContext()
                            self.reloadMangaData()
                        }
                    }
                }
            }
            
            secondAlert.addAction(secondAlertCancelButton)
            secondAlert.addAction(secondAlertNextButton)
            secondAlert.addTextField()
            
            self.present(secondAlert, animated: true)
        }
        
        firstAlert.addTextField()
        firstAlert.addAction(firstAlertCancelButton)
        firstAlert.addAction(firstAlertNextButton)
        
        self.present(firstAlert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 62
    }
    
    func reloadMangaData() {
        if let mangas = mangaka?.mangas {
            self.title = mangaka?.name
            self.mangas.removeAll()
            self.mangas = mangas.map({ $0 as! Manga })
        }
        self.tableView.reloadData()
    }
    
    @objc func removeManga() {
        if (self.tableView.isEditing) {
            self.tableView.setEditing(false, animated: true)
        } else {
            self.tableView.setEditing(true, animated: true)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mangas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath)
        let manga = mangas[indexPath.row]
        cell.textLabel?.text = manga.name
        cell.detailTextLabel?.text = manga.demography
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.mangas.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            if let manga = self.mangaka?.mangas?.allObjects[indexPath.row] as? Manga {
                self.mangaka?.removeFromMangas(manga)
                DatabaseController.persistentContainer.viewContext.delete(manga)
            }
            DatabaseController.saveContext()
            self.reloadMangaData()
        }
    }
}
