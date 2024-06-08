#import "../igotist.typ"

#igotist.normalizecoordinates("a1", "1-1", "J8", (1, 1), "19-19", skip-i: true)

#let diagram = igotist.makediagram("diag1")
#igotist.addstones(diagram, "d16", "e16", color: white)
#igotist.addlabels(diagram, "16-4", "4-16")
#igotist.showdiagram(diagram)
