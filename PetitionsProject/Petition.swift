//
//  Petition.swift
//  PetitionsProject
//
//  Created by Rodrigo on 23-10-24.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
