spells.json: parse-spells.pl spelllist.txt spelldescs.txt
	perl6 parse-spells.pl | json_pp -json_opt pretty,utf8,canonical > spells.json
