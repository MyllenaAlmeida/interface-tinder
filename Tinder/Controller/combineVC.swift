import UIKit

enum Action{
    case like
    case deslike
}

class combineVC: UIViewController{
    
    var iconApp: UIButton = .iconMenu(named: "icone-perfil")
    var logoButton: UIButton = .iconMenu(named: "icone-logo")
    var chatButton: UIButton = .iconMenu(named:"icone-chat")
    var deslikeButton: UIButton = .iconFooter(named: "icone-deslike")
    var superLikeButton: UIButton = .iconFooter(named:"icone-superlike")
    var likebutton: UIButton = .iconFooter(named: "icone-like")
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor.systemGroupedBackground
        self.findUser()
        self.addFooter()
        self.addButtonHeader()
        
    }
    
    func findUser(){
        self.users = UserService.shared.findUsers()
        self.addCards()
        
    }
}


extension combineVC{
    func addButtonHeader(){
        
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        let top: CGFloat = window?.safeAreaInsets.top ?? 44
        let stackView = UIStackView(arrangedSubviews: [iconApp, logoButton, chatButton])
        stackView.distribution = .equalCentering
        view.addSubview(stackView)
        stackView.preencher(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom:nil,
                            padding: .init(top: 32, left: 16, bottom: 0, right: 16))
        
        
    }
    
    func addFooter(){
        let stackView = UIStackView(arrangedSubviews: [UIView(), deslikeButton, superLikeButton, likebutton, UIView()])
        stackView.distribution = .equalCentering
        view.addSubview(stackView)
        stackView.preencher(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor,
                            padding: .init(top: 0, left: 16, bottom: 34, right: 16))
    }
    
    
}

extension combineVC{
    func addCards(){
        
        for user in users{
            let card = cardView()
            card.frame = CGRect(x: 0 , y: 0, width: view.bounds.width - 32, height: view.bounds.height * 0.7)
            card.center = view.center
            card.user = user
            card.tag = user.id
            
            let gesture = UIPanGestureRecognizer()
            gesture.addTarget(self, action: #selector(handlerCard))
            card.addGestureRecognizer(gesture)
            
            view.insertSubview(card, at: 0)
            view.addSubview(card)
        }
        
    }
    
    func removeCard(card: UIView){
        card.removeFromSuperview()
        self.users = self.users.filter({ (user) -> Bool in
            return user.id != card.tag
        })
    }
}


extension combineVC {
    @objc func handlerCard(gesture: UIPanGestureRecognizer){
        if let card = gesture.view as? cardView{
            let point = gesture.translation(in: view)
            card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
            
            let rotationAngle = point.x / view.bounds.width * 0.4

            if point.x > 0{
                card.likeImageView.alpha = rotationAngle * 5
                card.deslikeImageView.alpha = 0
            } else {
                card.likeImageView.alpha = 0
                card.deslikeImageView.alpha = rotationAngle * 5 * -1
                
            }
            
            card.transform = CGAffineTransform(rotationAngle: rotationAngle)
            
            if gesture.state == .ended {
                if card.center.x > self.view.bounds.width + 50{
                    self.animaCard(rotationAngle: rotationAngle, action: .like)
                    return
                    
                }
                
                if card.center.x < -50 {
                    self.animaCard(rotationAngle: rotationAngle, action: .deslike)
                    return
                    
                }
                
                
                
                
                UIView.animate(withDuration: 0.2){
                    card.center = self.view.center
                    card.transform = .identity
                    card.likeImageView.alpha = 0
                    card.deslikeImageView.alpha = 0
                    
                }
                
            }
        
        }
        
    }
    func animaCard(rotationAngle:CGFloat, action: Action) {
        if let user = self.users.first{
            for view in self.view.subviews{
                if view.tag == user.id{
                    if let card = view as? cardView{
                        let center: CGPoint
                        switch action{
                        case .deslike:
                            center = CGPoint(x: card.center.x - self.view.bounds.width, y:card.center.y + 50 )
                        case .like:
                            center = CGPoint(x: card.center.x + self.view.bounds.width, y: card.center.y + 50)
                        }
                        UIView.animate(withDuration: 0.2, animations:{card.center = center
                            card.transform = CGAffineTransform(rotationAngle: rotationAngle)
                        }) { (_) in
                            self.removeCard(card: card)
                        }
                    }
                }
            }
            
        }
    }
}

