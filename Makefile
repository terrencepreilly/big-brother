COMMON_DEPS = scripts/Message.elm scripts/UrlJoin.elm

all: BigBrother.js BigBrotherReporter.js

BigBrother.js: scripts/BigBrother.elm $(COMMON_DEPS)
	elm-make $< --output=$@

BigBrotherReporter.js: scripts/BigBrotherReporter.elm $(COMMON_DEPS)
	elm-make $< --output=$@

.PHONY: clean
clean:
	rm *.js
