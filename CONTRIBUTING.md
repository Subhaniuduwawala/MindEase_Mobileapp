# Contributing to MindEase

## Development Workflow for Team Members

### Initial Setup
```bash
# Clone the repository
git clone https://github.com/Subhaniuduwawala/MindEase_Mobileapp.git
cd MindEase_Mobileapp

# Install dependencies
flutter pub get

# Run the app
flutter run -d chrome  # or -d windows
```

### Before Starting Work
```bash
# Always pull latest changes first
git pull origin main

# Create a new branch for your feature
git checkout -b feature/your-feature-name
# or
git checkout -b fix/bug-description
```

### While Working
```bash
# Check what files you've changed
git status

# Stage your changes
git add .

# Commit with a clear message
git commit -m "Add: description of what you added"
# or
git commit -m "Fix: description of what you fixed"
```

### Committing Your Work
```bash
# Push your branch to GitHub
git push origin feature/your-feature-name

# Then create a Pull Request on GitHub for review
```

### Branch Naming Convention
- `feature/` - for new features (e.g., `feature/meditation-timer`)
- `fix/` - for bug fixes (e.g., `fix/login-validation`)
- `update/` - for updates to existing features (e.g., `update/dashboard-ui`)

### Commit Message Guidelines
- **Add:** When adding new features
- **Fix:** When fixing bugs
- **Update:** When updating existing features
- **Refactor:** When improving code structure
- **Docs:** When updating documentation

### Resolving Conflicts
If you get conflicts when pulling:
```bash
# Pull latest changes
git pull origin main

# Fix conflicts in your code editor
# Look for markers like <<<<<<< HEAD

# After fixing, add and commit
git add .
git commit -m "Resolve merge conflicts"
```

### Code Review Process
1. Push your branch to GitHub
2. Create a Pull Request
3. Wait for team member to review
4. Make requested changes if any
5. Once approved, merge to main

### Testing Before Push
```bash
# Run tests
flutter test

# Check for errors
flutter analyze

# Format code
flutter format .
```

## Communication
- Communicate with your team member before working on major features
- Use GitHub Issues to track bugs and feature requests
- Use GitHub Projects to organize tasks

## Need Help?
- Check Flutter documentation: https://flutter.dev/docs
- Review existing code for examples
- Ask your team member for guidance
