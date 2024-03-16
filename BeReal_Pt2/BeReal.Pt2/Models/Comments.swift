//
//  Comments.swift
//  BeReal.Pt2
//
//  Created by Admin on 3/15/24.
//

import Foundation
import ParseSwift

struct Comments: ParseObject {    
   
    // These are required by ParseObject
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?
    

    var username: String?
    var comment: String?
    //var date: Double?
    

}
