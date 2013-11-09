import qualified    Data.Text as T
import              Data.Yaml.Syck as Syck
import qualified    Data.ByteString.Char8 as BC 
import              Data.Maybe

 
yamlstring::String
yamlstring = 
 "--- !<tag:clarkevans.com,2002:invoice>\n"
 ++ "invoice: 34843\n"
 ++ "date   : 2001-01-23\n"
 ++ "bill-to: &id001\n"
 ++ "   given  : Chris\n"
 ++ "   family : Dumars\n"
 ++ "   address:\n"
 ++ "       lines: |\n"
 ++ "           458 Walkman Dr.\n"
 ++ "           Suite #292\n"
 ++ "       city    : Royal Oak\n"
 ++ "       state   : MI\n"
 ++ "       postal  : 48046\n"
 ++ "ship-to: *id001\n"
 ++ "product:\n"
 ++ "   - sku         : BL394D\n"
 ++ "     quantity    : 4\n"
 ++ "     description : Basketball\n"
 ++ "     price       : 450.00\n"
 ++ "   - sku         : BL4438H\n"
 ++ "     quantity    : 1\n"
 ++ "     description : Super Hoop\n"
 ++ "     price       : 2392.00\n"
 ++ "tax  : 251.42\n"
 ++ "total: 4443.52\n"
 ++ "comments:\n"
 ++ "   Late afternoon is best.\n"
 ++ "    Backup contact is Nancy\n"
 ++ "   Billsmer @ 338-4338.\n"

findNode::String -> YamlNode-> [Maybe YamlNode]
findNode key node =
    case n_elem node of
        EMap emap   -> concat $ mapMap key emap
        ESeq eseq   -> concat $ mapSeq key eseq
        EStr _      -> [Nothing]
        ENil        -> [Nothing]

mapMap::String -> [(YamlNode,YamlNode)]-> [[Maybe YamlNode]]      
mapMap key (x:xs)= evalNodeTuple key x:mapMap key xs
mapMap _ [] = []

mapSeq :: String -> [YamlNode] -> [[Maybe YamlNode]]
mapSeq key (x:xs)= findNode key x:mapSeq key xs
mapSeq _ [] = []

evalNodeTuple::String -> (YamlNode,YamlNode)->[Maybe YamlNode]
evalNodeTuple key (p,c)= 
    case n_elem p of
       EStr estr    -> if key == BC.unpack estr
                            then [Just c]
                            else findNode key c
       EMap _       -> [Nothing]
       ESeq _       -> [Nothing]
       ENil         -> [Nothing]
           
main::IO()
main=do 
    yamlnode <- Syck.parseYaml yamlstring
    print yamlnode
    let foundNodes = catMaybes $ findNode "description" yamlnode
    print foundNodes
    
    

