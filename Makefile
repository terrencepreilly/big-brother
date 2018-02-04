COMMON_DEPS = script/Message.elm script/UrlJoin.elm

all: BigBrother.js BigBrotherReporter.js

BigBrother.js: script/BigBrother.elm $(COMMON_DEPS)
	elm-make $< --output=$@

BigBrotherReporter.js: script/BigBrotherReporter.elm $(COMMON_DEPS)
	elm-make $< --output=$@

.PHONY: clean
clean:
	rm *.js
