# Building with Pipelex: Fundamentals, Composability, and Directions

## Part 1 -- The Fundamentals: What Makes Pipelex Methods Powerful

Pipelex is a declarative language for defining repeatable AI methods. A method is a `.mthds` file that captures a sequence of cognitive steps -- extraction, analysis, synthesis, generation, decision-making -- into a reusable, versionable, testable artifact. The power of a Pipelex method comes from combining four categories of AI capability with a rigorous orchestration layer.

### The Four Engines

**1. OCR and Document Extraction (`PipeExtract`)**

Documents are the raw material of most business processes. `PipeExtract` turns PDFs, scanned images, and photographs into structured pages of text and embedded images. This is the entry point for any method that needs to understand existing documents -- invoices, contracts, reports, receipts, medical records, blueprints, forms of every kind.

Key characteristics:
- Produces `PageContent` objects with text, embedded images, and full-page visual renderings
- Supports multiple OCR backends (Mistral OCR, local PDF extraction)
- Configurable page image resolution and image extraction limits
- The extracted content flows directly into downstream LLM steps as typed `Page` objects

**2. Language Models (`PipeLLM`)**

This is the reasoning core. `PipeLLM` handles everything from free-form text generation to structured data extraction to classification and analysis. It accepts text, images, and documents as inputs and produces either free-text or strongly-typed structured output conforming to a declared concept schema.

Key characteristics:
- Supports Vision Language Models (VLMs) for image understanding alongside text
- Direct document input: PDFs and images can be referenced inline in prompts
- Structured output with validation (via Pydantic models generated from inline concept definitions)
- Two structuring strategies: direct JSON generation or preliminary text + extraction
- Configurable reasoning effort and token budgets for balancing cost and depth
- Output multiplicity: generate a single item, a fixed count (`[3]`), or a variable-length list (`[]`)

**3. Image Generation (`PipeImgGen`)**

Turns text prompts into images. This enables any method to produce visual output -- illustrations, product renders, diagrams, logos, marketing visuals, architectural sketches -- as a first-class step in a pipeline.

Key characteristics:
- Supports multiple backends (GPT Image, Flux, SDXL variants)
- Static or dynamic prompts (referencing upstream pipeline outputs)
- Configurable aspect ratio, quality, and seed for reproducibility
- Can generate multiple image variations in a single step

**4. Custom Python Functions (`PipeFunc`)**

The escape hatch. When a step requires computation, external API calls, data transformation, or any logic that doesn't fit the declarative model, `PipeFunc` lets you call arbitrary Python code that reads from and writes to the pipeline's working memory.

### The Orchestration Layer

The four engines become powerful through orchestration. Pipelex provides four controllers that compose pipes into methods:

- **`PipeSequence`**: Chain steps linearly. The output of one step feeds the next. Most methods start here.
- **`PipeParallel`**: Run independent steps concurrently. Extract features and analyze sentiment at the same time. Generate social media posts for three platforms simultaneously.
- **`PipeBatch`**: Map a single pipe over a list of items, processing them all in parallel. Audit every line item in an expense report. Analyze every CV against a job description.
- **`PipeCondition`**: Branch based on data. Route positive feedback to one template and negative feedback to another. Handle invoices differently from receipts.

### The Concept System

What binds everything together is the concept system. Every piece of data flowing through a pipeline has a declared concept -- not just a type, but a meaning. An `Invoice` is not just `Text`; it is a concept with a specific structure (line items, dates, vendor info) and semantic identity. Pipelex validates that connected pipes are compatible before execution, catching nonsensical combinations (e.g., feeding a flower description into an invoice parser) at design time rather than runtime.

You define your own concepts with inline structures directly in `.mthds` files. Concepts support refinement (`CustomerFeedback` refines `Text`), enabling polymorphic compatibility while maintaining semantic precision.

### The Templating Layer (`PipeCompose`)

`PipeCompose` closes the loop. After extraction, analysis, and generation, you often need to assemble final outputs -- HTML reports, formatted emails, dashboard pages, combined documents. `PipeCompose` uses Jinja2 templates or construct mappings to merge structured data from working memory into polished deliverables.

---

## Part 2 -- Composability: Methods Built from Methods

The deepest source of leverage in Pipelex is composability. A method can invoke another method. This means you can build complex solutions by assembling existing, proven methods -- like LEGO bricks, or like functions calling functions in software.

### How Composability Works

Every `.mthds` bundle declares a domain and optionally a `main_pipe`. When bundles are loaded together into a library, any pipe can reference pipes from other bundles using their full identifier:

```toml
steps = [
    { pipe = "document_extraction.extract_invoice", result = "invoice_data" },
    { pipe = "compliance.check_policy_violations", result = "violations" },
    { pipe = "reporting.compose_html_report", result = "report" },
]
```

This works seamlessly across domains. The package system (`METHODS.toml`) adds version management, dependency declarations, and visibility control, so you can publish reusable methods while keeping internal helpers private.

### Why This Changes Everything

**Layer 1: Atomic methods.**
Small, focused methods that do one thing well. Extract structured data from an invoice. Classify the sentiment of a text. Generate a product image from a description. Translate text to Spanish. These are the building blocks.

**Layer 2: Composite methods.**
Methods that orchestrate several atomic methods into a workflow. A "CV screening" method that extracts candidate profiles, extracts job requirements, scores matches, and generates recommendation emails. Each sub-step is itself a reusable method.

**Layer 3: Enterprise methods.**
Methods that compose composite methods. A "quarterly compliance review" that runs document extraction on hundreds of contracts, applies clause analysis to each, cross-references with policy databases, generates risk assessments, and produces a board-ready report. Each major section delegates to a well-tested composite method.

### The Know-How Graph

At scale, this recursive composability creates what the Pipelex vision calls the **Know-How Graph**: a network of reusable methods where each method stands on the shoulders of others. Unlike a knowledge graph that maps facts, this maps procedures -- the actual know-how of getting cognitive work done.

The implications are structural:

- **No reinventing the wheel.** A generic "extract invoice line items" method works across industries. Wrap it with your domain-specific validation logic.
- **Separation of concerns.** The person who understands contract law writes the clause extraction method. The person who understands compliance writes the policy check method. The integrator composes them.
- **Testability at every level.** Each atomic method can be tested independently with known inputs and expected outputs. Composite methods inherit the reliability of their components.
- **Cost optimization.** Assign a cheap, fast model to simple classification. Assign a powerful model to complex reasoning. The method chooses the right tool for each step.
- **Shareability.** Methods are files. They can be versioned, diffed, published, forked, and composed by anyone -- including AI agents that can generate and refine methods from natural language requirements.

---

## Part 3 -- Directions for Valuable Examples

The examples built so far demonstrate the core patterns: haiku generation, motivational quotes, email drafting, PDF extraction, illustrated poems, social media kits, expense auditing, document comparison, research assistants, product catalogs, and sentiment routing. These cover the basic pipe types and orchestration patterns.

To reach a broader audience and demonstrate Pipelex's real-world value, we should pursue four directions that cut across industries and job functions.

### Direction 1: Document Intelligence

**Target audiences:** Legal, Finance, Insurance, Healthcare, Government, Real Estate, HR, Procurement

This is where Pipelex has the most immediate traction. The pattern is: ingest documents (PDFs, scanned images) via `PipeExtract`, structure the content with `PipeLLM`, apply analysis or validation logic, and produce reports or trigger actions.

Example families:
- **Contract analysis**: Extract clauses, identify risks, compare versions, generate redlines, check compliance
- **Financial document processing**: Invoices, purchase orders, bank statements, tax forms, audit trails
- **Insurance claims**: Extract claim details from forms and photos, cross-reference policy terms, generate adjuster reports
- **Medical records**: Extract diagnoses, medications, lab results; generate patient summaries; check for drug interactions
- **Regulatory filings**: Parse government forms, validate completeness, flag missing fields, auto-fill from source data
- **Real estate**: Extract property details from listings, compare appraisals, generate buyer reports

The composability angle is strong here: a generic "extract table from document" method gets reused inside dozens of domain-specific methods.

### Direction 2: Content Production Pipelines

**Target audiences:** Marketing, Communications, Publishing, E-commerce, Education, Creative Agencies

This direction combines LLM text generation with image generation and HTML/template composition. The pattern is: take a brief or source material, generate multiple content variants (text + visuals), and compose them into deliverables.

Example families:
- **Marketing campaigns**: From a product brief, generate ad copy for 5 channels + hero images + landing page HTML
- **E-commerce catalogs**: From product specs, generate descriptions, SEO tags, lifestyle images, comparison charts
- **Educational content**: From a syllabus, generate lesson plans, quizzes, visual aids, student handouts
- **Publishing workflows**: From a manuscript, generate book covers, back-cover blurbs, social media teasers, press kits
- **Internal communications**: From meeting notes, generate executive summaries, action item lists, stakeholder updates
- **Localization**: From source content, parallel-translate into multiple languages with culturally adapted imagery

The composability angle: a "generate social media post" method is atomic; a "launch campaign" method composes it with image generation, landing page composition, and email drafting methods.

### Direction 3: Analysis, Classification, and Decision Support

**Target audiences:** Operations, Quality Assurance, Risk Management, Customer Service, Research, Consulting

This direction uses `PipeLLM` for reasoning, `PipeCondition` for routing, and `PipeBatch` for scale. The pattern is: take a collection of items, analyze each one against criteria, classify them, and produce aggregate reports or trigger conditional actions.

Example families:
- **Customer feedback analysis**: Classify sentiment, extract themes, route to response templates, generate weekly insight reports
- **Resume screening**: Score candidates against job requirements, rank by fit, generate interview question sets
- **Product review mining**: Extract feature mentions, sentiment per feature, competitive comparisons, generate product improvement briefs
- **Quality inspection**: From images of products or construction sites, identify defects, classify severity, generate inspection reports
- **Risk assessment**: Analyze contracts/proposals against risk criteria, score and categorize risks, generate mitigation recommendations
- **Research synthesis**: Process multiple papers, classify relevance, synthesize findings into literature reviews

The composability angle: a "classify and route" pattern (analyze + condition + branch) becomes a reusable meta-method applicable to any domain where items need sorting.

### Direction 4: Multimodal Generation and Design

**Target audiences:** Design, Architecture, Product Development, Fashion, Media, Gaming, Brand Management

This direction leans heavily on `PipeImgGen` combined with `PipeLLM` for creative direction and `PipeCompose` for assembly. The pattern is: generate creative concepts through LLM reasoning, render them as images, and compose the results into visual deliverables.

Example families:
- **Brand identity exploration**: From a brand brief, generate logo concepts, color palettes, typography samples, mockup applications
- **Product design ideation**: From specifications, generate design sketches, material explorations, packaging concepts
- **Architectural visualization**: From floor plans and briefs, generate exterior renders, interior mood boards, landscape perspectives
- **Fashion lookbooks**: From trend reports, generate outfit concepts, fabric patterns, styled photography concepts
- **Storyboarding**: From a script, generate scene illustrations, character designs, mood frames
- **Data visualization**: From structured data, generate infographic designs, chart layouts, dashboard concepts

The composability angle: a "generate image from concept description" method is atomic; a "create brand identity kit" method composes it with brief analysis, style exploration, and multi-format rendering methods.

---

## Part 4 -- Rough Outline: The Road to 2,000 Use Cases

Getting to 2,000 documented use cases is an ambitious target that requires systematic expansion, not linear effort. The strategy is to exploit the combinatorial nature of Pipelex methods: industries x functions x patterns x variations.

### The Multiplication Framework

**Axis 1: Industries (20+)**

Agriculture, Architecture, Automotive, Construction, Consulting, E-commerce, Education, Energy, Entertainment, Fashion, Finance, Food & Beverage, Government, Healthcare, Insurance, Legal, Manufacturing, Media & Publishing, Non-profit, Pharmaceuticals, Real Estate, Retail, Technology, Telecommunications, Transportation & Logistics, Travel & Hospitality

**Axis 2: Business Functions (15+)**

Accounting, Compliance, Customer Service, Design, Engineering, HR & Recruiting, Legal, Marketing, Operations, Procurement, Product Management, Quality Assurance, Research & Development, Sales, Strategy & Planning

**Axis 3: Method Patterns (10+)**

Document extraction + structuring, Classification + routing, Batch analysis + aggregation, Content generation (text), Content generation (visual), Multi-format content kits, Comparison + diff reporting, Quality gate + validation, Research synthesis, Multimodal generation pipelines

**Axis 4: Complexity Tiers**

- Tier 1 (Atomic): Single-pipe or 2-step methods. ~200 examples.
- Tier 2 (Composite): 3-6 step methods combining patterns. ~800 examples.
- Tier 3 (Enterprise): Multi-method compositions for complex workflows. ~500 examples.
- Tier 4 (Showcase): End-to-end industry solutions composing 5+ methods. ~500 examples.

### The Execution Phases

**Phase 1 -- Foundation (target: ~100 use cases)**

Build the atomic method library. Focus on the 10 method patterns above, creating 8-12 generic versions of each that work across industries. These become the reusable building blocks for everything else.

Deliverables:
- 10-15 document extraction methods (invoice, contract, receipt, form, report, medical record, etc.)
- 10-15 classification/routing methods (sentiment, document type, priority, category, etc.)
- 10-15 content generation methods (summary, email, social post, report section, etc.)
- 10-15 image generation methods (product photo, logo, illustration, diagram, etc.)
- 10-15 analysis methods (comparison, scoring, risk assessment, quality check, etc.)
- 10-15 composition methods (HTML report, email template, dashboard, catalog, etc.)

**Phase 2 -- Industry Verticals (target: ~500 use cases)**

Take the atomic methods from Phase 1 and compose them into industry-specific workflows. For each of 10 priority industries, create 40-60 methods spanning the major business functions.

Priority industries for Phase 2:
1. Legal (contracts, compliance, litigation support)
2. Finance (accounting, auditing, reporting)
3. Healthcare (records, billing, clinical support)
4. E-commerce (catalog, marketing, customer service)
5. Education (content creation, assessment, administration)
6. Insurance (claims, underwriting, policy management)
7. Real Estate (listings, appraisals, transaction management)
8. HR & Recruiting (screening, onboarding, performance management)
9. Marketing & Advertising (campaigns, brand, content)
10. Manufacturing & Quality (inspection, compliance, documentation)

**Phase 3 -- Cross-Function Expansion (target: ~800 use cases)**

Extend into the remaining industries and business functions. This phase benefits enormously from composability: many methods from Phase 2 can be adapted to new industries by swapping out the domain-specific concepts while keeping the same orchestration pattern.

Approach:
- For each remaining industry (10-15 industries), create 30-50 methods by adapting Phase 2 patterns
- For each remaining business function, create 10-20 cross-industry methods
- Identify and build "horizontal" methods that apply universally (meeting processing, email generation, document comparison)

**Phase 4 -- Enterprise Showcases (target: ~600 use cases)**

Build the flagship examples: complex, multi-method compositions that demonstrate Pipelex at enterprise scale. Each showcase composes 3-10 methods from Phases 1-3 into a complete workflow.

Examples:
- "End-to-end loan origination": document extraction + applicant scoring + compliance check + risk assessment + approval routing + letter generation
- "Product launch toolkit": market research synthesis + competitive analysis + pricing recommendation + marketing campaign generation + sales enablement kit
- "Clinical trial document package": protocol extraction + patient screening criteria + consent form generation + regulatory compliance check + submission package assembly

### Scaling Mechanisms

To reach 2,000 efficiently:

1. **Template-based expansion.** Many use cases follow the same orchestration pattern with different concepts and prompts. Create parameterized templates: "Extract [document type], structure as [concept], validate against [rules], generate [report type]."

2. **Agent-assisted generation.** Pipelex methods are files that agents can read, understand, and generate. Use Claude or other LLMs to draft new methods from natural language descriptions of business processes, then have domain experts review and refine them.

3. **Community contributions.** Publish the cookbook and atomic method library. Invite domain experts to contribute industry-specific methods. The package system and composability make it safe to build on each other's work.

4. **Variation through configuration.** A single method pattern can yield multiple use cases by varying the concepts, prompts, and model choices. An "extract structured data from document" method becomes 20+ use cases just by changing the target concept (invoice, receipt, contract, medical record, insurance claim...).

5. **Systematic coverage grid.** Maintain a matrix of industries x functions x patterns. Track coverage. Identify gaps. Prioritize based on market demand and audience reach.

### What "2,000 Use Cases" Looks Like

Not 2,000 from-scratch methods. Instead: ~100 atomic methods composed into ~500 composite methods, expanded across ~20 industries and ~15 business functions, with ~600 enterprise showcases demonstrating the full power of composability. Each use case is a working `.mthds` file with documented inputs, expected outputs, and a clear description of who it serves and what problem it solves.

The end result is not just a collection of examples. It is the beginning of the Know-How Graph: a network of proven, reusable methods that compounds in value as every new method builds on what came before.
