#let fit(label, width, height) = {
    let stretch = if label.len() > 1 { 50% } else { 100% }
    set text(font: "Inter", size: height, stretch: stretch)
    style(styles => {
        let size = measure(label, styles)
        let x = 70% * (width / size.width) 
        scale(x: x, label)
    })
}

#circle(radius: 25pt)[
    #set align(center + horizon)
    #fit(str(100), 50pt, 50pt)
]

