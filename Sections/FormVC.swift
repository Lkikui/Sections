//
//  FormVC.swift
//  Sections
//
//  Created by Lisa Ryland on 1/28/18.
//  Copyright © 2018 Lisa Ryland. All rights reserved.
//

import UIKit

class FormVC: UIViewController {
    
    @IBOutlet weak var quoteTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    
    var delegate: FormVCDelegate?
    var quoteText: String?
    var quoteAuthor: String?
    var isFavorite: Bool?
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quoteTextField.text = quoteText
        authorTextField.text = quoteAuthor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addQuoteButtonPressed(_ sender: UIButton) {
        print("form submitted")
        let quote = quoteTextField.text
        let quoteAuthor = authorTextField.text
        
        delegate?.quoteSaved(by: self, quote: quote!, quoteAuthor: quoteAuthor!, at: indexPath)
        print(quote!, quoteAuthor!)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        print("form cancelled")
        delegate?.cancelButtonPressed(by: self)
    }
    
}
