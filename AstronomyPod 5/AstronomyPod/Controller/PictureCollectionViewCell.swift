
import UIKit

class PictureCollectionViewCell: UICollectionViewCell {
    
    
    var model: AstronomyPictureModel? {
        didSet {
            updateUI()
        }
    }
 
    var favHandler: (()->())?
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
        configureAppearance()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var favImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "deleteIcon")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private lazy var favImageWrapper: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(favImage)
        NSLayoutConstraint.activate([
            favImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            favImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            favImage.heightAnchor.constraint(equalToConstant: 26),
            favImage.widthAnchor.constraint(equalToConstant: 22),
            view.heightAnchor.constraint(equalToConstant: 44.0),
            view.widthAnchor.constraint(equalToConstant: 44.0),
            
        ])
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(isFavorateAction))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    
    @objc func isFavorateAction() {
        favHandler?()
    }
    
    
    
    
    lazy var dailyImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "")
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = 12.0
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(favImageWrapper)
        NSLayoutConstraint.activate([
            favImageWrapper.topAnchor.constraint(equalTo: view.topAnchor, constant: 6),
            favImageWrapper.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -2),
        ])
        
        return view
    }()
    
    
    
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dailyImage)
        NSLayoutConstraint.activate([
            dailyImage.topAnchor.constraint(equalTo: view.topAnchor),
            dailyImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dailyImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dailyImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        ])
        return view
    }()
    
    
    func configureAppearance() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    func configureSubviews() {
        
      
        dailyImage.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
            
        ])
        
    }
    
    
    func updateUI() {
        if let data = model?.imageData {
        self.dailyImage.image = UIImage(data: data)
        }
        self.dailyImage.bringSubviewToFront(favImageWrapper)
    }
}
