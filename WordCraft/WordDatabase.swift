import Foundation

// Word database for the game
struct WordPuzzle: Codable {
    let word: String
    let hint: String
    let difficulty: GameLevel

    // Scramble the word letters
    func scrambled() -> [String] {
        return word.map { String($0) }.shuffled()
    }
}

class WordDatabase {
    static let shared = WordDatabase()

    // Easy words (4-5 letters) — 50 words
    let easyWords = [
        WordPuzzle(word: "APPLE", hint: "A red fruit 🍎", difficulty: .easy),
        WordPuzzle(word: "BREAD", hint: "You make toast with this 🍞", difficulty: .easy),
        WordPuzzle(word: "CHAIR", hint: "Something you sit on 🪑", difficulty: .easy),
        WordPuzzle(word: "DANCE", hint: "Move to music 💃", difficulty: .easy),
        WordPuzzle(word: "EARTH", hint: "Our planet 🌍", difficulty: .easy),
        WordPuzzle(word: "FLAME", hint: "Hot and bright 🔥", difficulty: .easy),
        WordPuzzle(word: "GRAPE", hint: "Purple fruit in bunches 🍇", difficulty: .easy),
        WordPuzzle(word: "HEART", hint: "Symbol of love ❤️", difficulty: .easy),
        WordPuzzle(word: "LEMON", hint: "Sour yellow fruit 🍋", difficulty: .easy),
        WordPuzzle(word: "OCEAN", hint: "Large body of water 🌊", difficulty: .easy),
        WordPuzzle(word: "TIGER", hint: "Striped big cat 🐯", difficulty: .easy),
        WordPuzzle(word: "STORM", hint: "Heavy rain and wind ⛈️", difficulty: .easy),
        WordPuzzle(word: "PLANT", hint: "Grows in soil 🌱", difficulty: .easy),
        WordPuzzle(word: "WATER", hint: "You drink this daily 💧", difficulty: .easy),
        WordPuzzle(word: "MUSIC", hint: "Sounds that make melodies 🎵", difficulty: .easy),
        WordPuzzle(word: "CLOUD", hint: "Fluffy thing in the sky ☁️", difficulty: .easy),
        WordPuzzle(word: "BEACH", hint: "Sandy place by the sea 🏖️", difficulty: .easy),
        WordPuzzle(word: "CLOCK", hint: "Tells you the time ⏰", difficulty: .easy),
        WordPuzzle(word: "DREAM", hint: "Happens when you sleep 💤", difficulty: .easy),
        WordPuzzle(word: "EAGLE", hint: "Majestic bird of prey 🦅", difficulty: .easy),
        WordPuzzle(word: "FROST", hint: "Thin ice on cold mornings ❄️", difficulty: .easy),
        WordPuzzle(word: "GHOST", hint: "Spooky spirit 👻", difficulty: .easy),
        WordPuzzle(word: "HOUSE", hint: "Place where you live 🏠", difficulty: .easy),
        WordPuzzle(word: "JUICE", hint: "Squeezed from fruits 🧃", difficulty: .easy),
        WordPuzzle(word: "KNIFE", hint: "Used for cutting 🔪", difficulty: .easy),
        WordPuzzle(word: "LIGHT", hint: "Opposite of darkness 💡", difficulty: .easy),
        WordPuzzle(word: "MOUSE", hint: "Small squeaky animal 🐭", difficulty: .easy),
        WordPuzzle(word: "NIGHT", hint: "When it gets dark 🌙", difficulty: .easy),
        WordPuzzle(word: "PEARL", hint: "Gem found in oysters 🦪", difficulty: .easy),
        WordPuzzle(word: "QUEEN", hint: "Female royal ruler 👑", difficulty: .easy),
        WordPuzzle(word: "RIVER", hint: "Flowing body of water 🏞️", difficulty: .easy),
        WordPuzzle(word: "SNAKE", hint: "Slithering reptile 🐍", difficulty: .easy),
        WordPuzzle(word: "TRAIN", hint: "Rides on tracks 🚂", difficulty: .easy),
        WordPuzzle(word: "UMBRA", hint: "Shadow or shade 🌑", difficulty: .easy),
        WordPuzzle(word: "VIOLA", hint: "String instrument 🎻", difficulty: .easy),
        WordPuzzle(word: "WHALE", hint: "Biggest ocean creature 🐋", difficulty: .easy),
        WordPuzzle(word: "YOUTH", hint: "Young age or energy 🧒", difficulty: .easy),
        WordPuzzle(word: "ZEBRA", hint: "Black and white striped animal 🦓", difficulty: .easy),
        WordPuzzle(word: "STONE", hint: "Hard rock on the ground 🪨", difficulty: .easy),
        WordPuzzle(word: "MAPLE", hint: "Tree with sweet syrup 🍁", difficulty: .easy),
        WordPuzzle(word: "CANDY", hint: "Sweet sugary treat 🍬", difficulty: .easy),
        WordPuzzle(word: "TOWER", hint: "Tall narrow building 🗼", difficulty: .easy),
        WordPuzzle(word: "PIANO", hint: "Keyboard instrument 🎹", difficulty: .easy),
        WordPuzzle(word: "OLIVE", hint: "Small green or black fruit 🫒", difficulty: .easy),
        WordPuzzle(word: "MELON", hint: "Big round summer fruit 🍈", difficulty: .easy),
        WordPuzzle(word: "BRUSH", hint: "Used for painting or hair 🖌️", difficulty: .easy),
        WordPuzzle(word: "CORAL", hint: "Colorful sea structure 🪸", difficulty: .easy),
        WordPuzzle(word: "FIELD", hint: "Open grassy area 🌾", difficulty: .easy),
        WordPuzzle(word: "GLOBE", hint: "Model of the Earth 🌐", difficulty: .easy),
        WordPuzzle(word: "SCARF", hint: "Warm neck wrap 🧣", difficulty: .easy),
    ]

    // Medium words (6-7 letters) — 50 words
    let mediumWords = [
        WordPuzzle(word: "BALANCE", hint: "Stay steady ⚖️", difficulty: .medium),
        WordPuzzle(word: "CHICKEN", hint: "Farm bird that lays eggs 🐔", difficulty: .medium),
        WordPuzzle(word: "DIAMOND", hint: "Precious gemstone 💎", difficulty: .medium),
        WordPuzzle(word: "EXPLORE", hint: "Discover new places 🗺️", difficulty: .medium),
        WordPuzzle(word: "FREEDOM", hint: "Liberty and independence 🕊️", difficulty: .medium),
        WordPuzzle(word: "GIRAFFE", hint: "Tallest land animal 🦒", difficulty: .medium),
        WordPuzzle(word: "HAMSTER", hint: "Small furry pet 🐹", difficulty: .medium),
        WordPuzzle(word: "LIBRARY", hint: "Place full of books 📚", difficulty: .medium),
        WordPuzzle(word: "MONSTER", hint: "Scary creature 👾", difficulty: .medium),
        WordPuzzle(word: "RAINBOW", hint: "Colorful arc in the sky 🌈", difficulty: .medium),
        WordPuzzle(word: "CAPTAIN", hint: "Leader of a ship or team ⚓", difficulty: .medium),
        WordPuzzle(word: "BLANKET", hint: "Warm bed cover 🛏️", difficulty: .medium),
        WordPuzzle(word: "DOLPHIN", hint: "Smart ocean mammal 🐬", difficulty: .medium),
        WordPuzzle(word: "FEATHER", hint: "Light thing from a bird 🪶", difficulty: .medium),
        WordPuzzle(word: "KITCHEN", hint: "Room where you cook 🍳", difficulty: .medium),
        WordPuzzle(word: "LANTERN", hint: "Portable light source 🏮", difficulty: .medium),
        WordPuzzle(word: "PENGUIN", hint: "Black and white bird 🐧", difficulty: .medium),
        WordPuzzle(word: "SHELTER", hint: "Protection from weather 🏕️", difficulty: .medium),
        WordPuzzle(word: "VOLCANO", hint: "Mountain that erupts 🌋", difficulty: .medium),
        WordPuzzle(word: "WEATHER", hint: "Sun, rain, or snow 🌤️", difficulty: .medium),
        WordPuzzle(word: "ARCHIVE", hint: "Collection of records 🗄️", difficulty: .medium),
        WordPuzzle(word: "BICYCLE", hint: "Two-wheeled ride 🚲", difficulty: .medium),
        WordPuzzle(word: "COMPASS", hint: "Shows direction 🧭", difficulty: .medium),
        WordPuzzle(word: "DESSERT", hint: "Sweet after a meal 🍰", difficulty: .medium),
        WordPuzzle(word: "EVENING", hint: "Late part of the day 🌆", difficulty: .medium),
        WordPuzzle(word: "FICTION", hint: "Made-up stories 📖", difficulty: .medium),
        WordPuzzle(word: "GATEWAY", hint: "An entrance or opening 🚪", difficulty: .medium),
        WordPuzzle(word: "HARVEST", hint: "Gathering crops 🌽", difficulty: .medium),
        WordPuzzle(word: "INVOICE", hint: "Bill for payment 🧾", difficulty: .medium),
        WordPuzzle(word: "JOURNEY", hint: "A long trip ✈️", difficulty: .medium),
        WordPuzzle(word: "KINGDOM", hint: "Land ruled by a king 🏰", difficulty: .medium),
        WordPuzzle(word: "LOBSTER", hint: "Red sea creature 🦞", difficulty: .medium),
        WordPuzzle(word: "MYSTERY", hint: "Something unknown 🔍", difficulty: .medium),
        WordPuzzle(word: "NETWORK", hint: "Connected system 🌐", difficulty: .medium),
        WordPuzzle(word: "PANTHER", hint: "Black wild cat 🐆", difficulty: .medium),
        WordPuzzle(word: "REACTOR", hint: "Energy producing device ⚛️", difficulty: .medium),
        WordPuzzle(word: "SOLDIER", hint: "Person in the army 🪖", difficulty: .medium),
        WordPuzzle(word: "TEACHER", hint: "Person who educates 📝", difficulty: .medium),
        WordPuzzle(word: "UNICORN", hint: "Mythical horned horse 🦄", difficulty: .medium),
        WordPuzzle(word: "VILLAGE", hint: "Small community 🏘️", difficulty: .medium),
        WordPuzzle(word: "WARRIOR", hint: "Brave fighter ⚔️", difficulty: .medium),
        WordPuzzle(word: "BATTERY", hint: "Stores electric power 🔋", difficulty: .medium),
        WordPuzzle(word: "COSTUME", hint: "Special outfit for dress-up 🎭", difficulty: .medium),
        WordPuzzle(word: "ORIGAMI", hint: "Japanese paper folding art 🦢", difficulty: .medium),
        WordPuzzle(word: "FLIGHTS", hint: "Air travel trips ✈️", difficulty: .medium),
        WordPuzzle(word: "GLACIER", hint: "Massive slow-moving ice 🧊", difficulty: .medium),
        WordPuzzle(word: "HORIZON", hint: "Where sky meets earth 🌅", difficulty: .medium),
        WordPuzzle(word: "IMAGINE", hint: "Create in your mind 💭", difficulty: .medium),
        WordPuzzle(word: "JASMINE", hint: "Fragrant white flower 🌸", difficulty: .medium),
        WordPuzzle(word: "KETCHUP", hint: "Red tomato sauce 🍅", difficulty: .medium),
    ]

    // Hard words (8+ letters) — 50 words
    let hardWords = [
        WordPuzzle(word: "BIRTHDAY", hint: "Annual celebration 🎂", difficulty: .hard),
        WordPuzzle(word: "ELEPHANT", hint: "Large animal with trunk 🐘", difficulty: .hard),
        WordPuzzle(word: "FOOTBALL", hint: "Popular sport with oval ball 🏈", difficulty: .hard),
        WordPuzzle(word: "KEYBOARD", hint: "You type on this ⌨️", difficulty: .hard),
        WordPuzzle(word: "MOUNTAIN", hint: "Very tall landform 🏔️", difficulty: .hard),
        WordPuzzle(word: "PARADISE", hint: "Perfect, heavenly place 🏝️", difficulty: .hard),
        WordPuzzle(word: "QUESTION", hint: "Something you ask ❓", difficulty: .hard),
        WordPuzzle(word: "SANDWICH", hint: "Food between two bread slices 🥪", difficulty: .hard),
        WordPuzzle(word: "TREASURE", hint: "Hidden riches 💰", difficulty: .hard),
        WordPuzzle(word: "UMBRELLA", hint: "Keeps you dry in rain ☂️", difficulty: .hard),
        WordPuzzle(word: "ABSTRACT", hint: "Not concrete or physical 🎨", difficulty: .hard),
        WordPuzzle(word: "BRACELET", hint: "Jewelry worn on wrist 📿", difficulty: .hard),
        WordPuzzle(word: "CALENDAR", hint: "Shows dates and months 📅", difficulty: .hard),
        WordPuzzle(word: "DARKNESS", hint: "Absence of light 🌑", difficulty: .hard),
        WordPuzzle(word: "ENVELOPE", hint: "Holds a letter inside ✉️", difficulty: .hard),
        WordPuzzle(word: "FIREWORK", hint: "Explodes with colors in sky 🎆", difficulty: .hard),
        WordPuzzle(word: "GRAPHITE", hint: "What pencils are made of ✏️", difficulty: .hard),
        WordPuzzle(word: "HOMEWORK", hint: "School work done at home 📓", difficulty: .hard),
        WordPuzzle(word: "ICECREAM", hint: "Frozen sweet treat 🍦", difficulty: .hard),
        WordPuzzle(word: "KANGAROO", hint: "Jumping Australian animal 🦘", difficulty: .hard),
        WordPuzzle(word: "LEMONADE", hint: "Sweet lemon drink 🍋", difficulty: .hard),
        WordPuzzle(word: "MUSHROOM", hint: "Fungus that grows on the ground 🍄", difficulty: .hard),
        WordPuzzle(word: "NECKLACE", hint: "Jewelry worn around neck 📿", difficulty: .hard),
        WordPuzzle(word: "ORNAMENT", hint: "Decoration on a tree 🎄", difficulty: .hard),
        WordPuzzle(word: "PLATFORM", hint: "Raised flat surface 🚏", difficulty: .hard),
        WordPuzzle(word: "REINDEER", hint: "Pulls Santa's sleigh 🦌", difficulty: .hard),
        WordPuzzle(word: "SKELETON", hint: "Framework of bones 💀", difficulty: .hard),
        WordPuzzle(word: "TOMATOES", hint: "Red salad ingredient 🍅", difficulty: .hard),
        WordPuzzle(word: "AVOCADOS", hint: "Green fruit for guacamole 🥑", difficulty: .hard),
        WordPuzzle(word: "BARBECUE", hint: "Outdoor grill cooking 🍖", difficulty: .hard),
        WordPuzzle(word: "CHAMPION", hint: "Winner of a competition 🏆", difficulty: .hard),
        WordPuzzle(word: "DINOSAUR", hint: "Extinct prehistoric reptile 🦕", difficulty: .hard),
        WordPuzzle(word: "ESCALATE", hint: "Increase or make worse 📈", difficulty: .hard),
        WordPuzzle(word: "FRECKLES", hint: "Small brown spots on skin 👧", difficulty: .hard),
        WordPuzzle(word: "HAPPENED", hint: "Past tense of occur 📜", difficulty: .hard),
        WordPuzzle(word: "ILLUSION", hint: "Something that tricks your eyes 🪄", difficulty: .hard),
        WordPuzzle(word: "JACKHAMMER", hint: "Loud drilling tool 🔨", difficulty: .hard),
        WordPuzzle(word: "LANDMARK", hint: "Famous recognizable place 🗽", difficulty: .hard),
        WordPuzzle(word: "MOLECULE", hint: "Tiny particle of matter ⚗️", difficulty: .hard),
        WordPuzzle(word: "NOTEBOOK", hint: "For writing notes 📒", difficulty: .hard),
        WordPuzzle(word: "OVERTIME", hint: "Working extra hours ⏰", difficulty: .hard),
        WordPuzzle(word: "PARACHUTE", hint: "Slows you down when falling 🪂", difficulty: .hard),
        WordPuzzle(word: "RESPONSE", hint: "An answer or reply 💬", difficulty: .hard),
        WordPuzzle(word: "SQUIRREL", hint: "Small animal that loves nuts 🐿️", difficulty: .hard),
        WordPuzzle(word: "TWILIGHT", hint: "Light after sunset 🌇", difficulty: .hard),
        WordPuzzle(word: "WATERFALL", hint: "Water cascading off a cliff 💦", difficulty: .hard),
        WordPuzzle(word: "YEARBOOK", hint: "School memory book 📕", difficulty: .hard),
        WordPuzzle(word: "BACKPACK", hint: "Bag carried on shoulders 🎒", difficulty: .hard),
        WordPuzzle(word: "CUPCAKES", hint: "Small frosted treats 🧁", difficulty: .hard),
        WordPuzzle(word: "DOORBELL", hint: "Ring when you arrive 🔔", difficulty: .hard),
    ]

    func getWords(for level: GameLevel) -> [WordPuzzle] {
        let pool: [WordPuzzle]
        switch level {
        case .easy: pool = easyWords
        case .medium: pool = mediumWords
        case .hard: pool = hardWords
        }
        return Array(pool.shuffled().prefix(10))
    }
}
