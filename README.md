<!-- regenerate: on (set to off if you edit this file) -->

# Vibeslop

This is the working area for the individual Internet-Draft, "Vibeslop".

* [Editor's Copy](https://OR13.github.io/draft-steele-vibeslop/#go.draft-steele-vibeslop.html)
* [Datatracker Page](https://datatracker.ietf.org/doc/draft-steele-vibeslop)
* [Individual Draft](https://datatracker.ietf.org/doc/html/draft-steele-vibeslop)
* [Compare Editor's Copy to Individual Draft](https://OR13.github.io/draft-steele-vibeslop/#go.draft-steele-vibeslop.diff)


## Contributing

See the
[guidelines for contributions](https://github.com/OR13/draft-steele-vibeslop/blob/main/CONTRIBUTING.md).

The contributing file also has tips on how to make contributions, if you
don't already know how to do that.

## Command Line Usage

Formatted text and HTML versions of the draft can be built using `make`.

```sh
$ make
```

Command line usage requires that you have the necessary software installed.  See
[the instructions](https://github.com/martinthomson/i-d-template/blob/main/doc/SETUP.md).

With [Vale](https://vale.sh/) installed, lint the draft using `make vale`.
This downloads the latest [IETF Vale rules](https://github.com/OR13/ietf-vale),
including the optional draft checks for repeated words and articles, and
runs them at suggestion level. The configuration excludes kramdown-rfc
anchors, attributes, and references from prose checks.

The local abbreviation rule requires expansions independently of the spelling
vocabulary (`vocab: false`). Its exceptions are limited to familiar RFC terms
and BCP 14 requirement words. Citation labels are excluded as markup; they do
not justify exempting the same abbreviations when used in prose.

Suggestions require editorial review. Since v0.4.6, the rules accept
ordinary lowercase BCP 14 words and check mixed-case forms and keyword
context instead. Review `Bcp14Sparingly` suggestions in context: the
security recommendations contrasting safe and unsafe behavior express
safeguards, not mere preferences, and retain their original `SHOULD` wording.
