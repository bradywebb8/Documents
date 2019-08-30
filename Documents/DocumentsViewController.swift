//
//  DocumentsViewController.swift
//  Documents
//
//  Created by Brady Webb on 8/28/19.
//  Copyright © 2019 Brady Webb. All rights reserved.
//

import UIKit
import CoreData

class DocumentsViewController: UIViewController {
    
    @IBOutlet weak var documentsTableView: UITableView!
    
    var documents: [Document] = []
    let dateFormatter = DateFormatter()
    
    let searchController = UISearchController(searchResultsController: nil)
    var selectedScope = SearchScope.all
    
    override func viewDidLoad() {
        super.viewDidLoad()
        documentsTableView.dataSource = self
        documentsTableView.delegate = self
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Documents"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.scopeButtonTitles = SearchScope.titles
    }
    func getDocuments(with query: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Document>(entityName: "Document")
        do {
            if query != "" {
                switch selectedScope {
                case .all:
                    fetchRequest.predicate = NSPredicate(format: "name contains[c] %@ OR content contains[c] %@", query, query)
                case .name:
                    fetchRequest.predicate = NSPredicate(format: "name contains[c] %@", query)
                case.content:
                    fetchRequest.predicate = NSPredicate(format:"content contains[c] %@", query)
                }
            }
            documents = try context.fetch(fetchRequest)
            documentsTableView.reloadData()
        } catch {
            print("Failed to fetch document data: \(error.localizedDescription)")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension DocumentsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "documentCell", for: indexPath) as! DocumentsTableViewCell
        let document = documents[indexPath.row]
        cell.nameLabel.text = document.name
        cell.sizeLabel.text = "\(document.size) bytes"
        cell.timeLabel.text = "Modified: \(dateFormatter.string(from: document.lastModified!))"
        return cell
    }
}
extension DocumentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            let document = self.documents[indexPath.row]
            do {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                context.mergePolicy = NSOverwriteMergePolicy
                context.delete(document)
                try context.save()
                self.documents.remove(at: indexPath.row)
                success(true)
                self.documentsTableView.reloadData()
            } catch {
                print("Failed to delete document: \(error.localizedDescription)")
                success(false)
            }
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
extension DocumentsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        getDocuments(with: searchController.searchBar.text ?? "")
    }
}
extension DocumentsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.selectedScope = SearchScope.scopes[selectedScope]
        if let searchTerm = searchBar.text {
            getDocuments(with: searchTerm)
        }
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
