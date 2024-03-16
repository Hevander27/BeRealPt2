//
//  CommentCell.swift
//  BeReal.Pt2
//
//  Created by Admin on 3/15/24.
//

import Foundation
import UIKit

class CommentCell: UITableViewCell {

    
    var comment: Comments? {
        didSet {
            configure()
        }
    }

    
    private var usernameLabel = UILabel()
    private var commentLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        let stack = UIStackView(arrangedSubviews: [usernameLabel, commentLabel])
        addSubview(stack)
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        
        usernameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        commentLabel.font = UIFont.systemFont(ofSize: 12)
        
    }
    
    func configure() {
        if let comment = comment {
            usernameLabel.text = comment.username
            commentLabel.text = comment.comment
        }
    }
}
