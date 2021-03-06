//
//  FirebaseStorable.swift
//  PhotoBox
//
//  Created by Steve Lederer on 1/25/19.
//  Copyright © 2019 Steve Lederer. All rights reserved.
//

import Foundation
import FirebaseStorage

protocol FirebaseStorable {
    var data: Data { get }
    var uuid: String { get }
    static var CollectionName: String { get }
}

extension FirebaseStorable {
    var storageReference: StorageReference {
        return Storage.storage().reference().child(Self.CollectionName)
    }
}
