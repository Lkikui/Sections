//
//  FormVCDelegate.swift
//  Sections
//
//  Created by Lisa Ryland on 1/28/18.
//  Copyright © 2018 Lisa Ryland. All rights reserved.
//

import UIKit

protocol FormVCDelegate {
    func quoteSaved(by controller: FormVC, quote: String, quoteAuthor: String, at indexPath: IndexPath?)
    func cancelButtonPressed(by controller: FormVC)
}
