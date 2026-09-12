# Workflow

Follow this workflow for design and implementation within the user's requested scope.
Do not interpret questions or design discussions as requests to implement changes.

## Clarification

At each stage, resolve all ambiguity before proceeding.
Establish what you can from context or investigation, and ask the user about the rest.
Do not treat assumptions as resolved facts.
If a later stage reveals ambiguity in an earlier stage, return to that stage.
If the user's responses contradict earlier responses, stop and ask for clarification.
When user input or approval is required, stop and wait for their response.

## 1. Confirm the background

Confirm the background and purpose of the request.

## 2. Design the domain models

Propose models with only the necessary fields.
Explain what each model represents.
Revise based on feedback and obtain approval before proceeding.

## 3. Design the domain logic and side effects

Using the approved models, show the flow of transformations between models.
For each operation, provide its name, signature, and a short description.
Make the processing clear from the names, inputs, outputs, and transformation flow.
Identify side effects.
Revise based on feedback and obtain approval before proceeding.
