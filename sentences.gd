extends Node

var nouns = [
	"table ", "chair ", "tea ", "mug ", "computer ", "laptop ", "hedgehog ", "phone ",
	"shoe ", "slipper ", "leaf ", "glass ", "spectacles ", "pottery ", "hand cream ",
	"book ", "flag ", "man ", "woman ", "enby ", "person ", "drum ", "nail polish ", "poster ",
	"paper ", "wii sports ", "origami ", "kitten ", "cat ", "dog ", "puppy ", "fox ", "snail ",
	"nintendo 3ds ", "deoderant ", "controller ", "prison warden ", "door ", "sloth ",
	"mountain climber ", "tire "
]

var adjectives = [
	"transgender ", "gay ", "tall ", "short ", "heavy ", "light ", "powerful ", "old ",
	"wet ", "decrepid ", "slippery ", "stinky ", "broken ", "discoloured ", "pink ",
	"blue ", "red ", "green ", "grey ", "tired "
]

var verbs = [
	"steals ", "sings about ", "wants ", "runs alongside ", "punches ", "rips ", "pushes ", "drowns ", "agitates ",
	"annoys ", "pioneers ", "destroys ", "discovers ", "saves "
]

var adverbs = [
	"regrettably ", "quickly ", "light-heartedly ", "heavy-heartedly ", "speedily ", "smoothly ",
	"harshly ", "slowly ", "annoyedly ", "tiredly ", "energetically "
]

var connectives = [
	"and ", "but ", "so ", "therefore ", "unfortunately ", "undoubtedly "
]

var correct_sentence

func create_sentence() -> String:
	var created_sentence_list = [adjectives.pick_random() + nouns.pick_random() + 
	adverbs.pick_random() + verbs.pick_random() + adjectives.pick_random() + nouns.pick_random()]
	var created_sentence = ""
	for i in range(created_sentence_list.size()):
		created_sentence += created_sentence_list[i]
	created_sentence = created_sentence.strip_edges()
	return created_sentence
