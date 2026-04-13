#!/usr/bin/env python3
"""
Generate a beautifully formatted PDF reference guide for the Neovim config.
Uses reportlab for professional PDF generation.
"""

from reportlab.lib.pagesizes import A4
from reportlab.lib.units import mm, cm
from reportlab.lib.colors import HexColor, white, black
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle,
    PageBreak, KeepTogether
)
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.enums import TA_LEFT, TA_CENTER, TA_RIGHT
from reportlab.platypus.flowables import HRFlowable
import os

# ─── Colors ───────────────────────────────────────────────────────────────────
BG_DARK      = HexColor("#14161b")
BG_CARD      = HexColor("#1e2028")
BG_ROW_ALT   = HexColor("#f7f8fa")
BG_ROW       = HexColor("#ffffff")
BG_HEADER    = HexColor("#1a1c24")
BG_ACCENT    = HexColor("#0f7dff")
BG_SECTION   = HexColor("#f0f4ff")
TEXT_DARK     = HexColor("#1a1c24")
TEXT_MID      = HexColor("#4a4e5a")
TEXT_LIGHT    = HexColor("#7a7e8a")
ACCENT_BLUE  = HexColor("#0f7dff")
ACCENT_GREEN = HexColor("#10b981")
ACCENT_AMBER = HexColor("#f59e0b")
ACCENT_RED   = HexColor("#ef4444")
ACCENT_PURPLE= HexColor("#8b5cf6")
BORDER_LIGHT = HexColor("#e2e5eb")
KEY_BG       = HexColor("#eef1f6")
KEY_BORDER   = HexColor("#d0d5dd")

# ─── Styles ───────────────────────────────────────────────────────────────────
styles = getSampleStyleSheet()

style_title = ParagraphStyle(
    'CustomTitle',
    parent=styles['Title'],
    fontName='Helvetica-Bold',
    fontSize=32,
    leading=38,
    textColor=TEXT_DARK,
    spaceAfter=4*mm,
    alignment=TA_LEFT,
)

style_subtitle = ParagraphStyle(
    'CustomSubtitle',
    parent=styles['Normal'],
    fontName='Helvetica',
    fontSize=13,
    leading=18,
    textColor=TEXT_MID,
    spaceAfter=8*mm,
    alignment=TA_LEFT,
)

style_section = ParagraphStyle(
    'SectionHeader',
    parent=styles['Heading1'],
    fontName='Helvetica-Bold',
    fontSize=18,
    leading=24,
    textColor=TEXT_DARK,
    spaceBefore=10*mm,
    spaceAfter=4*mm,
    borderPadding=(0, 0, 2, 0),
)

style_subsection = ParagraphStyle(
    'SubSectionHeader',
    parent=styles['Heading2'],
    fontName='Helvetica-Bold',
    fontSize=13,
    leading=18,
    textColor=ACCENT_BLUE,
    spaceBefore=6*mm,
    spaceAfter=3*mm,
)

style_body = ParagraphStyle(
    'CustomBody',
    parent=styles['Normal'],
    fontName='Helvetica',
    fontSize=9.5,
    leading=14,
    textColor=TEXT_DARK,
    spaceAfter=3*mm,
)

style_note = ParagraphStyle(
    'NoteStyle',
    parent=styles['Normal'],
    fontName='Helvetica-Oblique',
    fontSize=9,
    leading=13,
    textColor=TEXT_MID,
    spaceAfter=3*mm,
    leftIndent=4*mm,
    borderPadding=(2*mm, 2*mm, 2*mm, 2*mm),
)

style_key = ParagraphStyle(
    'KeyStyle',
    parent=styles['Normal'],
    fontName='Courier-Bold',
    fontSize=9,
    leading=13,
    textColor=TEXT_DARK,
)

style_desc = ParagraphStyle(
    'DescStyle',
    parent=styles['Normal'],
    fontName='Helvetica',
    fontSize=9,
    leading=13,
    textColor=TEXT_MID,
)

style_table_header = ParagraphStyle(
    'TableHeader',
    parent=styles['Normal'],
    fontName='Helvetica-Bold',
    fontSize=9,
    leading=13,
    textColor=TEXT_MID,
)

style_code = ParagraphStyle(
    'CodeStyle',
    parent=styles['Normal'],
    fontName='Courier',
    fontSize=9,
    leading=13,
    textColor=TEXT_DARK,
    backColor=KEY_BG,
    borderPadding=(2*mm, 3*mm, 2*mm, 3*mm),
    spaceAfter=3*mm,
)

style_footer = ParagraphStyle(
    'FooterStyle',
    parent=styles['Normal'],
    fontName='Helvetica',
    fontSize=7.5,
    leading=10,
    textColor=TEXT_LIGHT,
    alignment=TA_CENTER,
)


def make_key(text):
    return Paragraph(f'<font face="Courier-Bold" size="9" color="#1a1c24">{text}</font>', style_key)

def make_desc(text):
    return Paragraph(text, style_desc)


def make_shortcut_table(data, col_widths=None):
    """Create a styled table for keyboard shortcuts."""
    if col_widths is None:
        col_widths = [55*mm, 105*mm]

    # Header row
    header = [
        Paragraph('<font face="Helvetica-Bold" size="8" color="#7a7e8a">SHORTCUT</font>', style_table_header),
        Paragraph('<font face="Helvetica-Bold" size="8" color="#7a7e8a">ACTION</font>', style_table_header),
    ]

    table_data = [header]
    for key, desc in data:
        table_data.append([make_key(key), make_desc(desc)])

    t = Table(table_data, colWidths=col_widths, repeatRows=1)

    row_styles = [
        ('BACKGROUND', (0, 0), (-1, 0), HexColor("#f0f2f5")),
        ('TEXTCOLOR', (0, 0), (-1, 0), TEXT_MID),
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (-1, 0), 8),
        ('BOTTOMPADDING', (0, 0), (-1, 0), 4*mm),
        ('TOPPADDING', (0, 0), (-1, 0), 3*mm),
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
        ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),
        ('LEFTPADDING', (0, 0), (-1, -1), 4*mm),
        ('RIGHTPADDING', (0, 0), (-1, -1), 4*mm),
        ('TOPPADDING', (0, 1), (-1, -1), 2.5*mm),
        ('BOTTOMPADDING', (0, 1), (-1, -1), 2.5*mm),
        ('LINEBELOW', (0, 0), (-1, 0), 0.5, BORDER_LIGHT),
        ('ROUNDEDCORNERS', [3, 3, 3, 3]),
        ('BOX', (0, 0), (-1, -1), 0.5, BORDER_LIGHT),
    ]

    # Alternating row colors
    for i in range(1, len(table_data)):
        if i % 2 == 0:
            row_styles.append(('BACKGROUND', (0, i), (-1, i), BG_ROW_ALT))
        else:
            row_styles.append(('BACKGROUND', (0, i), (-1, i), BG_ROW))

    t.setStyle(TableStyle(row_styles))
    return t


def make_three_col_table(data, col_widths=None):
    """Create a 3-column table."""
    if col_widths is None:
        col_widths = [45*mm, 50*mm, 65*mm]

    header = [
        Paragraph('<font face="Helvetica-Bold" size="8" color="#7a7e8a">SHORTCUT</font>', style_table_header),
        Paragraph('<font face="Helvetica-Bold" size="8" color="#7a7e8a">COMMAND</font>', style_table_header),
        Paragraph('<font face="Helvetica-Bold" size="8" color="#7a7e8a">DESCRIPTION</font>', style_table_header),
    ]

    table_data = [header]
    for row in data:
        table_data.append([make_key(row[0]), make_desc(row[1]), make_desc(row[2])])

    t = Table(table_data, colWidths=col_widths, repeatRows=1)

    row_styles = [
        ('BACKGROUND', (0, 0), (-1, 0), HexColor("#f0f2f5")),
        ('BOTTOMPADDING', (0, 0), (-1, 0), 4*mm),
        ('TOPPADDING', (0, 0), (-1, 0), 3*mm),
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
        ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),
        ('LEFTPADDING', (0, 0), (-1, -1), 4*mm),
        ('RIGHTPADDING', (0, 0), (-1, -1), 4*mm),
        ('TOPPADDING', (0, 1), (-1, -1), 2.5*mm),
        ('BOTTOMPADDING', (0, 1), (-1, -1), 2.5*mm),
        ('LINEBELOW', (0, 0), (-1, 0), 0.5, BORDER_LIGHT),
        ('BOX', (0, 0), (-1, -1), 0.5, BORDER_LIGHT),
    ]

    for i in range(1, len(table_data)):
        if i % 2 == 0:
            row_styles.append(('BACKGROUND', (0, i), (-1, i), BG_ROW_ALT))

    t.setStyle(TableStyle(row_styles))
    return t


def section_divider():
    return HRFlowable(width="100%", thickness=0.5, color=BORDER_LIGHT, spaceAfter=2*mm, spaceBefore=2*mm)


def add_page_number(canvas, doc):
    canvas.saveState()
    canvas.setFont('Helvetica', 8)
    canvas.setFillColor(TEXT_LIGHT)
    page_num = canvas.getPageNumber()
    canvas.drawCentredString(A4[0]/2, 12*mm, f"{page_num}")
    canvas.drawString(15*mm, 12*mm, "Neovim Reference Guide")
    canvas.drawRightString(A4[0] - 15*mm, 12*mm, "harsh@nvim")
    canvas.restoreState()


def build_pdf():
    output_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "neovim-reference-guide.pdf")

    doc = SimpleDocTemplate(
        output_path,
        pagesize=A4,
        leftMargin=18*mm,
        rightMargin=18*mm,
        topMargin=20*mm,
        bottomMargin=20*mm,
    )

    story = []

    # ══════════════════════════════════════════════════════════════════════════
    # COVER / TITLE
    # ══════════════════════════════════════════════════════════════════════════
    story.append(Spacer(1, 30*mm))
    story.append(Paragraph("Neovim", style_title))
    story.append(Paragraph("Reference Guide", ParagraphStyle(
        'TitleLine2', parent=style_title, fontSize=28, textColor=ACCENT_BLUE, spaceAfter=6*mm,
    )))
    story.append(Paragraph(
        "Complete keyboard shortcuts, LSP configuration, and plugin reference "
        "for your custom Neovim 0.12+ setup. Covers C, C++, Python, Go, "
        "JavaScript, and TypeScript.",
        style_subtitle
    ))
    story.append(section_divider())
    story.append(Spacer(1, 4*mm))

    cover_info = [
        ("Leader Key", "Space"),
        ("Plugin Manager", "vim.pack (built-in)"),
        ("Completion", "blink.cmp + Copilot"),
        ("Fuzzy Finder", "fzf-lua"),
        ("File Explorer", "neo-tree"),
        ("Formatter", "conform.nvim"),
        ("Linter", "nvim-lint"),
        ("Colorscheme", "default (Neovim 0.12)"),
    ]

    info_table_data = []
    for label, value in cover_info:
        info_table_data.append([
            Paragraph(f'<font face="Helvetica-Bold" size="9" color="#7a7e8a">{label}</font>', style_body),
            Paragraph(f'<font face="Helvetica" size="9" color="#1a1c24">{value}</font>', style_body),
        ])

    info_table = Table(info_table_data, colWidths=[45*mm, 115*mm])
    info_table.setStyle(TableStyle([
        ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),
        ('TOPPADDING', (0, 0), (-1, -1), 1.5*mm),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 1.5*mm),
        ('LEFTPADDING', (0, 0), (-1, -1), 0),
    ]))
    story.append(info_table)

    story.append(Spacer(1, 8*mm))
    story.append(Paragraph(
        "Prerequisites: Neovim 0.12+, tree-sitter-cli, Symbols Nerd Font Mono",
        style_note
    ))
    story.append(Paragraph(
        "Install on macOS:  brew install neovim tree-sitter-cli && "
        "brew install --cask font-symbols-only-nerd-font",
        style_code
    ))

    story.append(PageBreak())

    # ══════════════════════════════════════════════════════════════════════════
    # TABLE OF CONTENTS
    # ══════════════════════════════════════════════════════════════════════════
    story.append(Paragraph("Contents", style_section))
    story.append(Spacer(1, 2*mm))
    toc_items = [
        "1.  Essential Vim Motions",
        "2.  Window, Tab & Buffer Navigation",
        "3.  File Explorer (Neo-tree)",
        "4.  Fuzzy Finder (fzf-lua)",
        "5.  LSP: Code Intelligence",
        "6.  LSP: Adding New Languages",
        "7.  Diagnostics & Linting",
        "8.  Code Formatting",
        "9.  Completion (blink.cmp)",
        "10. Git Integration",
        "11. Treesitter",
        "12. Harpoon (File Bookmarks)",
        "13. Copilot (AI)",
        "14. Quickfix List",
        "15. Config File Structure",
    ]
    for item in toc_items:
        story.append(Paragraph(item, ParagraphStyle(
            'TOCItem', parent=style_body, fontSize=10, leading=16,
            leftIndent=4*mm, textColor=TEXT_DARK,
        )))

    story.append(PageBreak())

    # ══════════════════════════════════════════════════════════════════════════
    # 1. ESSENTIAL VIM MOTIONS
    # ══════════════════════════════════════════════════════════════════════════
    story.append(Paragraph("1. Essential Vim Motions", style_section))
    story.append(Paragraph(
        "Neovim has multiple modes. You start in Normal mode. Press <b>i</b> to enter Insert mode "
        "(typing text). Press <b>Esc</b> or <b>Ctrl+[</b> to return to Normal mode. "
        "Most shortcuts work in Normal mode.",
        style_body
    ))

    story.append(Paragraph("Cursor Movement", style_subsection))
    story.append(make_shortcut_table([
        ("h / j / k / l", "Move left / down / up / right (like arrow keys)"),
        ("w", "Jump forward to start of next word"),
        ("b", "Jump backward to start of previous word"),
        ("e", "Jump forward to end of current word"),
        ("0", "Jump to beginning of line"),
        ("$", "Jump to end of line"),
        ("gg", "Jump to first line of file"),
        ("G", "Jump to last line of file"),
        ("{number}G", "Jump to line {number}  (e.g. 42G goes to line 42)"),
        ("%", "Jump to matching bracket  ( ) [ ] { }"),
        ("Ctrl+o", "Jump back to previous location (after gd, search, etc.)"),
        ("Ctrl+i", "Jump forward (opposite of Ctrl+o)"),
    ]))

    story.append(Spacer(1, 3*mm))
    story.append(Paragraph("Editing", style_subsection))
    story.append(make_shortcut_table([
        ("i", "Enter Insert mode at cursor"),
        ("a", "Enter Insert mode after cursor"),
        ("A", "Enter Insert mode at end of line"),
        ("o", "Open new line below and enter Insert mode"),
        ("O", "Open new line above and enter Insert mode"),
        ("x", "Delete character under cursor (doesn't copy to clipboard)"),
        ("dd", "Delete (cut) entire line"),
        ("yy", "Yank (copy) entire line"),
        ("p", "Paste after cursor"),
        ("P", "Paste before cursor"),
        ("u", "Undo"),
        ("Ctrl+r", "Redo"),
        (".", "Repeat last change"),
        ("ciw", "Change inner word (delete word and enter Insert mode)"),
        ("diw", "Delete inner word"),
        ("ci\"", "Change inside quotes (works with ', (, [, { too)"),
        (">>  /  <<", "Indent / unindent line"),
    ]))

    story.append(Spacer(1, 3*mm))
    story.append(Paragraph("Search", style_subsection))
    story.append(make_shortcut_table([
        ("/{pattern}", "Search forward for {pattern}"),
        ("?{pattern}", "Search backward for {pattern}"),
        ("n", "Jump to next search match (centered on screen)"),
        ("N", "Jump to previous search match (centered on screen)"),
        ("*", "Search forward for word under cursor"),
        ("#", "Search backward for word under cursor"),
        (":noh", "Clear search highlighting"),
    ]))

    story.append(Spacer(1, 3*mm))
    story.append(Paragraph("Visual Mode (Selection)", style_subsection))
    story.append(make_shortcut_table([
        ("v", "Enter Visual mode (select characters)"),
        ("V", "Enter Visual Line mode (select whole lines)"),
        ("Ctrl+v", "Enter Visual Block mode (select a rectangle)"),
        ("< / >", "Indent / unindent selection (stays in Visual mode)"),
        ("y", "Yank (copy) selection"),
        ("d", "Delete selection"),
        ("p", "Paste over selection (keeps clipboard intact)"),
    ]))

    story.append(PageBreak())

    # ══════════════════════════════════════════════════════════════════════════
    # 2. WINDOW, TAB & BUFFER NAVIGATION
    # ══════════════════════════════════════════════════════════════════════════
    story.append(Paragraph("2. Window, Tab & Buffer Navigation", style_section))

    story.append(Paragraph("Window Splits", style_subsection))
    story.append(Paragraph(
        "Windows are viewports into buffers. You can split your screen to see multiple files.",
        style_body
    ))
    story.append(make_shortcut_table([
        (":split  or  :sp", "Split window horizontally (new window below)"),
        (":vsplit  or  :vs", "Split window vertically (new window right)"),
        ("Alt+h", "Move to the window on the LEFT"),
        ("Alt+j", "Move to the window BELOW"),
        ("Alt+k", "Move to the window ABOVE"),
        ("Alt+l", "Move to the window on the RIGHT"),
        ("Ctrl+w =", "Make all splits equal size"),
        ("Ctrl+w _", "Maximize current split height"),
        ("Ctrl+w |", "Maximize current split width"),
        (":close  or  :q", "Close current window"),
        (":only", "Close all other windows"),
    ]))
    story.append(Paragraph(
        "Note: On macOS, Alt is the Option key. Your terminal (Alacritty, Kitty, WezTerm, iTerm2) "
        "must be configured to send Option as Meta/Alt, not as a macOS special character.",
        style_note
    ))

    story.append(Spacer(1, 3*mm))
    story.append(Paragraph("Tabs", style_subsection))
    story.append(Paragraph(
        "Tabs are like workspaces. Each tab can have its own layout of window splits.",
        style_body
    ))
    story.append(make_shortcut_table([
        ("Shift+Tab", "Open current file in a new tab (full screen editing)"),
        ("Shift+h", "Go to previous tab"),
        ("Shift+l", "Go to next tab"),
        (":tabclose", "Close current tab"),
    ]))

    story.append(Spacer(1, 3*mm))
    story.append(Paragraph("Buffers", style_subsection))
    story.append(Paragraph(
        "A buffer is a file loaded into memory. You can have many buffers open but only "
        "see one per window.",
        style_body
    ))
    story.append(make_shortcut_table([
        ("Space fb", "List all open buffers (fuzzy search)"),
        ("Space bd", "Delete (close) the current buffer"),
        ("Alt+Tab", "Switch to the last buffer you were editing"),
    ]))

    story.append(Spacer(1, 3*mm))
    story.append(Paragraph("Scrolling", style_subsection))
    story.append(make_shortcut_table([
        ("Ctrl+j", "Scroll down half page (smooth animation)"),
        ("Ctrl+k", "Scroll up half page (smooth animation)"),
        ("Ctrl+d", "Scroll down half page (smooth animation)"),
        ("Ctrl+u", "Scroll up half page (smooth animation)"),
        ("Ctrl+f", "Scroll down full page"),
        ("Ctrl+b", "Scroll up full page"),
        ("zz", "Center screen on cursor"),
        ("zt", "Scroll so cursor is at top"),
        ("zb", "Scroll so cursor is at bottom"),
    ]))

    story.append(PageBreak())

    # ══════════════════════════════════════════════════════════════════════════
    # 3. FILE EXPLORER
    # ══════════════════════════════════════════════════════════════════════════
    story.append(Paragraph("3. File Explorer (Neo-tree)", style_section))
    story.append(Paragraph(
        "Neo-tree is the sidebar file tree, similar to VS Code's explorer panel.",
        style_body
    ))
    story.append(make_shortcut_table([
        ("Space e", "Toggle file explorer open / closed"),
        ("l  or  Enter", "Open file or expand folder"),
        ("h", "Collapse folder"),
        ("a", "Create new file (type name, use / for subdirectories)"),
        ("A", "Create new directory"),
        ("d", "Delete file or folder"),
        ("r", "Rename file or folder"),
        ("s", "Open in vertical split"),
        ("t", "Open in new tab"),
        ("y", "Copy file path to clipboard"),
        ("x", "Cut file"),
        ("c", "Copy file"),
        ("m", "Move file"),
        ("i", "Show file details (size, date)"),
        ("R", "Refresh the tree"),
        ("< / >", "Switch between Files / Buffers / Git views"),
        ("?", "Show all neo-tree keybindings"),
        ("q", "Close neo-tree"),
    ]))

    story.append(Spacer(1, 3*mm))
    story.append(Paragraph("Oil (Quick Parent Directory)", style_subsection))
    story.append(make_shortcut_table([
        ("-  (minus)", "Open parent directory as an editable buffer. "
                       "Rename files by editing text. Delete by removing lines. "
                       "Save (:w) to apply changes."),
    ]))

    story.append(PageBreak())

    # ══════════════════════════════════════════════════════════════════════════
    # 4. FUZZY FINDER
    # ══════════════════════════════════════════════════════════════════════════
    story.append(Paragraph("4. Fuzzy Finder (fzf-lua)", style_section))
    story.append(Paragraph(
        "fzf-lua lets you search files, text, git history, keymaps, and everything else. "
        "Type to filter, Ctrl+j/k to navigate, Enter to select.",
        style_body
    ))

    story.append(Paragraph("Inside any fzf-lua popup", style_subsection))
    story.append(make_shortcut_table([
        ("Type text", "Fuzzy filter results"),
        ("Ctrl+j / Ctrl+k", "Navigate down / up"),
        ("Enter", "Open selected item"),
        ("Ctrl+v", "Open in vertical split"),
        ("Ctrl+s", "Open in horizontal split"),
        ("Ctrl+t", "Open in new tab"),
        ("Tab", "Toggle selection (for multi-select)"),
        ("Esc", "Close the popup"),
    ]))

    story.append(Paragraph("File Shortcuts", style_subsection))
    story.append(make_shortcut_table([
        ("Space ff", "Find files by name in the project"),
        ("Space fr", "Recently opened files"),
        ("Space fb", "Open buffers"),
        ("Space fc", "Find files in your Neovim config"),
        ("Space fg", "Find git-tracked files"),
        ("Space fp", "Switch between recent projects"),
    ]))

    story.append(Paragraph("Text Search Shortcuts", style_subsection))
    story.append(make_shortcut_table([
        ("Space ft", "Live grep (search text across all files, updates as you type)"),
        ("Space fw", "Grep word under cursor across project"),
        ("Space fw (visual)", "Grep selected text across project"),
        ("Space fl", "Search lines in current buffer"),
        ("Space fL", "Search lines in all open buffers"),
    ]))

    story.append(Paragraph("Git Shortcuts", style_subsection))
    story.append(make_shortcut_table([
        ("Space gs", "Git status (changed files)"),
        ("Space gb", "Git branches"),
        ("Space gl", "Git log (commit history)"),
        ("Space gf", "Git log for current file only"),
        ("Space gS", "Git stash list"),
    ]))

    story.append(Paragraph("Utility Shortcuts", style_subsection))
    story.append(make_shortcut_table([
        ("Space fh", "Search Neovim help pages"),
        ("Space fk", "Search all keymaps"),
        ("Space fR", "Resume last fzf search"),
        ("Space :", "Command history"),
        ("Space fq", "Quickfix list"),
        ("Space fd", "Buffer diagnostics"),
        ("Space fD", "Workspace diagnostics"),
    ]))

    story.append(PageBreak())

    # ══════════════════════════════════════════════════════════════════════════
    # 5. LSP: CODE INTELLIGENCE
    # ══════════════════════════════════════════════════════════════════════════
    story.append(Paragraph("5. LSP: Code Intelligence", style_section))
    story.append(Paragraph(
        "LSP (Language Server Protocol) gives you IDE features: go-to-definition, "
        "find references, hover docs, rename, code actions, and diagnostics. "
        "These shortcuts only work in files where an LSP server is active.",
        style_body
    ))

    story.append(Paragraph("Navigation", style_subsection))
    story.append(make_shortcut_table([
        ("gd", "Go to definition (jump to where the function/class is defined). "
               "Opens fzf if multiple definitions. Use Ctrl+o to jump back."),
        ("gD", "Go to declaration (the prototype / interface, often same as definition)"),
        ("gr", "Show all references (everywhere this symbol is used). "
               "Opens fzf list. Navigate with j/k, Enter to jump."),
        ("gi", "Show implementations (for interfaces / abstract classes)"),
        ("gt", "Go to type definition (jump to the type of the variable)"),
        ("K", "Hover documentation. Press K on any symbol to see its docs. "
              "Press K again or move cursor to DISMISS the popup. "
              "Scroll inside popup with Ctrl+d / Ctrl+u."),
    ]))

    story.append(Paragraph("Actions", style_subsection))
    story.append(make_shortcut_table([
        ("Space ca", "Code actions (auto-fix imports, extract function, etc.). "
                     "Select an action from the popup menu with Enter."),
        ("Space lr", "Smart rename (rename a symbol everywhere it's used). "
                     "Type the new name, press Enter. Way better than find-replace."),
        ("Space lf", "Format file (or format selection in Visual mode). "
                     "Uses conform.nvim with your configured formatter."),
    ]))

    story.append(Paragraph("Dismissing Popups & Floating Windows", style_subsection))
    story.append(Paragraph(
        "This is important to know since popups can feel \"stuck\" if you don't know how to close them:",
        style_body
    ))
    story.append(make_shortcut_table([
        ("Esc", "Close most floating windows and popups"),
        ("q", "Close special buffers (help, quickfix, lspinfo, etc.)"),
        ("Move cursor", "Dismiss hover documentation (K popup)"),
        ("K again", "Also dismisses the hover popup"),
        ("Ctrl+w w", "Switch focus to/from a floating window"),
        (":close", "Close any focused window"),
    ]))

    story.append(Spacer(1, 3*mm))
    story.append(Paragraph("Commenting", style_subsection))
    story.append(make_shortcut_table([
        ("Space /", "Toggle comment on current line (Normal mode)"),
        ("Space /", "Toggle comment on selection (Visual mode)"),
        ("gcc", "Toggle comment on current line (built-in)"),
        ("gc", "Toggle comment on selection (built-in)"),
    ]))

    story.append(PageBreak())

    # ══════════════════════════════════════════════════════════════════════════
    # 6. LSP: ADDING NEW LANGUAGES
    # ══════════════════════════════════════════════════════════════════════════
    story.append(Paragraph("6. LSP: Adding New Languages", style_section))
    story.append(Paragraph(
        "Your config supports C, C++, Python, Go, JavaScript, TypeScript, Lua, Rust, and more "
        "out of the box. Here's how to add a new language:",
        style_body
    ))

    story.append(Paragraph("Step-by-step: Add a new LSP server", style_subsection))

    steps = [
        ("Step 1: Find the server", 'Run <b>:Mason</b> and search for your language, '
         'or check the LSP configs list at github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md'),
        ("Step 2: Install via Mason", 'Add the server name to <b>lua/plugins/mason.lua</b> '
         'in the ensure_installed list. Or install manually: <b>:MasonInstall server_name</b>'),
        ("Step 3: Enable the server", 'Add the server name to <b>vim.lsp.enable()</b> '
         'in <b>lua/config/lsp.lua</b>'),
        ("Step 4: Custom config (optional)", 'Create <b>lsp/server_name.lua</b> to customize '
         'the server. See lsp/clangd.lua for an example. '
         'Return a table with: cmd, filetypes, root_markers, settings.'),
        ("Step 5: Restart Neovim", 'Mason auto-installs the server. Open a file of that '
         'language and LSP features will work.'),
    ]

    for title, desc in steps:
        story.append(Paragraph(f'<b>{title}</b>', ParagraphStyle(
            'StepTitle', parent=style_body, fontName='Helvetica-Bold',
            spaceBefore=2*mm, spaceAfter=1*mm,
        )))
        story.append(Paragraph(desc, ParagraphStyle(
            'StepBody', parent=style_body, leftIndent=6*mm, spaceAfter=2*mm,
        )))

    story.append(Spacer(1, 3*mm))
    story.append(Paragraph("Active LSP Servers", style_subsection))

    server_data = [
        ("clangd", "C, C++, Objective-C", "LLVM clangd"),
        ("basedpyright", "Python", "Type checker + intellisense"),
        ("gopls", "Go", "Official Go server"),
        ("ts_ls", "JS, TS, JSX, TSX", "TypeScript server"),
        ("lua_ls", "Lua", "For editing Neovim configs"),
        ("rust_analyzer", "Rust", "Rust server"),
        ("eslint", "JS, TS", "Linting via LSP"),
        ("tailwindcss", "CSS/HTML/JSX", "Tailwind class completion"),
        ("html", "HTML", "HTML server"),
        ("cssls", "CSS", "CSS server"),
        ("bashls", "Bash/Shell", "Bash server"),
        ("gopls", "Go", "Go server"),
        ("jsonls", "JSON", "JSON with schemas"),
        ("yamlls", "YAML", "YAML server"),
    ]

    story.append(make_three_col_table(server_data, col_widths=[40*mm, 45*mm, 75*mm]))

    story.append(Spacer(1, 4*mm))
    story.append(Paragraph("Adding a formatter for a new language", style_subsection))
    story.append(Paragraph(
        "1. Install the formatter via Mason (:Mason, search, press i to install)<br/>"
        "2. Add it to ensure_installed in <b>lua/plugins/mason.lua</b><br/>"
        "3. Add a mapping in <b>lua/plugins/conform.lua</b>:<br/>"
        '&nbsp;&nbsp;&nbsp;&nbsp;<font face="Courier" size="9">your_filetype = { "formatter_name" },</font><br/>'
        "4. Restart Neovim. Now Space lf formats using your new formatter.",
        style_body
    ))

    story.append(Spacer(1, 3*mm))
    story.append(Paragraph("Adding a linter for a new language", style_subsection))
    story.append(Paragraph(
        "1. Install the linter via Mason<br/>"
        "2. Add it to ensure_installed in <b>lua/plugins/mason.lua</b><br/>"
        "3. Add a mapping in <b>lua/plugins/nvim-lint.lua</b>:<br/>"
        '&nbsp;&nbsp;&nbsp;&nbsp;<font face="Courier" size="9">your_filetype = { "linter_name" },</font><br/>'
        "4. Restart Neovim. Linting runs automatically on save.",
        style_body
    ))

    story.append(PageBreak())

    # ══════════════════════════════════════════════════════════════════════════
    # 7. DIAGNOSTICS & LINTING
    # ══════════════════════════════════════════════════════════════════════════
    story.append(Paragraph("7. Diagnostics & Linting", style_section))
    story.append(Paragraph(
        "Diagnostics are errors, warnings, and hints from LSP servers and linters. "
        "They appear as icons in the left gutter and can be viewed in floating popups.",
        style_body
    ))

    story.append(make_shortcut_table([
        ("gl", "Show diagnostic for current line (floating popup). "
               "Press Esc or move cursor to dismiss."),
        ("Space dj", "Jump to next diagnostic (error/warning)"),
        ("Space dk", "Jump to previous diagnostic"),
        ("Space D", "Show all diagnostics in current buffer (via fzf)"),
        ("Space fd", "Same as Space D (buffer diagnostics via fzf)"),
        ("Space fD", "Show diagnostics across entire workspace"),
        ("Space ll", "Manually trigger linting for current file"),
    ]))

    story.append(Spacer(1, 3*mm))
    story.append(Paragraph("Gutter Signs", style_subsection))
    story.append(Paragraph(
        "The left gutter shows icons for diagnostics:<br/>"
        "&nbsp;&nbsp;Error icon (red) = compilation error, type error, etc.<br/>"
        "&nbsp;&nbsp;Warning icon (yellow) = potential issue, unused variable, etc.<br/>"
        "&nbsp;&nbsp;Hint icon (blue) = suggestion for improvement<br/>"
        "&nbsp;&nbsp;Info icon (cyan) = informational message",
        style_body
    ))

    story.append(Spacer(1, 3*mm))
    story.append(Paragraph("Active Linters (nvim-lint)", style_subsection))
    story.append(make_shortcut_table([
        ("C / C++", "cpplint (Google C++ style checker)"),
        ("Python", "pylint (style + bug checker)"),
        ("Shell", "shellcheck (bash/zsh analyzer)"),
    ], col_widths=[45*mm, 115*mm]))
    story.append(Paragraph(
        "Note: Many languages get linting from their LSP server directly "
        "(eslint for JS/TS, basedpyright for Python types, clangd for C/C++ errors). "
        "nvim-lint adds additional standalone linters on top of LSP.",
        style_note
    ))

    story.append(PageBreak())

    # ══════════════════════════════════════════════════════════════════════════
    # 8. CODE FORMATTING
    # ══════════════════════════════════════════════════════════════════════════
    story.append(Paragraph("8. Code Formatting", style_section))
    story.append(Paragraph(
        "conform.nvim runs formatters to auto-style your code. "
        "Press <b>Space lf</b> to format the current file (or selection in Visual mode).",
        style_body
    ))

    story.append(Paragraph("Active Formatters", style_subsection))
    story.append(make_three_col_table([
        ("Space lf", "clang-format", "C, C++, Objective-C"),
        ("Space lf", "black + isort", "Python (isort sorts imports first)"),
        ("Space lf", "gofumpt + goimports", "Go (strict format + imports)"),
        ("Space lf", "prettier", "JS, TS, CSS, HTML, JSON, YAML, MD"),
        ("Space lf", "stylua", "Lua"),
        ("Space lf", "rustfmt", "Rust"),
        ("Space lf", "shfmt", "Shell scripts (2-space indent)"),
    ], col_widths=[30*mm, 50*mm, 80*mm]))

    # ══════════════════════════════════════════════════════════════════════════
    # 9. COMPLETION
    # ══════════════════════════════════════════════════════════════════════════
    story.append(Paragraph("9. Completion (blink.cmp)", style_section))
    story.append(Paragraph(
        "The completion menu appears automatically as you type. "
        "Suggestions come from the LSP server, Copilot AI, and file paths.",
        style_body
    ))

    story.append(make_shortcut_table([
        ("Ctrl+j", "Move DOWN in completion menu"),
        ("Ctrl+k", "Move UP in completion menu"),
        ("Enter", "Accept the selected completion"),
        ("Ctrl+Space", "Manually trigger completion"),
        ("Esc", "Dismiss the completion menu"),
        ("Tab", "Accept Copilot ghost text suggestion (in Insert mode)"),
    ]))

    story.append(Paragraph(
        "Completion sources (in priority order): Copilot AI (highest), "
        "LSP server completions, file path completions.",
        style_note
    ))

    story.append(PageBreak())

    # ══════════════════════════════════════════════════════════════════════════
    # 10. GIT
    # ══════════════════════════════════════════════════════════════════════════
    story.append(Paragraph("10. Git Integration", style_section))
    story.append(Paragraph(
        "gitsigns.nvim shows git diff indicators in the left gutter. "
        "The statusline shows the current branch and diff stats.",
        style_body
    ))

    story.append(Paragraph("Gutter Signs", style_subsection))
    story.append(Paragraph(
        "Green bar = added lines&nbsp;&nbsp;&nbsp;"
        "Yellow bar = changed lines&nbsp;&nbsp;&nbsp;"
        "Red triangle = deleted lines",
        style_body
    ))

    story.append(Paragraph("Git Shortcuts (via fzf-lua)", style_subsection))
    story.append(make_shortcut_table([
        ("Space gs", "Git status (changed files)"),
        ("Space gb", "Browse and switch git branches"),
        ("Space gl", "Git log (commit history)"),
        ("Space gf", "Git log for current file"),
        ("Space gS", "Git stash list"),
    ]))

    # ══════════════════════════════════════════════════════════════════════════
    # 11. TREESITTER
    # ══════════════════════════════════════════════════════════════════════════
    story.append(Paragraph("11. Treesitter", style_section))
    story.append(Paragraph(
        "Treesitter provides accurate syntax highlighting by parsing code into a tree. "
        "It needs a parser for each language.",
        style_body
    ))

    story.append(make_shortcut_table([
        (":TSInstall {lang}", "Install a parser (e.g. :TSInstall c cpp python go)"),
        (":TSInstall all", "Install parsers for all supported languages"),
        (":TSUpdate", "Update all installed parsers"),
        (":InspectTree", "Show the syntax tree for current file (for debugging)"),
    ]))

    story.append(Paragraph(
        "Common parsers to install:  c, cpp, python, go, lua, javascript, typescript, tsx, "
        "json, yaml, html, css, bash, markdown, rust, toml, dockerfile",
        style_note
    ))

    # ══════════════════════════════════════════════════════════════════════════
    # 12. HARPOON
    # ══════════════════════════════════════════════════════════════════════════
    story.append(Paragraph("12. Harpoon (File Bookmarks)", style_section))
    story.append(Paragraph(
        "Harpoon lets you bookmark files for instant switching. "
        "Much faster than fuzzy-finding for files you work on constantly.",
        style_body
    ))
    story.append(make_shortcut_table([
        ("m", "Mark/bookmark the current file"),
        ("Shift+M", "Open harpoon menu (j/k to navigate, Enter to open, dd to remove)"),
    ]))

    story.append(PageBreak())

    # ══════════════════════════════════════════════════════════════════════════
    # 13. COPILOT
    # ══════════════════════════════════════════════════════════════════════════
    story.append(Paragraph("13. Copilot (AI Code Suggestions)", style_section))
    story.append(Paragraph(
        "GitHub Copilot shows AI-generated code as ghost text as you type. "
        "Requires a Copilot subscription. Run <b>:Copilot auth</b> to sign in.",
        style_body
    ))
    story.append(make_shortcut_table([
        ("Tab", "Accept Copilot suggestion (in Insert mode)"),
        ("Ctrl+h", "Dismiss Copilot suggestion"),
        ("Ctrl+s", "Toggle auto-suggestions on/off (Normal mode)"),
        ("Alt+Enter", "Open Copilot panel (multiple suggestions)"),
    ]))

    # ══════════════════════════════════════════════════════════════════════════
    # 14. QUICKFIX
    # ══════════════════════════════════════════════════════════════════════════
    story.append(Paragraph("14. Quickfix List", style_section))
    story.append(Paragraph(
        "The quickfix list holds a list of locations (search results, diagnostics, etc.). "
        "Enhanced by bqf plugin with preview.",
        style_body
    ))
    story.append(make_shortcut_table([
        ("Space qq", "Toggle quickfix list open/closed"),
        ("Space qc", "Clear quickfix list and close it"),
        ("Space fq", "Browse quickfix list with fzf"),
        ("Inside QF: o", "Open file at cursor"),
        ("Inside QF: t", "Open in new tab"),
        ("Inside QF: s", "Open in split"),
        ("Inside QF: v", "Open in vertical split"),
        ("Inside QF: p", "Toggle preview"),
        ("Inside QF: q", "Close quickfix"),
    ]))

    story.append(PageBreak())

    # ══════════════════════════════════════════════════════════════════════════
    # 15. CONFIG FILE STRUCTURE
    # ══════════════════════════════════════════════════════════════════════════
    story.append(Paragraph("15. Config File Structure", style_section))
    story.append(Paragraph(
        "Your Neovim config lives at <b>~/.config/nvim/</b> (symlink your nvim-new folder there). "
        "Here's what each file does:",
        style_body
    ))

    structure = [
        ("init.lua", "Entry point", "Loads all modules in order"),
        ("lua/config/options.lua", "Editor settings", "Tabs, search, clipboard, UI"),
        ("lua/config/keymaps.lua", "Key bindings", "Leader key, window nav, etc."),
        ("lua/config/autocommands.lua", "Auto behaviors", "Trim whitespace, restore cursor"),
        ("lua/config/pack.lua", "Plugin manager", "All plugins listed here"),
        ("lua/config/colorscheme.lua", "Theme", "Colorscheme + highlight tweaks"),
        ("lua/config/statusline.lua", "Status bar", "Bottom bar with mode, git, diagnostics"),
        ("lua/config/lsp.lua", "LSP config", "Server list, diagnostics, keybinds"),
        ("lua/config/icons.lua", "Icon defs", "Shared icons for completion + breadcrumbs"),
        ("lua/plugins/*.lua", "Plugin configs", "One file per plugin, auto-loaded"),
        ("lsp/*.lua", "LSP server configs", "Per-server settings (auto-loaded by Neovim)"),
        ("ftplugin/*.lua", "Filetype settings", "Per-language overrides (auto-loaded)"),
    ]

    story.append(make_three_col_table(structure, col_widths=[52*mm, 35*mm, 73*mm]))

    story.append(Spacer(1, 6*mm))
    story.append(Paragraph("Using this config", style_subsection))
    story.append(Paragraph(
        "To use this config, symlink the nvim-new folder to your Neovim config path:",
        style_body
    ))
    story.append(Paragraph(
        "ln -sf ~/personal/nvim/nvim-new ~/.config/nvim",
        style_code
    ))
    story.append(Paragraph(
        "Or if you use fish shell, set NVIM_APPNAME to test without replacing your current config:",
        style_body
    ))
    story.append(Paragraph(
        "set -x NVIM_APPNAME nvim-new\n"
        "ln -sf ~/personal/nvim/nvim-new ~/.config/nvim-new\n"
        "nvim  # uses ~/.config/nvim-new/ instead of ~/.config/nvim/",
        style_code
    ))

    story.append(Spacer(1, 6*mm))
    story.append(Paragraph("Useful Commands", style_subsection))
    story.append(make_shortcut_table([
        (":Mason", "Open the tool installer UI (install/update LSP servers, formatters)"),
        (":checkhealth", "Diagnose issues with your Neovim setup"),
        (":Lazy", "Not applicable (we use vim.pack, not lazy.nvim)"),
        (":PackUpdate", "Update all installed plugins"),
        (":TSInstall {lang}", "Install a treesitter parser"),
        (":LspInfo", "Show active LSP servers for current buffer"),
        (":LspLog", "View LSP server logs (for debugging)"),
        (":Copilot auth", "Sign in to GitHub Copilot"),
        (":messages", "View recent Neovim messages/errors"),
    ]))

    story.append(Spacer(1, 10*mm))
    story.append(section_divider())
    story.append(Paragraph(
        "Generated for Harsh's Neovim config. "
        "Neovim 0.12+ | macOS | fish shell",
        style_footer
    ))

    # Build the PDF
    doc.build(story, onFirstPage=add_page_number, onLaterPages=add_page_number)
    print(f"PDF generated: {output_path}")


if __name__ == "__main__":
    build_pdf()
