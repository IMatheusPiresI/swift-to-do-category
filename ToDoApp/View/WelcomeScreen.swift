//
//  WelcomeScreen.swift
//  ToDoApp
//
//  Created by Matheus Sousa on 29/07/23.
//

import UIKit


protocol WelcomeScreenDelegate: AnyObject {
    func tappedFirstCategoryButton()
}

class WelcomeScreen: UIView {
    
    private weak var delegate: WelcomeScreenDelegate?
    
    public func delegate(delegate: WelcomeScreenDelegate?) {
        self.delegate = delegate
    }
    
    lazy var containerCenterView: UIStackView = {
        let stack = UIStackView()
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 26
        stack.alignment = .fill
        
        stack.addArrangedSubview(titleAppLabel)
        stack.addArrangedSubview(welcomeImageView)
        stack.addArrangedSubview(welcomeLabel)
        stack.addArrangedSubview(presentationLabel)
        stack.addArrangedSubview(createFirstCategoryButton)
        
        return stack
    }()
    
    lazy var titleAppLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = K.Texts.appName
        label.textColor = .primary
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 28)
        
        return label
    }()
    
    lazy var welcomeImageView: UIImageView = {
        let image = UIImageView()
        
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: K.Images.welcome)
        image.contentMode = .scaleAspectFit
        
        return image
    }()
    
    lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = K.Texts.welcome
        label.textColor = .primary
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        return label
    }()
    
    lazy var presentationLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = K.Texts.presentation
        label.textColor = .primary
        label.textAlignment = .justified
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var createFirstCategoryButton: UIButton = {
        let button = UIButton()
       
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(K.Texts.firstCategory, for: .normal)
        button.backgroundColor = .primary
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.clipsToBounds = true
        button.layer.cornerRadius = 12
        button.addOpacityEffect()
        button.addTarget(self, action: #selector(tappedFirstCategoryButton), for: .touchUpInside)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(containerCenterView)
        
        self.configConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tappedFirstCategoryButton() {
        self.delegate?.tappedFirstCategoryButton()
    }
    
    func configConstraints() {
        NSLayoutConstraint.activate([
            self.containerCenterView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.containerCenterView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.containerCenterView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.containerCenterView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            self.titleAppLabel.leadingAnchor.constraint(equalTo: self.containerCenterView.leadingAnchor),
            self.titleAppLabel.trailingAnchor.constraint(equalTo: self.containerCenterView.trailingAnchor),
            
            self.welcomeImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 200),
            self.welcomeImageView.leadingAnchor.constraint(equalTo: self.containerCenterView.leadingAnchor),
            self.welcomeImageView.trailingAnchor.constraint(equalTo: self.containerCenterView.trailingAnchor),
            self.welcomeImageView.topAnchor.constraint(equalTo: self.titleAppLabel.bottomAnchor, constant: 26),
            
            self.createFirstCategoryButton.leadingAnchor.constraint(equalTo: self.containerCenterView.leadingAnchor),
            self.createFirstCategoryButton.trailingAnchor.constraint(equalTo: self.containerCenterView.trailingAnchor),
            self.createFirstCategoryButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
