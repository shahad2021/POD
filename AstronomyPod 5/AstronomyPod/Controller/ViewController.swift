import UIKit


class ViewController: UIViewController {

    var isFavourite: Bool = false {
        didSet {
            updateFavouriteImage()
        }
    }

    private func updateFavouriteImage() {
        let normalImage = UIImage(named: isFavourite ? "favourite" : "unfavourite")
        favouriteButton.setImage(normalImage, for: .normal)
        if isFavourite, let pic = self.pictureOfTheDay {
            DataManager.shared.saveImages(pictire: pic)
        } else if let url = self.pictureOfTheDay?.hdurl {
            DataManager.shared.deleteImages(index: url)
        }
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
        label.text = "Favourites"
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .right
        label.textColor = .white
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showImagesAction))
        label.addGestureRecognizer(tapGesture)
        label.isUserInteractionEnabled = true
        label.widthAnchor.constraint(equalToConstant: 120).isActive = true
        return label
    }()
    

    @objc func showImagesAction() {
        let secondViewController = FavouriteViewController()
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    lazy var imageReceived: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    

    
    lazy var favouriteButton: UIButton = {
        let view = UIButton(type: .custom)
        // Set button image for normal state
        let normalImage = UIImage(named: "unfavourite")
        view.setImage(normalImage, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 44),
            view.widthAnchor.constraint(equalToConstant: 44)
        ])
        // Add a target action for button tap event
        view.addTarget(self, action: #selector(favouritebuttonTapped), for: .touchUpInside)

        return view
    }()


    @objc func favouritebuttonTapped() {
        isFavourite.toggle()
    }

    lazy var goToDescriptionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
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
        view.addSubview(activityIndicator)
        view.addSubview(imageReceived)
        view.addSubview(imageTitle)
        view.addSubview(goToDescriptionButton)
        view.addSubview(favouriteButton)
        view.addSubview(showListOfImagesLabel)
        navigationController?.isNavigationBarHidden = true
        
        
        imageReceived.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageReceived.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageReceived.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageReceived.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
        showListOfImagesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12).isActive = true
        showListOfImagesLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true

        favouriteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        favouriteButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18).isActive = true
        
        imageTitle.leadingAnchor.constraint(equalTo: favouriteButton.trailingAnchor, constant: 12).isActive = true
        imageTitle.trailingAnchor.constraint(equalTo: showListOfImagesLabel.leadingAnchor, constant: -12).isActive = true
        imageTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
        
        goToDescriptionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        goToDescriptionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        goToDescriptionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 8).isActive = true
        
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        requestImageFile()
        disableOrEnableUIElements(isDisabled: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        updateFavourite()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    private func updateFavourite() {
        let urls = DataManager.shared.getImages().compactMap { $0.url }
        if let url = self.pictureOfTheDay?.hdurl, urls.contains(url) {
            isFavourite = true
        } else {
            isFavourite = false
        }
    }
    
    //MARK: - Request Image File and Set title
    
    func requestImageFile() {
        activityIndicator.startAnimating()
        NetworkManager.shared.fetchImageOfTheDay { model in
            NetworkManager.shared.getPlanetaryImage(for: model?.hdurl.absoluteString ?? "") { planetImage in
                    DispatchQueue.main.async { [weak self] in
                        self?.activityIndicator.stopAnimating()
                        self?.imageReceived.image = planetImage
                        if let model = model, let data = planetImage?.pngData() {
                            self?.pictureOfTheDay = AstronomyPicture(explanation: model.explanation, hdurl: model.hdurl, mediaType: model.mediaType, title: model.title, data: data)
                        }
                        self?.disableOrEnableUIElements(isDisabled: false)
                    }
                }
        }
    }

    private func disableOrEnableUIElements(isDisabled: Bool) {
        favouriteButton.isUserInteractionEnabled = !isDisabled
        goToDescriptionButton.isUserInteractionEnabled = !isDisabled
        showListOfImagesLabel.isUserInteractionEnabled = !isDisabled
    }
    
    @objc func goToDescriptionIsTapped() {
        let secondViewController = SecondViewController()
        secondViewController.pictureOfTheDay = pictureOfTheDay
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
}

