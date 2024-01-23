//
//  DetailsTableViewCell.swift
//  finalTaskNiniJajanidze
//
//  Created by niniku on 19.01.24.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {
    
    static let identifier = "DetailsTableViewCell"
    
    // MARK: - Properties
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    private lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        
        return label
    }()
    
    private lazy var productQuantityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var productPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupViews() {
        
        selectionStyle = .none
        backgroundColor = .clear
        
        addSubview(productImageView)
        addSubview(productNameLabel)
        addSubview(productQuantityLabel)
        addSubview(productPriceLabel)
        
        productImageView.leadingToSuperview(offset: 16)
        productImageView.centerYToSuperview()
        productImageView.width(65)
        productImageView.height(60)
        
        productNameLabel.leadingToTrailing(of: productImageView, offset: 12)
        productNameLabel.trailingToLeading(of: productPriceLabel, offset: -12, relation: .equalOrLess)
        productNameLabel.centerYToSuperview(offset: -10)
        
        productQuantityLabel.leadingToTrailing(of: productImageView, offset: 12)
        productQuantityLabel.topToBottom(of: productNameLabel, offset: 4)
        
        productPriceLabel.trailingToSuperview(offset: 16)
        productPriceLabel.centerYToSuperview()
    }
    
    // MARK: - Function
    func configure(with product: Product, with quantity: Int) {
        productNameLabel.text = product.title
        productQuantityLabel.text = "\(quantity)"
        productPriceLabel.text = String(format: "$%.2f", Double(quantity) * product.price)
        if let url = URL(string: product.thumbnail) {
            productImageView.sd_setImage(with: url, completed: nil)
        }
    }
}
