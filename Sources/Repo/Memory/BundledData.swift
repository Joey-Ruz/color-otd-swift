import Foundation

/// Port of `/Users/joeyruz/Projects/RuzAI/ColorOTD/app/data.js`.
/// All curated content the prototype ships with — colours, poems, recipes,
/// the full Prussian Blue lens corpus, and the three browse themes.
enum BundledData {

    // MARK: - Archive (summary entries)

    /// Per data.js ARCHIVE — past colors-of-the-day in reverse-chronological order.
    /// These are summaries: no lens content, no recipe, no poem.
    /// `MemoryColorRepository` will hydrate them on demand.
    static let archiveSummaries: [(id: ColorId, name: String, hex: String, date: String, dateShort: String, onColor: String)] = [
        ("prussian-blue",   "Prussian Blue",   "#003153", "Thursday, 28 May 2026",   "May 28", "#EDE9DF"),
        ("vermilion",       "Vermilion",       "#E34234", "Wednesday, 27 May 2026",  "May 27", "#2A0F0B"),
        ("tyrian-purple",   "Tyrian Purple",   "#66023C", "Tuesday, 26 May 2026",    "May 26", "#F2E4EC"),
        ("orpiment",        "Orpiment",        "#E8B923", "Monday, 25 May 2026",     "May 25", "#2E2305"),
        ("ultramarine",     "Ultramarine",     "#1B1F8A", "Sunday, 24 May 2026",     "May 24", "#E7E7F4"),
        ("verdigris",       "Verdigris",       "#43B3AE", "Saturday, 23 May 2026",   "May 23", "#082423"),
        ("mummy-brown",     "Mummy Brown",     "#6F4E37", "Friday, 22 May 2026",     "May 22", "#EFE7DF"),
        ("scheeles-green",  "Scheele’s Green", "#3C7A3C", "Thursday, 21 May 2026",   "May 21", "#E8F0E5"),
        ("carmine",         "Carmine",         "#960018", "Wednesday, 20 May 2026",  "May 20", "#F4E0E2"),
        ("indian-yellow",   "Indian Yellow",   "#E3A857", "Tuesday, 19 May 2026",    "May 19", "#2E1F08"),
        ("malachite",       "Malachite",       "#1B7A4B", "Monday, 18 May 2026",     "May 18", "#E5F0E8"),
        ("han-purple",      "Han Purple",      "#5218A0", "Sunday, 17 May 2026",     "May 17", "#ECE5F4"),
        ("lead-white",      "Lead White",      "#F3F1E9", "Saturday, 16 May 2026",   "May 16", "#2A2823"),
        ("payne-grey",      "Payne’s Grey",    "#475663", "Friday, 15 May 2026",     "May 15", "#E9ECEF"),
        ("saffron",         "Saffron",         "#E8A317", "Thursday, 14 May 2026",   "May 14", "#2E2105"),
        ("cobalt",          "Cobalt",          "#1B4FA0", "Wednesday, 13 May 2026",  "May 13", "#E6ECF4"),
    ]

    // MARK: - Default favorites

    /// Pre-seeded favorites per data.js (so the Profile screen has content on first launch).
    static let defaultFavorites: Set<ColorId> = [
        "prussian-blue", "tyrian-purple", "verdigris", "carmine", "ultramarine",
    ]

    // MARK: - Poems (one-line italic flourishes)

    static let poems: [ColorId: String] = [
        "prussian-blue":   "The first blue ever made by accident — a chemist reaching for red, and stumbling on the colour of the deep, the dusk, and the drawing board.",
        "vermilion":       "Ground from cinnabar and mercury — the violent, brilliant red that lacquered emperors and slowly poisoned the alchemists who chased it.",
        "tyrian-purple":   "Wrung from the gland of a sea snail, ten thousand of them for a single hem — a colour so costly it became the law of kings.",
        "ultramarine":     "Beyond the sea, from a single mountain in Afghanistan — lapis lazuli ground finer than gold and reserved for the robe of the Virgin.",
        "verdigris":       "The green bloom of corroding copper — unstable, luminous, forever threatening to eat the very painting it adorned.",
        "mummy-brown":     "A brown ground, quite literally, from ground Egyptian mummies — a pigment painters used for centuries before learning what it was.",
        "carmine":         "Harvested from the cochineal insect of the cactus — a red so prized that Spain guarded its source as a state secret.",
        "scheeles-green":  "A dazzling arsenic green that coloured wallpaper, dresses and sweets — and is rumoured to have slowly killed Napoleon in exile.",
    ]

    /// Fallback poem for any colour without a curated one.
    static let fallbackPoem = "A pigment with its own long history across art, nature and language — explored here through six lenses."

    // MARK: - Recipes (mix bar + plain-language note, accessibility aid)

    static let recipes: [ColorId: RecipeEntity] = [
        "prussian-blue": RecipeEntity(
            note: "A very dark blue, deepened almost to black and cooled with a whisper of green.",
            mix: [
                .init(name: "Ultramarine blue", hex: "#1B1F8A", parts: 6),
                .init(name: "Black",            hex: "#16161A", parts: 2),
                .init(name: "Viridian green",   hex: "#1B7A4B", parts: 1),
            ]
        ),
        "vermilion": RecipeEntity(
            note: "A vivid, fiery red leaning warmly toward orange.",
            mix: [
                .init(name: "Scarlet red", hex: "#C81D11", parts: 6),
                .init(name: "Orange",      hex: "#E8821A", parts: 3),
                .init(name: "White",       hex: "#F3F1E9", parts: 1),
            ]
        ),
        "tyrian-purple": RecipeEntity(
            note: "A dark red-violet — crimson married to deep blue, then dimmed.",
            mix: [
                .init(name: "Carmine red",      hex: "#960018", parts: 4),
                .init(name: "Ultramarine blue", hex: "#1B1F8A", parts: 3),
                .init(name: "Black",            hex: "#16161A", parts: 1),
            ]
        ),
        "orpiment": RecipeEntity(
            note: "A warm golden yellow with a faint orange glow.",
            mix: [
                .init(name: "Cadmium yellow", hex: "#F2C200", parts: 6),
                .init(name: "Orange",         hex: "#E8821A", parts: 1),
            ]
        ),
        "ultramarine": RecipeEntity(
            note: "A pure, saturated blue carrying a trace of violet.",
            mix: [
                .init(name: "Blue",   hex: "#1530C0", parts: 6),
                .init(name: "Violet", hex: "#5218A0", parts: 2),
                .init(name: "Black",  hex: "#16161A", parts: 1),
            ]
        ),
        "verdigris": RecipeEntity(
            note: "A bright blue-green teal, equal parts green and cyan, lifted with white.",
            mix: [
                .init(name: "Green",     hex: "#1B7A4B", parts: 4),
                .init(name: "Cyan blue", hex: "#1B9AA8", parts: 4),
                .init(name: "White",     hex: "#F3F1E9", parts: 2),
            ]
        ),
        "mummy-brown": RecipeEntity(
            note: "A muted earth brown — warm red and ochre quieted with black.",
            mix: [
                .init(name: "Burnt sienna",  hex: "#8A4B2F", parts: 5),
                .init(name: "Yellow ochre",  hex: "#C58A3A", parts: 3),
                .init(name: "Black",         hex: "#16161A", parts: 2),
            ]
        ),
        "scheeles-green": RecipeEntity(
            note: "A strong leaf green, warmed slightly with yellow.",
            mix: [
                .init(name: "Green",          hex: "#1B7A4B", parts: 6),
                .init(name: "Cadmium yellow", hex: "#F2C200", parts: 2),
                .init(name: "Black",          hex: "#16161A", parts: 1),
            ]
        ),
        "carmine": RecipeEntity(
            note: "A deep, cool crimson red shaded with the faintest black.",
            mix: [
                .init(name: "Crimson", hex: "#C00020", parts: 7),
                .init(name: "Black",   hex: "#16161A", parts: 1),
            ]
        ),
        "indian-yellow": RecipeEntity(
            note: "A warm amber yellow, golden and slightly orange.",
            mix: [
                .init(name: "Cadmium yellow", hex: "#F2C200", parts: 5),
                .init(name: "Orange",         hex: "#E8821A", parts: 2),
                .init(name: "Burnt sienna",   hex: "#8A4B2F", parts: 1),
            ]
        ),
        "malachite": RecipeEntity(
            note: "A rich mineral green, cool and slightly bluish.",
            mix: [
                .init(name: "Green",     hex: "#1B7A4B", parts: 6),
                .init(name: "Cyan blue", hex: "#1B9AA8", parts: 1),
            ]
        ),
        "han-purple": RecipeEntity(
            note: "An electric violet — deep blue pushed toward red.",
            mix: [
                .init(name: "Blue",    hex: "#1530C0", parts: 4),
                .init(name: "Magenta", hex: "#A01070", parts: 3),
            ]
        ),
        "lead-white": RecipeEntity(
            note: "A soft white carrying the faintest warm, creamy tint.",
            mix: [
                .init(name: "White",        hex: "#F7F5EE", parts: 12),
                .init(name: "Yellow ochre", hex: "#C58A3A", parts: 1),
            ]
        ),
        "payne-grey": RecipeEntity(
            note: "A deep blue-grey — blue and black, never truly neutral.",
            mix: [
                .init(name: "Ultramarine blue", hex: "#1B1F8A", parts: 4),
                .init(name: "Black",            hex: "#16161A", parts: 3),
                .init(name: "White",            hex: "#F3F1E9", parts: 1),
            ]
        ),
        "saffron": RecipeEntity(
            note: "A warm orange-yellow, like late-afternoon light.",
            mix: [
                .init(name: "Cadmium yellow", hex: "#F2C200", parts: 4),
                .init(name: "Orange",         hex: "#E8821A", parts: 3),
            ]
        ),
        "cobalt": RecipeEntity(
            note: "A clean medium blue, calm and slightly cool.",
            mix: [
                .init(name: "Blue",  hex: "#1530C0", parts: 6),
                .init(name: "White", hex: "#F3F1E9", parts: 1),
                .init(name: "Black", hex: "#16161A", parts: 1),
            ]
        ),
    ]

    // MARK: - Themes (curated browse rows on Search)

    static let themes: [ThemeEntity] = [
        ThemeEntity(
            id: "mourning",
            label: "Colours of mourning",
            colorIds: ["payne-grey", "tyrian-purple", "mummy-brown"]
        ),
        ThemeEntity(
            id: "poison",
            label: "Pigments that could kill",
            colorIds: ["scheeles-green", "vermilion", "orpiment", "lead-white"]
        ),
        ThemeEntity(
            id: "royal",
            label: "Reserved for royalty",
            colorIds: ["tyrian-purple", "ultramarine", "han-purple"]
        ),
    ]

    // MARK: - Prussian Blue full lens corpus

    /// The one fully-curated lens corpus shipped in the prototype.
    /// Other colors fall back to placeholder entries via `Self.placeholderLenses`.
    static let prussianBlueLenses: [LensEntity] = [
        LensEntity(
            id: .art,
            label: "Art History",
            glyph: .brush,
            intro: "A pigment cheap enough to flood the world’s skies, oceans and sorrows. Within a century of its invention it had crossed every sea on Earth.",
            entries: [
                LensEntryEntity(lensId: .art, index: 0,
                    meta: "Katsushika Hokusai · c. 1831",
                    title: "The Great Wave off Kanagawa",
                    blurb: "Hokusai built the wave from imported Prussian blue — known in Japan as “bero-ai.” The new synthetic pigment held its hue where traditional indigo faded, letting the foam claw at a permanent sky.",
                    imageRef: "Ukiyo-e woodblock print"),
                LensEntryEntity(lensId: .art, index: 1,
                    meta: "Vincent van Gogh · 1889",
                    title: "The Starry Night",
                    blurb: "The roiling night of Saint-Rémy is carried by Prussian blue and cobalt, swirled wet-into-wet from the asylum window before dawn.",
                    imageRef: "Post-Impressionist oil"),
                LensEntryEntity(lensId: .art, index: 2,
                    meta: "Pablo Picasso · 1903–04",
                    title: "The Old Guitarist",
                    blurb: "Picasso’s Blue Period drowned its grief in this single cold pigment — poverty, hunger and isolation rendered almost monochrome.",
                    imageRef: "Blue Period oil"),
            ]
        ),
        LensEntity(
            id: .fashion,
            label: "Fashion",
            glyph: .thread,
            intro: "Before it was a colour of leisure, blue was a colour of discipline — cut, pressed, and worn as authority.",
            entries: [
                LensEntryEntity(lensId: .fashion, index: 0,
                    meta: "18th-century military dress",
                    title: "The Prussian Officer’s Coat",
                    blurb: "The deep uniform blue of the Prussian army lent the pigment its name and its bearing: severe, exact, unmistakable across a field.",
                    imageRef: "Military uniform plate"),
                LensEntryEntity(lensId: .fashion, index: 1,
                    meta: "French workwear · c. 1900",
                    title: "Bleu de Travail",
                    blurb: "The chore jacket dyed working bodies the colour of the sky’s indifference — hard-wearing, humble, now endlessly revived on the runway.",
                    imageRef: "Cotton drill chore coat"),
                LensEntryEntity(lensId: .fashion, index: 2,
                    meta: "Enduring tailoring",
                    title: "The Navy Suit",
                    blurb: "No colour signals quiet authority like a dark navy — formal without the finality of black, the default uniform of trust.",
                    imageRef: "Tailored suiting"),
            ]
        ),
        LensEntity(
            id: .nature,
            label: "Nature",
            glyph: .leaf,
            intro: "True blue is vanishingly rare in the living world. Most of what we call blue is a trick of structure, not pigment.",
            entries: [
                LensEntryEntity(lensId: .nature, index: 0,
                    meta: "Passerina cyanea",
                    title: "The Indigo Bunting",
                    blurb: "The bird carries no blue pigment at all — microscopic feather structure scatters light, painting it sky-blue only when the sun agrees.",
                    imageRef: "Songbird, breeding plumage"),
                LensEntryEntity(lensId: .nature, index: 1,
                    meta: "L’heure bleue",
                    title: "The Blue Hour",
                    blurb: "The window after sunset when the sun lights only the upper atmosphere, draining the world to a single saturated, sourceless blue.",
                    imageRef: "Twilight landscape"),
                LensEntryEntity(lensId: .nature, index: 2,
                    meta: "200–2,000 m depth",
                    title: "The Bathyal Zone",
                    blurb: "Red light dies first in seawater; blue travels deepest. Past a thousand metres, blue is the last colour, then none at all.",
                    imageRef: "Deep ocean column"),
            ]
        ),
        LensEntity(
            id: .pop,
            label: "Pop Culture",
            glyph: .star,
            intro: "The pigment quietly built the modern world’s documents — and, improbably, became a life-saving drug.",
            entries: [
                LensEntryEntity(lensId: .pop, index: 0,
                    meta: "Cyanotype · Sir John Herschel, 1842",
                    title: "The Blueprint",
                    blurb: "Architecture and engineering were copied for a century in Prussian blue. The word “blueprint” outlived the chemistry that made it.",
                    imageRef: "Architectural cyanotype"),
                LensEntryEntity(lensId: .pop, index: 1,
                    meta: "Anna Atkins · 1843",
                    title: "Photographs of British Algae",
                    blurb: "Often called the first book illustrated with photographs — ghostly white seaweed laid on fields of Prussian blue.",
                    imageRef: "Cyanotype photogram"),
                LensEntryEntity(lensId: .pop, index: 2,
                    meta: "Medical antidote",
                    title: "Radiogardase",
                    blurb: "Pharmaceutical-grade Prussian blue binds thallium and radioactive cesium in the gut — the same molecule that colours a blueprint.",
                    imageRef: "Pharmaceutical capsule"),
            ]
        ),
        LensEntity(
            id: .etymology,
            label: "Etymology",
            glyph: .quote,
            intro: "A colour named for an army, born from a botched batch of red dye in a Berlin laboratory.",
            entries: [
                LensEntryEntity(lensId: .etymology, index: 0,
                    meta: "Berlin · c. 1706",
                    title: "Berliner Blau",
                    blurb: "Colour-maker Johann Jacob Diesbach was attempting a red lake when contaminated potash turned his batch a brilliant, unexpected blue.",
                    imageRef: "Period laboratory"),
                LensEntryEntity(lensId: .etymology, index: 1,
                    meta: "For the Kingdom of Prussia",
                    title: "“Preußisch Blau”",
                    blurb: "The pigment took the name of the state whose military wore it — the first colour named after a nation rather than a place or a plant.",
                    imageRef: "Heraldic plate"),
                LensEntryEntity(lensId: .etymology, index: 2,
                    meta: "Japan · early 1800s",
                    title: "“Bero-ai”",
                    blurb: "Imported through Nagasaki, the foreign blue entered Japanese as a loanword — “berorin ai,” Berlin indigo — before transforming ukiyo-e.",
                    imageRef: "Trade-era document"),
            ]
        ),
        LensEntity(
            id: .symbolism,
            label: "Symbolism",
            glyph: .eye,
            intro: "Across cultures the colour holds two opposite truths at once: distance and depth, sadness and trust.",
            entries: [
                LensEntryEntity(lensId: .symbolism, index: 0,
                    meta: "Melancholy",
                    title: "Feeling Blue",
                    blurb: "The Western shorthand for sorrow. Picasso painted it; the blues sang it. A colour cool enough to stand in for grief itself.",
                    imageRef: "Mood study"),
                LensEntryEntity(lensId: .symbolism, index: 1,
                    meta: "Depth & distance",
                    title: "The Unconscious",
                    blurb: "Blue recedes — the colour of horizons, dreams and the parts of the mind we cannot reach. We move “into the blue.”",
                    imageRef: "Horizon study"),
                LensEntryEntity(lensId: .symbolism, index: 2,
                    meta: "Trust & constancy",
                    title: "True Blue",
                    blurb: "The same recession reads as steadiness: the loyal friend, the dependable institution, the colour chosen by banks and nations.",
                    imageRef: "Symbolic study"),
            ]
        ),
    ]

    /// Generate placeholder lens content for any colour without a curated corpus.
    /// Matches the prototype's fallback behavior in screens.jsx.
    static func placeholderLenses(for color: ColorEntity) -> [LensEntity] {
        LensId.displayOrder.map { lensId in
            LensEntity(
                id: lensId,
                label: lensId.defaultLabel,
                glyph: lensId.defaultGlyph,
                intro: "Editorial intro for \(lensId.defaultLabel.lowercased()) is curated per colour during the build.",
                entries: (0..<3).map { i in
                    LensEntryEntity(
                        lensId: lensId,
                        index: i,
                        meta: "Artist / source · year",
                        title: ["First entry", "Second entry", "Third entry"][i],
                        blurb: "Each lens shows three to five curated entries with image, caption and a short essay. The layout stays editorial, never a bare list.",
                        imageRef: "\(lensId.defaultLabel) reference"
                    )
                }
            )
        }
    }

    // MARK: - Composition

    /// Materialize a fully-loaded ColorEntity (with poem, recipe, and lens corpus)
    /// for the given summary id.
    static func fullColor(id: ColorId) -> ColorEntity? {
        guard let row = archiveSummaries.first(where: { $0.id == id }) else { return nil }
        let poem = poems[id] ?? fallbackPoem
        let recipe = recipes[id]
        // Build a summary first so we can derive placeholder lenses if needed.
        let base = ColorEntity(
            id: id,
            name: row.name,
            hex: row.hex,
            onColorHex: row.onColor,
            date: row.date,
            dateShort: row.dateShort,
            poem: poem,
            recipe: recipe,
            lenses: nil
        )
        let lenses = id == "prussian-blue" ? prussianBlueLenses : placeholderLenses(for: base)
        return ColorEntity(
            id: id,
            name: row.name,
            hex: row.hex,
            onColorHex: row.onColor,
            date: row.date,
            dateShort: row.dateShort,
            poem: poem,
            recipe: recipe,
            lenses: lenses
        )
    }

    /// Summary-only ColorEntity (used for Archive / Search grids).
    static func summaryColor(id: ColorId) -> ColorEntity? {
        guard let row = archiveSummaries.first(where: { $0.id == id }) else { return nil }
        return ColorEntity(
            id: id,
            name: row.name,
            hex: row.hex,
            onColorHex: row.onColor,
            date: row.date,
            dateShort: row.dateShort,
            poem: nil,
            recipe: nil,
            lenses: nil
        )
    }
}
