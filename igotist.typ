#import "@preview/cetz:0.2.0"

#let makediagram(key) = {
  state(key,(
    boardsize: 19,
    diagramsize: 9.5cm,
    linewidth: 0.75pt,
    hoshiradius: 1.5pt,
    stones: (
      (color: black, position: (3, 3)),
      (color: white, position: (15, 15)),
      (color: white, position: (15, 16)),
    ),
    numbers: (),
    labels: (),
    marks: (
      (position: (15, 15), type: "triangle"),
      (position: (3, 3), type: "square")
    )
  ))
}

#let normalizecoordinates(..coordinates, skip-i: false) = {
  coordinates.pos().map(coordinate => {
    if type(coordinate) == str {
      if coordinate.first() >= "a" and coordinate.first() <= "z" {
        let x = coordinate.first().to-unicode() - "a".to-unicode()
        if skip-i and x >= 8 {
          x -= 1
        }
        let y = int(coordinate.slice(1)) - 1
        (x, y)
      }
      if coordinate.first() >= "A" and coordinate.first() <= "Z" {
        let x = coordinate.first().to-unicode() - "A".to-unicode()
        if skip-i and x >= 8 {
          x -= 1
        }
        let y = int(coordinate.slice(1)) - 1
        (x, y)
      }
      if coordinate.contains("-") {
        let (x, y) = coordinate.split("-")
        (int(x) - 1, int(y) - 1)
      }
    } else {
      coordinate
    }
  })
}

#let addstones(diagram, ..stones, color: black, skip-i: false) = {
  let stones = normalizecoordinates(..stones.pos(), skip-i: skip-i)
  let stones = stones.map(stone => {
    (color: color, position: stone)
  })

  diagram.update(diagram => {
    diagram.stones = diagram.stones + stones
    diagram
  })
}

#let addmoves(diagram, ..moves, start: 1, sente: black, skip-i: false) = {
  let moves = normalizecoordinates(..moves.pos(), skip-i: skip-i)
  let moves = moves.enumerate().map(move => {
    let (i, move) = move
    if sente == black {
      let color = if calc.even(i) { black } else { white }
    } else {
      let color = if calc.even(i) { white } else { black }
    }
    (color: color, position: move)
  })
  let numbers = range(start, start + moves.len() + 1).map(number => {
    (position: number, number: number)
  })

  diagram.update(diagram => {
    diagram.moves = diagram.moves + moves
    diagram.numbers = diagram.numbers + numbers
    diagram
  })
}

#let addlabels(diagram, ..labels, uppercase: true, skip-i: false) = {
  let letters = if uppercase { "ABCDEFGHIJKLMNOPQRSTUVWXYZ" } else { "abcdefghijklmnopqrstuvwxyz" }
  let labels = normalizecoordinates(..labels.pos(), skip-i: skip-i)
  let labels = labels.enumerate().map(label => {
    let (i, label) = label  
    (position: label, label: letters.at(i))
  })

  diagram.update(diagram => {
    diagram.labels = diagram.labels + labels
    diagram
  })
}

#let addmarks(diagram, ..marks, type: "triangle", skip-i: false) = {
  let marks = normalizecoordinates(..marks.pos(), skip-i: skip-i)
  let marks = marks.map(mark => {
    (position: mark, type: type)
  })

  diagram.update(diagram => {
    diagram.marks = diagram.marks + marks
    diagram
  })
}

#let copydiagram(diagram, key) = {
  state(key, diagram.get())
}

#let showdiagram(diagram) = context {
  let diagram = diagram.get()

  cetz.canvas(length: diagram.diagramsize / diagram.boardsize, {
    import cetz.draw: *

    grid((0,0), (diagram.boardsize - 1, diagram.boardsize - 1), stroke: diagram.linewidth)

    let hoshi = (3, 9, 15)
    for y in hoshi {
      for x in hoshi {
        circle((x, y), radius: diagram.hoshiradius, fill: black)
      }
    }

    for stone in diagram.stones {
      circle(
        stone.position,
        radius: diagram.diagramsize / diagram.boardsize / 2 - diagram.linewidth / 2,
        stroke: diagram.linewidth,
        fill: stone.color
      )
    }

    for mark in diagram.marks {
      let radius = diagram.diagramsize / diagram.boardsize / 2 - diagram.linewidth / 2
      let stone = diagram.stones.find(s => s.position == mark.position)
      if stone == none {
        circle(
          mark.position,
          radius: radius,
          stroke: white,
          fill: white
        )
      }
      move-to(mark.position)
      let radius = radius - 1pt
      let stroke = diagram.linewidth + if stone != none and stone.color == black { white } else { black }
      if mark.type == "triangle" {
        line(
          (rel: (90deg, radius), update: false),
          (rel: (210deg, radius), update: false),
          (rel: (330deg, radius), update: false),
          close: true,
          stroke: stroke
        )
      }
      if mark.type == "square" {
        line(
          (rel: (45deg, radius), update: false),
          (rel: (135deg, radius), update: false),
          (rel: (225deg, radius), update: false),
          (rel: (315deg, radius), update: false),
          close: true,
          stroke: stroke
        )
      }
      if mark.type == "cross" {
        line(
          (rel: (45deg, radius), update: false),
          (rel: (225deg, radius), update: false),
          stroke: stroke
        )
        line(
          (rel: (135deg, radius), update: false),
          (rel: (315deg, radius), update: false),
          stroke: stroke
        )
      }
    }
  })
}
