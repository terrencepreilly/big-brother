BigBrother.js: script/BigBrother.elm
	elm-make script/BigBrother.elm --output=BigBrother.js

.PHONY: clean
clean:
	rm BigBrother.js
