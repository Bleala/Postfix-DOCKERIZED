---

### 📝 PR Title Convention
**Please provide a Pull Request title in the format of [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).**

* `feat:` Adds a new feature (triggers a `minor` release)
* `fix:` Patches a bug (triggers a `patch` release)
* `docs:` Changes to documentation (no release)
* `chore:` Build process or auxiliary tool changes (no release)
* `perf:` A code change that improves performance (triggers a `patch` release)
* For a **Breaking Change**, add a `!` after the type (e.g., `feat!: ...`) or add a `BREAKING CHANGE:` footer to the description (triggers a `major` release).

---

### 🔗 Related Issue

Closes: #

### 🎯 Description

### ✅ How Has This Been Tested?

**Testing Checklist:**
- [ ] The Docker image builds successfully locally (`docker build .`).
- [ ] The container starts without errors with the new configuration.
- [ ] I have manually verified the changed functionality (e.g., successfully sent a test email).
- [ ] My changes were tested on the following system: `[Please enter your OS and Docker version here]`

### ☑️ Final Checklist

- [ ] My code follows the style guidelines of this project.
- [ ] I have performed a self-review of my own code.
- [ ] My commits have clear and conventional messages.
- [ ] My change requires a change to the documentation, and I have updated the documentation accordingly.
- [ ] My change adds new configuration variables, and I have updated the `.env.example` file accordingly.

---

Thank you for your time and effort in helping to improve this project!