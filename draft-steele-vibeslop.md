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

Context:
: The full set of information available to an LLM at inference time,
  bounded by a finite context window.  Context includes the Prompt along
  with any retrieved documents, tool results, and accumulated history.
  Context engineering is the practice of deciding what information to
  include, exclude, order, or compress so that the most relevant
  information is available within the context window.

Agent:
: A software system that uses one or more LLMs to pursue a goal by
  interpreting instructions, invoking tools, and acting over multiple
  steps.  An Agent may operate autonomously or under human supervision,
  and maintains state across the steps it takes.

Agent Session:
: A single running instance of an Agent working toward a Task, with its
  own Context, Trajectory, and accumulated state.  An Agent Session begins
  when an Agent is given a Task and ends when the work is complete or
  otherwise terminated.  Multiple Agent Sessions may run in parallel, each
  progressing independent work.

Knowledge Base:
: The full set of information made accessible to an Agent Session through
  the tools and Context available to it.  A Knowledge Base may include
  files, databases, search indexes, and remote services reachable via
  tools, as well as whatever is present in the Context window.  It defines
  the boundary of what an Agent Session can know or retrieve while working
  on a Task.

Task:
: A unit of work assigned to an Agent, expressed as a goal to be achieved
  rather than a fixed sequence of operations.  A Task defines the intended
  outcome and any constraints, and is carried out by the Agent over one or
  more steps recorded in a Trajectory.

Loop:
: The iterative cycle by which an Agent makes progress on a Task:
  assembling Context, invoking an LLM, acting on the result (for example
  by calling a tool), observing the outcome, and repeating until a
  stopping condition is met.  Loop engineering is the practice of
  designing this cycle -- including its stopping conditions, error
  handling, and how Context is updated between iterations -- to produce
  reliable Agent behavior.

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

Bus-Channel:
: A communications channel in which both humans and their Agents
  participate to address a Task or set of Tasks.  Messages on a
  Bus-Channel are delivered to both people and their Agents.  Because
  every participant receives every message, humans on a busy Bus-Channel
  are subject to alert fatigue, where the volume of notifications reduces
  their ability to attend to the messages that require human judgment.

Issue Tracker:
: A system that records work to be done as a set of issues, each
  describing a Task and its status.  Issues can be assigned to a specific
  person or Agent, which establishes ownership and prevents double work
  when several participants might otherwise act on the same Task.  Whereas
  a Bus-Channel broadcasts every message to every participant, an Issue
  Tracker directs work to an assigned owner; the two are often used
  together, with Bus-Channel messages referencing issues and updates to
  issues announced on the Bus-Channel.

C2 Session:
: A command-and-control Agent Session whose Task is to help a human manage
  many parallel Agent Sessions rather than to perform the underlying work
  itself.  A C2 Session decomposes work into Tasks, assigns them to worker
  Agent Sessions -- for example by assigning issues from an Issue Tracker
  -- and dispatches work that can be progressed in parallel.  It tracks the
  status of the sessions it manages and integrates their results, and may
  communicate with humans and other Agents over a Bus-Channel.


# Security Considerations

TODO Security


# IANA Considerations

This document has no IANA actions.


--- back

# Acknowledgments
{:numbered="false"}

TODO acknowledge.
