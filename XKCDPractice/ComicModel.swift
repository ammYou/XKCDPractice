//
//  Model.swift
//  XKCDPractice
//
//  Created by AmamiYou on 2018/06/11.
//  Copyright © 2018年 AmamiYou. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire


struct ComicService {
    let latestURL = "https://xkcd.com/info.0.json"
    let comicURL:(Int) -> String = {
        "https://xkcd.com/\($0)/info.0.json"
    }
    
    func comicFromJson(json: Any) -> Comic? {
        if let dict = json as? [String: AnyObject]{
            return Comic(dict)
        }
        return nil
    }
    
    func getLatestComic() -> Observable<Comic?>{
        return RxAlamofire.requestJSON(.get, latestURL)
            .map{_, json in self.comicFromJson(json: json)}
        
    }
    
    func getComic(page: Int) -> Observable<Comic?>{
        print(comicURL(page))
        return  RxAlamofire.requestJSON(.get, comicURL(page))
            .map{_, json in self.comicFromJson(json: json)}
    }
}
