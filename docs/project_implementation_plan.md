# EasyUpload Implementation Plan

## 1. Executive Summary
This document outlines the architecture and phased implementation plan for a lightweight EasyUpload application. The core focus is on **mobile-friendly image uploads** for photographers and **beautiful, performant client galleries**. 

## 2. Technology Stack

### Frontend (Client & Photographer Interface)
*   **Framework**: Nuxt 3 (Vue.js application framework)
    *   *Why*: Provides Server-Side Rendering (SSR) for fast loading client galleries and incredible developer experience for Vue.
*   **Styling**: Tailwind CSS
    *   *Why*: Rapid UI development and responsive design, crucial for mobile and desktop viewing.
*   **State Management**: Pinia
    *   *Why*: Vue's modern standard for managing global states (e.g., user sessions, upload queues).
*   **Icons**: Heroicons or Lucide Vue

### Backend & Database (BaaS)
*   **Platform**: Supabase
    *   *Why*: Open-source Firebase alternative providing PostgreSQL database, built-in Authentication, and easy-to-configure Row Level Security (RLS).
*   **Database**: PostgreSQL (via Supabase)

### Storage & Content Delivery
*   **Storage**: Cloudflare R2 (Highly Recommended) or AWS S3
    *   *Why*: Cloudflare R2 offers zero egress fees, which is critical for a photo-heavy app where clients download large files.
*   **Image Processing**: Cloudflare Images or Supabase Edge Functions + Sharp (Node.js)
    *   *Why*: Automatically generate optimized thumbnails (WebP) to ensure gallery grids load instantly without fetching original 20MB files.

---

## 3. Core Architecture & Data Models

### Database Schema (Supabase PostgreSQL)
1.  **`users`**: Photographers (Standard Supabase Auth table + profiles).
2.  **`galleries`**:
    *   `id` (UUID)
    *   `photographer_id` (FK to users)
    *   `title` (String)
    *   `date` (Date)
    *   `cover_image_url` (String)
    *   `is_published` (Boolean)
    *   `client_pin` (String - optional for secure access)
3.  **`photos`**:
    *   `id` (UUID)
    *   `gallery_id` (FK to galleries)
    *   `original_url` (String - High Res Storage link)
    *   `thumbnail_url` (String - Optimized WebP link)
    *   `filename` (String)
    *   `size_bytes` (Integer)
    *   `uploaded_at` (Timestamp)

### Storage Buckets
1.  **`originals`**: Private bucket. Only accessible via signed URLs when a client clicks "Download".
2.  **`thumbnails`**: Public bucket. Used for rendering the masonry grid in the client galleries.

---

## 4. Phased Implementation Plan

### Phase 1: Foundation & Infrastructure (Week 1)
*   **Step 1.1**: Initialize Nuxt 3 project with Tailwind CSS setup.
*   **Step 1.2**: Set up Supabase project, initialize tables (`profiles`, `galleries`, `photos`), and configure Row Level Security (RLS).
*   **Step 1.3**: Integrate Supabase Auth into Nuxt 3 (Login/Signup pages for Photographers).
*   **Step 1.4**: Configure Cloudflare R2 (or AWS S3) bucket and get API keys.

### Phase 2: Photographer Dashboard & Mobile Uploads (Week 2-3)
*   **Step 2.1**: Build `DashboardLayout` for authenticated photographers.
*   **Step 2.2**: Implement "Create New Gallery" interface.
*   **Step 2.3**: Build the **Mobile-Optimized Uploader Component**:
    *   Multi-file selection via native mobile file picker.
    *   Drag-and-drop support for desktop.
    *   **Crucial**: Implement resumable/chunked uploads directly to the Storage bucket using Pre-signed URLs to bypass server memory limits.
    *   Upload progress indicators per file.
*   **Step 2.4**: Implement Image Processing function (Trigger on upload to create a 1080p thumbnail and save its URL to the database).

### Phase 3: Client Galleries (Week 4)
*   **Step 3.1**: Create dynamic Nuxt routes for galleries (e.g., `/gallery/[gallery_id]`).
*   **Step 3.2**: Build a beautiful Masonry Grid component to display `thumbnail_url`s.
*   **Step 3.3**: Implement a Lightbox component for viewing full-screen photos.
*   **Step 3.4**: Implement "Download Single" and "Download All" functionality (Generating a bulk zip via an Edge Function if needed).
*   **Step 3.5**: (Optional) Add Pin-protection middleware to restrict gallery access.

### Phase 4: Polish & Deployment (Week 5)
*   **Step 4.1**: SEO optimization for public-facing gallery links (Meta tags, Open Graph images).
*   **Step 4.2**: Configure as a PWA (Progressive Web App) so photographers can "Install" the dashboard to their mobile home screens.
*   **Step 4.3**: Deploy the frontend application to Vercel or Netlify.

---

## 5. Next Actions to Start Development
To kick off the project, we should proceed with **Phase 1, Step 1.1**:
> Initializing the Nuxt 3 application with Tailwind CSS in your current workspace `/Users/abshetty/Developer/antigravity/easyUpload`.

Let me know if you would like me to run the bootstrap commands to create the Vue/Nuxt project!
