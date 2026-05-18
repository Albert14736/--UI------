# Project Instructions: 崩坏指挥终端 (Honkai Command Terminal)

## 1. Workflow & Context Management
- **Persistent Memory**: After each turn, analyze the interaction for meaningful updates (e.g., architectural decisions, bug fixes, new design patterns, style guidelines). 
- **Update MEMORY.md**: Save these updates into `Gemini/MEMORY.md` using the existing format. Ensure new entries are dated if they introduce new standards.
- **Context Efficiency**: Prioritize `grep_search` and surgical reads. Minimize full-file reads for large Lua/XML files.

## 2. Technical Standards
- **File References**: When referencing DDS files in `Icons.xml`, `.ggxml`, or `.modinfo`, always include the full subfolder path (e.g., `ResourceAndText_Textures/xxx_22.dds`).
- **Lua UI**: Check for file existence using `include` safety checks in UI scripts.
- **Resource System**: Adhere to the dual-track resource logic defined in `HonkaiEnergySystem.lua`.

## 3. UI/UX Style
- **Aesthetic**: Modern, "Honkai" themed, semi-transparent (e.g., 15% opacity for loading screens).
- **Colors**: Preference for light purple/lavender accents.
