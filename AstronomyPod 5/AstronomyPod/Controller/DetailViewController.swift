
import UIKit

class DetailViewController: UIViewController {
    
    
    private lazy var backButton: UIImageView = {
           let btn = UIImageView()
        btn.image = UIImage(named: "backarr")?.withTintColor(.white)
           btn.translatesAutoresizingMaskIntoConstraints = false
           return btn
       }()
       
       
       private lazy var backButtonWrapper: UIView = {
               let view = UIView()
               view.translatesAutoresizingMaskIntoConstraints = false
               view.addSubview(backButton)
               NSLayoutConstraint.activate([
                   backButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                   backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                   backButton.widthAnchor.constraint(equalToConstant: 11),
                   backButton.heightAnchor.constraint(equalToConstant: 16),
               ])
               view.isUserInteractionEnabled = true
               let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonAction(sender:)))
               view.addGestureRecognizer(tapGesture)
               return view
           }()
           
           @objc private func backButtonAction(sender: UITapGestureRecognizer) {
               self.navigationController?.popViewController(animated: true)
           }

    
    lazy var imageTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    lazy var showListOfImagesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.text = "SavedImages"
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .right
        label.textColor = .white
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showImagesAction))
        label.addGestureRecognizer(tapGesture)
        label.isUserInteractionEnabled = true
        return label
    }()
    

      @objc func showImagesAction() {
          let secondViewController = FavouriteViewController()
          
          self.navigationController?.pushViewController(secondViewController, animated: true)
     }
    
    lazy var favImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "notFav")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    lazy var imageReceived: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    private lazy var favImageWrapper: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(favImage)
        NSLayoutConstraint.activate([
            favImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            favImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            favImage.heightAnchor.constraint(equalToConstant: 24.0),
            favImage.widthAnchor.constraint(equalToConstant: 24.0),
            view.heightAnchor.constraint(equalToConstant: 44.0),
            view.widthAnchor.constraint(equalToConstant: 44.0),
        
        ])
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(isFavorateAction))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        return view
    }()
    
     
      @objc func isFavorateAction() {
         
              
     }

    lazy var goToDescriptionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Description", for: .normal)
        button.addTarget(self, action: #selector(goToDescriptionIsTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    var pictureOfTheDay: AstronomyPicture?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(imageReceived)
        view.addSubview(imageTitle)
        view.addSubview(goToDescriptionButton)
        view.addSubview(backButtonWrapper)
        
    
        imageReceived.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageReceived.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageReceived.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageReceived.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
        backButtonWrapper.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        backButtonWrapper.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        backButtonWrapper.heightAnchor.constraint(equalToConstant: 44).isActive = true
        backButtonWrapper.widthAnchor.constraint(equalToConstant: 44).isActive = true
        
        imageTitle.leadingAnchor.constraint(equalTo: backButtonWrapper.trailingAnchor, constant: 8).isActive = true
        imageTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        imageTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        
        goToDescriptionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        goToDescriptionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        goToDescriptionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 8).isActive = true

        if let data = pictureOfTheDay?.data {
            self.imageReceived.image = UIImage(data: data)
        }
        

    }
    
 
    
      @objc func goToDescriptionIsTapped() {
        let secondViewController = SecondViewController()
        secondViewController.pictureOfTheDay = pictureOfTheDay
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    }
    
  
