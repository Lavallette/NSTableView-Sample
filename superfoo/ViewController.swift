//
//  ViewController.swift


import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var selectionLabel: NSTextField!
    
    var tableViewData: [Contract] = []
    
    let tableViewColumnNamesArray = [
        ["columnIdentifier":"conId","columnTitle":"ConId","columnType":"text","columnDefaultWidth":100, "columnMaxWidth":500,"columnMinWidth":50],
        ["columnIdentifier":"symbol","columnTitle":"Symbol","columnType":"text","columnDefaultWidth":100, "columnMaxWidth":500,"columnMinWidth":50],
        ["columnIdentifier":"secType","columnTitle":"secType","columnType":"text","columnDefaultWidth":100, "columnMaxWidth":500,"columnMinWidth":50],
        ["columnIdentifier":"exchange","columnTitle":"Exchange","columnType":"text","columnDefaultWidth":100, "columnMaxWidth":500,"columnMinWidth":50]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load test data
        tableViewData = createTestData()
        // Set up the tableView
        self.setTableColumns()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }
    
    func createTestData() -> Array<Contract> {
        // Create some fake contract
        return [
            Contract(p_conId: 1, p_symbol: "AAPL", p_secType: "STK", p_expiry: "", p_strike: 0, p_right: "", p_multiplier: "100", p_exchange: "SMART", p_currency: "USD", p_localSymbol: "", p_tradingClass: "", p_primaryExch: "", p_includeExpired: false, p_secIdType: "", p_secId: ""),
            Contract(p_conId: 2, p_symbol: "AMZN", p_secType: "STK", p_expiry: "", p_strike: 0, p_right: "", p_multiplier: "100", p_exchange: "SMART", p_currency: "USD", p_localSymbol: "", p_tradingClass: "", p_primaryExch: "", p_includeExpired: false, p_secIdType: "", p_secId: ""),
            Contract(p_conId: 3, p_symbol: "IBM", p_secType: "STK", p_expiry: "", p_strike: 0, p_right: "", p_multiplier: "100", p_exchange: "SMART", p_currency: "USD", p_localSymbol: "", p_tradingClass: "", p_primaryExch: "", p_includeExpired: false, p_secIdType: "", p_secId: "")
        ]
    }
    
    func setTableColumns() {
        // In Interface Builder, give the Identifier "ModelCellView" to the first column (NSTableColumn)
        // Delete remaining column, ie. keep only the first one
        
        // Save the cellView in the NIB
        let myCellViewNib = tableView.registeredNibsByIdentifier![NSUserInterfaceItemIdentifier(rawValue: "ModelCellView")]
        // Create the columns
        for var columnDictionary in self.tableViewColumnNamesArray{
            let newColumn = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: columnDictionary["columnIdentifier"] as! String))
            newColumn.headerCell.title = columnDictionary["columnTitle"] as! String
            //Float to CGfloat conversion is required
            newColumn.width = CGFloat(columnDictionary["columnDefaultWidth"] as! Int)
            newColumn.minWidth = CGFloat(columnDictionary["columnMinWidth"] as! Int)
            newColumn.maxWidth = CGFloat(columnDictionary["columnMaxWidth"] as! Int)
            
            let sortDescriptor = NSSortDescriptor(key: columnDictionary["columnIdentifier"]! as? String, ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
            
            newColumn.sortDescriptorPrototype = sortDescriptor
            
            tableView.register(myCellViewNib, forIdentifier: NSUserInterfaceItemIdentifier(rawValue: columnDictionary["columnIdentifier"] as! String))
            tableView.addTableColumn(newColumn)
        }
        tableView?.usesAlternatingRowBackgroundColors = true
        tableView?.columnAutoresizingStyle = .uniformColumnAutoresizingStyle
        
        tableView.window?.makeFirstResponder(self)
        
        // Remove the first column, the one created in IB
        tableView.removeTableColumn(tableView.tableColumns[0])
    }
    
    @IBAction func AddRow(_ sender: Any) {
        let aNewContract = Contract(p_conId: 1, p_symbol: "AAPL", p_secType: "STK", p_expiry: "", p_strike: 0, p_right: "", p_multiplier: "100", p_exchange: "SMART", p_currency: "USD", p_localSymbol: "", p_tradingClass: "", p_primaryExch: "", p_includeExpired: false, p_secIdType: "", p_secId: "")
        tableViewData.append(aNewContract)
        tableView.reloadData()
    }
    
    @IBAction func removeRow(_ sender: Any) {
        let index: Int = tableView.selectedRow
        if index > -1 {
            tableViewData.remove(at: index)
            let indexSet = IndexSet(integer:index)
            tableView.removeRows(at: indexSet, withAnimation: .effectFade)
        }
    }
    
    @IBAction func tableViewAction(_ sender: Any) {
        //print("tableViewAction")
        let index: Int = tableView.selectedRow
        
        if index > -1 {
            let aContract: Contract = tableViewData[index]
            selectionLabel.stringValue = "ConId: \(aContract.conId)\nSymbol: \(aContract.symbol)\nSec Type: \(aContract.secType)\nExchange: \(aContract.exchange)"
        } else {
            selectionLabel.stringValue = ""
        }
        
    }
    
    @IBAction func dump(_ sender: Any) {
        for contract in tableViewData {
            contract.printContract()
        }
    }
}

// MARK: - NSTableViewDataSource
extension ViewController:NSTableViewDataSource{
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return tableViewData.count
    }
}

// MARK: - NSTableViewDelegate
extension ViewController: NSTableViewDelegate{
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        //print("tableView:viewForTableColumn: row: \(row) - col: \(tableColumn!.identifier.rawValue)")
        
        let cellView = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as! NSTableCellView
        
        switch tableColumn?.identifier.rawValue  {
        case "conId"?:
            //print(tableColumn?.identifier.rawValue)
            cellView.textField?.integerValue = tableViewData[row].conId
        case "symbol"?:
            //print(tableColumn?.identifier.rawValue)
            cellView.textField?.stringValue = tableViewData[row].symbol
        case "secType"?:
            //print(tableColumn?.identifier.rawValue)
            cellView.textField?.stringValue = tableViewData[row].secType
        case "exchange"?:
            //print(tableColumn?.identifier.rawValue)
            cellView.textField?.stringValue = tableViewData[row].exchange
        default:
            return nil
        }
        return cellView
    }
    
    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor])
    {
        // Manage sorting
        // the first sort descriptor that corresponds to the column header clicked by the user
        guard let sortDescriptor = tableView.sortDescriptors.first else {
            return
        }
        
        switch sortDescriptor.key {
        case "conId"?:
            if sortDescriptor.ascending {
                tableViewData.sort(by: { $0.conId < $1.conId })
            } else {
                tableViewData.sort(by: { $0.conId > $1.conId })
            }
        case "symbol"?:
            if sortDescriptor.ascending {
                tableViewData.sort(by: { $0.symbol < $1.symbol })
            } else {
                tableViewData.sort(by: { $0.symbol > $1.symbol })
            }
        case "secType"?:
            if sortDescriptor.ascending {
                tableViewData.sort(by: { $0.secType < $1.secType })
            } else {
                tableViewData.sort(by: { $0.secType > $1.secType })
            }
        case "exchange"?:
            if sortDescriptor.ascending {
                tableViewData.sort(by: { $0.exchange < $1.exchange })
            } else {
                tableViewData.sort(by: { $0.exchange > $1.exchange })
            }
        default:
            return
        }
        tableView.reloadData()
    }
    
 
}
