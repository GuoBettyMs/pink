//
//  ChannelTableVC.swift
//  pink
//
//  Created by isdt on 2022/9/26.
//
/*
    参与话题功能 -> 横屏Tab 控制器联动的视图控制器,选择话题cell
 */

import UIKit
import XLPagerTabStrip

class ChannelTableVC: UITableViewController {

    var channel = ""
    var subChannels: [String] = []
//    var subChannel = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //因tableView 默认显示空cell(有多余的横线),添加tableFooterView使tableView不显示空cell(横线)
        tableView.tableFooterView = UIView()
    }

    // MARK: -
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return subChannels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kSubChannelCellID, for: indexPath)
        cell.textLabel?.text = "# \(subChannels[indexPath.row])"
        cell.textLabel?.font = .systemFont(ofSize: 15)
        
        //再选择话题时,若已选择的话题与channelVC.subChannel相同,显示标记
        let channelVC = parent as! ChannelVC
        if subChannels[indexPath.row] == channelVC.subChannel{
            cell.accessoryType = .checkmark
        }
        return cell
    }

    // MARK: 遵守 Table view data source - 标记已选中的地址并传值到笔记编辑界面
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //标记已选中的话题
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = .checkmark
        
        //点击cell后将cell的channel、subChannels 传给 ChannelVC 子控制器
        let channelVC = parent as! ChannelVC
        channelVC.PVDelegate?.updateChannel(channel: channel, subChannel: subChannels[indexPath.row])
        
        //将选择的话题传给channelVC.subChannel
        channelVC.subChannel = subChannels[indexPath.row]

        //print(presentingViewController)
        //根据present及dismiss机制，子视图控制器的presentingViewController和父视图控制器一样（这里为NoteEditVC）
        //故这里用dimiss就等于是在父视图控制器中直接用dismiss
        dismiss(animated: true)
    }
}

extension ChannelTableVC: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        IndicatorInfo(title: channel)
    }
}
