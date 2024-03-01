import UIKit
import SnapKit

class ViewController: UIViewController {
    
    var timer:Timer?
    var maxTime : Float = 31
    var score: Int = 0 {
            didSet {
                scoreLabel.text = "Score: \(score)"
            }
        }
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Math buster"
        label.font = .systemFont(ofSize: 30,weight: .bold)
        label.textColor = .myGreen
        return label
    }()
    lazy var scoreLabel : UILabel = {
        let label = UILabel()
        label.text = "Score:0"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .myGreen
        return label
    }()
    
    lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.text = "🤡"
        label.font = .systemFont(ofSize: 30)
        return label
    }()
    
    lazy var equationLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 35, weight: .semibold)
        label.textColor = .myGreen
//        label.text = "1+1"
        return label
    }()
    lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.progressTintColor = .init(UIColor(red: 79/255, green: 111/255, blue: 82/255, alpha: 1))
        view.setProgress(0.0, animated: true)
        return view
    }()//
    lazy var resultField : UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "Result"
        field.textAlignment = .center
        field.font = UIFont.systemFont(ofSize: 25)
        field.widthAnchor.constraint(equalToConstant: 370).isActive = true
        field.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return field
    }()
    
    lazy var submitButton : UIButton = {
        let button = UIButton()
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .init(UIColor(red: 79/255, green: 111/255, blue: 82/255, alpha: 1))
        button.layer.cornerRadius = 20
        button.widthAnchor.constraint(equalToConstant: 370).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.addTarget(self, action: #selector(checkAnswers), for: .touchUpInside)
        return button
    }()
    
    lazy var segmentControl : UISegmentedControl = {
        let view = UISegmentedControl(items:["Eazy😃","Medium🤔","Hard🥵"])
        view.selectedSegmentIndex = 0
        return view
    }()
    lazy var restartButton: UIButton = {
        let button = UIButton()
        button.setTitle("Restart", for: .normal)
        button.setTitleColor(.myGreen, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.addTarget(self, action: #selector(restartTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var timeLabel : UILabel = {
        let label = UILabel()
        label.text = "00 : 0"
        label.font = .systemFont(ofSize: 35, weight: .semibold)
        label.textColor = .myGreen
        return label
    }() //
    
    lazy var timeField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.textAlignment = .center
        field.font = UIFont.systemFont(ofSize: 25)
        let transparentGreen = UIColor.myGreen.withAlphaComponent(0.2)
        field.backgroundColor = transparentGreen
        field.widthAnchor.constraint(equalToConstant: 370).isActive = true
        field.heightAnchor.constraint(equalToConstant: 70).isActive = true
        field.isUserInteractionEnabled = false
        return field
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(red: 236/265, green: 227/255, blue: 206/255, alpha: 1)
        setUi()
        startTime()
    }
    
    func setUi() {
        view.addSubview(nameLabel)
        view.addSubview(segmentControl)
        view.addSubview(scoreLabel)
        view.addSubview(emojiLabel)
        view.addSubview(equationLabel)
        view.addSubview(timeField)
        view.addSubview(resultField)
        view.addSubview(submitButton)
        view.addSubview(restartButton)
        timeField.addSubview(timeLabel)
        timeField.addSubview(progressView)
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(150)
            make.centerX.equalToSuperview()
        }
        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(40)
        }
        scoreLabel.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        emojiLabel.snp.makeConstraints { make in
            make.top.equalTo(scoreLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        equationLabel.snp.makeConstraints { make in
            make.top.equalTo(emojiLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        timeField.snp.makeConstraints { make in
            make.top.equalTo(equationLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        timeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
        }
        progressView.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(12)
        }
        resultField.snp.makeConstraints { make in
            make.top.equalTo(timeField.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(resultField.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        restartButton.snp.makeConstraints { make in
            make.top.equalTo(submitButton.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
    func startTime() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(run), userInfo: nil, repeats: true)
    }
    @objc func run() {
        self.maxTime -= 1
        if self.maxTime == 0 {
            timer?.invalidate()
        }
        self.progressView.setProgress(Float(1 - self.maxTime/30), animated: true)
        
        let minutes = Int(maxTime) / 60
        let seconds = Int(maxTime) % 60
        timeLabel.text = String(format: "%02d : %02d", minutes, seconds)
    }
    @objc func restartTapped() {
        let randomSign = ["+", "-", "*", "/"].randomElement()!
        let firstRandom = Int.random(in: 0...9)
        let secondRandom = Int.random(in: 0...9)
        equationLabel.text = "\(firstRandom) \(randomSign) \(secondRandom)"
        resetTimer()
        generateNewEquation()
    }
    @objc func checkAnswers() {
            guard let userAnswer = resultField.text,
                  let equationText = equationLabel.text else {
                return
            }

            let correctAnswer = evaluateMathExpression(equationText)

            if userAnswer == String(correctAnswer) {
                score += 1
            } else {
                print("Incorrect!")
            }
            generateNewEquation()
        }


    func generateNewEquation() {
            let randomSign = ["+", "-", "*", "/"].randomElement()!
            let firstRandom = Int.random(in: 0...9)
            let secondRandom = Int.random(in: 0...9)
            equationLabel.text = "\(firstRandom) \(randomSign) \(secondRandom)"
        }


    func evaluateMathExpression(_ expression: String) -> Int {
        let expressionArray = expression.components(separatedBy: " ")
        
        guard expressionArray.count == 3,
              let firstInt = Int(expressionArray[0]),
              let secondInt = Int(expressionArray[2]) else {
            return 0
        }
        // 219...226 с gpt так как вообще не получалось сделать свитч но я посмотрел оббяснение и вроде как понял
        let operation = expressionArray[1]
        
        switch operation {
        case "+":
            return firstInt + secondInt
        case "-":
            return firstInt - secondInt
        case "*":
            return firstInt * secondInt
        case "/":
            return firstInt / secondInt
        default:
            return 0
        }
    }
    func resetTimer() {
            timer?.invalidate()
            maxTime = 31
            progressView.setProgress(0.0, animated: false)
            score = 0
            startTime()
        }
    
}

extension UIColor {
    static let myGreen = UIColor(red: 79/255, green: 111/255, blue: 82/255, alpha: 1)
    static let myBiege = UIColor.init(red: 236/255, green: 227/255, blue: 206/255, alpha: 1)
}
