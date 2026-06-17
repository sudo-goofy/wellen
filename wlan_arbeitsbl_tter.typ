#set page(
  paper: "a4",
  margin: (x: 2cm, y: 2.3cm),
  header: align(right)[#text(size: 9pt, fill: luma(150))[ITS/LF3 – 10. Klasse · WLAN & Wellen]],
  footer: align(center)[#text(size: 8pt, fill: luma(160))[#context counter(page).display("1 / 1", both: true)]],
)

#set text(
  font: ("Calibri", "Inter", "Avenir", "Helvetica Neue", "sans-serif"),
  size: 11pt,
  lang: "de",
  fill: black // Rohes Schwarz für den Matt Blease Style
)

// === MATT BLEASE COLOR PALETTE ===
#let ink        = black
#let paper      = white
#let blease-pop = rgb("#ffde00") // Starkes Marker-Gelb
#let light-ink  = luma(120)

// ALTE FARBEN ÜBERSCHREIBEN (Zwingt alle Bilder & Reste in den B&W Modus!)
#let tech-blue   = ink
#let tech-accent = ink
#let tech-bg     = white
#let good        = ink
#let bad         = ink

// === STYLE DEFINITIONS ===
#let thick-line = line(length: 100%, stroke: 3pt + ink)
#let thin-line  = line(length: 100%, stroke: 1.5pt + ink)
#let write-line = line(length: 100%, stroke: (paint: light-ink, thickness: 1pt, dash: "densely-dotted"))

// Quiz Node connections
#let dot = circle(radius: 4pt, fill: ink)
#let connection = align(center)[#dot #h(2em) #dot]

#show heading.where(level: 1): it => block(
  spacing: 1.8em,
  [
    #text(size: 26pt, weight: "black", tracking: 1.5pt, fill: ink, upper(it.body))
    #v(-0.3em)
    #thick-line
  ]
)

#show heading.where(level: 2): it => block(
  spacing: 1.4em,
  text(size: 15pt, weight: "black", fill: ink, upper(it.body))
)

// === KOMPONENTEN (MATT BLEASE STYLE) =================================

// Meta-Chips: Sozialform · Zeit · Material
#let chip(c) = box(inset: (x: 0.6em, y: 0.4em), radius: 2pt, fill: white,
  stroke: 1.5pt + ink)[#text(size: 9pt, weight: "bold", fill: ink, upper(c))]
#let meta(social, time, material) = block(below: 1.2em)[
  #chip[👥 #social] #h(0.4em) #chip[⏱ #time] #h(0.4em) #chip[🧰 #material]
]

// Differenzierung & Sicherheit (Starke Kasten, keine sanften Farben)
#let tip(body) = block(width: 100%, inset: 1em, radius: 2pt, fill: blease-pop,
  stroke: 2.5pt + ink)[#text(size: 10pt, weight: "bold")[💡 TIPP:] #text(size: 10pt)[#body]]
#let profi(body) = block(width: 100%, inset: 1em, radius: 2pt, fill: white,
  stroke: (left: 6pt + ink, rest: 1.5pt + ink))[#text(size: 10pt, weight: "bold")[⭐ FÜR PROFIS:] #text(size: 10pt)[#body]]
#let safety(body) = block(width: 100%, inset: 1em, radius: 2pt, fill: ink,
  stroke: 2.5pt + ink)[#text(size: 10pt, weight: "bold", fill: white)[⚠️ SICHERHEIT:] #text(size: 10pt, fill: white)[#body]]
#let reflect(body) = block(width: 100%, inset: 1em, radius: 2pt, fill: white,
  stroke: (left: 6pt + ink, rest: 1.5pt + ink))[#text(size: 10pt, weight: "bold")[🧪 RÜCKBLICK:] #text(size: 10pt)[#body]]

#let task-box(title, body) = block(
  width: 100%,
  breakable: false,
  stroke: 2.5pt + ink,
  fill: white,
  inset: 1.5em,
  radius: 2pt,
  [
    #text(weight: "black", size: 13pt, fill: ink, upper(title))
    #v(0.6em)
    #body
  ]
)

#let obs(n) = {
  v(0.8em)
  for _ in range(n) {
    write-line
    v(1.6em)
  }
  v(-0.5em)
}

// === WELLEN- & DIAGRAMM-HELFER =====================================
#let sine(w, amp, cycles, color, cy: 0pt, phase: 0.0, samples: 200, dash: none, thickness: 2pt, x0: 0pt, decay: 0.0) = {
  let pts = ()
  for i in range(samples + 1) {
    let t = i / samples
    let x = x0 + w * t
    let a = amp * (1.0 - decay * t)
    let y = cy - a * calc.sin(2 * calc.pi * cycles * t + phase)
    pts.push((x, y))
  }
  curve(stroke: (paint: color, thickness: thickness, dash: dash),
    curve.move(pts.at(0)), ..pts.slice(1).map(p => curve.line(p)))
}

#let router(label: "Router") = box(width: 1.6cm)[
  #align(center)[
    #box(height: 0.55cm)[
      #place(dx: 0.35cm, dy: -0.1cm, line(start: (0pt,0pt), end: (0pt, 0.45cm), stroke: 1.2pt + tech-blue))
      #place(dx: 0.7cm, dy: -0.1cm, line(start: (0pt,0pt), end: (0pt, 0.45cm), stroke: 1.2pt + tech-blue))
    ]
    #box(width: 1.2cm, height: 0.5cm, radius: 2pt, fill: tech-blue)
    #text(size: 7pt, weight: "bold")[#label]
  ]
]

#let heatmap(rx, couch_cx, couch_ok) = {
  let cols = 17
  let rows = 9
  let cw = 0.4cm
  let k = 2.0
  let ry = 4.5
  box(width: cols * cw, height: rows * cw)[
    #for c in range(cols) {
      for r in range(rows) {
        let x = c + 0.5
        let y = r + 0.5
        let d = calc.sqrt(calc.pow(x - rx, 2) + calc.pow(y - ry, 2))
        let v = calc.cos(k * d)
        let strength = calc.pow((v + 1.0) / 2.0, 1.4)
        place(dx: c * cw, dy: r * cw,
          box(width: cw, height: cw, fill: tech-blue.transparentize(100% - strength * 92%)))
      }
    }
    #place(dx: (rx - 0.5) * cw, dy: (ry - 0.5) * cw,
      box(width: cw, height: cw, fill: tech-accent, radius: 1pt))
    #place(dx: (couch_cx - 0.95) * cw, dy: (ry - 0.95) * cw,
      box(width: 1.2cm, height: 0.85cm, radius: 3pt,
        fill: white.transparentize(15%), stroke: 1.3pt + (if couch_ok { good } else { bad }))[
        #align(center + horizon)[#text(size: 11pt)[🛋]]
        #place(top + right, dx: 0.15cm, dy: -0.18cm, text(size: 8pt)[#if couch_ok [📶] else [📵]])])
  ]
}

#let hump(x0, color) = place(dx: x0, dy: 0pt,
  box(width: 2.5cm, height: 1.3cm, radius: (top: 0.65cm), fill: color.transparentize(45%), stroke: 1pt + color))

// === AUFBAU-ILLUSTRATIONEN (flach, minimal) ========================
#let ink  = rgb("#334155")
#let skin = rgb("#f0c8a0")

#let ill-arc(cx, cy, r, a0, a1, color, thickness: 1.6pt, samples: 36) = {
  let pts = ()
  for i in range(samples + 1) {
    let a = a0 + (a1 - a0) * i / samples
    pts.push((cx + r * calc.cos(a), cy + r * calc.sin(a)))
  }
  curve(stroke: (paint: color, thickness: thickness), curve.move(pts.at(0)), ..pts.slice(1).map(p => curve.line(p)))
}

#let ill-person(cx, top, body) = {
  place(dx: cx - 0.11cm, dy: top + 1.32cm, line(start: (0pt,0pt), end: (-0.11cm, 0.52cm), stroke: (paint: ink, thickness: 2.8pt, cap: "round")))
  place(dx: cx + 0.11cm, dy: top + 1.32cm, line(start: (0pt,0pt), end: (0.11cm, 0.52cm), stroke: (paint: ink, thickness: 2.8pt, cap: "round")))
  place(dx: cx - 0.25cm, dy: top + 0.45cm, box(width: 0.5cm, height: 1.0cm, radius: (top: 0.24cm, bottom: 0.05cm), fill: body))
  place(dx: cx - 0.23cm, dy: top, circle(radius: 0.23cm, fill: skin))
}

#let ill-datawave(w, x0, cy, color, thickness: 2.4pt) = {
  let samples = 220
  let pts = ()
  for i in range(samples + 1) {
    let t = i / samples
    let env = if t < 0.34 { 1.0 } else if t < 0.66 { 0.3 } else { 1.0 }
    let y = cy - 0.42cm * env * calc.sin(2 * calc.pi * 3 * t)
    pts.push((x0 + w * t, y))
  }
  curve(stroke: (paint: color, thickness: thickness), curve.move(pts.at(0)), ..pts.slice(1).map(p => curve.line(p)))
}

#let ill-speaker(cx, cy, dir, color) = {
  place(dx: cx - 0.3cm, dy: cy - 0.5cm, box(width: 0.6cm, height: 1.0cm, radius: 3pt, fill: ink))
  place(dx: cx - 0.16cm, dy: cy - 0.02cm, circle(radius: 0.15cm, fill: color))
  place(dx: cx - 0.13cm, dy: cy - 0.36cm, circle(radius: 0.06cm, fill: tech-bg))
  let base = if dir > 0 { 0.0 } else { calc.pi }
  for r in (0.48cm, 0.82cm, 1.16cm) {
    place(ill-arc(cx + dir*0.28cm, cy, r, base - 0.7, base + 0.7, color))
  }
}

#let ill-caption(body) = align(center)[#text(size: 8.5pt, weight: "bold", fill: ink)[#body]]

// Seil-Aufbau (Station 1, A/B)
#let illu-seil() = align(center)[#box(width: 16cm, height: 2.7cm, fill: tech-bg, radius: 8pt)[
  #place(dy: 2.45cm, line(start: (0.6cm, 0pt), end: (15.4cm, 0pt), stroke: (paint: ink.lighten(40%), thickness: 1.5pt)))
  #ill-person(2.3cm, 0.45cm, tech-blue)
  #ill-person(13.7cm, 0.45cm, tech-accent)
  #place(dx: 2.3cm, dy: 1.1cm, line(start: (0pt,0pt), end: (0.5cm, 0.08cm), stroke: (paint: ink, thickness: 2.8pt, cap: "round")))
  #place(dx: 13.7cm, dy: 1.1cm, line(start: (0pt,0pt), end: (-0.5cm, 0.08cm), stroke: (paint: ink, thickness: 2.8pt, cap: "round")))
  #place(dy: 1.18cm, sine(10.6cm, 0.4cm, 3, ink, cy: 0pt, x0: 2.8cm, thickness: 2.4pt))
  #place(dx: 1.65cm, dy: 0.5cm, text(size: 13pt, fill: tech-blue)[↕])
]]

// Modulation-Aufbau (Station 2, D)
#let illu-modulation() = align(center)[#box(width: 16cm, height: 2.7cm, fill: tech-bg, radius: 8pt)[
  #place(dy: 2.45cm, line(start: (0.6cm, 0pt), end: (15.4cm, 0pt), stroke: (paint: ink.lighten(40%), thickness: 1.5pt)))
  #ill-person(2.3cm, 0.45cm, tech-blue)
  #place(dx: 2.3cm, dy: 1.1cm, line(start: (0pt,0pt), end: (0.5cm, 0.08cm), stroke: (paint: ink, thickness: 2.8pt, cap: "round")))
  #place(dy: 1.2cm, ill-datawave(12.3cm, 2.8cm, 0cm, ink))
  #place(dx: 5.0cm, dy: 0.25cm, text(size: 11pt, weight: "bold", fill: tech-blue)[1])
  #place(dx: 8.6cm, dy: 0.7cm, text(size: 11pt, weight: "bold", fill: tech-accent)[0])
  #place(dx: 12.3cm, dy: 0.25cm, text(size: 11pt, weight: "bold", fill: tech-blue)[1])
]]

// Betonwand / Zwei-Finger (Station 1, C)
#let illu-betonwand() = align(center)[#box(width: 16cm, height: 3.0cm, fill: tech-bg, radius: 8pt)[
  #place(dy: 2.7cm, line(start: (0.6cm, 0pt), end: (15.4cm, 0pt), stroke: (paint: ink.lighten(40%), thickness: 1.5pt)))
  #ill-person(2.3cm, 0.65cm, tech-blue)
  #ill-person(13.7cm, 0.65cm, tech-accent)
  #ill-person(8.0cm, 0.25cm, good)
  #place(dx: 2.3cm, dy: 1.3cm, line(start: (0pt,0pt), end: (0.5cm, 0.08cm), stroke: (paint: ink, thickness: 2.8pt, cap: "round")))
  #place(dx: 13.7cm, dy: 1.3cm, line(start: (0pt,0pt), end: (-0.5cm, 0.08cm), stroke: (paint: ink, thickness: 2.8pt, cap: "round")))
  #place(dx: 8.0cm, dy: 0.75cm, line(start: (0pt,0pt), end: (0pt, 0.5cm), stroke: (paint: ink, thickness: 2.8pt, cap: "round")))
  #place(dx: 7.9cm, dy: 1.27cm, line(start: (0pt,0pt), end: (0.08cm, 0.12cm), stroke: (paint: ink, thickness: 1.8pt, cap: "round")))
  #place(dx: 8.1cm, dy: 1.27cm, line(start: (0pt,0pt), end: (-0.08cm, 0.12cm), stroke: (paint: ink, thickness: 1.8pt, cap: "round")))
  #place(dy: 1.38cm, sine(4.7cm, 0.4cm, 1.8, ink, cy: 0pt, x0: 2.8cm, thickness: 2.4pt))
  #place(dy: 1.38cm, line(start: (8.1cm, 0pt), end: (13.2cm, 0pt), stroke: (paint: ink.lighten(45%), thickness: 2pt)))
  #place(dx: 6.7cm, dy: 0.05cm, text(size: 7.5pt, weight: "bold", fill: good)[2 Finger = „Wand“])
  #place(dx: 9.6cm, dy: 1.05cm, text(size: 7.5pt, fill: ink.lighten(20%))[stirbt hier?])
]]

// Lautsprecher (Station 3, F/G)
#let illu-speaker-scene() = align(center)[#box(width: 16cm, height: 3.2cm, fill: tech-bg, radius: 8pt)[
  #place(dx: 0.6cm, dy: 2.6cm, box(width: 14.8cm, height: 0.32cm, radius: 1pt, fill: ink.lighten(70%)))
  #ill-speaker(2.0cm, 1.85cm, 1, tech-blue)
  #ill-speaker(14.0cm, 1.85cm, -1, tech-blue)
  #ill-person(8.0cm, 0.55cm, tech-accent)
  #place(dx: 7.78cm, dy: 1.05cm, line(start: (0pt,0pt), end: (-0.04cm, -0.32cm), stroke: (paint: ink, thickness: 2.8pt, cap: "round")))
  #place(dx: 7.7cm, dy: 0.68cm, circle(radius: 0.07cm, fill: ink))
  #place(dx: 8.55cm, dy: 1.5cm, text(size: 13pt, fill: tech-accent)[→])
  #place(dx: 0.95cm, dy: 2.62cm, text(size: 7pt, fill: white)[Pult])
]]

// ===================================================================
// TITELKOPF + LERNZIELE
// ===================================================================

#block(width: 100%, fill: tech-blue, radius: 8pt, inset: 1.2em)[
  #text(size: 22pt, weight: "black", fill: white)[📡 WLAN entschlüsselt] #h(1fr)
  #text(size: 11pt, fill: white.transparentize(15%))[Lernfeld 3 · Netze]
  #v(0.2em)
  #text(size: 12pt, fill: white.transparentize(10%))[Die Physik des Unsichtbaren – vom Seil zum Router.]
]

#v(0.6em)
#grid(columns: (1fr, 1fr, 1fr), gutter: 1em,
  [#text(size: 10pt, weight: "bold", fill: ink)[NAME] #box(width: 1fr, baseline: 0pt, repeat("."))],
  [#text(size: 10pt, weight: "bold", fill: ink)[KLASSE] #box(width: 1fr, baseline: 0pt, repeat("."))],
  [#text(size: 10pt, weight: "bold", fill: ink)[DATUM] #box(width: 1fr, baseline: 0pt, repeat("."))]
)

#v(0.8em)

#block(width: 100%, inset: 1.2em, radius: 2pt, fill: blease-pop, stroke: 2.5pt + ink)[
  #text(weight: "black", fill: ink, size: 13pt)[🎯 DAS KANN ICH AM ENDE DER STUNDE]
  #v(0.6em)
  #let canbox = box(width: 1em, height: 1em, stroke: 2pt + ink, radius: 0pt, baseline: 0.15em)
  #set par(spacing: 1em)
  #canbox #h(0.5em) Ich kann erklären, wie aus Nullen und Einsen eine Funkwelle wird (*Modulation*). \
  #canbox #h(0.5em) Ich kann den Deal erklären: *2,4 GHz* = mehr Reichweite/durch Wände, *5 GHz* = mehr Tempo/Daten. \
  #canbox #h(0.5em) Ich kann erklären, warum es trotz starkem Router *Funklöcher* gibt. \
  #canbox #h(0.5em) Ich kann *zwei* Ursachen für schlechtes WLAN nennen – und je eine Lösung.
]

#v(0.8em)

#block(width: 100%, inset: 1.2em, radius: 2pt, fill: white, stroke: 2.5pt + ink)[
  #text(weight: "black", fill: ink, size: 12pt)[🗺 DEIN FAHRPLAN HEUTE] #h(1fr) #text(size: 8.5pt, fill: ink)[erst entdecken (Hand) → dann verstehen (Kopf)]
  #v(0.7em)
  #let fstep(ic, top, bot) = box(width: 100%, inset: 0.5em, radius: 2pt, fill: white, stroke: 1.5pt + ink)[
    #align(center)[#text(size: 16pt)[#ic] \ #text(size: 8pt, weight: "bold", fill: ink)[#top] \ #text(size: 7.5pt, fill: ink)[#bot]]
  ]
  #let farr = align(center + horizon)[#text(size: 13pt, fill: ink, weight: "black")[→]]
  #grid(columns: (1fr, 0.45fr, 1fr, 0.45fr, 1fr, 0.45fr, 1fr), align: horizon,
    fstep("🪢", "Experiment 1", "Seil"), farr,
    fstep("📲", "Experiment 2", "Modulation"), farr,
    fstep("🔊", "Experiment 3", "Funkloch"), farr,
    fstep("🤔", "Reflektion", "Keynote Fazit")
  )
]

#v(1em)

// ==========================================
// LABOR-LOGBUCH
// ==========================================

= Labor-Logbuch
#text(size: 14pt, weight: "medium")[Die Physik des Unsichtbaren.]

#v(0.6em)
*Mission:* Vergiss für einen Moment Handys und WLAN. Vertraue nur deinen Muskeln, deinen Augen und deinen Ohren. Beobachte genau und notiere, was im Raum passiert.

#pagebreak()

== 🪢 Experiment 1: Die mechanische Welle (Das Seil)
#meta("Partner / 3er", "12 min", "1 Springseil + 1 \"Wand\"")
#align(center)[#image("station1.png", height: 4.2cm)]
#ill-caption[*So geht's:* Zwei halten das Seil straff, eine Person schwingt.]
#v(0.7em)
#task-box("Auftrag A: Slow Motion")[
  Spannt das Seil. Eine Person schwingt langsam und gemütlich. Erzeugt eine lange Welle.

  *Frage:* Wie viel Kraft (Energie) kostet dich diese Bewegung auf Dauer?
  #obs(3)
]

#v(0.8em)

#task-box("Auftrag B: High Speed")[
  Gleiches Seil. Schwingt nun extrem schnell. Erzeugt viele kleine, kurze Wellen.

  *Frage:* Was spürst du in den Muskeln? Was passiert, wenn ihr die Spannung verliert?
  #obs(3)
]

#v(0.6em)
#tip[Achte auf den Zusammenhang *Tempo ↔ Anstrengung*. Genau dieser Deal steckt später hinter "2,4 GHz vs. 5 GHz".]

#pagebreak()

#text(size: 11pt, weight: "bold", fill: rgb("#64748b"))[🪢 Experiment 1 · Fortsetzung — Wellen treffen auf Hindernisse]
#v(0.6em)
#align(center)[#image("station2.png", height: 4.2cm)]
#ill-caption[*So geht's:* Eine dritte Person umschließt die Seilmitte locker mit *zwei Fingern* (= Wand).]
#v(0.7em)
#task-box("Auftrag C: Die Betonwand (Zwei-Finger-Trick)")[
  Jetzt kommt eine *Mauer* ins Spiel: Eine *dritte Person* legt locker *zwei Finger* um die *Mitte* des Seils. Sie ist die Betonwand.

  *1. Die lange Welle (2,4 GHz):* Schlagt eine langsame, weit ausholende Welle. Was passiert an den Fingern – und kommt die Welle auf der anderen Seite (im "Garten") an?

  *2. Die kurze Welle (5 GHz):* Schlagt jetzt eine schnelle, kurze, zittrige Welle. Was machen die Finger mit dieser Welle?

  *Beobachtung:* Welche Welle *durchschlägt* die Wand – und welche *stirbt* an den Fingern?
  #obs(10)
]

#pagebreak()

== 📲 Experiment 2: Die Daten-Welle (Modulation)
#meta("Gruppe (3–4)", "10 min", "Seil")
#align(center)[#image("station_modulation.png", height: 3.5cm)]
#ill-caption[*So geht's:* Große Welle = *1*, flache Welle = *0* – im Takt schwingen.]
#v(0.7em)
#task-box("Auftrag D: Der 1en und 0en Trick")[
  Eine einfache Welle überträgt noch keine Informationen. Schwingt das Seil in einem gleichmäßigen Rhythmus (die leere "Trägerwelle").
  Jetzt wollt ihr eine geheime digitale Nachricht verschlüsseln: Verändert extrem auffällig die *Höhe* eurer Wellen! Ein riesiger Schwingungs-Ausschlag bedeutet *1*, ein ganz kleiner, flacher Ausschlag bedeutet *0*. Versendet so den Code "101".

  *Beobachtung:* Was ist das Wichtigste, damit der Empfänger die Einsen und Nullen klar voneinander unterscheiden und fehlerfrei "ablesen" kann?
  #obs(2)
]

#v(0.8em)

#task-box("Auftrag E: Der Daten-Zähler")[
  Denk an Auftrag D: Auf *jedem Wellenberg* reitet jetzt ein Datenpaket (eine 0 oder 1). Also wird gezählt!

  Eine Person schwingt *10 Sekunden* lang gleichmäßig, die andere zählt die ankommenden Wellenberge:

  #v(0.4em)
  #grid(columns: (1fr, 1fr), gutter: 1.5em,
    [Langsame Welle (2,4 GHz): #box(width: 1.5cm, stroke: (bottom: 1pt + tech-blue))[] Berge],
    [Schnelle Welle (5 GHz): #box(width: 1.5cm, stroke: (bottom: 1pt + tech-blue))[] Berge],
  )
  #v(0.5em)

  *Beobachtung:* Welche Welle liefert mehr Datenpakete pro Zeit? Was heißt das für ruckelfreies 4K-Netflix?
  #obs(2)
]


#pagebreak()

== 🔊 Experiment 3: Die akustische Welle (Das begehbare Funkloch)
#meta("Einzeln, nacheinander", "10 min", "2 Lautsprecher, 1 Ton")
#safety[Stellt die Lautstärke nur *mittel* ein und haltet euch *ein* Ohr zu. Nie mit voller Lautstärke direkt ans Ohr.]
#v(0.5em)
#align(center)[#image("station3.png", height: 4.2cm)]
#ill-caption[*So geht's:* Zwei Boxen, gleicher Ton. Mit einem zugehaltenen Ohr langsam durchlaufen.]
#v(0.6em)
#task-box("Auftrag F: Der Blindflug im Raum")[
  Zwei Lautsprecher spielen exakt denselben Ton. Halte dir ein Ohr zu (wichtig!) und laufe langsam, parallel zum Pult, von links nach rechts durch das Zimmer.

  *Beobachtung:* Beschreibe, wie sich die Lautstärke verändert, je nachdem, wo du stehst. Gibt es Muster?
  #obs(2)
]

#v(0.8em)

#task-box("Auftrag G: Der Ingenieurs-Trick")[
  Bleib genau an einer Stelle stehen, wo es extrem leise oder still ist. Wir verschieben nun einen Lautsprecher auf dem Pult um 30 Zentimeter.

  *Beobachtung:* Was passiert mit deinem "Funkloch"? Warum hat diese kleine Bewegung das Problem gelöst?
  #obs(3)
]

#pagebreak()

// ==========================================
// TRANSFER / KEYNOTE-BEGLEITER
// ==========================================

= 📡 Reality Check
#text(size: 14pt, weight: "medium")[Die Auflösung aus der Präsentation.]

#v(0.4em)
*Mission:* Notiere hier die wichtigsten "Goldenen Regeln", die wir jetzt gemeinsam in der Präsentation erarbeiten. Was war die wahre Physik hinter den Experimenten?

#v(1em)

#let keynote-box(icon, title, body) = block(width: 100%, stroke: 1.5pt + tech-blue, fill: tech-bg, inset: 1.2em, radius: 6pt, breakable: false)[
  #grid(
    columns: (auto, 1fr),
    gutter: 1em,
    text(size: 18pt)[#icon],
    [
      #text(weight: "bold", size: 12pt, fill: tech-blue, title)
      #v(0.2em)
      #body
    ]
  )
]

#keynote-box("🧱", "1. Der Frequenz-Deal (2,4 GHz vs. 5 GHz)")[
  *Regel:* #v(1em)
  #write-line #v(1.4em)
  #write-line #v(1.4em)
  #write-line #v(1.4em)
  #write-line #v(0.2em)
]

#v(1em)

#keynote-box("📊", "2. Die Daten-Modulation")[
  *Regel:* #v(1em)
  #write-line #v(1.4em)
  #write-line #v(1.4em)
  #write-line #v(1.4em)
  #write-line #v(0.2em)
]

#v(1em)

#keynote-box("👻", "3. Das Funkloch-Mysterium (Interferenz)")[
  *Regel:* #v(1em)
  #write-line #v(1.4em)
  #write-line #v(1.4em)
  #write-line #v(1.4em)
  #write-line #v(0.2em)
]

#pagebreak()
// ==========================================
// VISUAL-NOTES (SKRIPT)
// ==========================================

= 🧠 Cheat Sheet: Die WLAN-Physik
#text(size: 14pt, weight: "medium")[Zusammenfassung für dein Gehirn.]

#v(1.2em)

#block(breakable: false, width: 100%)[
== 1. Wie das WLAN durch die Wand kommt
#align(center)[
  #box(width: 16cm, height: 4.6cm, fill: tech-bg, radius: 6pt, stroke: 0.75pt + rgb("#cbd5e1"))[
    #place(dx: 7.6cm, dy: 0.3cm, box(width: 0.7cm, height: 4cm, fill: rgb("#e2e8f0"), stroke: 1pt + rgb("#94a3b8")))
    #place(dx: 7.6cm, dy: 0.3cm, box(width: 0.7cm, height: 4cm)[
      #for r in range(8) { place(dy: r * 0.5cm, line(start: (0pt,0pt), end: (0.7cm, 0pt), stroke: 0.5pt + rgb("#94a3b8"))) }
    ])
    #place(dx: 7.55cm, dy: 4.35cm, text(size: 7pt, fill: rgb("#64748b"))[Wand])
    #place(dx: 0.2cm, dy: 1.5cm, router())
    #place(dy: 1.3cm, sine(7cm, 0.55cm, 3, tech-blue, cy: 0pt, x0: 1.9cm, thickness: 2.2pt))
    #place(dy: 1.55cm, sine(6.4cm, 0.34cm, 2.8, tech-blue.lighten(20%), cy: 0pt, x0: 8.3cm, thickness: 2.2pt, decay: 0.4))
    #place(dx: 9.0cm, dy: 0.32cm, text(size: 8.5pt, weight: "bold", fill: tech-blue)[2,4 GHz #text(fill: good)[✓ kommt durch]])
    #place(dx: 9.0cm, dy: 0.78cm, text(size: 7.5pt, fill: rgb("#475569"))[lange Welle · weniger Daten])
    #place(dy: 3.1cm, sine(5.6cm, 0.4cm, 9, tech-accent, cy: 0pt, x0: 1.9cm, thickness: 2pt))
    #place(dx: 7.0cm, dy: 2.55cm, text(size: 14pt, fill: bad)[✗])
    #place(dx: 1.9cm, dy: 3.7cm, text(size: 8.5pt, weight: "bold", fill: tech-accent)[5 GHz #text(fill: bad)[prallt ab]])
    #place(dx: 4.6cm, dy: 3.7cm, text(size: 7.5pt, fill: rgb("#475569"))[kurze Welle · viele Daten])
  ]
]
#v(0.4em)
#grid(columns: (1fr, 1fr), gutter: 1.5em,
  [*2,4 GHz – lang & ruhig:* Kommt gut durch dicke Wände, transportiert aber weniger Daten pro Sekunde. Ideal fürs Nebenzimmer.],
  [*5 GHz – kurz & schnell:* Transportiert extrem viele Daten, prallt aber an Wänden ab und verliert schnell Energie. Optimal nur im selben Raum.]
)

#v(0.6em)
#reflect[
  *Betonwand (Auftrag C):* Die langsame 2,4-GHz-Welle riss sich durch die Finger-Wand (→ kommt im Garten an); die kurze 5-GHz-Welle wurde geschluckt (→ tot an der Wand). *Lange Wellen durchdringen, kurze nicht.* \
  *Daten-Zähler (Auftrag E):* Die schnelle Welle bringt mehr Wellenberge pro Sekunde = mehr Datenpakete = 4K ohne Ruckeln. *Das ist der Preis fürs Durchkommen.*
]
]

#v(1.2em)

#block(breakable: false, width: 100%)[
== 2. Warum Signale verschwinden (Stehende Wellen)
#align(center)[
  #box(width: 16cm, height: 5cm, fill: tech-bg, radius: 6pt, stroke: 0.75pt + rgb("#cbd5e1"))[
    #place(dx: 0.3cm, dy: 0.55cm, text(size: 8pt, weight: "bold", fill: tech-blue)[Dein Signal])
    #place(dy: 1.2cm, sine(11cm, 0.5cm, 4, tech-blue, cy: 0pt, x0: 3cm, thickness: 2.2pt))
    #place(dx: 14.3cm, dy: 1.0cm, text(size: 13pt, weight: "bold", fill: rgb("#475569"))[+])
    #place(dx: 0.3cm, dy: 2.25cm, text(size: 8pt, weight: "bold", fill: tech-accent)[Reflexion \ (Wand)])
    #place(dy: 2.7cm, sine(11cm, 0.5cm, 4, tech-accent, cy: 0pt, x0: 3cm, phase: calc.pi, thickness: 2.2pt, dash: "dashed"))
    #place(dx: 14.3cm, dy: 2.5cm, text(size: 13pt, weight: "bold", fill: rgb("#475569"))[=])
    #place(dx: 0.3cm, dy: 4.0cm, text(size: 8pt, weight: "bold", fill: bad)[Summe])
    #place(dy: 4.2cm, line(start: (3cm, 0pt), end: (14cm, 0pt), stroke: (paint: bad, thickness: 2.5pt, dash: "dotted")))
    #place(dx: 6.0cm, dy: 4.35cm, text(size: 8.5pt, weight: "bold", fill: bad)[Stille → Funkloch 📵])
  ]
]
#v(0.4em)
*Destruktive Interferenz:* Funkwellen werden an Wänden und Möbeln reflektiert. Treffen die Original-Welle und ihre Reflexion gegenphasig aufeinander, *löschen sie sich aus*. An dieser Stelle ist "Stille" – ein Funkloch –, obwohl der Router auf voller Stärke sendet.
]

#pagebreak()

#block(breakable: false, width: 100%)[
== 3. Trick 1: Router verschieben (gegen eigene Funklöcher)
#align(center)[
  #grid(columns: (1fr, auto, 1fr), align: center + horizon, column-gutter: 0.4cm,
    box(width: 7.6cm, fill: tech-bg, radius: 6pt, stroke: 0.75pt + rgb("#cbd5e1"), inset: 0.3cm)[
      #align(center)[#text(size: 8pt, weight: "bold")[Vorher: Couch im Funkloch]]
      #v(0.15cm)
      #align(center)[#heatmap(3.0, 13.5, false)]
    ],
    text(size: 16pt, fill: good)[→],
    box(width: 7.6cm, fill: tech-bg, radius: 6pt, stroke: 0.75pt + rgb("#cbd5e1"), inset: 0.3cm)[
      #align(center)[#text(size: 8pt, weight: "bold")[Router ein paar dm verschoben]]
      #v(0.15cm)
      #align(center)[#heatmap(5.0, 13.5, true)]
    ]
  )
]
#v(0.4em)
Funkwellen bilden im Raum ein unsichtbares "Schachbrett" aus starken Zonen und Funklöchern. Verschiebst du den Router nur um *30–50 cm*, wandert das gesamte Muster – das Funkloch zieht von der Couch in eine unwichtige Ecke. #text(fill: rgb("#64748b"))[(🟧 = Router)]
]

#v(1.0em)

#block(breakable: false, width: 100%)[
== 4. Trick 2: Kanal wechseln (gegen den Nachbarn)
#align(center)[
  #grid(columns: (1fr, auto, 1fr), align: center + horizon, column-gutter: 0.4cm,
    box(width: 7.6cm, height: 3cm, fill: tech-bg, radius: 6pt, stroke: 0.75pt + rgb("#cbd5e1"), inset: 0.3cm)[
      #align(center)[#text(size: 8pt, weight: "bold", fill: bad)[Gleicher Kanal → Crash ⚡]]
      #box(width: 6.9cm, height: 1.7cm)[
        #hump(1.0cm, tech-blue)
        #hump(2.0cm, tech-accent)
        #place(dy: 1.4cm, line(start: (0cm,0pt), end: (6.9cm,0pt), stroke: 0.8pt + rgb("#94a3b8")))
      ]
      #align(center)[#text(size: 7pt, fill: rgb("#64748b"))[Frequenz →]]
    ],
    text(size: 16pt, fill: good)[→],
    box(width: 7.6cm, height: 3cm, fill: tech-bg, radius: 6pt, stroke: 0.75pt + rgb("#cbd5e1"), inset: 0.3cm)[
      #align(center)[#text(size: 8pt, weight: "bold", fill: good)[Kanal gewechselt → frei ✓]]
      #box(width: 6.9cm, height: 1.7cm)[
        #hump(0.3cm, tech-blue)
        #hump(4.0cm, tech-accent)
        #place(dy: 1.4cm, line(start: (0cm,0pt), end: (6.9cm,0pt), stroke: 0.8pt + rgb("#94a3b8")))
      ]
      #align(center)[#text(size: 7pt, fill: rgb("#64748b"))[Frequenz →]]
    ]
  )
]
#v(0.4em)
Funkt der *Nachbar* auf demselben Kanal wie du, stören sich beide Netze dauerhaft (Co-Channel-Störung). Hier hilft Verschieben *nicht* – du musst in den Router-Einstellungen einen *freien Kanal* wählen.
]

#pagebreak()

// ==========================================
// REFLEXION / EXIT-TICKET
// ==========================================

= 🎟 Exit-Ticket
#text(size: 14pt, weight: "medium")[Bevor du gehst: Was bleibt hängen?]

#v(1.2em)

#block(width: 100%, inset: 1.2em, radius: 6pt, fill: tech-bg, stroke: 1.5pt + tech-blue)[
  *🧓 Erkläre es deiner Oma in EINEM Satz:* Warum ist das WLAN im hintersten Zimmer so schlecht?
  #obs(5)
]

#v(1em)

#grid(columns: (1fr, 1fr), gutter: 1em,
  block(width: 100%, inset: 1.2em, radius: 2pt, fill: white, stroke: 2.5pt + ink, height: 4.2cm)[
    *💡 Mein größtes Aha heute:*
    #v(0.6em) #write-line #v(1.4em) #write-line
  ],
  block(width: 100%, inset: 1.2em, radius: 2pt, fill: white, stroke: 2.5pt + ink, height: 4.2cm)[
    *❓ Das verwirrt mich noch:*
    #v(0.6em) #write-line #v(1.4em) #write-line
  ]
)

#v(1em)

#block(width: 100%, inset: 1.2em, radius: 2pt, fill: white, stroke: 1.5pt + ink)[
  *So sicher fühle ich mich beim Thema WLAN* (kreuze an):
  #v(1em)
  #let cf = box(width: 1.2em, height: 1.2em, stroke: 1.5pt + ink)
  #grid(columns: (1fr, 1fr, 1fr, 1fr), align: center,
    [#cf \ 😟 \ blicke nicht durch],
    [#cf \ 🙂 \ kann das Wichtigste],
    [#cf \ 😎 \ kann es erklären],
    [#cf \ 🤓 \ kann es unterrichten],
  )
]

#pagebreak()

// ==========================================
// LÖSUNGEN
// ==========================================

#block(width: 100%, fill: ink, radius: 2pt, inset: 1.2em)[
  #text(size: 18pt, weight: "black", fill: white)[🔑 LÖSUNGEN / KEYNOTE-Auszug] #h(1fr)
  #text(size: 10pt, fill: white.transparentize(15%))[für Lehrkraft & Tafelbild]
]

#v(1em)

== Reality Check (Notizen aus der Präsentation)
#block(width: 100%, inset: 1em, radius: 6pt, fill: tech-bg, stroke: 0.75pt + rgb("#cbd5e1"))[
  #set par(spacing: 0.8em)
  *1. Der Frequenz-Deal:*  
  2,4 GHz = lang & energiesparend, kommt durch dicke Wände (ideal für Distanz).  
  5 GHz = kurz & powervoll, aber prallt ab (ideal für max. Datenspeed im gleichen Raum).

  *2. Die Daten-Modulation:*  
  Wellen allein übertragen keine Videos. Nur durch gezielte, getaktete Veränderungen (z.B. der Amplitude/Höhe) können Nullen und Einsen auf das Signal "geprägt" werden.

  *3. Das Funkloch-Mysterium:*  
  Überlagert sich ein Signal gegenphasig mit sich selbst (Wand-Reflexion) oder den Wellen eines Nachbarn, kommt es zur Interferenz: Die Wellen löschen sich aus = "Stille", obwohl man Empfang haben müsste. Der Ingenieurs-Trick: Router minimal verschieben, um das Wellen-Gittermuster im Raum zu ändern.
]

#v(0.8em)

== Erwartete Beobachtungen (Experimente)
#block(width: 100%, inset: 1em, radius: 6pt, fill: tech-bg, stroke: 0.75pt + rgb("#cbd5e1"))[
  #set par(spacing: 0.7em)
  *A/B (Seil):* Schnelles Schwingen kostet viel mehr Kraft/Energie und ist kaum durchzuhalten → Analogie zu 5 GHz (viel Energie, hohe "Datenrate"). \
  *C (Betonwand):* Die *lange* 2,4-GHz-Welle hat genug "Wucht", um die Finger-Wand zu durchschlagen → kommt im "Garten" an. Die *kurze* 5-GHz-Welle wird von den Fingern geschluckt → stirbt an der Wand. Aha: niedrige Frequenz = bessere Reichweite/Wanddurchdringung. \
  *D (Modulation):* Wichtig sind ein *klarer Unterschied* zwischen großem und kleinem Ausschlag und ein *gleichmäßiger Takt* – sonst verwechselt der Empfänger 0 und 1. \
  *E (Daten-Zähler):* Die schnelle Welle liefert deutlich *mehr Wellenberge pro Zeit* → mehr Datenpakete → mehr Datenrate (4K). Trade-off zu C: schneller, aber kürzere Reichweite. \
  *F (Schall):* Es gibt feste laute und leise Zonen (Interferenzmuster), unabhängig von der Lautstärke. \
  *G (Schall):* Das "Funkloch" wandert – schon eine kleine Verschiebung der Quelle verändert das gesamte Muster im Raum.
]
