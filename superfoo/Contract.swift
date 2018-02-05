
import Foundation

open class Contract { // }: Equatable {
    
    var conId: Int = 0
    var symbol: String = ""
    var secType: String = ""
    var expiry: String = ""
    var strike: Double = 0
    var right: String = ""
    var multiplier: String = ""
    var exchange: String = ""
    
    var currency: String = ""
    var localSymbol: String = ""
    var tradingClass: String = ""
    var primaryExch: String = ""
    var includeExpired: Bool = false
    
    var secIdType: String = ""
    var secId: String = ""
    

    var comboLegsDescrip: String = ""

    
    public init() {
    }
    
    public init(p_conId: Int, p_symbol: String, p_secType: String, p_expiry: String,
        p_strike: Double, p_right: String, p_multiplier: String, p_exchange: String,
        p_currency: String, p_localSymbol: String, p_tradingClass: String,
        p_primaryExch: String, p_includeExpired: Bool,
        p_secIdType: String, p_secId: String) {
            conId = p_conId
            symbol = p_symbol
            secType = p_secType
            expiry = p_expiry
            strike = p_strike
            right = p_right
            multiplier = p_multiplier
            exchange = p_exchange
            currency = p_currency
            includeExpired = p_includeExpired
            localSymbol = p_localSymbol
            tradingClass = p_tradingClass
            primaryExch = p_primaryExch
            secIdType = p_secIdType
            secId = p_secId
            comboLegsDescrip = ""
            //if p_comboLegs != nil { comboLegs = p_comboLegs! }
    }
    
    func printContract() {
        print("\(conId) \(symbol) \(secType) \(expiry) \(strike) \(right)")

    }
}


