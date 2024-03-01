import UIKit
import SnapKit

class ViewController2: UIViewController {
    lazy var button : UIButton = {
        let button = UIButton()
        button.setTitle("Start a game", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .myBiege
        title = "Welcome to the game"
        setUI()
    }
    @objc func buttonTapped() {
        navigationController?.pushViewController(ViewController(), animated: true)
    }
    func setUI () {
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
}
