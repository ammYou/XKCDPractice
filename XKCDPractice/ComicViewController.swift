//
//  ComicViewController.swift
//  XKCDPractice
//
//  Created by AmamiYou on 2018/06/11.
//  Copyright © 2018年 AmamiYou. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class ComicViewController: UIViewController {
    @IBOutlet weak var comicView: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var downLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var viewModel = ComicViewModel()
    var dispose = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.title.asDriver().drive(self.topLabel.rx.text).disposed(by: dispose)
        viewModel.imageUrl.asDriver().drive(onNext:{[weak self](url) in
            self?.comicView.kf.setImage(with: url)
        }).disposed(by: dispose)
        viewModel.date.asDriver().drive(self.downLabel.rx.text).disposed(by: dispose)
        viewModel.isNextEnabled.drive(nextButton.rx.isEnabled).disposed(by: dispose)
        viewModel.isPreviousEnabled.drive(backButton.rx.isEnabled).disposed(by: dispose)
        
        nextButton.rx.tap.asDriver().drive(onNext:{
            self.viewModel.getNextComic()
        }).disposed(by: dispose)
        
        backButton.rx.tap.asDriver().drive(onNext:{
            self.viewModel.getPreviousComic()
        }).disposed(by: dispose)
        
        viewModel.getLatestComic()
    }
    
}
