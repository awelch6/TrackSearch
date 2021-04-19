//
//  SearchTableViewCell.swift
//  TrackSearch
//
//  Created by Austin Welch on 4/16/21.
//

import UIKit
import SnapKit
import RxSwift

class SearchTableViewCell: UITableViewCell {
    
    private lazy var trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var genreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private let bag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func set(_ viewModel: SearchCellViewModel) {
        viewModel.output.artistText
            .observeOn(MainScheduler.instance)
            .bind(to: artistNameLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.output.trackNameText
            .observeOn(MainScheduler.instance)
            .bind(to: trackNameLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.output.releaseDateText
            .observeOn(MainScheduler.instance)
            .bind(to: releaseDateLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.output.genreText
            .observeOn(MainScheduler.instance)
            .bind(to: genreLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.output.priceText
            .observeOn(MainScheduler.instance)
            .bind(to: priceLabel.rx.text)
            .disposed(by: bag)
    }
}

// MARK: UI Setup

extension SearchTableViewCell {
    
    
    private func setContraints() {
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(8)
        }
        
        contentView.addSubview(trackNameLabel)
        trackNameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(8)
            make.left.equalToSuperview().inset(8)
            make.right.equalTo(priceLabel.snp.left)

        }
        
        contentView.addSubview(artistNameLabel)
        artistNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(trackNameLabel.snp.bottom)
            make.left.equalToSuperview().inset(8)
            make.right.equalTo(priceLabel.snp.left)
        }
        
        contentView.addSubview(releaseDateLabel)
        releaseDateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(artistNameLabel.snp.bottom)
            make.left.equalToSuperview().inset(8)
            make.right.equalTo(priceLabel.snp.left)

        }
        
        contentView.addSubview(genreLabel)
        genreLabel.snp.makeConstraints { (make) in
            make.top.equalTo(releaseDateLabel.snp.bottom)
            make.left.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8)
            make.right.equalTo(priceLabel.snp.left)
        }
    }
}
