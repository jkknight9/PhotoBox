//
//  MemberDataSource.swift
//  PhotoBox
//
//  Created by Jack Knight on 1/23/19.
//  Copyright © 2019 Steve Lederer. All rights reserved.
//

import UIKit

class MemberDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var members: [AppUser]? {
        didSet {
            guard let currentUser = UserController.shared.currentUser else { return }
            if let blockedUserIDs = currentUser.blockedUserIDs {
                for blockedUserID in blockedUserIDs {
                    members = members?.filter{ $0.uuid == blockedUserID }
                }
            }
        }
    }
    var eventCreatorID: String?
    
    var profilePics: [UIImage] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let members = members else { return 0 }
        return members.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemberCell", for: indexPath) as! MemberCollectionViewCell
        if let membersArray = members {
            let member = membersArray[indexPath.row]
            cell.memberName.text = member.name
            if member.uuid == eventCreatorID {
                cell.memberAdminLabel.alpha = 1.0
            } else {
                cell.memberAdminLabel.alpha = 0
            }
            PhotoController.shared.fetchProfileImages(for: member) { (image) in
                if let image = image {
                    DispatchQueue.main.async {
                        cell.memberPhotoImageView.image = image
                    }
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: "\(MembersHeaderView.self)",
                    for: indexPath) as? MembersHeaderView
                else {
                    fatalError("Invalid view type")
            }
            headerView.label.text = "Who's Here?"
            return headerView
        default:
            assert(false, "Invalid element type")
        }
        return UICollectionReusableView()
    }
    
}
