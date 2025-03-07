name: "✨ Feature Request"
description: "Suggest an idea to improve the Newt Home Assistant add-on."
title: "[Feature Request]: <Brief Description>"
labels: ["enhancement", "feature request"]
body:
  - type: markdown
    attributes:
      value: |
        ### ✨ **Feature Request**
        Thanks for suggesting a new feature! Please fill out the details below.

  - type: textarea
    id: feature-description
    attributes:
      label: "🔹 Describe the Feature"
      description: "What is the feature? How would it improve the add-on?"
      placeholder: "Explain the feature in detail..."
    validations:
      required: true

  - type: textarea
    id: use-case
    attributes:
      label: "🎯 Use Case"
      description: "How would this feature benefit users?"
      placeholder: "Describe why this feature is useful..."
    validations:
      required: true

  - type: textarea
    id: alternatives
    attributes:
      label: "🔄 Alternatives Considered"
      description: "Are there other ways to achieve this?"
      placeholder: "Have you tried other solutions or workarounds?"
    validations:
      required: false

  - type: textarea
    id: additional-info
    attributes:
      label: "ℹ️ Additional Information"
      description: "Any extra details, screenshots, or links?"
      placeholder: "Add any relevant information here..."
    validations:
      required: false
