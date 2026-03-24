---
name: mayi-travel
description: Use when user wants deep cultural travel research for a city, says '旅行研究', '博物馆功课', '古建功课', 'travel research', '出发前功课', or provides a city name with intent to do pre-trip cultural preparation
---

# Mayi Travel Research

## Overview

Deep cultural travel research for a target city. Produces a structured knowledge document covering historical background, museum highlights, archaeological significance, architectural heritage, and recommended visit routes. Methodology borrows from archaeological Desk-Based Assessment (DBA): exhaust all available evidence before arriving.

## When to Use

- User wants pre-trip cultural preparation for a specific city
- User mentions 旅行研究, 博物馆功课, 古建功课, travel research, 出发前功课
- User provides a city name with intent to do deep cultural research

When NOT to use:

- User wants a casual travel itinerary or hotel/flight booking help
- User only needs restaurant or shopping recommendations
- User wants real-time travel logistics (weather, transport schedules)

## Required Inputs

- `city`: target city name

## Input Validation

- `city` must be provided. If missing, stop and ask.
- If the user message is ambiguous about which city, ask for clarification before proceeding.

## Optional Inputs

- `focus_topics`: one or more focus themes (e.g., 唐代, 石窟, 青铜器). When specified, all research dimensions prioritize these themes; other dimensions serve as background.
- `quick_mode`: when set, skip content analysis step — only do research and produce the document directly.

## Workflow

1. **Parse inputs** — Extract city name and optional parameters from user message.

2. **Multi-dimensional research** — Perform extensive web research covering all dimensions below. Use bilingual (Chinese + English) search terms to maximize coverage. Research all dimensions in parallel:

   **Dimension A — Historical Layers**
   Which major historical periods shaped this city? What physical remains did each period leave? How did dynastic transitions affect the city layout?

   **Dimension B — Museum Highlights**
   Which important museums exist? What are the star exhibits and core collections? Which artifacts have major archaeological significance? Provide specific artifact names and gallery locations.

   **Dimension C — Ancient Architecture**
   Which important ancient buildings and sites survive? Construction era, architectural form, structural features. Which are national key cultural relics protection units? What details to look for when visiting (bracket sets, painted decorations, stele inscriptions, etc.)?

   **Dimension D — Archaeological Discoveries**
   What major archaeological discoveries were made in or near this city? Where are the excavated artifacts housed today? Any notable excavation stories?

   **Dimension E — Cultural Context**
   Important historical figures, literary works, and cultural traditions associated with this city. Helps understand the city's cultural character.

   **Dimension F — In-Depth Content Discovery**
   Search bilibili.com, zhihu.com, mp.weixin.qq.com, douyin.com, xiaohongshu.com for in-depth content about the city's museums and ancient architecture.
   Selection criteria:
   - Want: content with knowledge value (background, craftsmanship, excavation process, architectural details)
   - Skip: pure check-in photos, recommendation-only without analysis, advertorial content
   - Bilibili videos: prefer 10+ minute educational content
   - WeChat articles: prefer those with references or identifiable author credentials
   - Return: title, URL, one-sentence summary

3. **Content analysis (optional)** — If `quick_mode` is NOT set, extract valid URLs from step 2 results and analyze each for core knowledge points. Degradation rules:
   - If analysis fails for a URL (inaccessible, no subtitles, etc.), skip it — do not block
   - If all URLs fail, continue — step 2 results are sufficient
   - Content analysis is an enhancement layer, not a requirement

4. **Synthesize structured document** — Combine research results (step 2) and content analysis (step 3, if available) into the output structure defined below.

5. **Summary report** — Present a brief completion summary:
   ```
   ════ 旅行研究完成 ═══════════════════════
   🏛️ 城市: {city}
   📊 研究覆盖: {N}个博物馆 | {M}座古建 | {K}处考古遗址
   📎 深度内容: {X}个视频 | {Y}篇文章
   ```

## Output Structure

Output directly in the conversation. Use this exact section order:

1. **城市概览** — The city's place in Chinese civilization. One paragraph: why it's worth visiting and what to look for.

2. **历史分层**
   - Per period: era name (date range), key events, surviving physical remains, what you can still see today.

3. **博物馆指南**
   - Per museum: address, hours, reservation info (if needed).
     - 镇馆之宝: artifact name → why it matters | what details to observe
     - 重点展厅: gallery name → core highlights
     - 容易错过的: overlooked but worthwhile items

4. **古建遗存**
   - Per site: name (dynasty, protection level), form overview.
     - 看什么: specific observation points → why each is notable

5. **考古发现**
   - Per discovery: excavation story, significance, where artifacts are now housed.

6. **参观路线**
   - Route options with theme, estimated duration, and audience fit.
   - Per stop: location → what to focus on (suggested time).

7. **深度内容推荐**
   - 视频: title + URL + one-sentence summary
   - 文章: title + URL + one-sentence summary
   - 书籍 (if applicable): title + why it's worth reading

## Writing Rules

- Every recommendation must include "why to see it" and "what details to look for" — no vague suggestions.
- Tone: personal research notes, not tour-guide script.
- When exact information is available, be precise. When not, leave blank rather than fabricate.

## Error Handling

- City name missing or ambiguous: stop and ask for clarification.
- Research yields very thin results for a city: note coverage gaps explicitly; do not pad with generic content.
- Focus topic yields no relevant results: report this and provide general coverage instead.

## Quality Checks

- Every museum/site recommendation traces back to research evidence.
- No fabricated artifact names, dates, or locations.
- Bilingual search was used (check that both Chinese and English sources appear).
- Focus topics (if specified) are prioritized throughout all dimensions.
- Output follows the exact section order.
- Content discovery URLs are real and include selection-criteria justification.

## Key Constraints

- Step 2 is the core — parallel research across all dimensions in one pass.
- Step 3 (content analysis) is an enhancement layer; failure does not block the workflow.
- The structured output is the primary deliverable — quality over quantity.
- No generic travel guides; every recommendation needs "why" and "what to look for".
- Research uses bilingual (Chinese + English) keywords for broader coverage.
- When uncertain, leave blank rather than fabricate.

## Minimal Invocation Example

Input:

- `city`: `西安`

Output:

- Structured research document output directly in conversation.

Advanced invocation:

- `city`: `大同`
- `focus_topics`: `石窟`, `辽金建筑`
- `quick_mode`: true
