Skip to main contentSkip to footer
Research
Economic Futures

Commitments

Learn
News
Try Claude
Product
Introducing Agent Skills
Oct 16, 2025
●
3 min read

Claude can now use Skills to improve how it performs specific tasks. Skills are folders that include instructions, scripts, and resources that Claude can load when needed.

Claude will only access a skill when it's relevant to the task at hand. When used, skills make Claude better at specialized tasks like working with Excel or following your organization's brand guidelines.

You've already seen Skills at work in Claude apps, where Claude uses them to create files like spreadsheets and presentations. Now, you can build your own skills and use them across Claude apps, Claude Code, and our API.

How Skills work
While working on tasks, Claude scans available skills to find relevant matches. When one matches, it loads only the minimal information and files needed—keeping Claude fast while accessing specialized expertise.

Skills are:

Composable: Skills stack together. Claude automatically identifies which skills are needed and coordinates their use.
Portable: Skills use the same format everywhere. Build once, use across Claude apps, Claude Code, and API.
Efficient: Only loads what's needed, when it's needed.
Powerful: Skills can include executable code for tasks where traditional programming is more reliable than token generation.
Think of Skills as custom onboarding materials that let you package expertise, making Claude a specialist on what matters most to you. For a technical deep-dive on the Agent Skills design pattern, architecture, and development best practices, read our engineering blog.

Skills work with every Claude product
Claude apps
Skills are available to Pro, Max, Team and Enterprise users. We provide skills for common tasks like document creation, examples you can customize, and the ability to create your own custom skills.

The Skills capabilities interface in Claude.ai with example Skills toggled on. 
Claude automatically invokes relevant skills based on your task—no manual selection needed. You'll even see skills in Claude's chain of thought as it works.

Creating skills is simple. The "skill-creator" skill provides interactive guidance: Claude asks about your workflow, generates the folder structure, formats the SKILL.md file, and bundles the resources you need. No manual file editing required.

Enable Skills in Settings. For Team and Enterprise users, admins must first enable Skills organization-wide.

Claude Developer Platform (API)
Agent Skills, which we often refer to simply as Skills, can now be added to Messages API requests and the new /v1/skills endpoint gives developers programmatic control over custom skill versioning and management. Skills require the Code Execution Tool beta, which provides the secure environment they need to run.

Use Anthropic-created skills to have Claude read and generate professional Excel spreadsheets with formulas, PowerPoint presentations, Word documents, and fillable PDFs. Developers can create custom Skills to extend Claude's capabilities for their specific use cases.

Developers can also easily create, view, and upgrade skill versions through the Claude Console.

Explore the documentation or Anthropic Academy to learn more.






Claude Code
Skills extend Claude Code with your team's expertise and workflows. Install skills via plugins from the anthropics/skills marketplace. Claude loads them automatically when relevant. Share skills through version control with your team. You can also manually install skills by adding them to ~/.claude/skills. The Claude Agent SDK provides the same Agent Skills support for building custom agents.

Getting started
Claude apps: User Guide & Help Center
API developers: Documentation
Claude Code: Documentation
Example Skills to customize: GitHub repository
What's next
We're working toward simplified skill creation workflows and enterprise-wide deployment capabilities, making it easier for organizations to distribute skills across teams.

Keep in mind, this feature gives Claude access to execute code. While powerful, it means being mindful about which skills you use—stick to trusted sources to keep your data safe. Learn more.



News

Seoul becomes Anthropic’s third office in Asia-Pacific as we continue our international growth
Oct 23, 2025

News

Expanding our use of Google Cloud TPUs and Services
Oct 23, 2025

News

A statement from Dario Amodei on Anthropic's commitment to American AI leadership
Oct 21, 2025

Products
Claude
Claude Code
Max plan
Team plan
Enterprise plan
Download app
Pricing
Log in to Claude
Models
Opus
Sonnet
Haiku
Solutions
AI agents
Code modernization
Coding
Customer support
Education
Financial services
Government
Life sciences
Claude Developer Platform
Overview
Developer docs
Pricing
Amazon Bedrock
Google Cloud’s Vertex AI
Console login
Learn
Courses
Connectors
Customer stories
Engineering at Anthropic
Events
Powered by Claude
Service partners
Startups program
Company
Anthropic
Careers
Economic Futures
Research
News
Responsible Scaling Policy
Security and compliance
Transparency
Help and security
Availability
Status
Support center
Terms and policies
Privacy choices
Privacy policy
Responsible disclosure policy
Terms of service: Commercial
Terms of service: Consumer
Usage policy
© 2025 Anthropic PBC

