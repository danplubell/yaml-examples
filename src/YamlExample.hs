{-
Example of using Data.Yaml to decode and encode an ADT from a string to an object.
-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
import              Data.Yaml as Yaml
import qualified    Data.Text as T
import              Data.Aeson.TH
import qualified    Data.ByteString.Char8 as BC 

--Define the ADTs
data Product = Product
  {
      sku:: T.Text
    , quantity:: Int
    , description::T.Text
    , price::Double
  } deriving (Eq,Show)
  
deriveJSON id ''Product -- use the Aeson templates to derive the ToJSON and the FromJSON instances

data Address = Address
  {
      lines::T.Text
    , city:: T.Text
    , state:: T.Text
    , postal:: T.Text
  }deriving (Eq,Show)
  
deriveJSON id ''Address

data BillTo = BillTo
  {
      given:: T.Text
    , family:: T.Text
    , address:: Address
  }deriving (Eq,Show)
  
deriveJSON id ''BillTo

--Define the data structure
data Invoice = Invoice
 {
      invoice:: T.Text
    , date:: T.Text
    , tax:: Double
    , total:: Double
    , product:: [Product]
    , comments:: T.Text
    , billTo:: BillTo
    , shipTo:: BillTo
 } deriving (Eq, Show)

deriveJSON id ''Invoice

--Here's the string to parse
yamlstring::String
yamlstring = 
       "invoice: '34843'\n" 
    ++ "date   : 2001-01-23\n" 
    ++ "tax  : 251.42\n" 
    ++ "total: 4443.52\n"
    ++ "product:\n" 
    ++ "    - sku         : BL394D\n" 
    ++ "      quantity    : 4\n" 
    ++ "      description : Basketball\n" 
    ++ "      price       : 450.00\n" 
    ++ "    - sku         : BL4438H\n" 
    ++ "      quantity    : 1\n" 
    ++ "      description : Super Hoop\n" 
    ++ "      price       : 2392.00\n" 
    ++ "comments: >\n" 
    ++ "    Late afternoon is best.\n" 
    ++ "    Backup contact is Nancy\n" 
    ++ "    Billsmer @ 338-4338.\n"
    ++ "billTo: &id001\n"   
    ++ "    given  : Chris\n" 
    ++ "    family : Dumars\n" 
    ++ "    address:\n" 
    ++ "        lines: |\n" 
    ++ "            458 Walkman Dr.\n" 
    ++ "            Suite #292\n" 
    ++ "        city    : Royal Oak\n" 
    ++ "        state   : MI\n" 
    ++ "        postal  : '48046'\n" 
    ++ "shipTo: *id001\n"     

{-
This function will parse the yamlstring into an Invoice instance.  If the string is parsed correctly then the Invoice object
is shown.  If there is an exception then the exception is shown
-}
thisDoesParse::IO()
thisDoesParse =do
     let invoiceObj = (Yaml.decodeEither' $ BC.pack yamlstring)::Either Yaml.ParseException Invoice
     case  invoiceObj of 
        Left exception -> putStrLn $ "Exception: " ++  show exception
        Right invoice' -> print invoice'

{-
This function will parse the yamlstring into an Invoice object, encode the result, and then attempt to decode the result.
It will not parse because the invoice number looks like an integer to the Aeson parser is expecting an Text value but the data looks like
a Number.  The decode method will process an all digit string if the value has quotes.  But, when the object is encoded the digit string is not
quoted.  The next attempt to decode the string will fail because of the Text/Number ambiguity.
-}
thisDoesntParse::IO()
thisDoesntParse=do
    let invoiceObj = (Yaml.decodeEither' $ BC.pack yamlstring)::Either Yaml.ParseException Invoice
    case  invoiceObj of 
        Left exception -> print exception
        Right invoice' -> do 
            let invoiceObj' = (Yaml.decodeEither' $ Yaml.encode invoice')::Either Yaml.ParseException Invoice
            case invoiceObj' of
                Left exception -> putStrLn  $ "Exception: " ++ show exception 
                Right invoice'' -> print invoice''
main::IO()
main = do
    thisDoesParse
    thisDoesntParse
    
            
            
            
    
       