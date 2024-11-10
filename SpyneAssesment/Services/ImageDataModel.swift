//
//  ImageDataModel.swift
//  SpyneAssesment
//
//  Created by Sree Lakshman on 10/11/24.
//

import Foundation
import RealmSwift

class ImageDataModel: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var imageName: String = ""
    @Persisted var imageURI: String?
    @Persisted var captureDate: Date = Date()
    @Persisted var uploadStatus: String = "Pending"
}
