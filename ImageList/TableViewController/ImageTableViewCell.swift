//
//  ImageTableViewCell.swift
//  ImageList
//
//  Created by Dima Surkov on 10.12.2019.
//  Copyright © 2019 Dima Surkov. All rights reserved.
//

import UIKit

final class ImageTableViewCell: UITableViewCell {
    
    // MARK: - Properties

    static let identifier: String = "identifier"

    private let webImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var linkButton: UIButton = {
        let link = UIButton(type: .system)
        link.titleLabel?.textColor = .blue
        link.titleLabel?.lineBreakMode = .byTruncatingTail
        link.titleLabel?.font = .systemFont(ofSize: 15, weight: .thin)
        link.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        return link
    }()
    
    private let imageSizeInKBLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 10, weight: .thin)
        return label
    }()
    
    private let imageSizeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 10, weight: .thin)
        return label
    }()
    
    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        makeLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public

    func configure(with url: String) {
        Network.shared.fetchImage(stringUrl: url) { [weak self] (model) in
            guard let model = model else { return }
            
            DispatchQueue.main.async {
                self?.webImage.image = model.image
                self?.linkButton.setTitle(model.link, for: .normal)
                self?.imageSizeInKBLabel.text = "\((model.size / 1000)) KB"
                self?.imageSizeLabel.text = "\(model.width) X \(model.height) пикс"
            }
        }
    }
    
    // MARK: - Layout

    private func makeLayout(){
        [webImage, linkButton, imageSizeInKBLabel, imageSizeLabel].forEach { contentView.addSubview($0) }

        webImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(linkButton.snp.top).offset(-5)
            $0.width.height.equalTo(150)
        }
        
        linkButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(5)
            $0.trailing.equalToSuperview().offset(-5)
            $0.bottom.equalTo(imageSizeInKBLabel.snp.top).offset(-5)
        }
        
        imageSizeInKBLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(5)
            $0.trailing.equalToSuperview().offset(-5)
            $0.bottom.equalTo(imageSizeLabel.snp.top).offset(-5)
        }
        
        imageSizeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(5)
            $0.trailing.equalToSuperview().offset(-5)
            $0.bottom.equalToSuperview().offset(-5)
        }
    }
    
    // MARK: - Action

    @objc private func didTap() {
        guard let url = URL(string: (linkButton.titleLabel?.text)!) else { return }
        UIApplication.shared.open(url)
    }
}
