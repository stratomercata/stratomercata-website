# STRATO Mercata Website

The official website for STRATO Mercata - a platform to easily earn on vaulted gold, silver & crypto with instant credit. Built by Ethereum veterans.

## About This Project

**STRATO Mercata** (https://stratomercata.github.io/stratomercata-website) is a Jekyll-based static website that serves as the primary web presence for STRATO Mercata. The site features video content, team member profiles, and information about the platform's capabilities.

### What You'll Find Here

- **Team Profiles**: Biographies and profiles of STRATO Mercata team members
- **Video Content**: Show episodes, contest announcements, and platform demonstrations
- **Articles**: Platform updates, announcements, and educational content
- **Platform Information**: Details about trading, lending, and borrowing on real-world assets

---

## Jekyll Setup

This is a static site built with Jekyll 4.3+ and deployed via GitHub Pages.

### Project Structure

```
stratomercata-website/
├── _config.yml                # Jekyll configuration (environment-agnostic)
├── Gemfile                    # Ruby dependencies
├── .github/workflows/         # GitHub Actions for deployment
│   └── jekyll-gh-pages.yml    # Deployment workflow (sets URL & baseurl)
└── source/                    # Jekyll source directory
    ├── _layouts/              # Page templates (default, person, article, video)
    ├── _includes/             # Reusable components (auto_link, embeds, SEO)
    ├── _articles/             # Article collection (Markdown files)
    ├── _people/               # People collection (Markdown files)
    ├── _videos/               # Video collection (Markdown files)
    ├── articles/index.html    # Articles listing page
    ├── people/index.html      # People listing page
    ├── videos/index.html      # Videos listing page
    ├── assets/css/            # Stylesheets
    ├── images/                # Image assets
    └── videos/raw-audio/      # Source audio files for transcription
```

### Configuration Philosophy

The `_config.yml` file contains production settings:
- **`baseurl: "/stratomercata-website"`**: GitHub Pages subpath
- **`url: "https://stratomercata.github.io"`**: Production domain

For local development, Jekyll's `serve` command automatically overrides these:
- Sets `url` to `http://localhost:4000`
- Sets `baseurl` to empty string

This is the standard Jekyll approach for GitHub Pages sites.

---

## Local Development

### Prerequisites

- Ruby 3.3+ (install via [rbenv](https://github.com/rbenv/rbenv) or [rvm](https://rvm.io/))
- Bundler: `gem install bundler`

### Setup & Run

```bash
# Install dependencies
bundle install

# Clean, build, and serve with incremental builds
bundle exec jekyll clean && bundle exec jekyll serve --incremental

# Access at http://localhost:4000
```

The development server includes:
- **Auto-regeneration**: Changes to source files trigger automatic rebuilds
- **Incremental builds**: Only changed files are rebuilt (faster)
- **LiveReload**: Browser refreshes automatically when files change

---

## Collections

The site uses three Jekyll collections:

### Articles (`_articles/`)
Platform updates, announcements, and educational content about STRATO Mercata.

### People (`_people/`)
Team member profiles with photos, bios, and social links.

Example frontmatter:
```yaml
---
name: Bob Summerwill
role: Head of Ecosystem
photo: /images/bobsummerwill.com/2025.08.26/bob-summerwill.jpeg
twitter: bobsummerwill
linkedin: bob-summerwill
---
```

### Videos (`_videos/`)
Show episodes, contests, and platform demonstrations with embedded YouTube videos and transcripts.

Example frontmatter:
```yaml
---
title: "STRATO Mercata Show: State of Blockchain"
date: 2025-10-08
hosts: ["Bob Summerwill", "Victor Wong", "Kieren James-Lubin"]
description: "Reflections on TOKEN2049 in Singapore"
embed:
  url: https://www.youtube.com/embed/VIDEO_ID
---
```

---

## Workflow: Adding Video Content with Transcripts

### 1. Extract Audio from Video

Download the video from Streamyard/YouTube, then extract audio:

```bash
ffmpeg -i "video-file.mp4" -q:a 0 -map a "output-audio.mp3"
```

### 2. Transcribe with TurboScribe

1. Upload the audio file to [TurboScribe](https://turboscribe.ai)
2. Select **Whale Transcription** mode
3. Enable **Speaker Recognition** in settings
4. Set number of speakers (usually 2-3)
5. Click **Transcribe**

### 3. Save Audio File

Store the MP3 for future reference:
```
source/videos/raw-audio/show-name-YYYY-MM-DD.mp3
```

### 4. Create Video Page

Copy an existing video page as a template:

```bash
cp source/_videos/existing-video.md source/_videos/new-video-YYYY-MM-DD.md
```

Update the frontmatter with new details.

### 5. Add Transcript

1. Export transcript from TurboScribe as **TXT** with **Section Timestamps** enabled
2. Paste the content into the video page body
3. Transform speaker labels and timestamps

Example transformation:
```
[Speaker 1] (0:03 - 0:05)

becomes:

[[0:03]](https://www.youtube.com/watch?v=VIDEO_ID&t=3s) **Bob:**
```

Where `3s` is the starting timestamp in seconds.

### 6. Verify Locally

```bash
bundle exec jekyll clean && bundle exec jekyll serve --incremental
```

Visit http://localhost:4000/videos/ to verify the new video appears correctly.

---

## Deployment

### Automatic Deployment

The site automatically deploys to GitHub Pages when changes are pushed to the `main` branch.

The GitHub Actions workflow (`.github/workflows/jekyll-gh-pages.yml`):
1. Checks out the repository
2. Sets up Ruby and installs dependencies
3. Configures GitHub Pages settings
4. Builds the site with dynamic baseurl:
   ```bash
   bundle exec jekyll build --baseurl "${{ steps.pages.outputs.base_path }}"
   ```
   The `url` setting from `_config.yml` is used automatically
5. Uploads and deploys the site

### Manual Deployment

You can also trigger deployment manually from the Actions tab in GitHub.

---

## Development Tips

### Auto-linking System

The site includes an auto-linking system (`source/_includes/auto_link.html`) that automatically converts mentions of people, articles, and videos to links:

```markdown
Bob Summerwill spoke about blockchain.
```

Automatically becomes:
```html
<a href="/people/bob-summerwill/">Bob Summerwill</a> spoke about blockchain.
```

The system processes content in priority order:
1. **Hidden People** - Removes/redacts links to hidden profiles
2. **Videos** - Links video titles to their pages
3. **Articles** - Links article titles to their pages
4. **People** - Links person names (with conflict detection to avoid nested links)

### Relative URLs

Always use Jekyll's `relative_url` filter for internal links:

```liquid
[Link text]({{ '/people/bob-summerwill/' | relative_url }})
```

This ensures links work correctly in both local development and production.

### Image Paths

Images are organized by source and date:
```
source/images/bobsummerwill.com/2025.08.26/photo.jpeg
source/images/linkedin.com/2025.10.07/profile.png
source/images/stratomercata.com/2025.10.07/screenshot.png
```

Always use relative paths with the `relative_url` filter for images.

---

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/your-feature`)
3. Commit your changes (`git commit -m 'Add new feature'`)
4. Push to the branch (`git push origin feature/your-feature`)
5. Open a Pull Request

For major changes, please open an issue first to discuss what you would like to change.

---

## License

This project is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License (CC BY-SA 4.0) - see the [LICENSE](LICENSE) file for details.

---

## Support

For questions or support:
- Open an [issue](https://github.com/stratomercata/stratomercata-website/issues)
- Contact [@bobsummerwill](https://x.com/bobsummerwill) on X/Twitter
- Visit [STRATO Mercata](https://www.stratomercata.com)
