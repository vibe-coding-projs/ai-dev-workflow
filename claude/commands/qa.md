Use both Playwright and Chrome to QA the preview environment:

1. Get the preview URL from the Jira ticket comments
2. **Automated checks via Playwright** (headless):
   - Open the preview URL
   - Check each acceptance criterion from the Jira ticket visually
   - Take screenshots of each key screen/state
3. **Visual checks via Chrome** (real browser):
   - Open the preview URL in the local Chrome browser
   - Check layout, responsiveness, and visual appearance
4. Report what passed and what failed
5. Post a QA summary comment on the Jira ticket with results and screenshots
