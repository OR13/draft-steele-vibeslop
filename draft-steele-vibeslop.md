---
title: "Vibeslop"
category: info

docname: draft-steele-vibeslop-latest
submissiontype: IETF  # also: "independent", "editorial", "IAB", or "IRTF"
number:
date:
consensus: true
v: 3
# area: AREA
# workgroup: WG Working Group
keyword:
 - artificial intelligence
 - agents
 - large language models
venue:
#  group: WG
#  type: Working Group
#  mail: WG@example.com
#  arch: https://example.com/WG
  github: "OR13/draft-steele-vibeslop"
  latest: "https://OR13.github.io/draft-steele-vibeslop/draft-steele-vibeslop.html"

author:
 -
    fullname: "Orie Steele"
    email: "orie@or13.io"

normative:

informative:

...

--- abstract

AI Agents have transformed the way internet applications are developed and
have introduced a new set of challenges for organizations.  This document
describes techniques and concepts that are emerging to assist with these
challenges, and relates them to concepts already familiar to the IETF
community.


--- middle

# Introduction

TODO Introduction


# Terminology

{::boilerplate bcp14-tagged}

Large Language Model (LLM):
: A machine learning model, typically based on the transformer
  architecture and trained on large text corpora, that generates text by
  predicting subsequent tokens from a given context.  In this document an
  LLM is treated as the underlying inference component that an Agent uses
  to reason and produce output.

Prompt:
: The input provided to an LLM to elicit a response.  A Prompt may include
  instructions, context, examples, and prior conversation, and may be
  composed from multiple sources such as a system message, developer
  instructions, and end-user input.

Agent:
: A software system that uses one or more LLMs to pursue a goal by
  interpreting instructions, invoking tools, and acting over multiple
  steps.  An Agent may operate autonomously or under human supervision,
  and maintains state across the steps it takes.

Task:
: A unit of work assigned to an Agent, expressed as a goal to be achieved
  rather than a fixed sequence of operations.  A Task defines the intended
  outcome and any constraints, and is carried out by the Agent over one or
  more steps recorded in a Trajectory.

Trajectory:
: The ordered sequence of inputs, model outputs, tool invocations, and
  observations produced while an Agent works toward a goal.  A Trajectory
  is the primary record used to inspect, replay, or evaluate an Agent's
  behavior.

Eval:
: A repeatable procedure for measuring the behavior of an LLM or Agent
  against a defined set of inputs and expected outcomes.  Evals are used
  to assess quality, detect regressions, and compare alternative models
  or Agent configurations.


# Security Considerations

TODO Security


# IANA Considerations

This document has no IANA actions.


--- back

# Acknowledgments
{:numbered="false"}

TODO acknowledge.
