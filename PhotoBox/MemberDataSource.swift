//
//  MemberDataSource.swift
//  PhotoBox
//
//  Created by Jack Knight on 1/23/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

class MemberDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var members: [BasicProfile]?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let members = members else { return 0 }
        return members.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemberCell", for: indexPath) as! MemberCollectionViewCell
        if let membersArray = members {
            let member = membersArray[indexPath.row]
            cell.memberName.text = member.name
//            cell.memberPhotoImageView.image = member.profilePicURL
            
        }

        
        return cell
    }
    
    
}
