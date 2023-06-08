
import UIKit

class FavouriteViewController: UIViewController {
    
    var pictures: [AstronomyPictureModel] = [] {
        didSet{
            collectionView.reloadData()
        }
    }

    func UpdateUI() {
        let data = DataManager.shared.getImages()
        pictures = data
        if pictures.count == 0{
            noItemTitle.isHidden = false
        }else{
            noItemTitle.isHidden = true
        }
    }
    
    private lazy var backButton: UIImageView = {
        let btn = UIImageView()
        btn.image = UIImage(named: "backarr")?.withTintColor(.black)
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

    private lazy var noItemTitle: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.text = "no item yet"
        view.textColor = UIColor.black
        view.font = UIFont.boldSystemFont(ofSize: 18.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.text = "Favourite Pictures"
        view.textColor = UIColor.black
        view.textAlignment = .left
        view.font = UIFont.boldSystemFont(ofSize: 22)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let  collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.backgroundColor = UIColor.white
        collectionview.register(PictureCollectionViewCell.self, forCellWithReuseIdentifier: "PictureCollectionViewCell")
        collectionview.showsVerticalScrollIndicator = false
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        return collectionview
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.backgroundColor = UIColor.black
        activityIndicator.layer.cornerRadius = 8.0
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UpdateUI()
        self.view.backgroundColor = UIColor.white
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        view.addSubview(noItemTitle)
        noItemTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        noItemTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        view.addSubview(backButtonWrapper)


        NSLayoutConstraint.activate([
            backButtonWrapper.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButtonWrapper.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            backButtonWrapper.heightAnchor.constraint(equalToConstant: 44),
            backButtonWrapper.widthAnchor.constraint(equalToConstant: 44),
            
            
            titleLabel.topAnchor.constraint(equalTo: backButtonWrapper.bottomAnchor, constant: 18),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),

            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 18),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12),

        ])
        
        DataManager.shared.getImages().forEach { img in
            print(img.title ?? "")
        }
        print(DataManager.shared.getImages().count)
        
    }

}


extension FavouriteViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictureCollectionViewCell", for: indexPath) as? PictureCollectionViewCell else {
            fatalError("crash")
        }
        let data =  self.pictures[indexPath.item]
        cell.model = data
        cell.favHandler = { [weak self] in
            if let url = data.url{
                DataManager.shared.deleteImages(index: url)
                self?.UpdateUI()
            }
        }
        
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let _ = collectionView.dequeueReusableCell(withReuseIdentifier: "PictureCollectionViewCell", for: indexPath) as? PictureCollectionViewCell else {
            fatalError("crash")
        }
        let data =  self.pictures[indexPath.item]
        
        let secondViewController = DetailViewController()
        secondViewController.pictureOfTheDay = AstronomyPicture(explanation: data.explanation ?? "", hdurl: data.url!, mediaType: "", title: data.title ?? "", data: data.imageData)

        self.navigationController?.pushViewController(secondViewController, animated: true)
        
    }
}

extension FavouriteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = self.view.bounds.size.width/2 - 24
        return CGSize(width: w, height: 180)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
    
}

