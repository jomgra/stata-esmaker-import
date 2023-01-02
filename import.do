/*

     IMPORTERINGSFUNKTION esMaker 
	 
	 - Funktionen fungerar vid valet "Exportera frågor och svar" i EsMaker.
	 - Fungerar INTE om du har en fråga som innehåller enkelt citattecken ("). Dubbla fungerar.
 
*/
 
//Ange sökvägen till datafilen
local f = "C:\Documents\data.xlsx"

// Ange vilken som är den första frågan i enkäten. Detta behövs för att programmet ska kunna börja numreringen av frågorna på rätt fråga.
local firstquestion = "Jag arbetar på en kontrollmyndighet inom"

// START - PROGRAMMET STARTAR

import excel "`f'", firstrow clear

foreach var of varlist * {

	local lab: variable label `var'
	local lab = usubinstr("`lab'", uchar(34), "", .)
	
	tokenize "`lab'", parse("[")
	local newq = ("`1'" != "`lastq'")
	local multiq = (ustrpos("`lab'","[") > 0)

	local q = ("`lab'" == "`firstquestion'" | `q' + 0 == 1)

	if `q' & !`multiq' {
		local i = `i' + 1
		rename `var' Q`i'		
	}

	if `q' & `multiq' {
		if `newq' {
			local i = `i' + 1
			local j = 0
			}
		local j = `j' + 1
		rename `var' Q`i'_`j'
	}

	local lastq = "`1'"
}

// STOPP - PROGRAMMET SLUTAR
