//
//  CommentViewController.swift
//  BeReal.Pt2
//
//  Created by Admin on 3/15/24.
//

import Foundation
import UIKit


class CommentViewController: UITableViewController {
    
    
    var post: Post {
        didSet {
            loadComments()
        }
    }
    
    var comments: [Comments]
    
    init(post: Post) {
        self.post = post
        self.comments = [Comments]()
        
        
        super.init(style: .plain)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CommentCell.self, forCellReuseIdentifier: "CommentCell")
        title = "Comments"
        
        let newCommentButton = UIButton(type: .custom)
        newCommentButton.setImage(UIImage(systemName: "note.text"), for: .normal)
        newCommentButton.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)

        let commentBar = UIBarButtonItem(customView: newCommentButton)

        navigationItem.rightBarButtonItem = commentBar
        
        loadComments()
        tableView.rowHeight = 65
    }
    
    func saveComment(comment: String) {
        var commentObj = Comments()
        commentObj.comment = comment
        if let username = post.user?.username {
            commentObj.username = username
        }
        
        post.comments?.append(commentObj)
        post.save { [weak self] result in
            switch result {
            case .success(let post):
                print("Success!")
                self?.post = post
            case .failure(let error):
               print("Comment Not Saved\n \(error)")
            }
        }
    }
    
    func loadComments() {
        print("INSIDE LOAD COMMENTS")
        if let comments = post.comments {
            print("INSIDE IF LET COMMENTS")
            self.comments = comments
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func handleCommentTapped() {
        print("HANDLE COMMENT TAPPED")
        
        let alertController = UIAlertController(title: "Type in a new comment", message: nil, preferredStyle: .alert)

        alertController.addTextField { (textField) in
            textField.placeholder = "Type here..."
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            if let textField = alertController.textFields?.first, let userInput = textField.text {
                self.saveComment(comment: userInput)
            }
        }

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        present(alertController, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentCell else {
            return UITableViewCell()
        }
        cell.comment = comments[indexPath.row]
        return cell
    }
    
}
