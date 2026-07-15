extends Node

var correct_sentence

var nouns = [
	"table", "chair", "tea", "mug", "computer", "laptop", "hedgehog", "phone",
	"shoe", "slipper", "leaf", "glass", "booklet", "pottery", "hand cream",
	"book", "flag", "man", "woman", "enby", "person", "drum", "nail polish", "poster",
	"paper", "wii sports", "origami", "kitten", "cat", "dog", "puppy", "fox", "snail",
	"nintendo 3ds", "deodorant", "controller", "prison warden", "door", "sloth",
	"mountain climber", "tyre", "guitar", "mouse", "rat", "spray bottle", "tintin",
	"slinky", "vaseline", "lanyard", "slipper", "skirt", "shirt", "vampire", "sun",
	"daughter", "son", "follower", "streamer", "wire", "USB stick", "keychain",
	"lost key", "pair of pyjamas", "scissors", "flashcard", "lamp", "timer", "magnet",
	"scarf", "bag", "music festival", "examiner", "lunatic", "chicken", "egg",
	"tree", "tie", "dress", "laptop", "pokemon", "hair", "locker",
	"plant", "flower", "clock", "sand", "mountain", "mat", "rug", "seat",
	"tree", "child", "spouse", "fish", "government", "whale", "fool",
	"thermometer", "metronome", "mum", "dad", "train", "gallery", "cinema",
	"zebra", "zoo", "newspaper", "letter", "radio", "shark", "blahaj"
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
	"hairy", "wooden", "iron", "plastic", "metal", "copper", "ceramic",
	"accident-prone", "bashful", "cloth", "flimsy", "conceited", "sober",
	"playful", "sizeable", "happy", "morose", "sad", "excited", "large",
	"small", "big", "tiny", "local"
]

var verbs_present = [
	"steals", "sings about", "wants", "runs alongside", "punches", "rips", "pushes", "drowns",
	"agitates", "annoys", "pioneers", "destroys", "discovers", "saves", "growls at", "barks at",
	"meows at", "yips at", "snarls at", "bites at", "kisses", "marries", "hugs", "confuses",
	"pinches", "kicks", "licks", "flicks at", "throws a stone at", "pulls at", "frowns at",
	"rubs", "brawls", "holds", "eats whole", "sits on", "flips", "circles", "slaps",
	"encircles", "repots", "transmogrifies", "snaps", "manifests", "expunges", "chooses",
	"attends funeral of", "ends up with", "wears", "swims with", "rides", "thinks about",
	"consumes", "murders", "loses",
]

var adverbs_present = [
	"regrettably", "quickly", "light-heartedly", "heavy-heartedly", "speedily", "smoothly",
	"harshly", "slowly", "annoyedly", "tiredly", "energetically", "sloppily", "angrily",
	"gaily", "begrudgingly", "happily", "unfortunately", "stupidly", "lazily",
	"ultimately", "loosely", "thinly", "boringly", "unfortunately", "undoubtedly",
	"dreamily", "generously", "reluctantly", "accidentally", "never", "nearly",
	"almost", "nervously"
]

var adverbs_future = [
	"to", "will", "wants to", "might", "won't", "will not", ""
]

var verbs_future = [
	"steal", "sing about", "want", "run alongside", "punch", "rip", "push", "drown",
	"agitate", "annoy", "pioneer", "destroy", "discover", "save", "growl at", "bark at",
	"meow at", "yip at", "snarl at", "bite at", "kiss", "marry", "hug", "confuse",
	"pinch", "kick", "lick", "flick at", "throw a stone at", "pull at", "frown at",
	"rub", "brawl", "hold", "eat whole", "sit on", "flip", "circle", "slap",
	"encircle", "repot", "transmogrify", "snap", "manifest", "expunge", "choose",
	"attend funeral of", "end up with", "wear", "swim with", "ride", "think about",
	"consume", "murder", "lose",
]

var flairs = [
	"Reported", "Breaking", "Breaking News", "Local", "Science", "Space",
	"Arts",
]

var connectives = [
	"and", "but", "so", "then", "thus", "before", "after",
]

var sentence_structures = [
	["adj", "noun", "adv_p", "verb_p", "adj", "noun"],
	["adj", "and", "adj", "noun", "verb_p", "noun"],
	["noun", "verb_p", "noun", "conn", "noun", "verb_p", "noun"],
	["adj", "noun", "adv_f", "verb_f", "adj", "noun"]
]

var boss_sentence_structures = [
	["adj", "and", "adj", "noun", "adv_p", "and", "adv_p", "verb_p", "adj", "noun"]
]

func create_sentence(structure = sentence_structures) -> String:
	var sentence_structure
	sentence_structure = structure.pick_random()
	var sentence = ""
	if randi_range(1,5) == 1: #1 in 5 to add a flair
		sentence += flairs.pick_random() + ": "
	for word in sentence_structure:
		var word_to_add : String
		match word:
			"adj":
				word_to_add = adjectives.pick_random()
			"noun":
				word_to_add = nouns.pick_random()
			"adv_p": #present
				word_to_add = adverbs_present.pick_random()
			"verb_p": #present
				word_to_add = verbs_present.pick_random()
			"adv_f": #future
				word_to_add = adverbs_future.pick_random()
			"verb_f": #future
				word_to_add = verbs_future.pick_random()
			"conn":
				word_to_add = connectives.pick_random()
			_:
				word_to_add = word
		
		sentence += word_to_add + " "
	return sentence

func create_boss_sentence():
	return create_sentence(boss_sentence_structures)
