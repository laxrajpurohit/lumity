//
//  Protocol.swift
//  Source-App
//
//  Created by Nikunj on 11/04/21.
//

import Foundation


protocol SelectedIntrestDelegate: class {
    func getIntrestData(data: [InterestsListData])
}

protocol EnterNewPostDelegate: class {
    func uploadNewPost()
}

protocol DeleteGroupDelegate: class {
    func deleteGroup()
}

