# Product Requirements Document (PRD): EasyUpload MVP

## 1. Project Overview
**Goal:** Build a lightweight, high-performance web application tailored for photographers to easily upload high-resolution photos via mobile or desktop, and share secure, beautiful galleries with clients.

**Target Audience:**
1.  **Photographers:** Creators who need a streamlined, fast way to upload large volumes of photos on the go.
2.  **Clients:** End-users (e.g., wedding attendees, models) who need a frictionless, fast-loading interface to view and download their photos.

---

## 2. Core User Stories (The "Must Haves")

### Photographer Capabilities
*   [x] **Authentication:** As a photographer, I want to sign up and log in securely so that my galleries remain private to me.
*   [x] **Dashboard:** As a photographer, I want to see a list of my previously created galleries including their cover photo, title, and creation date.
*   [x] **Gallery Creation:** As a photographer, I want to create a new gallery by naming it and optionally setting a client access PIN.
*   [x] **Mobile-Friendly Upload:** As a photographer, I want to select multiple images from my phone's camera roll and upload them concurrently without the browser crashing.
*   [x] **Upload Feedback:** As a photographer, I want to see a visual progress bar for each file so I know how the upload is proceeding.
*   [x] **Sharing:** As a photographer, I want to generate a shareable public URL for a specific gallery.

### Client Capabilities
*   [x] **Secure Access:** As a client, I want to be prompted to enter a PIN if the photographer secured the gallery.
*   [x] **Fast Viewing:** As a client, I want to open the gallery link and instantly see a beautiful, masonry grid of thumbnails that don't drain my mobile data or load slowly.
*   [x] **Immersive Viewing:** As a client, I want to tap on a thumbnail to view it in full screen (Lightbox) and swipe left/right between images.
*   [x] **Downloading:** As a client, I want an obvious button to download the original, high-resolution file of an image to my device.

---

## 3. Out of Scope for MVP (Future Enhancements)
To ensure we can build the MVP quickly and successfully, the following features are explicitly **out of scope** for phase 1:
*   **E-Commerce:** Selling prints, physical albums, or connecting to third-party print labs.
*   **Payments:** Charging clients for digital downloads.
*   **Watermarking:** Automatically applying watermarks to thumbnails.
*   **Favorites System:** Allowing clients to create a "favorites" list to send back to the photographer for retouching.
*   **Custom Domains:** Allowing photographers to map their own domain (e.g., `photos.johnsmith.com`).

---

## 4. Non-Functional Requirements
*   **Performance:** Client gallery grids must load in under 1 second (LCP) on a standard 4G mobile connection. This necessitates server-side rendering (SSR) and aggressive image proxying/thumbnailing.
*   **Reliability:** The uploader must be able to handle individual files up to 50MB and total queue sizes of 1GB+ without exhausting device memory.
*   **Responsiveness:** UI must look completely native on both small mobile screens and ultra-wide desktop monitors.

---

## 5. Acceptance Criteria (Definition of Done)
1. A photographer can create an account, create a gallery, upload 10 large photos from their phone, and get a link.
2. A user opening that link sees the 10 photos load instantly as compressed thumbnails in a masonry grid.
3. The user can click down on any image to download the original high-resolution file perfectly intact.
