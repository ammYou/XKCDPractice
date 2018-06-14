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
        //viewModel.imageUrl.asDriver().drive(onNext:{[weak self](url) in
        })
    }
    
}
