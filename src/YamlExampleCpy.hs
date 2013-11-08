{-# LANGUAGE OverloadedStrings #-}
--{-# LANGUAGE TemplateHaskell #-}
import Data.Yaml as Yaml
import qualified Data.ByteString.Char8 as BC 
--import Control.Applicative
--import qualified Data.Text as T
--import Control.Monad
--import Data.Aeson.TH
import qualified Data.Text as ST
import Data.Monoid ((<>))
yamlstring::String
yamlstring = 
       "invoice: 34843" 
    ++ "date   : 2001-01-23\n" 
    ++ "billTo: &id001\n"   
    ++ "    given  : Chris\n" 
    ++ "    family : Dumars\n" 
    ++ "    address:\n" 
    ++ "        lines: |\n" 
    ++ "            458 Walkman Dr." 
    ++ "            Suite #292" 
    ++ "        city    : Royal Oak\n" 
    ++ "        state   : MI\n" 
    ++ "        postal  : 48046\n" 
    ++ "shipTo: *id001\n" 
    ++ "product:\n" 
    ++ "    - sku         : BL394D\n" 
    ++ "      quantity    : 4\n" 
    ++ "      description : Basketball\n" 
    ++ "      price       : 450.00\n" 
    ++ "    - sku         : BL4438H\n" 
    ++ "      quantity    : 1\n" 
    ++ "      description : Super Hoop\n" 
    ++ "      price       : 2392.00\n" 
    ++ "tax  : 251.42\n" 
    ++ "total: 4443.52\n"
    ++ "comments: >\n" 
    ++ "    Late afternoon is best.\n" 
    ++ "    Backup contact is Nancy\n" 
    ++ "    Billsmer @ 338-4338.\n"

testdecode::String -> Object
testdecode s = 
    let a =  Yaml.decode $ BC.pack s
    in
        case a of 
            Nothing -> error "error"
            Just a' -> a'
        
type Key = ST.Text
data Config = Config [Key] Object
    deriving (Eq, Show)
    
load :: FilePath -> IO Config
load f = maybe err (return . Config []) =<< Yaml.decodeFile f
  where
    err = error $ "Invalid config file " <> f <> "."
load' :: FilePath -> IO Object
load' f = do
    a<- Yaml.decodeFile f
    case a of 
        Nothing -> error "error"
        Just x -> return x
main::IO()
main = do
        print $ testdecode yamlstring
        putStrLn $ BC.unpack $ encode $ testdecode yamlstring 
    
--    result <- load' "invoice.yaml"
--    print result
{-
--- !clarkevans.com/^invoice
invoice: 34843
date   : 2001-01-23
bill-to: &id001
    given  : Chris
    family : Dumars
    address:
        lines: |
            458 Walkman Dr.
            Suite #292
        city    : Royal Oak
        state   : MI
        postal  : 48046
ship-to: *id001
product:
    - sku         : BL394D
      quantity    : 4
      description : Basketball
      price       : 450.00
    - sku         : BL4438H
      quantity    : 1
      description : Super Hoop
      price       : 2392.00
tax  : 251.42
total: 4443.52
comments: >
    Late afternoon is best.
    Backup contact is Nancy
    Billsmer @ 338-4338.
-}

{-
yamlstring = 
       "--- !clarkevans.com/^invoice" 
    ++ "invoice: 34843" 
    ++ "date   : 2001-01-23" 
    ++ "billTo: &id001"   
    ++ "    given  : Chris" 
    ++ "    family : Dumars" 
    ++ "    address:" 
    ++ "        lines: |" 
    ++ "            458 Walkman Dr." 
    ++ "            Suite #292" 
    ++ "        city    : Royal Oak" 
    ++ "        state   : MI" 
    ++ "        postal  : 48046" 
    ++ "shipTo: *id001" 
    ++ "product:" 
    ++ "    - sku         : BL394D" 
    ++ "      quantity    : 4" 
    ++ "      description : Basketball" 
    ++ "      price       : 450.00" 
    ++ "    - sku         : BL4438H" 
    ++ "      quantity    : 1" 
    ++ "      description : Super Hoop" 
    ++ "      price       : 2392.00" 
    ++ "tax  : 251.42" 
    ++ "total: 4443.52" 
    ++ "comments: >" 
    ++ "    Late afternoon is best." 
    ++ "    Backup contact is Nancy" 
    ++ "    Billsmer @ 338-4338."
-}    
{-yamlstring::String
yamlstring = 
       "--- !clarkevans.com/^invoice" 
    ++ "invoice: 34843" 
    ++ "date   : 2001-01-23" 
    ++ "billTo: &id001"   
    ++ "shipTo: *id001" 
    ++ "tax  : 251.42" 
    ++ "total: 4443.52" 
    ++ "comments: Backup contact is Nancy" 
-}
{-
data Invoice = Invoice 
    { invoice  :: String
    , date     :: String
    , billTo   :: String
    , shipTo   :: String
    , tax      :: Double
    , total    :: Double
    , comments :: String
    } deriving (Show)

instance ToJSON Invoice where
    toJSON (Invoice i d b s ta to c) =
        object ["invoice"   .=  i
               ,"date"      .=  d
               ,"billTo"    .=  b
               ,"shipTo"    .=  s
               ,"tax"       .=  ta
               ,"total"     .=  to
               ,"comments"  .=  c
               ] 
instance FromJSON Invoice where
    parseJSON (Object v) = Invoice <$>
                           v .: "invoice" <*>
                           v .: "date" <*>
                           v .: "billTo" <*>
                           v .: "shipTo" <*>
                           v .: "tax" <*>
                           v .: "total" <*>
                           v .: "comments"
sampleInvoice::Invoice
sampleInvoice =  Invoice 
    {
      invoice   =   "10044"
    , date      =   "11-01-2014"
    , billTo    =   "Mr. Smith"
    , shipTo    =   "Mrs. Smith"
    , tax       =   1234.00
    , total     =   45555.00
    , comments  =   "Nancy is the backup"
    }   
-}
{-
data Invoice = Invoice 
    { invoice  :: T.Text
      , date     :: T.Text
    } deriving (Show)

deriveJSON id ''Invoice
-}
--instance ToJSON Invoice
--instance FromJSON Invoice
    
{-
instance ToJSON Invoice where
    toJSON (Invoice i ) =
        object ["invoice"   .=  i
               ] 
instance FromJSON Invoice where
    parseJSON (Object v) = Invoice <$>
                           v .: "invoice" 
    parseJSON _          = mzero                           
-}
{-
sampleInvoice::Invoice
sampleInvoice =  Invoice 
    {
      invoice   =   "10044"
    }   
    
-}
{-
readDataFile :: IO [Invoice]
readDataFile = do
  d  <- Data.Yaml.decode <$> BC.readFile ("invoice1.yaml")
  case d of
    Nothing -> error "failed to parse"
    Just d' -> return d'    
main::IO()
main= do 
    result <- readDataFile
    print result
-}
--    let bstr = Data.Yaml.encode sampleInvoice
--    putStrLn $ BC.unpack bstr
--    let yaml = (Data.Yaml.decode $ Data.Yaml.encode sampleInvoice)::Maybe Invoice
--    print yaml    
                    
