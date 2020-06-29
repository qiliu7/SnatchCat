//
//  dataModel.swift
//  SnatchCat
//
//  Created by Kappa on 2020-05-25.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit

//enum Location {
//    case city(String)
//    case coordinate(Double, Double)
////    case postalCode(String)
//}

struct CatProfile {
    let cat: CatResult
    var photo: UIImage?
    
    // TODO: attributes 需要都转成string, attributes是不是需要做成dictionary 根据true、false的值显示？先有再完善吧。。。
    private enum attributeString: String {
        case vaccinationsUpToDate = "Vaccinations up-to-date"
        case houseTrained = "House-trained"
        case goodWithKids = "Good with kids"
        case goodWithCats = "Good with other cats"
        case goodWithDogs = "Goood with dogs"
        case spayedNeutered = "Spayed/neutered"
    }
    
    // tableView datasource
    //    var attributes {
    //        return
    //    }
    struct CatDetailAttributes {
        let breed: String
        let physicalCharacteristics: [String?]
        let health: String?
        let behavioral: [String?]
    }
    
    //    var whatever: [String: [String]?] {
    //        return [
    //            "breed": [cat.breeds.primary],
    ////            "physicalCharacteristics": []
    //        ]
    //    }
    var attributesDict: [String: [String]] {
        
        // TODO: needs refactor
        var shotsCurrentString: String?
        var spayedNeuteredString: String?
        var goodWithDogsString: String?
        var goodWithCatsString: String?
        var goodWithChildrenString: String?
        
        if let hadShots = cat.attributes.shotsCurrent {
            shotsCurrentString = hadShots ? attributeString.vaccinationsUpToDate.rawValue : nil
        }
        if let spayedNeutered = cat.attributes.spayedNeutered {
            spayedNeuteredString = spayedNeutered ? attributeString.spayedNeutered.rawValue : nil
        }
        if let goodWithDogs = cat.environment.dogs {
            goodWithDogsString = goodWithDogs ? attributeString.goodWithDogs.rawValue : nil
        }
        if let goodWithCats = cat.environment.cats {
            goodWithCatsString = goodWithCats ? attributeString.goodWithCats.rawValue : nil
        }
        if let goodWithChildren = cat.environment.children {
            goodWithChildrenString = goodWithChildren ? attributeString.goodWithKids.rawValue : nil
        }
        
        var dict: [String: [String]] = [
            "Breed": [cat.breeds.primary],
            "Physical": [cat.size, cat.gender, cat.age, cat.coat, cat.colors.primary].compactMap { $0 },
            "Health": [shotsCurrentString, spayedNeuteredString].compactMap { $0 },
            "Behavioral": [goodWithDogsString, goodWithCatsString, goodWithChildrenString].compactMap { $0 }
        ]
        
        dict = dict.filter({ return $0.value.count != 0 })
        return dict
        
    }
    
//    var attributes: CatDetailAttributes {
//        return CatDetailAttributes(breed: cat.breeds.primary, physicalCharacteristics: [cat.size, cat.gender, cat.age, cat.coat, cat.colors.primary], health: cat.attributes.shotsCurrent ?? false ? attributeString.vaccinationsUpToDate.rawValue : nil, behavioral: [cat.attributes.houseTrained ?? false ? attributeString.houseTrained.rawValue : nil, cat.environment.children ?? false ? attributeString.goodWithKids.rawValue : nil, cat.environment.cats ?? false ? attributeString.goodWithCats.rawValue: nil, cat.environment.dogs ?? false ? attributeString.goodWithDogs.rawValue : nil])
//    }
}




