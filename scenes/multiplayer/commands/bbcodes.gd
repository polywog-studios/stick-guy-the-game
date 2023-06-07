extends BaseCommand

var bb_codes = [
	'[b\u200e]: [b]bold[/b]',
	'[i\u200e]: [i]italic[/i]',
	'[font_size\u200e={value}]: [font_size=32]size 32[/font_size]',
	'[color\u200e={hex}]: [color=#FF0000]color #FF0000[/color]',
	'[flt\u200e]: [flt]floating[/flt]',
	'[shk\u200e]: [shk]shaking[/shk]',
	'[pride\u200e]: [pride]rainbow[/pride]',
	'[pride\u200e flag={flag}]: [pride flag=mlm]mlm[/pride], [pride flag=lesbian]lesbian[/pride], [pride flag=bi]bi[/pride], [pride flag=pan]pan[/pride], [pride flag=trans]trans[/pride]'
]

func _init():
	description = "bbcodes up your ass."

func _ready():
	for i in bb_codes:
		game._submit_raw_local_message(i, "big gay")
