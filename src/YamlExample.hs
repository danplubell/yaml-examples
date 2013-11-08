{-
Example of decoding a yaml string in memory
-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
import Data.Yaml as Yaml
import qualified Data.Text as T
import Data.Aeson.TH
import qualified Data.ByteString.Char8 as BC 

--Define the ADTs
data Product = Product
  {
      sku:: T.Text
    , quantity:: Int
    , description::T.Text
    , price::Double
  } deriving (Eq,Show)
  
deriveJSON id ''Product -- use the aeson templates to derive the ToJSON and the FromJSON

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

main::IO()
main = do
    let obj = (Yaml.decodeEither' $ BC.pack yamlstring)::Either Yaml.ParseException Invoice
    case obj of 
        Left p -> print p
        Right a -> print a
        