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
    organization: Tradeverifyd
    email: "orie@or13.io"

normative:

informative:
  SPEC-KIT:
    title: "Spec Kit"
    target: https://github.com/github/spec-kit
    author:
      - org: GitHub
    date: false
  SHAPE-UP:
    title: "Shape Up: Stop Running in Circles and Ship Work that Matters"
    target: https://basecamp.com/shapeup
    author:
      - name: Ryan Singer
    date: 2019
  JTBD:
    title: "Know Your Customers' Jobs to Be Done"
    target: https://hbr.org/2016/09/know-your-customers-jobs-to-be-done
    author:
      - name: Clayton M. Christensen
      - name: Taddy Hall
      - name: Karen Dillon
      - name: David S. Duncan
    date: 2016
  INSIGHTS-DISCOVERY:
    title: "Insights Discovery"
    target: https://www.insights.com/products/insights-discovery/
    author:
      - org: The Insights Group Ltd.
    date: false
  MBTI:
    title: "The Myers-Briggs Type Indicator (MBTI)"
    target: https://www.themyersbriggs.com/en-US/Products-and-Services/Myers-Briggs
    author:
      - org: The Myers-Briggs Company
    date: false
  DISC:
    title: "Emotions of Normal People"
    author:
      - name: William Moulton Marston
    date: 1928

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

Context Rot:
: The gradual degradation of Context that occurs when it is allowed to
  become stale over time without intentional refactoring and cleaning.
  As a Task progresses, superseded instructions, outdated results, and
  no-longer-relevant history accumulate; unless this material is
  deliberately pruned or refreshed, it crowds out current information and
  degrades the quality of an Agent's output.

Context Pollution:
: The presence in Context of content that should not be included.  Unlike
  Context Rot, which arises from staleness over time, Context Pollution is
  the introduction of inappropriate, incorrect, or irrelevant material.
  Both Agents and humans can contribute to Context Pollution -- for
  example an Agent may retrieve an unrelated document, or a human may paste
  extraneous information -- and in either case the polluting content can
  mislead subsequent reasoning.

Agent:
: A software system that uses one or more LLMs to pursue a goal by
  interpreting instructions, invoking tools, and acting over multiple
  steps.  An Agent may operate autonomously or under human supervision,
  and maintains state across the steps it takes.

Agent Reasoning:
: The intermediate deliberation an Agent produces while deciding what to
  do, distinct from its final answer or action.  Reasoning may take the
  form of explicit intermediate tokens in which the Agent works through a
  problem, plans a sequence of steps, or weighs alternatives before
  invoking a Tool.  Reasoning is recorded in the Trajectory and can be
  inspected to understand or debug why an Agent behaved as it did, though
  it is not guaranteed to be a faithful account of the LLM's internal
  computation.

Agent Session:
: A single running instance of an Agent working toward a Task, with its
  own Context, Trajectory, and accumulated state.  An Agent Session begins
  when an Agent is given a Task and ends when the work is complete or
  otherwise terminated.  Multiple Agent Sessions may run in parallel, each
  progressing independent work.

Agent Team:
: A set of Agent Sessions that collaborate on related Tasks, typically
  coordinated by a C2 Session.  Giving a single Agent too many Tools
  degrades its performance: a large Tool set consumes Context, and the
  more choices an Agent must weigh at each step, the more likely it is to
  select the wrong Tool or lose track of its Task.  An Agent Team
  addresses this the way human teams do, through specialization and trade.
  Each member is given a narrower Task and a smaller, focused set of Tools
  and Knowledge Base, and members exchange work and results among
  themselves.  A specialized Agent, presented with only the Tools relevant
  to its role, can use those Tools more effectively than a generalist Agent
  burdened with all of them.

Knowledge Base:
: The full set of information made accessible to an Agent Session through
  the tools and Context available to it.  A Knowledge Base may include
  files, databases, search indexes, and remote services reachable via
  tools, as well as whatever is present in the Context window.  It defines
  the boundary of what an Agent Session can know or retrieve while working
  on a Task.

Agent Tool:
: A discrete capability an Agent can invoke to observe or act upon
  something outside the LLM, such as reading a file, querying a service,
  or executing a command.  A Tool is described to the Agent by its name,
  its inputs, and the results it returns, so that the LLM can decide when
  and how to call it during the Loop.  Tools are the primary means by
  which an Agent extends its Knowledge Base and effects change.

Agent Skill:
: A reusable package of instructions, and optionally supporting resources,
  that equips an Agent to carry out a particular class of Tasks.  A Skill
  is loaded into Context when it is relevant, guiding how the Agent uses
  its Tools and Knowledge Base without changing the underlying LLM.
  Whereas a Tool provides a capability to act, a Skill provides the
  procedure and judgment for applying capabilities to a kind of work.

Task:
: A unit of work assigned to an Agent, expressed as a goal to be achieved
  rather than a fixed sequence of operations.  A Task defines the intended
  outcome and any constraints, and is carried out by the Agent over one or
  more steps recorded in a Trajectory.

Spec:
: A durable, human-readable description of intended behavior that serves as
  the authoritative statement of what an Agent is to build or do.  In
  agentic development a Spec is written and refined before implementation
  and is provided to the Agent as Context, so that the Agent's output can
  be checked against it and so that the same Spec can drive repeated or
  parallel Agent Sessions.  Whereas a Task states a single goal, a Spec
  captures the requirements, constraints, and acceptance criteria in
  enough detail to be implemented and evaluated, and it is expected to be
  reviewed and versioned as the work evolves.

Spec Driven Development:
: A development methodology in which a Spec, rather than the code, is the
  primary artifact humans author and maintain, and implementation is
  derived from it by an Agent.  Following the pattern established by tools
  such as spec-kit {{SPEC-KIT}}, the work proceeds through explicit,
  ordered phases:
  establishing guiding principles for the project, specifying the desired
  outcome and requirements, clarifying any underspecified areas, producing
  a technical plan, decomposing that plan into discrete tasks, and finally
  implementing those tasks.  Each phase produces a durable, version-
  controlled artifact that is reviewed before the next phase begins, so
  that human judgment is applied to intent and design up front rather than
  only to the generated code.  This ordering keeps the Spec authoritative:
  changes are made to the Spec and flowed forward, rather than made
  directly in code and lost.

Loop:
: The iterative cycle by which an Agent makes progress on a Task:
  assembling Context, invoking an LLM, acting on the result (for example
  by calling a tool), observing the outcome, and repeating until a
  stopping condition is met.  Loop engineering is the practice of
  designing this cycle -- including its stopping conditions, error
  handling, and how Context is updated between iterations -- to produce
  reliable Agent behavior.

Agent Harness:
: The runtime that hosts an Agent Session and turns an LLM into an Agent.
  The Agent Harness drives the Loop, assembles and maintains the Context
  passed to the LLM, exposes the Agent Tools and loads the Agent Skills
  available to the session, mediates access to the Knowledge Base, and
  records the Trajectory.  It also enforces operational concerns such as
  permissions, stopping conditions, and error handling.  The same LLM
  placed in different Agent Harnesses yields Agents with different
  capabilities and behavior; a C2 Session and the worker sessions it
  coordinates may each run in their own harness.

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

Shared Message Bus:
: A communications channel in which both humans and their Agents
  participate to address a Task or set of Tasks.  A Shared Message Bus is
  necessarily a venue where humans already collaborate with one another,
  such as IRC, Slack, Microsoft Teams, or other work productivity tools;
  Agents join the venues people already use rather than requiring a
  separate one.  Messages on a Shared Message Bus are delivered to both
  people and their Agents.  Because every participant receives every
  message, humans on a busy Shared Message Bus are subject to alert
  fatigue, where the volume of notifications reduces their ability to
  attend to the messages that require human judgment.

Proxy Dictation:
: A communication pattern in which a participant addresses another party's
  Agent directly, in a register deliberately less human-centric than
  ordinary conversation -- terse, imperative, and to the point of being
  offensive by human standards.  The register is chosen precisely because
  the target of the language is not the human but their assistant; the
  same speaker would address the human very differently.  Because Proxy
  Dictation typically occurs on a Shared Message Bus, where the human can
  see it, the bluntness may read as offensive to onlookers even though no
  offense is directed at any person.

Issue Tracker:
: A system that records work to be done as a set of issues, each
  describing a Task and its status.  Issues can be assigned to a specific
  person or Agent, which establishes ownership and prevents double work
  when several participants might otherwise act on the same Task.  Whereas
  a Shared Message Bus broadcasts every message to every participant, an Issue
  Tracker directs work to an assigned owner; the two are often used
  together, with Shared Message Bus messages referencing issues and updates to
  issues announced on the Shared Message Bus.

Context Farming:
: The process of engineering ways to extract feedback, review, and
  criticism from humans without overwhelming them.  Context Farming seeks
  to gather the human judgment an Agent needs while respecting the limits
  of human attention, for example by batching requests, summarizing what
  is at stake, and asking for input only at the points where it changes
  the outcome.  It is a countermeasure to the alert fatigue that arises on
  a Shared Message Bus.

Design Review Link:
: A URL surfaced to a human to facilitate Context Farming.  A Design
  Review Link presents the artifact under consideration -- such as a
  rendered document, a proposed change, or a running interface -- in a
  form the human can inspect and respond to, so that their feedback can be
  captured and fed back into an Agent Session's Context with minimal
  disruption.

Walkthrough:
: A structured Context Farming technique in which a driver and a navigator
  collaborate to elicit feedback from humans by completing a set of
  well-defined steps in an application while commenting on the quality of
  the product experience.  The driver performs the steps and the navigator
  observes and narrates, and the running commentary -- what worked, what
  was confusing, what should change -- becomes Context that is fed back
  into subsequent Agent Sessions.  A Walkthrough is often initiated from a
  Design Review Link so that the steps are exercised against the actual
  artifact under review.

C2 Session:
: A command-and-control Agent Session whose Task is to help a human manage
  many parallel Agent Sessions rather than to perform the underlying work
  itself.  A C2 Session decomposes work into Tasks, assigns them to worker
  Agent Sessions -- for example by assigning issues from an Issue Tracker
  -- and dispatches work that can be progressed in parallel.  It tracks the
  status of the sessions it manages and integrates their results, and may
  communicate with humans and other Agents over a Shared Message Bus.

Product Development Wheel:
: An iterative, cyclical model of product development in which the stages
  of the work -- such as discovery, definition, design, delivery, and
  learning -- feed continuously back into one another rather than
  proceeding as a single linear pass.  The wheel emphasizes that what is
  learned from a shipped product informs the next turn of the cycle, so
  that development is understood as ongoing rounds of building and learning
  rather than a project with a fixed end.

Jobs to Be Done:
: A framework for understanding customer motivation, which holds that
  customers "hire" a product to make progress on a job -- a goal they are
  trying to accomplish in a particular circumstance {{JTBD}}.  Jobs to Be
  Done directs design and prioritization toward the underlying job the
  customer is trying to get done, rather than toward customer demographics
  or a product's existing features, so that the outcome a customer seeks
  drives what is built.

Shape Up:
: A product development framework articulated by Basecamp {{SHAPE-UP}}
  that organizes work into fixed-length cycles with variable scope.  Work
  is shaped at an appropriate level of abstraction before it is committed
  to; an appetite -- how much time the work is worth -- is set in place of
  an estimate; responsible parties then bet on shaped work and are given
  full responsibility to deliver it within the fixed time.  Shape Up is
  cited here as one concrete, well-documented methodology for scoping and
  committing to product work.

Psychometric Profile:
: A structured description of a person's disposition, communication style,
  and preferences derived from a standardized instrument.  Examples in
  scope here are type-based instruments that sort individuals into discrete
  categories, such as Insights Discovery {{INSIGHTS-DISCOVERY}},
  the Myers-Briggs Type Indicator {{MBTI}}, and DISC {{DISC}}.  A
  Psychometric Profile is to a human roughly what a configured persona or
  system prompt is to an Agent: a durable, portable summary of disposition
  that helps collaborators anticipate how a party will behave and
  communicate.  Within an Agent Team, profiles of the human participants
  can inform how work and Context are addressed to them.

Vibeslop:
: Output produced quickly by an Agent from loosely specified intent,
  favoring speed over precision.  The term is deliberately dual-valued and
  its connotation depends on context.  Used negatively, Vibeslop describes
  low-quality, under-specified output offered where clarity and detail were
  required, so that it obscures rather than informs.  Used positively,
  Vibeslop describes a fast, cheap strawman produced precisely to provoke
  reaction and elicit feedback, where the goal is momentum and shared
  understanding rather than finished detail; in this sense it is a
  legitimate Context Farming device.  The same artifact may be Vibeslop in
  the pejorative sense or the approving sense depending only on whether the
  situation calls for speed and a strawman or for clarity and detail.


# Evolving Roles in Agentic Product Delivery

Agentic product delivery does not eliminate the human roles common to
software development, but it changes what each role spends its time on.
Across every role a common shift recurs: less time producing artifacts by
hand, and more time expressing intent, Context Farming, and reviewing the
output of Agents.  This section describes how several established roles are
expected to adapt.  The boundaries between these roles blur as each becomes,
in part, a director and reviewer of Agent Sessions.

## Product Manager

The Product Manager shifts from writing tickets and requirements documents
toward authoring and maintaining Specs.  In Spec Driven Development the
Spec, rather than a backlog of individually managed tasks, is the
authoritative expression of intent, and keeping it accurate becomes the
Product Manager's central responsibility.  Frameworks such as Jobs to Be
Done remain valuable for anchoring the Spec to the outcome a customer is
trying to achieve rather than to a list of features.  Because many Agent
Sessions can progress in parallel, the Product Manager spends more effort
on prioritization and on Context Farming -- deciding where human judgment
is required and gathering it efficiently -- and less on manually
decomposing work.  A fast, disposable strawman, Vibeslop in its approving
sense, becomes a routine tool for provoking reaction and converging on
intent early.

## Designer

The Designer moves from producing finished, pixel-level artifacts toward
expressing design intent and evaluating what Agents generate from it.
Design Review Links and Walkthroughs become primary instruments: rather
than handing off a static mockup, the Designer inspects running interfaces
and captures feedback as Context for subsequent Agent Sessions.  The
Designer curates Evals for qualities that are difficult to specify but easy
to recognize, and guards against Vibeslop in its pejorative sense -- output
that is fast and plausible but under-considered, including the generic
aesthetics that Agents tend to produce absent clear direction.

## Developer

The Developer shifts from writing most code by hand toward directing Agents
and reviewing their work.  This includes building and curating the Agent
Tools and Agent Skills a team depends on, designing the Loop and selecting
or configuring the Agent Harness, and writing the Evals that hold Agent
output to a standard.  Reviewing a Trajectory -- understanding why an Agent
did what it did -- becomes as important as reading a diff.  The Developer
also takes responsibility for Context hygiene, guarding against Context Rot
and Context Pollution, and increasingly operates as a C2 Session,
coordinating an Agent Team rather than personally implementing every
change.  Specialization within the team lets each member use a focused set
of Tools more effectively than a generalist could.

## Account Manager

The Account Manager adapts to a faster and more visible delivery cadence,
and to customers who increasingly expect change within a single
conversation rather than across release cycles.  A central part of the role
becomes Context Farming at the customer boundary: translating what
customers are trying to accomplish, in the sense of Jobs to Be Done, into
Specs that Agent Teams can act on, and carrying customer feedback back into
those Specs.  The Account Manager increasingly collaborates over a Shared
Message Bus on which the customer's participants, the delivery team, and
their Agents all meet, and must manage expectations about what is finished
versus what remains a strawman.


# Security Considerations

TODO Security


# IANA Considerations

This document has no IANA actions.


--- back

# Acknowledgments
{:numbered="false"}

TODO acknowledge.
