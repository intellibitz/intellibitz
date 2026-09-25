# Google Colaboratory (Colab) Quickstart

Reference guide for Google Colaboratory, Gemini API integration, and cloud GPU environments.

---

## Overview

[Google Colaboratory](https://colab.research.google.com/) provides hosted Jupyter notebook runtimes in the browser with:
- Zero local configuration required
- Free access to GPUs / TPUs
- Collaborative sharing and Google Drive synchronization

---

## Gemini API Quickstart

The Gemini API allows integration of multimodal models (text, code, image, audio) created by Google DeepMind.

1. **Get an API Key**:
   - Visit [Google AI Studio](https://aistudio.google.com/).
   - Create an API key for your project.

2. **Install the Python SDK**:
   ```bash
   pip install -U google-genai
   ```

3. **Initialize and Generate**:
   ```python
   import os
   from google import genai

   client = genai.Client(api_key=os.environ["GEMINI_API_KEY"])
   response = client.models.generate_content(
       model="gemini-2.5-flash",
       contents="Explain quantum computing in simple terms.",
   )
   print(response.text)
   ```
