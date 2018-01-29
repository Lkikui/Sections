//
//  QuoteVC.swift
//  Sections
//
//  Created by Lisa Ryland on 1/25/18.
//  Copyright © 2018 Lisa Ryland. All rights reserved.
//

import UIKit
import CoreData

class QuoteVC: UITableViewController, FormVCDelegate {
    
    var quoteBank = [Quote]()
    var favoritedQuotes = [Quote]()
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! FormVC
        let formVCController = controller
        formVCController.delegate = self
    }
    
    //MARK: fetch request
    func fetchAllItems() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Quote")
        request.returnsObjectsAsFaults = false
        request.sortDescriptors = [NSSortDescriptor(key: "isFavorited", ascending: true)]
        
        //quote bank (default)
        request.predicate = NSPredicate(format: "isFavorited == %@", NSNumber(value: false))
        do {
            let result = try managedObjectContext.fetch(request)
            quoteBank = result as! [Quote]
        } catch {
            print("\(error)")
        }
        
        //favorited quotes
        request.predicate = NSPredicate(format: "isFavorited == %@", NSNumber(value: true))
        do {
            let result = try managedObjectContext.fetch(request)
            favoritedQuotes = result as! [Quote]
        } catch {
            print("\(error)")
        }
        
        tableView.reloadData()
    }
    
    //MARK: protocol adherence
    func quoteSaved(by controller: FormVC, quote: String, quoteAuthor: String, at indexPath: IndexPath?) {
        // add new event
        let newQuote = NSEntityDescription.insertNewObject(forEntityName: "Quote", into: managedObjectContext) as! Quote
        newQuote.author = quoteAuthor
        newQuote.quote = quote
        newQuote.isFavorited = false //setting default
        quoteBank.append(newQuote)
        
        do {
            try managedObjectContext.save()
        } catch {
            print("\(error)")
        }

        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Remove item by swiping left
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        var quote: Quote
        
        if indexPath.section == 0 {
            quote = favoritedQuotes[indexPath.row]
        } else {
            quote = quoteBank[indexPath.row]
        }
        
        managedObjectContext.delete(quote)
        do {
            try managedObjectContext.save()
        } catch {
            print("\(error)")
        }
        
        tableView.reloadData()
        fetchAllItems()
    }
    
    func cancelButtonPressed(by controller: FormVC) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: toggle isFavorited on cell click
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var quote: Quote?
        
        if indexPath.section == 0 || quote?.isFavorited == true {
            quote = favoritedQuotes[indexPath.row]
            quote?.isFavorited = false
        } else if indexPath.section == 1 || quote?.isFavorited == false {
            quote = quoteBank[indexPath.row]
            quote?.isFavorited = true
        }
        
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print("Cannot save object: \(error), \(error.localizedDescription)")
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
        tableView.reloadRows(at: [indexPath], with: .none)
        fetchAllItems()
    }

    //MARK: number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    //MARK: number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { //section identifiers start with an index of 0
            return favoritedQuotes.count
        } else {
            return quoteBank.count
        }
    }
    
    //MARK: what to display in cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quoteCell", for: indexPath)
    
        if indexPath.section == 0 { // if first section
            cell.textLabel?.text = favoritedQuotes[indexPath.row].quote
            cell.detailTextLabel?.text = favoritedQuotes[indexPath.row].author
        } else { // if second section
            cell.textLabel?.text = quoteBank[indexPath.row].quote
            cell.detailTextLabel?.text = quoteBank[indexPath.row].author
        }
        
        return cell
    }
    
    
    //MARK: section titles
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sectionTitle = ["Favorite Quotes", "Quote Bank"]
        return sectionTitle[section]
    }

}

