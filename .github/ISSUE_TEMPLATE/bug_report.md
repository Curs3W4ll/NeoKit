name: Bug Report
description: Create a report to help us improve
title: "[Bug]: "
labels: [bug]
body:
  - type: checkboxes
    attributes:
      label: Is there an existing issue for this?
      description: Please search to see if an issue already exists for the bug you encountered.
      options:
        - label: I have searched the existing issues
          required: true
  - type: markdown
    attributes:
      value: Please make sure you have read the README before opening an issue.
  - type: textarea
    id: what-happened
    attributes:
      label: What happened?
      placeholder: Please describe the bug you are experiencing.
      value: "The issue is that..."
    validations:
      required: true
  - type: textarea
    id: what-expected
    attributes:
      label: What did you expect to happen?
      description: Expected behavior
      value: Expected behavior
    validations:
      required: true
  - type: textarea
    id: os-info
    attributes:
      label: Environment
      description: Provide information about your machine configuration
      value: |
        "- OS: [e.g. Ubuntu]"
        "- Version: [e.g. 20.04]"
        "- Nvim version: [e.g. v0.9.1]"
  - type: textarea
    id: additional-information
    attributes:
      label: Additional Information
      placeholder: Add in any relevant additional information
      value: "..."
    validations:
      required: false
  - type: input
    id: commit
    attributes:
      label: commit
      description: what commit triggered this issue?
    validations:
      required: false
