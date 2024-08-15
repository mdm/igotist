#import "../igotist.typ"

#igotist.normalizecoordinates("a1", "1-1", "J8", (1, 1), "19-19", skip-i: true)

#let diagram = igotist.makediagram("diag1")
#igotist.addstones(diagram, "d16", "e16", color: white)
// #igotist.addlabels(diagram, "16-4", "4-16")
#igotist.addmarks(diagram, "16-4", "4-16")
#igotist.addmarks(diagram, "4-10", "3-10", type: "cross")
#igotist.addstones(diagram, "3-10", color: black)
#igotist.addmoves(diagram, "8-10", start: 1)
#igotist.addmoves(diagram, "10-10", start: 55)
#igotist.addmoves(diagram, "12-10", start: 253)
#igotist.showdiagram(diagram)
#context diagram.get().marks.first().keys()