import UIKit


class cardView: UIView {
    
    
    var user: User?{
        didSet{
            if let user = user {
                backgroundImageView.image = UIImage(named: user.photo)
                nomeLabel.text = user.name
                idadeLabel.text = String(user.age)
                descriptionLabel.text = user.description
            }
        }
        
    }
    
    let backgroundImageView:UIImageView = .photoImageView()
    
    
    let nomeLabel: UILabel = .textBoldLabel(32,textColor: .white)
    let idadeLabel: UILabel = .textLabel(28, textColor: .white)
    let descriptionLabel: UILabel = .textLabel( 18, textColor: .white, numberOfLines: 2)
    let deslikeImageView:UIImageView = .iconCard(named: "card-deslike")
    let likeImageView: UIImageView = .iconCard(named: "card-like")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(backgroundImageView)
        addSubview(deslikeImageView)
        layer.borderWidth = 0.3
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 8
        clipsToBounds = true
        
        addSubview(likeImageView)
        likeImageView.preencher(top: topAnchor,
                                   leading: leadingAnchor,
                                   trailing: nil,
                                   bottom: nil,
                                   padding: .init(top: 20, left: 20, bottom: 0, right: 0))
        
        addSubview(deslikeImageView)
        deslikeImageView.preencher(top: topAnchor,
                                   leading: nil,
                                   trailing: trailingAnchor,
                                   bottom: nil,
                                   padding: .init(top: 20, left: 0, bottom: 0, right: 20))
        
        
        
        nomeLabel.addShadow()
        idadeLabel.addShadow()
        descriptionLabel.addShadow()
        
        backgroundImageView.preencherSuperview()
        
        let nameStackView = UIStackView(arrangedSubviews:[nomeLabel, idadeLabel, UIView()])
         nameStackView.spacing = 12
        
        let stackView = UIStackView(arrangedSubviews: [nameStackView, descriptionLabel])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical

        addSubview(stackView)
        stackView.preencher(
            top: nil, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, padding:.init(top: 0, left: 16, bottom: 16, right: 16) )
    }
    required init?(coder: NSCoder) {
       fatalError()
    }
}
