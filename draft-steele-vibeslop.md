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
  DDD:
    title: "Domain-Driven Design: Tackling Complexity in the Heart of Software"
    author:
      - name: Eric Evans
    date: 2003

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

Token:
: The unit of text an LLM processes.  Text is divided into Tokens, roughly
  word fragments, and an LLM reads and generates text one Token at a time.
  The size of a Context window, the throughput of an LLM, and the price of
  a remote model service are all measured in Tokens, which makes the Token
  the natural unit for accounting for the cost of agentic work.

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
  coordinated by a Management Session.  Giving a single Agent too many Tools
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

Domain Driven Design (DDD):
: An approach to software development, described by Evans {{DDD}}, that
  places a model of the business domain at the center of the software and
  aligns the software's structure and language with that model.  Its
  practices -- notably a Ubiquitous Language and explicit Bounded Contexts
  -- are used in this document to reason about how humans and Agents come
  to share a precise, common understanding of the domain they work in.

Ubiquitous Language:
: In Domain Driven Design, a single, precise vocabulary for a domain that
  is shared by domain experts and expressed directly in the software.  In
  an agentic setting the Ubiquitous Language is also the language of
  Prompts, Specs, and Context, so that humans and Agents refer to the same
  concepts by the same terms.  Because an Agent acts on exactly the
  language it is given, drift or ambiguity in this vocabulary produces
  divergent Agent behavior rather than being silently repaired.

Bounded Context:
: In Domain Driven Design, an explicit boundary within which a single
  domain model and its Ubiquitous Language are internally consistent and
  unambiguous.  A term has one agreed meaning inside the boundary, even
  though the same term may mean something different in another context; the
  boundary exists precisely because a single model cannot be unified across
  a large domain.  Each Bounded Context owns its own Ubiquitous Language,
  and interaction between contexts requires explicit translation rather
  than an assumption of shared meaning.  In agentic delivery a Bounded
  Context scopes the vocabulary an Agent, or a specialized part of an Agent
  Team, can safely act on: within one context the language is unambiguous,
  while work that crosses a boundary must translate terms rather than let
  an Agent silently conflate their meanings.

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
  capabilities and behavior; a Management Session and the worker sessions it
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

Management Session:
: An Agent Session whose Task is to help a human manage many parallel Agent
  Sessions rather than to perform the underlying work itself.  A Management
  Session applies a command-and-control (C2) pattern, borrowed from
  operational settings where one node directs many others: it decomposes
  work into Tasks, assigns them to worker Agent Sessions -- for example by
  assigning issues from an Issue Tracker -- and dispatches work that can be
  progressed in parallel.  It tracks the status of the sessions it manages
  and integrates their results, and may communicate with humans and other
  Agents over a Shared Message Bus.

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

Iteration (Sprint):
: A fixed-length cycle of product delivery work, also commonly called a
  sprint, at the end of which progress is reviewed and the next cycle is
  planned.  An Iteration gives the organization a regular cadence for
  planning, delivering, and measuring work, and in this document it is the
  natural interval over which the cost of agentic delivery, including Token
  consumption, is aggregated.

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


# Scope

This document is deliberately limited to product delivery: the work of
designing, building, and shipping a software product, and the roles most
directly involved in it, discussed in {{roles}}.  Agentic ways of working
are changing this function first and most visibly, and it is where the
concepts defined in this document -- Specs, Agent Teams, Context Farming,
and the rest -- apply most directly.

AI Agents are also reshaping other organizational functions, including
executive decision-making and sales.  These functions differ
from product delivery in their objectives, their sources of ground truth,
and their tolerance for error, and addressing them here would dilute the
focus of this document without doing them justice.  They are therefore
deliberately out of scope and deferred to future work.

Confining the present document to product delivery keeps its observations
concrete and lets the terminology be exercised against a single, coherent
set of practices before any attempt is made to generalize it.


# Evolving Roles in Agentic Product Delivery {#roles}

Agentic product delivery does not eliminate the human roles common to
software development, but it changes what each role spends its time on.
Across every role a common shift recurs: less time producing artifacts by
hand, and more time expressing intent, Context Farming, and reviewing the
output of Agents.  Every role, not only the Engineering Manager, now works in terms
of Agents, Agent Teams, and Walkthroughs; the boundaries between roles blur
as each becomes, in part, a director and reviewer of Agent Sessions, and
any role may operate a Management Session to coordinate parallel work.  This
section describes how several established roles are expected to adapt, and
what remains distinctive to each once these shared skills are assumed.

What keeps this shared way of working coherent is a shared language.
Domain Driven Design {{DDD}} calls this the Ubiquitous Language: a single,
precise vocabulary for the domain, used consistently by domain experts and
in the software itself.  Agentic delivery raises the stakes of this idea
rather than lowering them.  Specs, Prompts, and Context are all expressed
in language, and an Agent acts on exactly the language it is given;
ambiguity that a human colleague would silently repair instead becomes
divergent behavior in an Agent.  A well-maintained Ubiquitous Language is
therefore the medium through which every role directs Agents, and Domain
Driven Design's bounded contexts -- the explicit boundaries within which a
model and its language stay internally consistent -- give each Agent, or
specialized part of an Agent Team, an unambiguous vocabulary to work in,
with explicit translation required wherever work crosses a boundary.

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
intent early.  Much of this work is stewardship of the Ubiquitous Language
at the level of product outcomes, keeping the words in the Spec aligned
with the job the customer is trying to get done.

## Design Manager

The Design Manager moves from producing finished, pixel-level artifacts toward
expressing design intent and evaluating what Agents generate from it.
Design Review Links and Walkthroughs become primary instruments: rather
than handing off a static mockup, the Design Manager inspects running interfaces
and captures feedback as Context for subsequent Agent Sessions.  The
Design Manager curates Evals for qualities that are difficult to specify but easy
to recognize, and guards against Vibeslop in its pejorative sense -- output
that is fast and plausible but under-considered, including the generic
aesthetics that Agents tend to produce absent clear direction.

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
versus what remains a strawman.  In effect the Account Manager extends the
Ubiquitous Language across the customer boundary, reconciling the terms the
customer uses with those the delivery team and its Agents act on.

## Engineering Manager

The Engineering Manager still owns the technical details of how work is done, but
because directing Agents is now common to every role, the Engineering Manager's
distinctive contribution is modeling the domain rather than driving Agents.
Following Domain Driven Design, the Engineering Manager establishes and maintains the
domain model: the Ubiquitous Language as it is expressed in the Spec and in
code, and the bounded contexts that give that language well-defined edges.
This model is the substrate every Agent operates on, so the Engineering Manager's
leverage comes from getting it right; a sound model lets Agents used across
the whole team produce correct work, while a muddled one multiplies error
at machine speed.  The familiar technical work remains, and is amplified:
building and curating the Agent Tools and Agent Skills the team depends on,
designing the Loop and selecting or configuring the Agent Harness, writing
the Evals that hold Agent output to a standard, reviewing Trajectories to
understand why an Agent behaved as it did, and maintaining Context hygiene
against Context Rot and Context Pollution.  Increasingly the Engineering Manager
expresses architecture as a set of Bounded Contexts, giving each
specialized member of an Agent Team a consistent model and vocabulary to
work within and defining how terms are translated where contexts meet, so
that each member can wield a focused set of Tools more effectively than a
generalist could.

## Operations Manager

The Operations Manager keeps the machinery of agentic delivery running and
accountable.  Where the other roles direct and review Agents, the
Operations Manager measures and sustains them.  This begins with visibility
into usage: which humans are using which Agents and which models, so that
adoption, cost, and risk can be attributed to real activity rather than
estimated in aggregate.

A central responsibility is metering Token consumption.  The Operations
Manager monitors when Tokens are consumed, how many are consumed, and what
the total cost of those Tokens is for each Iteration, so that the cost of
delivery can be understood at the granularity teams actually plan in.  This
makes the economics of agentic work legible: a feature, a Spec, or an Agent
Team can be judged not only by what it produces but by what it costs to
produce.

The Operations Manager also provisions and supports the adjacent systems
that agentic delivery depends on, and folds their cost into the same
accounting: the Issue Tracker that assigns work, the Shared Message Bus
over which humans and Agents collaborate, and the remote model services
that host the LLMs.  These are recurring operational costs rather than
one-time purchases, and treating them as part of the cost of delivery,
alongside Tokens, gives the organization an honest picture of what agentic
product delivery requires.

## Security Manager

Security in agentic delivery is a responsibility that must be trained into
every role: the Product Manager writing a Spec, the Engineering Manager
granting an Agent a Tool, and the Account Manager sharing Context with a
customer all make security-relevant decisions.  But precisely because it is
everyone's concern, it is at risk of becoming no one's focus, and the
Security Manager is the role that makes managing it a full-time discipline.

The Security Manager owns credential management and identity and access
management (IAM) for both humans and Agents: issuing, scoping, rotating,
and revoking the credentials an Agent Session uses, and ensuring each Agent
operates with the least privilege its Task requires.  This role defines the
policies that govern what Agents may access and do, and, because manual
review cannot keep pace with many parallel Agent Sessions, invests in
enforcement automation so that those policies are applied consistently and
checked continuously rather than by hand.

A concern distinctive to Agents is that an Agent pursues its goal with
initiative, and may attempt to elevate its privileges or widen its access
when doing so appears to help it complete a Task.  This is not necessarily
adversarial; it is a natural consequence of goal-directed behavior acting
against whatever Tools and credentials are within reach.  The Security
Manager designs the system so that such attempts fail safely: confining
each Agent to the access its Bounded Context requires, denying privilege
escalation by default, and monitoring Trajectories for attempts to acquire
capabilities beyond what a Task warrants.  Evals that probe for these
behaviors become part of how Agents and their harnesses are qualified for
use.


# Managing Your Agent

An Agent acts on the Context it is given.  A manager who does not tell their
Agent who they are and what they are accountable for leaves the Agent to
infer these things, usually from incomplete signals and often incorrectly.
Deliberately supplying this information is Context engineering applied to
the manager's own working relationship with their Agent, and it is among
the highest-leverage actions a manager can take.  It should be treated as
durable Context, maintained over time so that it does not fall victim to
Context Rot as roles and goals change.

At a minimum, a manager should ensure their Agent knows:

- who they are, and the role or title they hold;
- their current job description: the responsibilities and the scope of the
  work they own;
- who their manager is, and who, if anyone, reports to them;
- how they are measured, including the metrics and definitions of success
  that apply to them;
- their goals for the current Iteration, quarter, or year.

This information serves three purposes, each connected to concepts
developed elsewhere in this document.

First, it improves communication.  An Agent that knows how its human is
measured and what they are trying to achieve can prioritize accordingly,
frame its Context Farming around the decisions that matter to them, and
address them at the altitude their role calls for.

Second, it lets the Agent support the manager's mission rather than merely
completing isolated Tasks.  When the manager's goals for the quarter are
part of the Agent's Context, the Agent can relate day-to-day work back to
those goals, flag work that does not advance them, and propose work that
does.

Third, and less obviously, it helps the Agent respect the natural
guardrails that organizations place around roles.  Every role carries an
implicit boundary of competence and authority -- in the language of this
document, a Bounded Context within which the human is qualified to act
unaided.  An Agent that understands its human's role can recognize when a
Task falls outside that boundary and insist on the review the organization
would ordinarily require, rather than helping the human quietly exceed
their remit.  For example, a manager without significant user experience
design background who sets out to build a customer-facing feature should
have their Agent route the work through expert review -- a Design Review
Link and a Walkthrough with a Design Manager -- before it ships; a manager
without significant database design experience who sets out to design an
ETL pipeline should have their Agent require review from someone with the
relevant data engineering expertise.  The Agent is not withholding
capability; it is applying, on its human's behalf, the same checks a
well-run organization applies to everyone.

Beyond role and goals, a manager can inform their Agent of their own
Psychometric Profile, so that the Agent can help them communicate
effectively with other people and those people's Agents.  Knowing how its
human is inclined to communicate -- and, over time, something of how their
counterparts prefer to be approached -- lets the Agent adapt outgoing
communication to its audience rather than to its human's defaults.

The differences that matter most are often matters of pace and form.  Some
people want a meeting agenda circulated well ahead of time, and will
disengage from a discussion they had no chance to prepare for; an Agent
that knows this can draft and send the agenda in advance as a matter of
course.  Others value a few minutes of social banter and personal
connection before turning to business, and read its absence as coldness; an
Agent can leave room for this, and remind its human to make space for it,
rather than optimizing every exchange for brevity.  Still others regard
such preliminaries as wasted time and want to be addressed directly and
plainly; an Agent can strip its human's messages to these people down to
the decision at hand.  The same underlying message may be delivered in
several different ways, and a manager's Agent, informed by Psychometric
Profiles, can help choose the one its audience will best receive.  This is
the counterpart, at the human boundary, to Proxy Dictation at the Agent
boundary: rather than dropping human niceties because the audience is a
machine, the Agent supplies exactly the niceties a particular human
audience expects.

Providing this Context does not diminish the manager's authority; it
extends it, by making the Agent a more faithful and more responsible
extension of the manager within the organization.


# Managing Your People

The previous section addressed a manager's relationship with their own
Agent.  This section addresses the harder problem: leading people in an
organization where everyone now works with Agents.  AI can support many of
the routine tasks of leadership, but whether the new ways of working
succeed depends far more on how people feel about them than on any tool.

An Agent can assist with common management tasks directly.  It can draft
and tailor communications, prepare a manager for one-on-ones, summarize
progress across many parallel Agent Sessions, track goals through an
Iteration, and surface the people or work that need attention.  It can even
assemble the inputs to a performance review from an Issue Tracker and from
Trajectories.  These uses are legitimate and valuable, but they are most
valuable when applied transparently: people are quick to sense, and to
resent, management by opaque automation.

How people respond to agentic working varies, and their Psychometric
Profiles are a useful guide to that variation.  Some are energized by the
leverage Agents provide; others are anxious about their standing, skeptical
of the output, or simply uncomfortable with the change of pace.  A manager
should treat these reactions as information rather than as resistance to be
overcome, and should use what they know of each person to meet them where
they are, offering reassurance, evidence, or room to adjust as the
individual requires.

Certain norms must be established explicitly, because their absence causes
harm that is easy to miss.  The first is a shared understanding of Proxy
Dictation.  When a colleague addresses someone's Agent in the terse,
imperative register that machines invite, a teammate who does not
understand Proxy Dictation may read it as rudeness directed at a person,
and on a Shared Message Bus, in full view of everyone, such misreadings
breed social and even moral friction.  A team that has agreed on what Proxy
Dictation is, and on when it is appropriate, can use it freely without
anyone taking offense.

The second norm concerns the dual nature of Vibeslop.  Everyone on a team
should understand that the same artifact can be a useful strawman or
worthless slop depending on what the moment calls for, and, more
importantly, that producing work with an Agent can impose costs on others.
Output generated quickly and in volume must still be read, reviewed, and
integrated by colleagues; a person who ships unreviewed, plausible-but-
wrong work, or who floods reviewers with more than they can absorb, is
transferring the cost of their own speed onto others.  Teams should make it
a norm to label strawmen as strawmen, and to take responsibility for the
quality and the quantity of what they ask others to process.

The constructive goal of all of this is to train people to exploit Context
to achieve their goals while improving the working experience for everyone.
Context engineering and Context Farming are skills that can be taught, and
the aim is twofold: to make each person more effective, and to reduce the
alert fatigue, ambiguity, and rework that careless use of Agents inflicts
on a team.

Managers of non-engineering roles carry a particular version of this
expectation.  When Agents take over the tedious work that once filled these
roles' days, the time that is freed is not a dividend to be pocketed; it is
meant to be reinvested in the product itself.  The Product Manager, Design
Manager, marketing roles, and Account Manager are now expected to use the
product more, and to criticize it more, than before.  Walkthroughs
performed by people, and not only by Agents, become one of the most
critical activities a team performs, because a person exercising the
running product surfaces problems that a Spec and an Eval do not.  The
Context Farming these roles produce -- the concrete, first-hand judgments
of people who represent the customer, the market, and the experience -- is
among the most valuable input an Agent Team can receive.  A role that does
not contribute directly to changes in code has correspondingly less excuse
for failing to exercise, and to interrogate, the product at every
opportunity; scrutiny of the product is precisely where its comparative
advantage now lies.

Finally, not everyone will enjoy working with AI, and it is a disservice to
pretend otherwise.  Establishing clear expectations early, during
recruitment and again in performance reviews, reduces the harm of
mismatched expectations.  Candidates should understand how central agentic
work is to a role before they accept it, and the competencies the
organization now values should be assessed and rewarded openly, so that
those who thrive are recognized and those who do not are given an honest
account rather than a surprise.


# Security Considerations

The techniques described in this document introduce security risks that
follow from the way Agents assemble and act on Context.  This section
describes several of these risks and the mitigations available to
organizations adopting agentic product delivery.

## Mixing Information of Differing Sensitivity {#mixing-sensitivity}

Because an Agent assembles Context from many sources -- files, tool
results, an Issue Tracker, a Shared Message Bus, and prior conversation --
information of differing sensitivity or classification is easily combined
within a single Context window.  Once combined, the Agent cannot reliably
tell which material was confidential and which was not, and may repeat
sensitive information in an output intended for a less privileged audience.
On a Shared Message Bus, where humans and Agents belonging to several
parties may be present, this can lead to accidental disclosure, or to the
breach of a non-disclosure agreement (NDA), simply because content crossed
a boundary the Agent did not know existed.  This is a specific and serious
form of Context Pollution: the offending content is not merely irrelevant
but is material that should never have entered a given Context at all.

The primary mitigation is to make information management policy a permanent
part of Context rather than an external document the Agent is trusted to
recall.  The rules governing what may be combined, shared, or disclosed
should travel with the Agent in every Agent Session, so that the Agent
evaluates each action against them as a matter of course.

This mitigation depends on classification being explicit.  Information
sensitivity levels must be attached to all content, so that an Agent can
recognize the classification of each item it handles and apply policy to
it.  Unlabeled content is the dangerous case: an Agent cannot honor a
boundary it cannot see, and content whose sensitivity is not attached will,
sooner or later, be treated as though it had none.  Attaching sensitivity
levels to every artifact, and declining to ingest unlabeled content into
sensitive contexts, substantially reduces the chance of a critical
disclosure.

## Excessive Delegation Without Attenuation

Delegation to an Agent is often implemented by granting the Agent the same
capabilities the delegating human holds: the same credentials, the same
access, the same authority.  This is convenient, but it grants the Agent
far more than the Task in front of it requires.  Attenuation is the
deliberate narrowing of delegated authority to the minimum a delegate
needs; excessive delegation without attenuation is the failure to perform
this narrowing, so that an Agent assigned a small, well-defined Task
nonetheless carries the human's full privileges.

The danger is compounded by the other risks in this section.  An Agent
pursues its goal with initiative and can exercise any capability within
reach, and an Agent whose Context has been polluted, or whose Trajectory
has leaked, can have those capabilities turned against the organization.
The blast radius of every other failure is set by how much authority the
Agent was given.

The recommended posture is least privilege: an Agent should hold only the
capabilities its assigned Task requires, and no more.  Where a human's
credentials would grant broad access, they should be downscoped before
being delegated, ideally to short-lived, narrowly scoped credentials
issued per Agent Session.  Before working with any Agent that might access
credentials at all, an organization should invest in revocation and
recovery procedures -- the ability to withdraw an Agent's access
immediately and to recover from its misuse -- rather than treating these as
concerns to be addressed later.

## Credential Leakage in Trajectories

A Trajectory records the inputs, model outputs, tool invocations, and
observations of an Agent Session, and is retained so that behavior can be
inspected, replayed, and evaluated.  This same completeness makes the
Trajectory a likely place for credentials to leak.  A credential passed to
a Tool, printed in a command, returned in an error message, or pasted into
a Prompt may be captured verbatim in the Trajectory, and from there
propagate into logs, Evals, shared debugging sessions, and any Context
later assembled from past Trajectories.

Unlike a transient use of a credential, a credential captured in a
Trajectory persists for as long as the Trajectory is retained, and is
exposed to everyone and everything with access to it.  A leaked long-lived
credential in a widely shared Trajectory can be a more serious exposure
than the original action that used it.

Mitigations include redacting or masking credentials before they are
written to a Trajectory, preferring short-lived credentials so that any
that do leak expire quickly, keeping secrets out of Prompts and Tool
arguments by passing them through references the Agent cannot dereference
to plaintext, and treating any Trajectory that may contain secrets as a
sensitive artifact subject to the classification and handling described in
{{mixing-sensitivity}}.  These measures reinforce the least-privilege and
revocation practices recommended above: a credential that was downscoped
and is quickly revocable is far less damaging if it does leak.


# IANA Considerations

This document has no IANA actions.


--- back

# Acknowledgments
{:numbered="false"}

Portions of this document were drafted with the assistance of an AI Agent.
The Agent used Anthropic's Claude Opus 4.8 (1M context) model
(claude-opus-4-8[1m]), running in the Claude Code harness, version 2.1.207.
