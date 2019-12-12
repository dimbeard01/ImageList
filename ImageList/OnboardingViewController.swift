//
//  OnboardingViewController.swift
//  ImageList
//
//  Created by Dima Surkov on 10.12.2019.
//  Copyright © 2019 Dima Surkov. All rights reserved.
//

import UIKit
import SnapKit

final class OnboardingViewController: UIViewController {
    
    // MARK: - Properties
    
    var imageURLList: [String] = [] {
        didSet {
            let imageListTableViewController = ImageListTableViewController()
            imageListTableViewController.onboardingViewController = self
            navigationController?.pushViewController(imageListTableViewController, animated: true)
        }
    }

    private lazy var fetchImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Далее", for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(fetchImageURL), for: .touchUpInside)
        return button
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.placeholder = "https://..."
        return textField
    }()
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Hello"
        view.backgroundColor = UIColor(displayP3Red: 142/255, green: 90/255, blue: 247/255, alpha: 1)
        makeLayout()
    }
    
    // MARK: - Support
    
    private func showAlert(with title: String) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
  
    // MARK: - Layout

    private func makeLayout() {
        view.addSubview(textField)
        view.addSubview(fetchImageButton)
        
        textField.snp.makeConstraints {
            $0.width.equalTo(300)
            $0.height.equalTo(30)
            $0.center.equalToSuperview()
        }
        
        fetchImageButton.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(10)
            $0.centerX.equalTo(textField.snp.centerX)
            $0.height.equalTo(40)
            $0.width.equalTo(200)
        }
    }
    
    // MARK: - Action

    @objc private func fetchImageURL() {
        guard let stringTextField = textField.text else { return }
        
        guard let url = URL(string: stringTextField) else { return }
        let htmlFromURL = try? String(contentsOf: url, encoding: .utf8)
        
        if let html = htmlFromURL {
            Network.shared.fetchImageURL(stringURL: html) { [weak self] (model) in
                guard let model = model else {return}
                
                if model.isEmpty {
                    self?.showAlert(with: "Страница не содержит изображений")
                } else {
                    DispatchQueue.main.async {
                        self?.imageURLList = model
                    }
                }
            }
        } else {
            self.showAlert(with: "Некорректная ссылка")
        }
    }
}
