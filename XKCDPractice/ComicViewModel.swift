//
//  ViewModel.swift
//  XKCDPractice
//
//  Created by AmamiYou on 2018/06/11.
//  Copyright © 2018年 AmamiYou. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ComicViewModel {
    var title: Variable<String>//漫画タイトル
    var date: Variable<String>//日付
    var imageUrl: Variable<URL?>//漫画URL
    
    var latestComicNum: Variable<Int?>//次の漫画の番号
    var currentComic: Variable<Comic?>//現在の漫画情報
    
    var isNextEnabled: Driver<Bool>
    var isPreviousEnabled: Driver<Bool>
    
    private var formatter = DateFormatter()
    private var service = ComicService()
    
    var dispose = DisposeBag()
    
    init() {
        self.title = Variable<String>("")
        self.date = Variable<String>("")
        self.imageUrl = Variable<URL?>(nil)
        self.latestComicNum = Variable<Int?>(nil)
        self.currentComic = Variable<Comic?>(nil)
        self.formatter.dateStyle = .long
        self.formatter.timeStyle = .none
        
//        次のページがあるか
        isNextEnabled = Driver.combineLatest(self.latestComicNum.asDriver(), self.currentComic.asDriver(), resultSelector:{(latestNum, current)-> Bool in
            guard let latestNum = latestNum, let currentNum = current?.num else {return false}
            return latestNum != currentNum
        }).distinctUntilChanged()
        
//       前のページがあるか
        isPreviousEnabled = currentComic.asDriver().map({
            (comic)-> Bool in
            guard let num = comic?.num else{return false}
            return num > 1
        }).distinctUntilChanged()
    }
    
//    漫画を取得する
    func getLatestComic() {
        self.service.getLatestComic().subscribe(onNext: {(comic) in
            guard let comic = comic else {return}
            self.latestComicNum.value = comic.num
            
            self.latestComicNum.value = comic.num
            self.updateViewModel(comic: comic)
        }).disposed(by: dispose)
    }
    
//    前のページを取得する
    func getPreviousComic(){
        guard let current = self.currentComic.value?.num, current > 0 else {
            return
        }//前のページがあるか
        self.service.getComic(page: current - 1).subscribe(onNext: {(comic) in
            guard let comic = comic else {return}//あったら前のページを今のページにする
            self.updateViewModel(comic: comic)//viewに通知
        }).disposed(by: dispose)
    }
    
//    次のページを取得する
    func getNextComic(){
        guard let current = self.currentComic.value?.num, let latest = self.latestComicNum.value, current < latest else {
            return
        }//次のページがあるか
        service.getComic(page: current + 1).subscribe(onNext:{(comic) in
            guard let comic = comic else {return}//あったら次のページを今のページにする
            self.updateViewModel(comic: comic)
        }).disposed(by: dispose)
    }
    
//    viewに通知
    private func updateViewModel(comic: Comic){//データを代入してviewに通知する
        self.currentComic.value = comic
        self.title.value = comic.title ?? ""
        
        if let urlString = comic.img, let url = URL(string: urlString){
            self.imageUrl.value = url
        }
        
        if let date = comic.date{
            self.date.value = formatter.string(from: date)
        }else{
            self.date.value = ""
        }
    }

}


