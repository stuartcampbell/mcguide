$ write sys$output "Starting BR Compilation - keep your fingers crossed"
$ FOR/ALIGN=COMMON=NATURAL/real=64/EXT BR,CR,PN,TR,DR,BD_CURVED,ST
$! FOR/ALIGN=COMMON=NATURAL/real=64/EXT BR,CR,PN,TR,DR,BD,ST
$ write sys$output "BR Compilation succesful, now starting linkage"
$! LINK BR,CR,PN,TR,DR,BD,ST,[NAG]NAG$LIBRARY.OLB /LIB
$ LINK BR,CR,PN,TR,DR,BD_CURVED,ST
$! LINK BR,CR,PN,TR,DR,BD,ST
$ write sys$output "Linkage succesful. You can run the program now"

           