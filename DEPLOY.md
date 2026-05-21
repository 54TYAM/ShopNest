Deployment steps for Render and GitHub

1) Create a new GitHub repository (replace <USERNAME> and <REPO>):

```bash
git init
git add .
git commit -m "Initial commit: prepare for deployment"
git branch -M main
git remote add origin https://github.com/<USERNAME>/<REPO>.git
git push -u origin main
```

2) On Render:
- Create a new Web Service and connect your GitHub repository.
- Set the Build Command to: `pip install -r requirements.txt`
- Leave Start Command empty (Render will use `Procfile`) or set to:
  `bash -lc 'export API_HOST=0.0.0.0; export API_PORT=$PORT; uvicorn src.api.main:app --host 0.0.0.0 --port $PORT'`
- Add environment variables if needed (e.g., `GROQ_API_KEY`, `ELEVENLABS_API_KEY`).

Notes and caveats:
- This project installs heavy ML dependencies (`torch`, `faiss-cpu`, `transformers`) which may take long to build on Render and might exceed build limits. Consider:
  - Using a Docker deployment with prebuilt wheels, or
  - Removing heavy local models and using managed LLM APIs, or
  - Deploying to a machine with larger resources (Render paid plan, Railway, or a cloud VM).

- If your app fails during build due to binaries, try building a Docker image locally and pushing to GitHub Container Registry, then deploy the image on Render.

- After deployment, visit the service URL and the `/health` endpoint to verify the app is running.

Example health check:

```bash
curl https://<your-service>.onrender.com/health
```
