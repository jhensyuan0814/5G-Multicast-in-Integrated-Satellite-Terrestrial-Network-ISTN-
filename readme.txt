Score_by_XXX 是主程式

variables:

$XXX_collection = []自訂

$version_collection = [1:3] 1-our alg 2-all SFN 3-all PTM

$debug = you want to print the information about SFNs during our algorithm

$final result = length(side_collection)*length(version_collection)

$scenario: 
0-completely random position 
1-Fixed density with uniform distribution 
2-Fixed density with clustered distribution 
3-Variable density with uniform distribution
4-Variable density with clustered distribution

$ini_BSMU_hex(ISD,BSNum,MUNum,scenario) 

$param
1-side = 60000, MU = 190~950
2-side = 30000, MU = 190~950
3-side = 30000, MU = 1000~5000
4-side = 45000, MU = 1000~5000
5-side = 60000, MU = 1000~5000
