## The Vim Grammar Formula

Every command you type in Normal mode follows this exact sentence structure:
**Verb (Action) + Modifier (Boundary) + Noun (Object/Motion)**

---

### 1. Verbs (The Operators)
*What do you want to do?*

| Key | Action | Description |
| :--- | :--- | :--- |
| **`d`** | Delete | Cuts the text (saves it to your clipboard/register). |
| **`c`** | Change | Deletes the text AND puts you in Insert mode. |
| **`y`** | Yank | Copies the text. |
| **`v`** | Visual | Highlights the text so you can see it before acting. |
| **`>`** | Indent | Pushes the code block to the right. |
| **`<`** | Dedent | Pushes the code block to the left. |

---

### 2. Modifiers (The Boundaries)
*How much of the object do you want?*

| Key | Modifier | Description |
| :--- | :--- | :--- |
| **`i`** | Inside | Targets the core content, ignoring surrounding whitespace or brackets. |
| **`a`** | Around | Targets the content PLUS its surrounding whitespace or brackets. |
| **`t`** | Till | (Used with search) Stops right *before* a specific character. |
| **`f`** | Find | (Used with search) Lands exactly *on* a specific character. |

---

### 3. Nouns (Text Objects)
*What are you targeting?*

| Key | Object | Source |
| :--- | :--- | :--- |
| **`w`** | Word | Native Vim |
| **`p`** | Paragraph | Native Vim |
| **`s`** | Sentence | Native Vim |
| **`"`** / **`'`** | Quotes | Native Vim |
| **`(`** / **`{`** / **`[`** | Brackets/Braces | Native Vim |
| **`t`** | XML/HTML Tag | Native Vim |
| **`f`** | Function | `mini.ai` (via Tree-sitter) |
| **`c`** | Class | `mini.ai` (via Tree-sitter) |
| **`o`** | Block (Loops, Ifs) | `mini.ai` (via Tree-sitter) |
| **`B`** | Buffer (Entire file) | `mini.ai` |

---

### 4. Nouns (Motions)
*Instead of an object, you can target a direction.*

| Key | Motion | Description |
| :--- | :--- | :--- |
| **`j`** / **`k`** | Down / Up | Acts on the current line and the one below/above. |
| **`w`** / **`b`** | Next / Prev Word | Acts from the cursor to the start of the next/prev word. |
| **`$`** / **`^`** | End / Start of line | Acts from the cursor to the end/start of the line. |
| **`G`** | End of file | Acts from the cursor to the absolute bottom of the file. |

---

## Practical Examples: Speaking the Language

Read these out loud as you type them. It wires your brain to think in text objects rather than individual keystrokes.

### Editing Code Blocks
| Command | Translation | Result |
| :--- | :--- | :--- |
| **`c i w`** | Change Inside Word | Deletes the word under your cursor and drops you in Insert mode. |
| **`d i (`** | Delete Inside Parentheses | Empties the arguments of a function call: `func(arg1, arg2)` becomes `func()`. |
| **`y a {`** | Yank Around Braces | Copies an entire code block, including the curly braces. |
| **`c i "`** | Change Inside Quotes | Replaces the string inside `"hello world"`. |
| **`v a t`** | Visual Around Tag | Highlights an entire `<div>...</div>` block in HTML. |

### Using Your `mini.ai` Superpowers
| Command | Translation | Result |
| :--- | :--- | :--- |
| **`v i f`** | Visual Inside Function | Highlights the body of the function, leaving the definition line untouched. |
| **`d a c`** | Delete Around Class | Deletes an entire class from the file. |
| **`> i o`** | Indent Inside Block | Indents the contents of an `if` statement or `for` loop. |
| **`y a B`** | Yank Around Buffer | Copies the entire file to your clipboard. |

### The "Double Tap" Shortcut
When you double-tap a Verb, it automatically applies that action to the **current line**.

| Command | Result |
| :--- | :--- |
| **`dd`** | Deletes the entire current line. |
| **`cc`** | Clears the current line and puts you in Insert mode. |
| **`yy`** | Copies the current line. |
| **`>>`** | Indents the current line. |
