# Contributing to Photo Organiser

Thank you for your interest in contributing to Photo Organiser! This document provides guidelines for contributing to the project.

## Getting Started

1. Fork the repository on GitHub
2. Clone your fork locally
3. Create a new branch for your feature or bugfix
4. Make your changes
5. Test your changes thoroughly
6. Submit a pull request

## Development Setup

```bash
git clone https://github.com/lylo/photo-organiser.git
cd photo-organiser
bundle install
```

## Code Style

- Follow Ruby conventions and best practices
- Use British spelling consistently (organise, not organize)
- Keep methods focused and well-documented
- Add comments for complex logic
- Maintain the existing code style

## Testing Your Changes

Before submitting a pull request:

1. **Test the help system**:
   ```bash
   bundle exec ruby photo-organiser.rb --help
   bundle exec ruby photo-organiser.rb --version
   ```

2. **Test with dry run** (safe to run):
   ```bash
   bundle exec ruby photo-organiser.rb /path/to/test/photos /tmp/test-output --dry-run
   ```

3. **Test error handling**:
   - Try with non-existent source directory
   - Try with files that have no EXIF data
   - Try with invalid arguments

## Types of Contributions

### Bug Reports
- Use the GitHub issue tracker
- Include Ruby version, OS, and ExifTool version
- Provide steps to reproduce the issue
- Include sample files if relevant (but not personal photos)

### Code Contributions
- Fix bugs
- Improve error handling
- Improve performance
- Enhance documentation

### Documentation
- Improve README clarity
- Add usage examples
- Fix typos and grammar
- Translate to other languages

## Pull Request Guidelines

1. **One feature per PR**: Keep changes focused and atomic
2. **Clear description**: Explain what your change does and why
3. **Update documentation**: Update README if you add features
4. **Test your changes**: Ensure nothing breaks
5. **Follow the style**: Match existing code patterns

## Questions?

Feel free to open an issue for questions about contributing, or reach out via GitHub.

Thank you for helping make Photo Organiser better! 📸
