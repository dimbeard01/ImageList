//
//  ImageListTableViewController.swift
//  ImageList
//
//  Created by Dima Surkov on 10.12.2019.
//  Copyright © 2019 Dima Surkov. All rights reserved.
//

import UIKit

final class ImageListTableViewController: UITableViewController {
    
    // MARK: - Properties

    var onboardingViewController: OnboardingViewController?
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    // MARK: - Support

    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(ImageTableViewCell.self, forCellReuseIdentifier: ImageTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = onboardingViewController?.imageURLList else { return 0 }
        return model.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.identifier, for: indexPath) as? ImageTableViewCell else { return UITableViewCell() }

        guard let model = onboardingViewController?.imageURLList else { return UITableViewCell() }
        cell.configure(with: model[indexPath.row])
        return cell
    }
    
    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }

}
