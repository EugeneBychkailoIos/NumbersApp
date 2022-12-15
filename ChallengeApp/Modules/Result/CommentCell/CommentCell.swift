//
//  CommentCell.swift
//  ChallengeApp
//
//  Created by jekster on 13.12.2022.
//

import UIKit
import SnapKit

class CommentCell: UITableViewCell, Reusable {
    
    private let containerView = UIView()
    private let idTitle = UILabel()
    private let titleLabel = UILabel()
    private let bodyLabel = UILabel()
    private var separatorView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonInit()
        self.selectionStyle = .none
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(idTitle)
        containerView.addSubview(titleLabel)
        containerView.addSubview(bodyLabel)
        containerView.addSubview(separatorView)
        
        containerView.backgroundColor = UIColor.white
        separatorView.backgroundColor = UIColor.black
        idTitle.textColor = UIColor.red
        titleLabel.textColor = UIColor.black
        bodyLabel.textColor = UIColor.black
        
        titleLabel.numberOfLines = 0
        bodyLabel.numberOfLines = 0
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        idTitle.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        idTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(idTitle.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        bodyLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(32)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        separatorView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.leading.equalToSuperview().offset(32)
            $0.height.equalTo(1)
        }
    }
    
    func configureCell(with item: Post) {
        idTitle.text = String(item.postId)
        titleLabel.text = item.name
        bodyLabel.text = item.body
    }
    
}
