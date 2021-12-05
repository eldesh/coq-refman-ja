
JAVA      ?= java
JAVAFLAGS ?=

OMEGAT ?= OmegaT.jar

RSTS = zebibliography.rst                          \
	   index.rst                                   \
	   license.rst                                 \
	   coq-optindex.rst                            \
	   language/module-system.rst                  \
	   language/cic.rst                            \
	   language/coq-library.rst                    \
	   language/gallina-extensions.rst             \
	   language/gallina-specification-language.rst \
	   practical-tools/utilities.rst               \
	   practical-tools/coq-commands.rst            \
	   practical-tools/coqide.rst                  \
	   coq-exnindex.rst                            \
	   introduction.rst                            \
	   coq-tacindex.rst                            \
	   coq-cmdindex.rst                            \
	   addendum/program.rst                        \
	   addendum/omega.rst                          \
	   addendum/nsatz.rst                          \
	   addendum/miscellaneous-extensions.rst       \
	   addendum/generalized-rewriting.rst          \
	   addendum/canonical-structures.rst           \
	   addendum/type-classes.rst                   \
	   addendum/micromega.rst                      \
	   addendum/implicit-coercions.rst             \
	   addendum/extended-pattern-matching.rst      \
	   addendum/universe-polymorphism.rst          \
	   addendum/extraction.rst                     \
	   addendum/ring.rst                           \
	   addendum/parallel-proof-processing.rst      \
	   credits-contents.rst                        \
	   proof-engine/vernacular-commands.rst        \
	   proof-engine/proof-handling.rst             \
	   proof-engine/detailed-tactic-examples.rst   \
	   proof-engine/tactics.rst                    \
	   proof-engine/ssreflect-proof-language.rst   \
	   proof-engine/ltac.rst                       \
	   user-extensions/syntax-extensions.rst       \
	   user-extensions/proof-schemes.rst           \
	   genindex.rst                                \
	   credits.rst

POS = addendum.po         \
      coq-cmdindex.po     \
      coq-exnindex.po     \
      coq-optindex.po     \
      coq-tacindex.po     \
      credits-contents.po \
      credits.po          \
      genindex.po         \
      index.po            \
      language.po         \
      license.po          \
      practical-tools.po  \
      proof-engine.po     \
      user-extensions.po  \
      zebibliography.po

HTML_RST = index.html.rst \
		   credits.html.rst \
		   zebibliography.html.rst

SPHINX_DIR = coq/doc/sphinx

TARGET_POS = $(addprefix target/, $(POS))
SOURCE_POS = $(addprefix source/, $(POS))

TARGET_POS_JA = $(addprefix $(SPHINX_DIR)/locales/ja/LC_MESSAGES/, $(notdir $(TARGET_POS)))

SOURCE_RSTS = $(addprefix $(SPHINX_DIR)/, $(RSTS))
SOURCE_POTS = $(addprefix $(SPHINX_DIR)/_build/gettext/, $(POS:.po=.pot))

all:
	@echo "target:"
	@echo "\thtml: 翻訳結果を反映した .html ファイルを生成します."
	@echo "\tsource: オリジナルの .po ファイルを生成します."
	@echo "\ttarget: OmegaTプロジェクトから翻訳結果の .po ファイルを生成します."


.PHONY: target
target: $(TARGET_POS)


$(TARGET_POS): omegat/omegat.project $(SOURCE_POS)
	@echo " [GEN] target po files.."
	@mkdir -p target
	$(JAVA) $(JAVAFLAGS) -jar $(OMEGAT) --mode=console-translate $<


.PHONY: source
source: source_pre $(SOURCE_POS)


coq/config/coq_config.py:
	cd coq && ./configure -local


$(SPHINX_DIR)/%.rst: $(SPHINX_DIR)/%.html.rst
	@echo " [COPY] $< $@"
	@cp -f $< $@


.PHONY: source_pre
source_pre: coq/config/coq_config.py


$(SOURCE_POTS): coq/config/coq_config.py $(SOURCE_RSTS)
	$(MAKE) -C coq refman-gettext ALLSPHINXOPTS='-d $$(SPHINXBUILDDIR)/doctrees_gettext'


$(SOURCE_POS): source/%.po: $(SPHINX_DIR)/_build/gettext/%.pot
	@mkdir -p $(dir $@)
	@msginit --no-translator -l ja -i $< -o $@


$(TARGET_POS_JA): $(TARGET_POS)
	@mkdir -p $(SPHINX_DIR)/locales/ja/LC_MESSAGES/
	@for pos in $^; do \
		echo " [COPY] $$pos $(SPHINX_DIR)/locales/ja/LC_MESSAGES/$(basename $$pos)" ; \
		cp -f $$pos $(SPHINX_DIR)/locales/ja/LC_MESSAGES/ ; \
	done


.PHONY: html
html: $(TARGET_POS_JA)
	$(MAKE) -C coq refman-html SPHINXOPTS='-D language="ja"'
	@echo "  [GEN] html/refman"
	@mkdir -p html/refman
	@cp -r $(SPHINX_DIR)/_build/html/* html/refman


.PHONY: clean
clean:
	-$(RM) -r html/refman
	-$(RM) -r target
	-$(RM) -r source

.PHONY: distclean
distclean: clean
	-$(RM) -r $(SPHINX_DIR)/locales/ja/LC_MESSAGES
	-$(RM) -r $(SPHINX_DIR)/_build
	-$(RM) $(addprefix $(SPHINX_DIR)/, $(HTML_RST:.html.rst=.rst))

