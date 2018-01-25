BigBrother.js: BigBrother.elm
	elm-make BigBrother.elm --output=BigBrother.js

.PHONY: clean
clean:
	rm BigBrother.js
