# 1.0.1
- Resolved lint error with updated lint options.
# 1.0.0
- Migrated to null-safety. This package is compatible with null-safety.
- Resolved observation from linting tool.
# 0.1.5
- Resolved observations in pub.
- Resolved issues with the cancelation of events.cancel property is now changed to method, to make it consistent with the older implementation, signture of the same is kept as-is. 
- Updated library documentation.
# 0.1.4
- Performance optimization - Observed that in real-time applications, removing event handlers were taking lots of time. Same observed with adding handlers also. 
- Modified code to use Set, instead of list to provide faster performance.
- Removed unwanted checks while adding handlers. 
# 0.1.3
- Addressed health and maintenance suggestions.
# 0.1.2
- Added additional examples.

# 0.1.1
- Removing event registration in the callback caused exception. Addressed the issue by creating a sublist and triggering callback from there.

# 0.1.0
- Added example.dart

# 0.0.9

- Added CHANGELOG.md

# 0.0.8

First reviewed version.