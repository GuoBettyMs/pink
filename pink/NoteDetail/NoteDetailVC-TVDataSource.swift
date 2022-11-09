//
//  NoteDetailVC-TVDataSource.swift
//  pink
//
//  Created by gbt on 2022/11/8.
//
/*
    详细笔记页面中,tableViewcell(对评论的回复view) 数据源
 */
import Foundation

extension NoteDetailVC: UITableViewDataSource{
    
    //评论个数,相当于Sections个数
    func numberOfSections(in tableView: UITableView) -> Int {
        comments.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kReplyCellID, for: indexPath)
        cell.textLabel?.text = "对评论的回复"
        return cell
    }
    
    
}
