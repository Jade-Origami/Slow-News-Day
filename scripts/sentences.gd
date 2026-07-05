extends Node

var correct_sentence

var nouns = [
	"table", "chair", "tea", "mug", "computer", "laptop", "hedgehog", "phone",
	"shoe", "slipper", "leaf", "glass", "booklet", "pottery", "hand cream",
	"book", "flag", "man", "woman", "enby", "person", "drum", "nail polish", "poster",
	"paper", "wii sports", "origami", "kitten", "cat", "dog", "puppy", "fox", "snail",
	"nintendo 3ds", "deodorant", "controller", "prison warden", "door", "sloth",
	"mountain climber", "tire", "guitar", "mouse", "rat", "spray bottle", "tintin",
	"slinky", "vaseline", "lanyard", "trouser leg", "skirt", "shirt", "vampire", "sun",
	"daughter", "son", "follower", "streamer", "wire", "USB stick", "keychain",
	"lost key", "pair of pyjamas", "scissors", "flashcard", "lamp", "timer", "magnet",
	"scarf", "bag", "music festival", "examiner", "lunatic", "chicken", "egg",
	"tree", "tie", "dress", "wii sports resort", "pokemon", "hair", "locker",
	"plant", "flower", "clock", "sand", "mountain"
]

var adjectives = [
	"transgender", "gay", "tall", "short", "heavy", "light", "powerful", "old",
	"wet", "decrepid", "slippery", "crumbling", "broken", "discoloured", "pink",
	"blue", "red", "green", "grey", "tired", "folded", "slimy", "soft",
	"angry", "sticky", "heated", "crazy", "cracked", "sloppy", "american",
	"british", "french", "german", "spanish", "scottish", "welsh", "irish",
	"purple", "puzzled", "confused", "unusual", "cold", "warm", "ace",
	"straight", "disappointed", "new", "swanky", "drunk", "nonplussed",
	"young", "fickle", "idiotic", "ridiculous", "pointless", "orange",
	"hairy"
]

var verbs = [
	"steals", "sings about", "wants", "runs alongside", "punches", "rips", "pushes", "drowns",
	"agitates", "annoys", "pioneers", "destroys", "discovers", "saves", "growls at", "barks at",
	"meows at", "yips at", "snarls at", "bites at", "kisses", "marries", "hugs", "confuses",
	"pinches", "kicks", "licks", "flicks at", "throws a stone at", "pulls at", "frowns at",
	"rubs", "brawls with", "holds", "eats whole", "sits on", "flips", "circles",
	"encircles", "repots", "transmogrifies", "snaps", "manifests", "expunges"
]

var adverbs = [
	"regrettably", "quickly", "light-heartedly", "heavy-heartedly", "speedily", "smoothly",
	"harshly", "slowly", "annoyedly", "tiredly", "energetically", "sloppily", "angrily",
	"gaily", "begrudgingly", "happily", "unfortunately", "stupidly", "lazily",
	"ultimately", "loosely", "thinly", "boringly", "unfortunately", "undoubtedly"
]

var connectives = [
	"and", "but", "so", "therefore"
]

var sentence_structures = [
	["adj", "noun", "adv", "verb", "adj", "noun"],
	["adj", "and", "adj", "noun", "verb", "noun"],
]

func create_sentence(different_space_char) -> String:
	var sentence_structure = sentence_structures.pick_random()
	var sentence = ""
	var space_char = " "
	if different_space_char:
		space_char = "_"
	for word in sentence_structure:
		var word_to_add : String
		match word:
			"adj":
				word_to_add = adjectives.pick_random()
			"noun":
				word_to_add = nouns.pick_random()
			"adv":
				word_to_add = adverbs.pick_random()
			"verb":
				word_to_add = verbs.pick_random()
			_:
				word_to_add = word
		word_to_add.replacen(" ", space_char)
		sentence += word_to_add + space_char
	return sentence
