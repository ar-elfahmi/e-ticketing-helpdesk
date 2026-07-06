# Design System

## 1. Visual Theme & Atmosphere

Design system embodies a warm, approachable, and educational aesthetic rooted in natural earth tones and soft, calming colors. The visual identity reflects accessibility and inclusivity—creating an inviting space for language learners of all levels. The palette balances a rich forest green with cream and beige neutrals, evoking a sense of growth, knowledge, and organic learning. The design prioritizes clarity and readability while maintaining a contemporary, refined feel through generous whitespace and thoughtful typography. Rounded corners and subtle shadows create a soft, friendly interface that feels modern yet timeless.

**Key Characteristics**
- Warm, earthy color palette dominated by forest green and cream tones
- Soft, approachable aesthetic with rounded corners and subtle shadows
- Strong typographic hierarchy using Bricolage Grotesque and DM Sans
- Generous whitespace and breathing room throughout layouts
- Emphasis on accessibility and ease of use for educational content
- Organic, nature-inspired color relationships
- Refined minimalism with purposeful use of elevation and depth

## 2. Color Palette & Roles

### Primary
- **Forest Green Deep** (`#2F4530`): Primary brand color used extensively across buttons, headings, borders, and key interactive elements. Conveys trust, growth, and learning.
- **Forest Green Medium** (`#5C7A52`): Secondary forest green for hover states, secondary buttons, and accents. Lighter variant maintains brand consistency.
- **Forest Green Dark** (`#3E5A37`): Darkest variant for emphasis, strong text contrast, and premium component highlights.

### Accent Colors
- **Golden Warm** (`#E9C97B`): Warm accent for highlights, badges, or call-out elements that require attention without primary dominance.
- **Cream Light** (`#EFE7D5`): Soft cream accent for backgrounds, content cards, and layered depth. Creates warm, inviting card containers.

### Interactive
- **Button Primary** (`#5C7A52`): Medium forest green for primary action buttons, ensuring clear call-to-action visibility.
- **Link Color** (`#5C7A52`): Links and secondary interactive text use medium forest green for consistency and recognizability.

### Neutral Scale
- **Background Warm** (`#F4EEDD`): Primary page background color. Warm, off-white tone that reduces visual strain while maintaining warmth.
- **White** (`#FFFFFF`): Pure white for card surfaces, text backgrounds, and high-contrast containers requiring neutrality.

### Surface & Borders
- **Border Subtle** (`#2F4530` at 14% opacity): Soft border color for card edges and dividers. Maintains visual separation without harshness.
- **Border Medium** (`#2F4530` at 18% opacity): Slightly more prominent borders for interactive elements and form inputs.
- **Card Surface Warm** (`#EFE7D5`): Warm cream background for featured content cards, creating visual hierarchy through color differentiation.

### Semantic & Status
- **Success** (`#22C55E`): Green for success states, confirmations, and positive feedback messages.
- **Error** (`#EF4444`): Red for error messages, warnings, and invalid input states.

### Shadow Colors
- **Shadow Small** (Forest Green `#2F4530` at 12% opacity): Subtle shadow for cards and floating elements. `0px 6px 18px 0px`
- **Shadow Medium** (Forest Green `#2F4530` at 7% opacity): Minimal shadow for understated depth. `0px 2px 8px 0px`

## 3. Typography Rules

### Font Family
**Primary:** Bricolage Grotesque (Google Fonts) — bold, geometric display font for headings and emphasis. Fallback: `system-ui, -apple-system, sans-serif`

**Secondary:** DM Sans (Google Fonts) — clean, open sans-serif for body text and UI copy. Fallback: `system-ui, -apple-system, sans-serif`

### Hierarchy

| Role | Font | Size | Weight | Line Height | Letter Spacing | Notes |
|------|------|------|--------|-------------|-----------------|-------|
| Display (H1) | Bricolage Grotesque | 51px | 800 | 56px | 0px | Hero headlines; maximum emphasis and presence |
| Heading Large (H2) | Bricolage Grotesque | 35px | 800 | 44px | 0px | Section headings; strong visual hierarchy |
| Heading Medium (H3) | Bricolage Grotesque | 18px | 700 | 23px | 0px | Subsection titles; card headers |
| Accent/Emphasis (Span) | Bricolage Grotesque | 20px | 800 | 30px | 0px | Highlighted text; bold callouts within paragraphs |
| Body (P) | DM Sans | 18px | 400 | 31px | 0px | Primary body text; article and descriptive copy |
| Link (A) | DM Sans | 14px | 600 | 21px | 0px | Inline links; slightly reduced size with increased weight |
| Button (Button) | DM Sans | 16px | 500 | normal | 0px | Call-to-action text; clear and legible at standard size |
| Caption | DM Sans | 14px | 400 | 21px | 0px | Fine print; secondary supporting text |
| Code (Mono) | `Courier New, monospace` | 14px | 400 | 21px | 0px | Technical content and code blocks |

### Principles
- **Contrast through weight:** Use Bricolage Grotesque at 700–800 weight for hierarchy; rely on DM Sans 400–600 for legibility.
- **Line height for readability:** Body text uses 31px line height (1.7x multiplier) to ensure comfortable reading on screens.
- **Size progression:** Each level increases ~1.4x from the previous for clear visual steps.
- **Font-family consistency:** Limit to two font families across the entire system for cohesion.
- **Screen readability:** Body text at 18px minimum ensures accessibility and comfort on small and large screens.

## 4. Component Stylings

### Buttons

#### Primary Button
- **Background:** `#5C7A52`
- **Text Color:** `#FFFFFF`
- **Font:** DM Sans, 16px, weight 500
- **Padding:** `0px 16px`
- **Height:** `40px`
- **Border Radius:** `10px`
- **Border:** None
- **Box Shadow:** None
- **Hover State:** Background `#2F4530`, text `#FFFFFF`
- **Active State:** Background `#3E5A37`, text `#FFFFFF`
- **Disabled State:** Background `#5C7A52` at 50% opacity, text `#FFFFFF` at 60% opacity

#### Secondary Button / Ghost Button
- **Background:** Transparent `rgba(0, 0, 0, 0)`
- **Text Color:** `#5C7A52` at 60% opacity or `#2F4530`
- **Font:** DM Sans, 14px, weight 400
- **Padding:** `0px`
- **Height:** Auto
- **Border Radius:** `0px`
- **Border:** None
- **Box Shadow:** None
- **Hover State:** Text color `#5C7A52`, opacity 100%
- **Underline:** Optional underline on hover

### Cards & Containers

#### Card Warm (Featured Content)
- **Background:** `#EFE7D5`
- **Text Color:** `#2F4530`
- **Font:** DM Sans, 16px, weight 400
- **Padding:** `20px 24px`
- **Border Radius:** `24px`
- **Border:** `1px solid #2F4530` at 14% opacity
- **Box Shadow:** `0px 6px 18px 0px rgba(47, 69, 48, 0.12)`
- **Line Height:** `24px`

#### Card White (Standard Content)
- **Background:** `#FFFFFF`
- **Text Color:** `#2F4530`
- **Font:** DM Sans, 16px, weight 400
- **Padding:** `20px`
- **Border Radius:** `24px`
- **Border:** `1px solid #2F4530` at 18% opacity
- **Box Shadow:** `0px 2px 8px 0px rgba(47, 69, 48, 0.07)`
- **Line Height:** `24px`

#### Page Background Container
- **Background:** `#F4EEDD`
- **Padding:** `48px 40px` (desktop), `24px 16px` (mobile)

### Inputs & Forms

#### Text Input
- **Background:** `#FFFFFF`
- **Text Color:** `#2F4530`
- **Font:** DM Sans, 16px, weight 400
- **Padding:** `12px 16px`
- **Border Radius:** `10px`
- **Border:** `1px solid #2F4530` at 18% opacity
- **Box Shadow:** None
- **Focus State:** Border `#5C7A52`, box-shadow `0px 0px 0px 3px rgba(92, 122, 82, 0.1)`
- **Error State:** Border `#EF4444`, box-shadow `0px 0px 0px 3px rgba(239, 68, 68, 0.1)`

#### Checkbox / Radio
- **Background:** `#FFFFFF`
- **Border:** `2px solid #5C7A52`
- **Checked State:** Background `#5C7A52`, checkmark `#FFFFFF`
- **Border Radius:** `4px` (checkbox), `50%` (radio)

### Navigation

#### Header Navigation
- **Background:** `#F4EEDD`
- **Text Color:** `#2F4530`
- **Font:** DM Sans, 16px, weight 400
- **Padding:** `16px 40px`
- **Height:** `64px`
- **Border Bottom:** `1px solid #2F4530` at 14% opacity (optional)

#### Navigation Link
- **Text Color:** `#5C7A52`
- **Font:** DM Sans, 16px, weight 600
- **Padding:** `8px 16px`
- **Border Radius:** `999px`
- **Border:** `1px solid #2F4530` at 14% opacity (pill style)
- **Hover State:** Background `#EFE7D5`, text `#2F4530`

### Badges
- **Background:** `#EFE7D5`
- **Text Color:** `#2F4530`
- **Font:** DM Sans, 12px, weight 600
- **Padding:** `4px 12px`
- **Border Radius:** `16px`
- **Border:** `1px solid #2F4530` at 14% opacity

## 5. Layout Principles

### Spacing System
Base unit: `8px`

**Spacing Scale:**
- `8px`: Fine-grained spacing (button padding, icon gaps)
- `16px`: Component padding, tight grouping
- `20px`: Default gap between related elements
- `24px`: Card padding, section spacing
- `32px`: Medium section separation
- `40px`: Large container padding
- `48px`: Extra-large section margins, page-level padding

**Usage Context:**
- Buttons: `16px` horizontal padding, `8px` vertical margin
- Cards: `20px` internal gap, `24px` padding on all sides
- Sections: `48px` top/bottom spacing
- List items: `20px` gap between elements
- Form groups: `24px` between inputs

### Grid & Container
- **Max Width:** `1280px` for desktop layouts
- **Column Strategy:** 12-column grid with `20px` gutters
- **Container Padding:** `40px` left/right on desktop, `16px` on mobile
- **Section Pattern:** Full-width background bands with centered content containers
- **Card Grid:** 2-3 columns on desktop (depending on content), 1 column on mobile

### Whitespace Philosophy
prioritizes breathing room and visual clarity. Whitespace serves as a design element—generous margins and padding reduce cognitive load and guide focus. Sections are well-separated by vertical spacing (`48px`), allowing users to pause and absorb content. Internal card padding (`20px–24px`) prevents content crowding. The warm background (`#F4EEDD`) is never used without adequate whitespace, ensuring text and interactive elements remain legible and inviting.

### Border Radius Scale
- `0px`: Sharp edges for technical/data components (tables, code blocks)
- `4px`: Subtle rounding for form inputs, checkboxes, small components
- `10px`: Standard button rounding, maintaining modern feel
- `16px`: Badge and small container rounding
- `24px`: Primary card rounding, larger container rounding
- `999px`: Fully rounded pills for badges, navigation elements

## 6. Depth & Elevation

| Level | Treatment | Use |
|-------|-----------|-----|
| Base (0) | No shadow | Flat surfaces, text layers, backgrounds |
| Low (1) | `0px 2px 8px 0px rgba(47, 69, 48, 0.07)` | Standard cards, subtle floating elements |
| Medium (2) | `0px 6px 18px 0px rgba(47, 69, 48, 0.12)` | Featured cards, modals, emphasized containers |
| High (3) | `0px 12px 24px 0px rgba(47, 69, 48, 0.16)` | Dropdowns, tooltips, floating overlays |
| Extra (4) | `0px 20px 40px 0px rgba(47, 69, 48, 0.2)` | Full-screen modals, sticky headers with depth |

**Shadow Philosophy:**
Shadows are used sparingly and subtly to create depth without visual noise. The forest green at reduced opacity maintains color harmony while establishing elevation. Low shadows (`md`) are default for cards and containers. Medium shadows (`lg`) are reserved for featured or interactive elements that require visual prominence. Shadows respect the warm, natural aesthetic and never feel harsh or aggressive.

## 7. Do's and Don'ts

### Do
- Use `#5C7A52` (medium forest green) as the primary interactive color for consistency across buttons and links.
- Apply `24px` border radius to all card containers for cohesive visual language.
- Maintain the `#F4EEDD` background across pages—it's fundamental to the warm aesthetic.
- Use DM Sans for all UI copy (buttons, labels, navigation) and Bricolage Grotesque for headings only.
- Include `20px` gap minimum between adjacent content sections for breathing room.
- Apply the small shadow (`0px 2px 8px 0px rgba(47, 69, 48, 0.07)`) to white cards and the medium shadow to warm-toned cards.
- Ensure body text is always `18px` or larger for readability on all devices.
- Use pill-style buttons (`border-radius: 999px`) for secondary navigation or tag-like actions.
- Test color combinations against WCAG AA contrast standards (minimum 4.5:1 for text).

### Don't
- Don't use primary green (`#2F4530`) as a background for extended body text—reserve it for accents and borders only.
- Don't exceed two shadow levels in a single view; excessive depth creates visual clutter.
- Don't apply custom colors outside the defined palette; maintain consistency by using only specified hex values.
- Don't use button heights smaller than `40px`; touch targets must accommodate accessibility guidelines.
- Don't mix Bricolage Grotesque and DM Sans at the same size—maintain clear role separation.
- Don't exceed `56px` line height on body text; tighter leading maintains readability.
- Don't apply more than `24px` padding to cards—excessive padding wastes space.
- Don't use the warm background color (`#F4EEDD`) inside card containers; reserve it for page-level backgrounds only.
- Don't apply active or hover states that shift layout; use only color and shadow changes.
- Don't forget to include visible focus indicators (e.g., outline or shadow) on interactive elements for keyboard navigation.

## 8. Responsive Behavior

### Breakpoints

| Breakpoint Name | Width | Key Changes |
|-----------------|-------|-------------|
| Mobile | 320px – 640px | Single-column layout, `16px` padding, stacked cards, `35px` H2, `16px` body |
| Tablet | 641px – 1024px | Two-column cards, `24px` padding, `40px` H2, `18px` body |
| Desktop | 1025px – 1280px | Three-column cards (where applicable), `40px` padding, `51px` H1, `35px` H2, `18px` body |
| Large Desktop | 1281px+ | Constrained max-width `1280px` with centered container |

### Touch Targets
- **Minimum interactive element size:** `40px × 40px` (buttons, links, inputs)
- **Spacing between touch targets:** `8px` minimum gap to prevent accidental activation
- **Tap-friendly padding:** `12px` internal padding for form inputs
- **Link size:** `16px` font with `8px 16px` padding for comfortable touch interaction

### Collapsing Strategy
- **Navigation:** Horizontal on desktop (`40px` padding), collapse to mobile menu icon on tablet/mobile (320px+)
- **Cards:** 3-column on desktop, 2-column on tablet, 1-column on mobile
- **Spacing:** Reduce section margins from `48px` to `32px` on tablet, `24px` on mobile
- **Typography:** H1 scales from `51px` (desktop) to `35px` (tablet) to `28px` (mobile); body remains `18px` minimum
- **Padding:** Container padding reduces from `40px` to `24px` on tablet, `16px` on mobile
- **Features:** Hero sections may stack vertically; flex direction changes from row to column
- **Modals:** Full-screen on mobile with `16px` edge padding; fixed width (`600px` max) on desktop with centered positioning

## 9. Agent Prompt Guide

### Quick Color Reference
- **Primary CTA Button:** Medium Forest Green (`#5C7A52`)
- **Primary Background:** Warm Cream (`#F4EEDD`)
- **Card Background (Featured):** Light Cream (`#EFE7D5`)
- **Card Background (Standard):** White (`#FFFFFF`)
- **Heading Text:** Deep Forest Green (`#2F4530`)
- **Body Text:** Deep Forest Green (`#2F4530`)
- **Accent / Highlight:** Golden Warm (`#E9C97B`)
- **Success State:** Green (`#22C55E`)
- **Error State:** Red (`#EF4444`)
- **Border (Subtle):** Deep Forest Green (`#2F4530`) at 14% opacity
- **Border (Medium):** Deep Forest Green (`#2F4530`) at 18% opacity
- **Link Color:** Medium Forest Green (`#5C7A52`)

### Iteration Guide

1. **Start with the warm background:** All pages use `#F4EEDD` as the base. This is non-negotiable and sets the tone.

2. **Apply consistent spacing:** Use the `8px` base unit throughout. Default section gaps are `48px` (desktop), `32px` (tablet), `24px` (mobile).

3. **Build with two fonts only:** Bricolage Grotesque for headings (H1, H2, H3) at weights 700–800; DM Sans for everything else (body, buttons, labels) at weights 400–600.

4. **Primary button colors:** All primary call-to-action buttons are `#5C7A52` with `#FFFFFF` text, `16px` DM Sans, `10px` radius, `40px` height.

5. **Card styling:** White cards use `#FFFFFF` background with `0px 2px 8px 0px rgba(47, 69, 48, 0.07)` shadow. Featured/warm cards use `#EFE7D5` with `0px 6px 18px 0px rgba(47, 69, 48, 0.12)` shadow. All cards: `24px` radius, `20px`–`24px` padding.

6. **Typography hierarchy:** H1 `51px`, H2 `35px`, H3 `18px`, body `18px`, links `14px` — all with specific line heights (`56px`, `44px`, `23px`, `31px`, `21px` respectively).

7. **Interactive elements:** All links are `#5C7A52`. Hover states darken to `#2F4530`. Buttons maintain consistent `40px` height with `16px` horizontal padding.

8. **Borders and dividers:** Use `#2F4530` at 14% opacity for subtle dividers; 18% opacity for slightly stronger borders on form inputs and cards.

9. **Shadows are minimal:** Two levels only — small shadow `0px 2px 8px 0px` for standard elements, medium shadow `0px 6px 18px 0px` for emphasis. No additional custom shadows.

10. **Responsive breakpoints:** Mobile (320px–640px), Tablet (641px–1024px), Desktop (1025px+). Adjust padding, grid columns, and typography size only; maintain color and component structure across all sizes.

11. **Status colors:** Green (`#22C55E`) for success, Red (`#EF4444`) for errors. These are semantic and should never be repurposed for brand color.

12. **Accessibility first:** Body text minimum `18px`. Links and buttons minimum `40px × 40px`. Color contrast minimum 4.5:1 for WCAG AA. Include focus states with visible outlines or shadows on all interactive elements.