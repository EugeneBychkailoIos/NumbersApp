//
//  ResultViewController.swift
//  ChallengeApp
//
//  Created by jekster on 12.12.2022.
//

import UIKit
import Combine
import SnapKit

final class ResultViewController: BaseViewController<ResultViewModel> {
    
    // MARK: - Private properties
    
    private var stateCancellable: Cancellable?
    
    private let containerView = UIView()
    private let tableView = UITableView()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        setupView()
        setupConstraints()
        super.viewDidLoad()
        viewModel.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.coordinateToBack()
    }
    
    override func observeViewModelState() {
        stateCancellable = viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] state in
                render(state)
            })
    }
    
    // MARK: - Private methods
    
    private func render(_ state: ResultViewModel.State) {
        switch state {
        case .idle:
//            debugPrint("idle")
            containerView.isHidden = false
        case .started:
            containerView.isHidden = false
//            debugPrint("started")
        }
    }
}

    // MARK: - Extensions

private extension ResultViewController {
    
    func setupView() {
        view.addSubview(containerView)
        containerView.addSubview(tableView)
        containerView.backgroundColor = UIColor.gray
        tableView.backgroundColor = UIColor.gray
        
        tableView.register(CommentCell.self)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.delegate = self
        tableView.dataSource = self
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaInsets.top).offset(16)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

extension ResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.date.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.identifier, for: indexPath) as? CommentCell else {
            return UITableViewCell()
        }
        
        let model = viewModel.date[indexPath.row]
            cell.configureCell(with: model)
        return cell
    }
    
}
