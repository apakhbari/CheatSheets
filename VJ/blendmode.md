# Resolume blend modes, explained visually and practically

Think of blend modes as rules for how one layer of pixels interacts with the pixels underneath it. In Resolume Arena, they let you combine clips, generative visuals, textures, and effects so that two layers become one composition rather than simply covering each other.

Since you're learning VJing, the most useful approach is to understand the mathematics behind the modes and then learn which ones create which visual effects.

Imagine you have two layers:

- Bottom layer (A): a dark, abstract video with blue geometric shapes.
- Top layer (B): a white-and-black animated texture, such as film grain, fractals, or glowing lines.

[Blue abstract background for modern design](https://images.openai.com/static-rsc-4/0zpyH2_GMy2CobcENZtC0acU-giTfCX7nArnnCxNzpqQJcgvFNOGooGxiP51tZ2K1gXlxm3Kagn6Esq8RQ5EiOL1aj6v5MjizhiSaR2E0HHT_l3-N4rFc_RUZR_3UexN3iPLOcEQxCyYdzQnTlM0S-afXIELOQ8EnKmJ4xoHrpJ16U25AcpIhpy-SwfD9X87?purpose=inline)

Layer A — background

The image already on the screen.

[Abstract fractal background](https://images.openai.com/static-rsc-4/Xx40-poknNzj3LhLxd9Fw7mOtjSVKWREljcErZ7qlltaat8bnKgEElufPRjpqQOXehoTbC3UKu1qtKHya412poVFDbG26bxWS7dpBpw2EELNRFs-yKQaPK-h5X_O6WtOj5w32Uci_A7zQSHgoPX2pwukmm_LPoasnH89Ibsgcu2AouJwjzmNlMT9OLYccsf9?purpose=inline)

Layer B — foreground

The image you want to combine with the background.

The blend mode determines what happens when those two images overlap.

## 1. The main families of blend modes

[Glowing curved blue light lines](https://images.openai.com/static-rsc-4/Ibiz-0Fp9OQRdJKI_KSFKMamEanqpouBfjoDKUxeR8FtsWINQBpFw1nwWYA8Lq69qfCxCXCb8werhIQ7GRErMJwvRPX5SatTdqG8ZiNOe-a4xLoWscrSXSevRANkktsUi4jMf1ByP2MZhCmxjn9jwYBBJSnvALUMoLzgtxaylK0EKe8u1VdoDeiKGWrIy6J7?purpose=inline)

### 1. Lightening modes

Start here

These make bright parts of the top layer stand out while reducing the visibility of its dark parts.

- Add — Adds brightness from both layers. Great for lasers, glowing lines, particles, and light trails. Can quickly turn the image white.
- Screen — A softer, smoother brightening effect. Excellent for dreamy overlays and atmospheric textures.
- Lighten — Keeps whichever pixel is lighter. Useful for combining highlights without adding all their brightness together.
- Dodge — Aggressively intensifies highlights, producing overexposed, high-energy visuals.

Rule of thumb: Add for power, Screen for subtlety, Lighten for selective highlights, Dodge for intensity.

[Dark cinematic background with red top light leak and grunge scratches](https://images.openai.com/static-rsc-4/4xcwvvtY_3HTFPGLYNvroC-jrM6SXhpd1gYePZV8bLLWNfoP-BAbm7K1O6xXJlCg7NBHiMzQRyDJy0BPjaQ18DzT1sd896yLCeYYbM_ATEeezSmYJ56ipnNRrShU-SN0ZyiVDsVSjOlUgd1NuIhvQ6YJVtID6rtin9Y-a_uAefleJjMWleN3aUTTPBAElfec?purpose=inline)

### 2. Darkening modes

These make shadows and dark textures influence the composition.

- Multiply — Darkens the image according to both layers' colors. White preserves the underlying image; black makes the result black. Great for grunge, shadows, dirty textures, and distressed overlays.
- Darken — Chooses the darker pixel rather than multiplying both colors. Good for combining shadowy textures.
- Burn — Creates aggressive darkening and contrast, with deep, sometimes saturated shadows.

Rule of thumb: Multiply for texture, Darken for selective shadows, Burn for a harsh or gritty look.

[Acidwave Vibes: A Stunning 4K Ultra HD Wallpaper by QuantumCurator | 4248x2376 | Wallpaper Abyss](https://images.openai.com/static-rsc-4/Xbb9cBpCqkI8yOMW8cEUjmfo1TXMYSPRrzyDZb6PQNLoPJ8otcp4klgegDEQXObyzMt5gUAns5aoTwrqH5vK4gYTJwK4xCNoBIiD5pPJNJgx9ynfvDf32D-WLc1LlX0jyDn1d5n_vnU1Kij9YOdRPCWlND5hV8RukbjCZPXlRFg?purpose=inline)

### 3. Contrast modes

These push light and dark regions in different directions, creating punchier compositions.

- Overlay — Dark areas become darker and bright areas brighter. Good for adding texture and contrast without simply covering the original.
- Soft Light — A gentler version of Overlay. Good for subtle color and texture integration.
- Hard Light — A much harsher, more aggressive interaction, particularly with high-contrast patterns.

Rule of thumb: Overlay for depth, Soft Light for refinement, Hard Light for aggressive visual impact.

[Glitch Art Abstract in Neon Teal, Purple, Orange with Retro 90s Vibes](https://images.openai.com/static-rsc-4/Va4Es-FDUOJRZ0-heah4Ulxlav-Uvif-3p-7KfTBaj1PYWPFwm6FxbLaNOX0WSWpPMXjKYLGnThEtF8xbwPB6lCaY6WfdjazQz5D3FSYoYATrxW33QwKT1IeBBXQPERPPGXkZdVceMz1OjpGhslpOo9ac6qClZtf6o2RVtRYgH3-OtiCJi-XAqP_ZTujEqLL?purpose=inline)

### 4. Difference and subtraction modes

These are where things get experimental.

- Difference — Calculates the difference between the colors of both layers. Similar colors tend toward black; opposing colors can become bright. Excellent for psychedelic visuals, mirrored patterns, and glitchy feedback.
- Difference I — An inverted variation of Difference, generally producing a brighter, inverted result.
- Exclusion — Similar to Difference, but usually softer and more washed out.
- Subtract — Subtracts one layer's color values from the other. Can create dark, strange color shifts and unusual negative-like imagery.

Rule of thumb: Difference for psychedelic transformations, Exclusion for softer inversions, Subtract for unpredictable experimental results.

[Abstract Futuristic Shape](https://images.openai.com/static-rsc-4/vWXrVV-uVy4WnXRbMAUShECUcf0o9JxeGqKBFLKH9G0-rCYLSDlBY64gYd3iXKqWUOdbaQC5ddEqIXTFa3meVy9Ioer11AZn-x-dEPXDAnAwIKTFM-Vs4YWzQTJMGQibmdX0eXzZFYDXfm1ovxHr2rNgoCEzIfieFiFnn8AKK_fHk-eXFFyzMD2-W3LgIK72?purpose=inline)

### 5. Alpha and keying modes

These control which parts of a layer are visible.

- Alpha — Uses the layer's opacity or transparency. The normal choice for footage with a real alpha channel.
- Luma Key — Uses brightness to determine which parts of the top layer are visible. Bright parts remain; dark parts are removed, depending on the threshold.
- Luma Key I — Inverts that selection.
- Luma is Alpha — Converts brightness into transparency: white is opaque, black is transparent, and gray is partially transparent.
- 50 Mask — Uses a mask-like blend where white reveals and black hides, with gray values between them.

Rule of thumb: Use Alpha for actual transparency and luma-based modes to turn monochrome footage into a visual mask.

[Checkered background with distorted squares](https://images.openai.com/static-rsc-4/K5iDdSwQATcjZgR-ruTaW2sQLcr9s5wSoeTLyUqEkwuIl_CGzGWCv0kjum4rNsL2ucNWi2Igrm-TmHEkhk9fdq1p1Qr3yO5lSPd6L9srrv_gw4fmZ88xzPehCzOf-5pPWuYP9qxqTjqEnqoXofOtWo-HgLJItH0v7qu39Ys5tW6JFh7ZSlUgk4U6pv7QJoG4?purpose=inline)

### 6. Distortion and transition modes

Not every item in the blend menu is a conventional color-blending formula.

- Displace — Uses one layer to distort or shift another. Think liquid ripples, warped grids, or heat-haze effects.
- Cut — Switches abruptly rather than blending gradually.
- Dissolve, Wipe, Push, Zoom, Cube and similar modes — Provide different ways to transition between visual sources.

Rule of thumb: Blend modes combine image information; transition modes control how one visual gives way to another.

These descriptions follow Resolume's official [Blend Modes guide](https://resolume.com/support/en/blend-modes?utm_source=chatgpt.com).&#x20;

[image](https://www.google.com/s2/favicons?domain=https://resolume.com\&sz=32)

Resolume

+1



## 2. The three most important modes to understand mathematically

Let's simplify the image-processing logic. Assume each color channel ranges from 0 (black) to 1 (white).

### Add

\\[ C\_{\text{out}}=\min(A+B,1) \\]

Example: 0.3 + 0.5 = 0.8. Two moderately bright signals create a brighter result.

### Multiply

\\[ C\_{\text{out}}=A\times B \\]

Example: 0.5 × 0.4 = 0.2. The result gets darker. White (1) preserves the other color, and black (0) produces black.

### Screen

\\[ C\_{\text{out}}=1-(1-A)(1-B) \\]

Example: 1 − (0.7 × 0.5) = 0.65. It brightens the result without the same straightforward accumulation as Add.

These equations are simplified channel-level models; actual output also depends on opacity, alpha handling, color processing, and Resolume's particular blend implementation.

The key insight: black behaves differently depending on the mode. With Add or Screen, black contributes essentially nothing. With Multiply, black destroys the underlying color. This is why a black-background video can look completely different under different blend modes.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://resolume.com\&sz=32)

Resolume

+1



## 3. Try this exercise in Resolume Arena

This is how I'd learn blend modes in your studio rather than trying to memorize the entire menu.

## The two-layer experiment

Time: 10–15 minutes

1. Load a colorful, moving abstract clip into Layer 1.
2. Load a high-contrast black-and-white animated clip into Layer 2. Fractals, line art, and geometric patterns work well.
3. Keep Layer 2 at 100% opacity initially and switch between Add, Screen, Multiply, Difference, and Alpha.
4. Move the opacity slider down to around 30–60% and observe how the interaction changes.
5. Repeat with a completely different clip. Notice that the same blend mode can produce a radically different result.

Tip: For a black-background overlay, try Add first. For a white-background texture, try Multiply. Then deliberately try the opposite choices to learn their limitations.

## 4. What about the `50` blend modes?

Resolume includes modes such as `50 Add`, `50 Lighten`, and `50 Mask`. These are special mixing modes that can be useful in audiovisual performance setups, where you want the video and audio faders to behave independently of the normal opacity-based mixing behavior. They're not simply alternative names for the standard modes.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://resolume.com\&sz=32)

Resolume

+1



My recommendation is to learn these five first:

| Mode       | Think of it as                |
| ---------- | ----------------------------- |
| Add        | Light accumulation            |
| Screen     | Soft light                    |
| Multiply   | Shadows and texture           |
| Difference | Psychedelic color mathematics |
| Alpha      | Normal transparency           |

Once those five feel intuitive, explore Overlay, Dodge, Luma Key, and Displace.

One final principle: blend modes are not effects you apply to make an image look better in isolation. They're relationships between layers. When you're building a VJ composition, choose the mode based on what you want the top layer to contribute to the bottom layer—not just on how attractive the top layer looks by itself.