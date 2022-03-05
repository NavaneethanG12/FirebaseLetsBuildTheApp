import UIKit

class ScrollViewController: UIViewController{
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    let scrollViewContainer: UIStackView = {
        let container = UIStackView()
        container.axis = .vertical
        container.translatesAutoresizingMaskIntoConstraints = false
        container.spacing = 20
        return container
    }()
    
    let redView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let blueView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let greenView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.addSubview(scrollView)
        scrollViewContainer.addArrangedSubview(redView)
        scrollViewContainer.addArrangedSubview(blueView)
        scrollViewContainer.addArrangedSubview(greenView)
        scrollView.addSubview(scrollViewContainer)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            scrollViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        ])
        
        // this is very impoertant for scrolling
        scrollViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        redView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        blueView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        greenView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.addSubview(scrollView)
        
    }
}
