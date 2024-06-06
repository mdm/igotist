#import "../igotist.typ"

#igotist.normalizecoordinates("a1", "1-1", "J8", (1, 1), "19-19", skip-i: true)

#let diagram = igotist.makediagram()
#let diagram = igotist.addstones(diagram, "d16", "e16", color: white)
#igotist.showdiagram(diagram)