# Pipelex + Linkup: What Becomes Possible

## The Missing Piece

Today, a Pipelex method operates on what you give it. You feed it documents, text, images -- and it extracts, reasons, generates, and composes with precision. But the method is blind to the world outside its inputs. It can tell you everything about the contract you uploaded, but nothing about the case law that changed last Tuesday. It can generate a market report from the data you provide, but it can't check whether that data is still current.

Linkup fills the gap. It gives Pipelex methods live, structured, sourced access to the web. Not links for a human to click -- atoms of information with provenance and timestamps, delivered directly to the pipeline's working memory.

This is not a minor enhancement. It changes what a Pipelex method *can be*. A method no longer processes static inputs; it investigates, verifies, enriches, and grounds its work in the state of the world right now.

## Why Neither Tool Alone Is Enough

**Linkup alone** gives you fresh, accurate search results. But search results are raw material. You still need to structure them, reason over them, cross-reference them with your own documents, generate deliverables, and orchestrate multi-step workflows. Linkup returns data; it does not produce a 15-page due diligence report with risk scores, visual comparisons, and actionable recommendations.

**Pipelex alone** gives you rigorous orchestration, document intelligence, structured reasoning, and multimodal generation. But it operates in a closed world. Every fact it works with must be supplied as an input. It cannot discover that a vendor went bankrupt yesterday, that a regulation was amended last month, or that a competitor just launched a rival product.

**Combined**, a Pipelex method can start from a question or a document, reach out to the live web for context, and then do what Pipelex does best: structure, reason, compose, and deliver. The orchestration layer -- sequence, parallel, batch, condition -- means these web lookups happen at exactly the right step, with exactly the right query, and the results flow into downstream pipes as typed, validated concepts.

## The New Category: Live-Grounded Methods

The integration opens a new category of methods that we can call **live-grounded methods**. These are methods where at least one step queries the web for current information, and downstream steps reason over the combination of local inputs and live data.

The pattern in a `.mthds` file would look like this:

1. **Extract** or receive structured input (document, brief, question)
2. **Search** the live web via Linkup for relevant context (regulations, prices, news, competitors, benchmarks)
3. **Reason** over the combination of extracted data and live context using `PipeLLM`
4. **Generate** deliverables (reports, visuals, structured data) using `PipeCompose` and `PipeImgGen`

The batch and parallel controllers make this scalable: search for context on 50 line items simultaneously, or run four independent research threads in parallel and synthesize the results.

---

## The Ten Demos That Could Not Exist Without Both

### 1. Live Competitive Landscape from a Product Brief

**Input:** A product description or pitch deck (PDF or text).

**What happens:**
- `PipeExtract` pulls the product's features, positioning, and target market from the document
- `PipeLLM` formulates targeted search queries (competitor names, category terms, feature comparisons)
- Linkup deep-searches for competitor products, their pricing, recent funding rounds, G2/Capterra ratings, and press coverage
- `PipeBatch` processes each discovered competitor in parallel: structure their profile, score feature overlap, identify differentiation gaps
- `PipeImgGen` generates a visual positioning map and competitor logo-style thumbnails
- `PipeCompose` assembles a complete competitive landscape HTML report with structured comparison tables, sourced data points, and visual positioning

**Why neither alone:** Linkup can find the competitors but cannot extract your product's features from a PDF or generate a structured visual report. Pipelex can structure and compose beautifully but has no idea who your competitors are or what they launched last week.

**Who cares:** Product managers, founders preparing investor decks, strategy consultants.

---

### 2. Contract Clause Risk Assessment Against Current Case Law

**Input:** A commercial contract (PDF).

**What happens:**
- `PipeExtract` processes the contract, `PipeLLM` identifies and classifies every clause (non-compete, indemnification, limitation of liability, IP assignment, termination, etc.)
- For each flagged clause, Linkup searches for recent judicial decisions, regulatory guidance, and enforcement trends in the relevant jurisdiction
- `PipeLLM` evaluates each clause in light of the live legal context: is this non-compete enforceable given the FTC's latest ruling? Is this liability cap consistent with current industry standards?
- `PipeCondition` routes clauses into risk tiers (high/medium/low) based on the combined analysis
- `PipeCompose` generates a risk assessment report with clause-by-clause annotations, live source citations, and a risk heat map

**Why neither alone:** Linkup can surface recent case law but cannot parse a 40-page contract or structure a risk assessment. Pipelex can parse the contract and reason about clauses but has no access to legal developments that happened after its training data.

**Who cares:** Corporate counsel, M&A teams, legal tech companies, compliance officers.

---

### 3. Real-Time Market Intelligence Briefing from a Question

**Input:** A natural language research question (e.g., "What is the current state of the European EV charging infrastructure market?").

**What happens:**
- `PipeLLM` decomposes the question into 4-6 research sub-queries (market size, key players, regulatory landscape, technology trends, investment activity, regional differences)
- `PipeParallel` runs all sub-queries through Linkup simultaneously, each returning sourced, timestamped findings
- `PipeLLM` structures each research thread into a section with key data points, sources, and analysis
- `PipeLLM` synthesizes a cross-cutting executive summary with the most important findings
- `PipeImgGen` generates section illustrations (market growth visualization concept, infrastructure map concept, technology comparison visual)
- `PipeCompose` assembles a complete illustrated briefing document in HTML with a table of contents, sourced data, and section imagery

**Why neither alone:** Linkup can find the data but delivers it as search results, not a structured multi-section briefing with illustrations. Pipelex can compose beautiful documents but has nothing to put in them without live data.

**Who cares:** Strategy consultants, investment analysts, business development teams, executive assistants preparing briefing materials.

---

### 4. Automated Due Diligence Package

**Input:** A company name + uploaded financial documents (annual reports, balance sheets as PDFs).

**What happens:**
- `PipeExtract` processes all uploaded financial documents, `PipeLLM` structures the extracted data into financial metrics (revenue, margins, debt ratios, growth rates)
- In parallel, Linkup runs a battery of searches: recent news coverage, pending litigation, regulatory filings, executive changes, Glassdoor sentiment, customer complaints, patent activity
- `PipeLLM` cross-references the extracted financial data with web findings: does the revenue in the filing match what's reported publicly? Are there news stories that contradict the narrative in the annual report?
- `PipeBatch` scores each risk dimension (financial health, legal exposure, reputation, management stability, market position)
- `PipeCondition` flags critical discrepancies for highlighted treatment
- `PipeCompose` produces a due diligence report with financial summaries, risk scores, discrepancy flags, and source-cited findings from the web

**Why neither alone:** Linkup can find the news and filings but cannot extract structured data from your uploaded documents or cross-reference them. Pipelex can analyze the documents but cannot discover that the CEO resigned last week or that a class-action lawsuit was filed last month.

**Who cares:** Private equity firms, venture capital analysts, M&A advisory teams, investment banks, corporate development.

---

### 5. Fact-Verified Content Production

**Input:** A draft article, press release, or marketing white paper (text or PDF).

**What happens:**
- `PipeExtract` (if PDF) then `PipeLLM` extracts every factual claim from the document: statistics, dates, quotes, company names, product claims, market figures
- `PipeBatch` sends each claim to Linkup for verification against current web sources
- `PipeLLM` classifies each claim: verified (with source), unverified (no corroboration found), contradicted (conflicting information found), or outdated (newer data available)
- `PipeCondition` routes contradicted and outdated claims to a correction-suggestion pipe
- `PipeCompose` produces two outputs: (1) the original document annotated with verification status for each claim, and (2) a fact-check summary report with sources and suggested corrections

**Why neither alone:** Linkup can verify individual facts but cannot parse a document, extract claims, classify verification results, or produce an annotated deliverable. Pipelex can extract and classify but cannot check any claim against reality.

**Who cares:** Newsrooms, communications teams, legal review for marketing materials, academic publishers, regulatory affairs.

---

### 6. Live-Enriched Product Catalog with Market Context

**Input:** A list of product names or SKUs (text or spreadsheet).

**What happens:**
- `PipeBatch` processes each product in parallel:
  - Linkup searches for current retail pricing, customer reviews, specifications, and competitor alternatives
  - `PipeLLM` structures the findings into a product card: current market price range, average rating, top-praised features, top-criticized features, strongest competitor, price comparison
  - `PipeLLM` generates an image prompt based on the product description
  - `PipeImgGen` renders a product visualization
- `PipeLLM` generates cross-product insights: pricing trends, competitive gaps, market positioning recommendations
- `PipeCompose` assembles a complete HTML catalog with product cards, live market data, generated visuals, and strategic commentary

**Why neither alone:** Linkup can find the prices and reviews but cannot generate product images, structure a catalog, or produce strategic insights. Pipelex can compose the catalog beautifully but has no access to live pricing, reviews, or competitor data.

**Who cares:** E-commerce category managers, retail buyers, product marketing teams, dropshipping entrepreneurs.

---

### 7. Regulatory Compliance Gap Analysis

**Input:** A company policy document or standard operating procedure (PDF).

**What happens:**
- `PipeExtract` processes the policy document, `PipeLLM` identifies every procedure, requirement, and control described
- `PipeLLM` determines the relevant regulatory frameworks (GDPR, SOX, HIPAA, ISO 27001, industry-specific regulations) based on the document's domain and jurisdiction
- Linkup searches for the current text of each relevant regulation, recent amendments, enforcement actions, and guidance documents
- `PipeBatch` compares each internal procedure against the corresponding regulatory requirement: is the procedure sufficient? Is it aligned with the latest version of the regulation? Are there new requirements not covered?
- `PipeCondition` classifies gaps by severity (critical, major, minor, informational)
- `PipeCompose` generates a compliance gap report with procedure-by-regulation mappings, gap descriptions, severity ratings, and links to the relevant regulatory sources

**Why neither alone:** Linkup can find regulations but cannot parse your internal policy document or perform structured gap analysis. Pipelex can analyze the document and structure the report but has no way to know what the current regulation actually says.

**Who cares:** Compliance officers, internal auditors, GRC teams, regulated industry consultants (finance, healthcare, pharma).

---

### 8. Trend-Aware Brand Identity Exploration

**Input:** A brand brief (company name, industry, values, style preference).

**What happens:**
- Linkup searches for current design trends in the brand's industry, competitor visual identities, recent rebranding case studies, and cultural/aesthetic movements relevant to the target audience
- `PipeLLM` synthesizes the trend research into a creative direction document: what's working now, what's oversaturated, what's emerging, what visual language will differentiate
- `PipeLLM` generates 3-5 logo concepts informed by both the brand brief and the live trend analysis, each with a rationale explaining how it responds to the current landscape
- `PipeImgGen` renders each logo concept as a square image
- `PipeLLM` generates application mockup prompts (business card, website header, app icon)
- `PipeBatch` renders mockups for each concept via `PipeImgGen`
- `PipeCompose` assembles a brand exploration deck in HTML: trend analysis, concept rationale, logo renders, and mockup applications

**Why neither alone:** Linkup can surface trends but cannot generate logos, render mockups, or compose a brand deck. Pipelex can generate and compose but without live trend data, the concepts are generic and disconnected from what's actually happening in the market.

**Who cares:** Brand strategists, creative agencies, startup founders, marketing directors launching new products.

---

### 9. Investment Thesis Research Report

**Input:** An investment thesis statement (e.g., "AI infrastructure companies serving European enterprises will outperform in the next 3 years") + optionally, uploaded analyst reports (PDFs).

**What happens:**
- If analyst reports are provided, `PipeExtract` + `PipeLLM` extract their key arguments, data points, and conclusions
- `PipeLLM` decomposes the thesis into testable components (market size claims, growth assumptions, competitive dynamics, regulatory tailwinds/headwinds, comparable valuations)
- `PipeParallel` runs Linkup searches for each component: latest market data, recent deals, earnings reports, analyst commentary, regulatory developments
- `PipeLLM` evaluates each component of the thesis against the live evidence: supported, partially supported, challenged, or insufficient data
- `PipeLLM` identifies the strongest supporting evidence and the biggest risks, with source citations
- `PipeImgGen` generates section header illustrations that visually represent each research dimension
- `PipeCompose` produces a thesis research report: thesis statement, component-by-component analysis with live-sourced evidence, risk factors, overall assessment, and source bibliography

**Why neither alone:** Linkup can find the market data but cannot extract from uploaded analyst reports, decompose a thesis, score evidence, or compose a structured investment document. Pipelex can do all the structuring and reasoning but cannot access earnings reports from last quarter or news from this morning.

**Who cares:** Portfolio managers, equity research analysts, family offices, corporate venture arms, LP due diligence teams.

---

### 10. Talent Market Intelligence from a Job Description

**Input:** A job description (PDF or text).

**What happens:**
- `PipeExtract` (if PDF) then `PipeLLM` extracts the role requirements: title, skills, experience level, location, industry
- Linkup searches for: current salary benchmarks for the role and location, talent supply indicators (LinkedIn job post volume, hiring trends), competitor job postings for similar roles, in-demand skills trajectory, remote work prevalence for the role
- `PipeLLM` structures the market intelligence: how competitive is the compensation? How scarce is the talent? What are competitors offering? What skills should be added or deprioritized based on market trends?
- `PipeLLM` generates recommendations: suggested salary range adjustment, differentiating benefits to highlight, alternative titles that attract more candidates, skills to add to the description
- `PipeCompose` produces a talent market intelligence report with benchmark data, competitive landscape, and actionable hiring recommendations -- all sourced from live data

**Why neither alone:** Linkup can find salary data and job postings but cannot parse your job description PDF or generate structured hiring recommendations. Pipelex can analyze the document and compose the report but has no access to current salary benchmarks or competitor postings.

**Who cares:** Talent acquisition leaders, HR business partners, compensation analysts, recruiting agencies, hiring managers in competitive markets.

---

## What These Ten Demos Prove

Every one of these demos follows the same structural argument:

1. **Documents + live web = grounded intelligence.** The most valuable business analyses require both your proprietary data (contracts, financials, policies, briefs) and the current state of the world (regulations, markets, competitors, trends). Neither source alone is sufficient.

2. **Structured orchestration turns research into deliverables.** Raw search results require a human to read, interpret, organize, and format them. Pipelex's pipeline architecture automates the entire chain from query to polished output -- with typed concepts ensuring the reasoning makes sense at every step.

3. **Composability multiplies the value of live search.** A single Linkup query is useful. A Linkup query embedded in a batch operation across 50 contract clauses, cross-referenced with extracted document data, classified by risk level, and rendered into an HTML report -- that is a product.

4. **The combination is defensible.** Anyone can call a search API. Anyone can prompt an LLM. The value is in the method: the specific sequence of extraction, search, reasoning, classification, and composition that reliably produces a high-quality deliverable for a specific business problem. That method is a `.mthds` file -- versionable, shareable, improvable, and composable into larger solutions.

Pipelex brings the structure. Linkup brings the world. Together, methods stop being closed-world document processors and become live-grounded intelligence systems.
