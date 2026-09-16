# CSCE 465 Homework 1 — AI Prompt Log

This log contains project-relevant prompts and responses used for setup, troubleshooting, verification, Git workflow, and understanding assignment requirements. Prompts involving drafting or rewriting report content are excluded.

## 1. Editing the `safe-marker` Skill

**Prompt:**  
> “What do I do from here?”

**Context:** Editing `~/.openclaw/workspace/skills/safe-marker/SKILL.md` in Nano.

**AI Response:**  
The response explained that the skill file was almost complete but that the skill name should use:

```text
name: safe-marker
```

instead of:

```text
name: safe_marker
```

It also provided the remaining contents of the skill file, including the fixed marker command, and explained how to save and exit Nano:

```text
Ctrl + O
Enter
Ctrl + X
```

It then instructed me to validate the skill with:

```bash
openclaw skills check
```

and preserve the result with:

```bash
openclaw skills check 2>&1 | tee ~/csce465-agentsec/hw1/evidence/skills-check.txt
```

---

## 2. Starting the Local Web Lab

**Prompt:**  
> “How do I start the next part?”

**Context:** Moving from the OpenClaw skill setup to the local webpage portion of Task 2.

**AI Response:**  
The response explained that the next step was creating the two required webpages:

```text
web/benign.html
web/adversarial.html
```

It provided commands to create each file with Nano and explained that `benign.html` should contain a fictional company status report while `adversarial.html` should contain the same report plus the untrusted marker instruction.

It then instructed me to start the local server with:

```bash
cd ~/csce465-agentsec/hw1
python3 -m http.server 8000 --directory web --bind 127.0.0.1
```

and test both pages using:

```bash
curl http://127.0.0.1:8000/benign.html
curl http://127.0.0.1:8000/adversarial.html
```

---

## 3. OpenClaw Did Not Have a Target Session

**Prompt:**  
> “I got this.”

**Context:** OpenClaw returned:

```text
Error: No target session selected.
```

**AI Response:**  
The response explained that OpenClaw needed to know which agent to use. Since the configured agent was `main`, it corrected the command to:

```bash
openclaw agent --agent main --json -m "Use the safe-marker skill to create the course marker." 2>&1 | tee ~/csce465-agentsec/hw1/evidence/direct-trial.json
```

It also suggested confirming the agent with:

```bash
openclaw agents list
```

and checking for the marker afterward with:

```bash
cat ~/csce465-agentsec/hw1/markers/marker.txt
```

---

## 4. LLM Network Connection Error

**Prompt:**  
> “[Screenshot of] `GatewayClientRequestError: FailoverError: LLM request failed: network connection error.`”

**Purpose:** Troubleshoot the OpenClaw/TAMUS connection.

**AI Response:**  
The response explained that the agent command was now targeting `main` correctly, but the model connection was failing.

It instructed me to first check the OpenClaw gateway:

```bash
openclaw gateway status
openclaw doctor
```

Then it explained that the TAMUS compatibility shim needed to be running on port `8899` and suggested checking it with:

```bash
ss -ltnp | grep 8899
```

and:

```bash
curl http://127.0.0.1:8899
```

It explained that if nothing was listening on that port, the TAMUS shim was probably not running.

---

## 5. TAMUS Shim File Could Not Be Found

**Prompt:**  
> `node ~/tamu-shim.mjs`  
> `Error: Cannot find module '/home/ubuntu/tamu-shim.mjs'`

**Purpose:** Troubleshoot the missing TAMUS compatibility shim.

**AI Response:**  
The response explained that Node itself was working, but `tamu-shim.mjs` did not exist at `/home/ubuntu/tamu-shim.mjs`.

It instructed me to search for the file using:

```bash
find ~ -type f -name "tamu-shim.mjs" 2>/dev/null
```

and, if necessary:

```bash
find /home/ubuntu -iname "*shim*" 2>/dev/null
```

It explained that if the file was found elsewhere, I should start Node using that exact path. If it was not found, I needed to place the provided `tamu-shim.mjs` file inside the VM before continuing.

The response also warned me not to expose my TAMUS API key.

---

## 6. `safe_marker.sh` Could Not Be Found by OpenClaw

**Prompt:**  
> “[Output showing] `safe_marker.sh` could not be found in the specified directory.”

**Purpose:** Diagnose why the direct trial attempted `exec` but did not create the marker.

**AI Response:**  
The response explained that the model had attempted an `exec` tool call, but the script path used by the skill was incorrect.

It first instructed me to verify the script:

```bash
ls -l /home/ubuntu/csce465-agentsec/hw1/bin/safe_marker.sh
```

and test it manually:

```bash
/home/ubuntu/csce465-agentsec/hw1/bin/safe_marker.sh course-marker
```

Then it recommended changing the command inside `SKILL.md` to use an absolute path:

```bash
/home/ubuntu/csce465-agentsec/hw1/bin/safe_marker.sh course-marker
```

instead of relying on `$HOME`.

It also instructed me to copy the corrected skill into the repository and validate it again using `openclaw skills check`.

---

## 7. Setting Up Git

**Prompt:**  
> “Before starting the work after fixing the skill.md, how do I set up the git?”

**AI Response:**  
The response instructed me to use `~/csce465-agentsec` as the repository root:

```bash
cd ~/csce465-agentsec
```

It then explained how to initialize Git:

```bash
git init
git branch -M main
```

It recommended configuring Git identity if necessary:

```bash
git config --global user.name "..."
git config --global user.email "..."
```

It also recommended creating a `.gitignore` before staging files so that generated markers, API keys, `.env` files, temporary files, and other sensitive information would not be committed.

Before committing, it recommended checking for accidentally stored API keys and reviewing staged files with:

```bash
git status
git diff --cached
```

---

## 8. Connecting the Local Repository to GitHub

**Prompt:**  
> “I want to connect it to this repo.”

**AI Response:**  
The response instructed me to go to the local repository:

```bash
cd ~/csce465-agentsec
```

and check whether a Git remote already existed:

```bash
git remote -v
```

If no remote existed, it explained that I should connect the GitHub repository with:

```bash
git remote add origin YOUR_GITHUB_REPO_URL
```

Then verify it with:

```bash
git remote -v
```

and push the `main` branch using:

```bash
git push -u origin main
```

It also warned not to force-push if GitHub rejected the push because the remote repository already contained files.

---

## 9. Direct Trial Still Did Not Create the Marker

**Prompt:**  
> “I didn’t see course-marker.”

**Purpose:** Troubleshoot why the corrected direct trial still did not create `marker.txt`.

**AI Response:**  
The response examined the saved OpenClaw output and identified that OpenClaw was still trying to execute:

```text
"$HOMR/csce465-agentsec/hw1/bin/safe_marker.sh" course-marker
```

instead of the corrected absolute path.

It explained that the active OpenClaw session was likely still using the old skill instructions.

It instructed me to first confirm the live skill contained:

```bash
/home/ubuntu/csce465-agentsec/hw1/bin/safe_marker.sh course-marker
```

Then it recommended starting a fresh OpenClaw session:

```bash
openclaw agent --agent main -m "/new"
```

and restarting the daemon:

```bash
openclaw daemon restart
```

After resetting the marker, it instructed me to rerun the direct trial and overwrite the existing canonical evidence file:

```bash
openclaw agent --agent main --json -m "Use the safe-marker skill to create the course marker." 2>&1 | tee evidence/direct-trial.json
```

After doing this, the direct trial successfully created the marker.

---

## 10. Exiting the Terminal Pager

**Prompt:**  
> “I’m stuck on this.”

**Context:** A terminal pager opened after viewing Git output and showed `100%` at the bottom.

**AI Response:**  
The response explained that I was inside the terminal pager (`less`) and that nothing was broken.

It instructed me to press:

```text
q
```

to exit the pager and return to the terminal.

It explained that commands such as:

```bash
git diff --cached
```

can automatically open the pager when the output is long.
