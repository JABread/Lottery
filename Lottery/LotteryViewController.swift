//
//  ViewController.swift
//  Lottery
//
//  Created by 张俊安 on 2018/5/25.
//  Copyright © 2018年 Jon.Zhang. All rights reserved.
//

import UIKit

class LotteryViewController: UIViewController {

    @IBOutlet private weak var bonusLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!

    private let lotteryVM = LotteryViewModel()

    private struct Constant {
        struct TableView {
            static let cellId = "LotteryCellId"
            static let cellHeight: CGFloat = 60.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupTableView()

        lotteryVM.bonus.bind { [unowned self] (bonus) in
            self.bonusLabel.text = "\(bonus) ￥"
        }

        lotteryVM.time.bind { [unowned self] (clock) in
            self.timeLabel.text = "\(clock)s"
            self.tableView.reloadData()
        }

        lotteryVM.start()

        let timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { [unowned self] (_) in
            self.lotteryVM.bet(22)
        }
        RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)

    }

    @IBAction func bet(_ sender: Any) {
        lotteryVM.bet(2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension LotteryViewController {

    private func setupUI() {
        title = "Lottery"
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constant.TableView.cellId)
    }
}

extension LotteryViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lotteryVM.shotRecords.value.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constant.TableView.cellHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.TableView.cellId) else {
            return UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: Constant.TableView.cellId)
        }

        let record = lotteryVM.shotRecords.value[indexPath.row]
        cell.textLabel?.text = "开奖期号：\(record.period)"

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lottery = lotteryVM.shotRecords.value[indexPath.row]
        let msg = """
                    一等奖: \(lottery.first)
                    二等奖: \(lottery.second)
                  """
        let alertVc = UIAlertController(title: "开奖期号: \(lottery.period)", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let gotAction = UIAlertAction(title: "Got it", style: UIAlertActionStyle.default, handler: nil)
        alertVc.addAction(gotAction)
        present(alertVc, animated: true, completion: nil)

    }

}









