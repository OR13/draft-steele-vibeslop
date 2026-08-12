LIBDIR := lib
-include $(LIBDIR)/main.mk

$(LIBDIR)/main.mk:
ifneq (,$(shell grep "path *= *$(LIBDIR)" .gitmodules 2>/dev/null))
	git submodule sync
	git submodule update --init
else
ifneq (,$(wildcard $(ID_TEMPLATE_HOME)))
	ln -s "$(ID_TEMPLATE_HOME)" $(LIBDIR)
else
	git clone -q --depth 10 -b main \
	    https://github.com/martinthomson/i-d-template $(LIBDIR)
endif
endif

# kramdown-rfc shells out to a bare `aasvg` on PATH for every "~~~ aasvg"
# fence, and the i-d-template-action container does not ship it: without this,
# kramdown-rfc dies with Errno::ENOENT and xml2rfc then reports the document as
# unparseable.  The install has to happen inside the container that runs the
# build, which is why it hangs off the make graph rather than off a workflow
# step.  No-op wherever aasvg is already on PATH, so local builds are untouched.
#
# Pinned to 0.4.3 deliberately.  0.5.x emits a <style> element carrying
# light-dark() CSS, which is outside the RFC 7996 SVG profile; xml2rfc rejects
# it with "Did not expect element style there".  Do not float this version
# without checking that the SVG still validates.
AASVG_VERSION := 0.4.3

draft-steele-vibeslop.xml: | aasvg-installed

.PHONY: aasvg-installed
aasvg-installed:
	@command -v aasvg >/dev/null 2>&1 || \
	    npm install -g -q aasvg@$(AASVG_VERSION)
