name: Feature Request
description: Request for a new feature or suggest an idea
title: "[Feature Request]: "
labels: [enhancement]
body:
  - type: textarea
    id: what-feature
    attributes:
      label: What?
      description: Describe the feature you want to see.
      placeholder: Please describe the feature you want to see and most importantly how it will work.
  - type: textarea
    id: why-feature
    attributes:
      label: Why?
      description: Describe the reason why you want to see this feature.
      placeholder: Please describe the reason why you want this feature, it should be applicable to more people than just you.
  - type: textarea
    id: alternatives
    attributes:
      label: Alternatives you have considered
      description: A clear and concise description of any alternative solutions or features you've considered.
  - type: textarea
    id: additional-information
    attributes:
      label: Additional Information
      placeholder: Add in any relevant additional information
      value: "..."
    validations:
      required: false
  - type: markdown
    attributes:
      value: |
        Please note that I won't just add features simply because you request them, my time is limited so if you would like to see a feature you should consider if and how you can contribute it yourself.
