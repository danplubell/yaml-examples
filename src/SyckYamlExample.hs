import Data.Yaml.Syck

yamlstring::String
yamlstring = 
       "--- !clarkevans.com/^invoice\n" 
    ++ "invoice: 34843\n" 
    ++ "date   : 2001-01-23\n" 
    ++ "billTo: &id001\n"   
    ++ "    given  : Chris\n" 
    ++ "    family : Dumars\n" 
    ++ "    address:\n" 
    ++ "        lines: |\n" 
    ++ "            458 Walkman Dr.\n" 
    ++ "            Suite #292\n" 
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
   

main::IO()
main = do
    yamlnode <-parseYaml yamlstring
--    yamlnode <- parseYamlFile "invoice.yaml"
--    yamlstr <- emitYaml yamlnode
    print yamlnode

