//
//  OptionCell.swift
//  ForDesign
//
//  Created by GIORGI PILISSHVILI on 28.08.22.
//

import UIKit

class OptionCell: UITableViewCell {
    
    @IBOutlet weak var labelOption: UILabel!
    @IBOutlet weak var buttonOption: UIButton!
    @IBOutlet weak var progress: UIProgressView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureDesign()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureDesign() {
        progress.layer.cornerRadius = 8
        progress.clipsToBounds = true
    }
    
    func configure(with poll: Poll.Option) {
        labelOption.text = poll.content
    }
    
}
