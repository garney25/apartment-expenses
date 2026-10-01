# Ours — Apartment Expenses

A lightweight, mobile-first web app for two people to track and split shared apartment
expenses (built for the Jumeirah Complex). One tap to add an expense, attach a receipt,
and the home screen always answers the only question that matters: **who owes whom, and
how much this month.**

**Live app:** https://garney25.github.io/apartment-expenses/

---

## Features

- **Monthly dashboard** — total spend, who paid what, each person's share, and the net
  settlement shown front-and-centre.
- **Add in under 30 seconds** — amount, category, date, paid-by, split, notes.
- **Receipts** — snap a photo or upload an image/PDF; stored against the expense.
- **On-device receipt OCR** — reads the provider, date and total from a receipt photo
  locally (Tesseract.js, in-browser), suggests a category, and shows them for you to
  confirm before saving. Free, no API key, and the image never leaves your phone for
  reading. Never invents a total — flags it for manual entry when unsure.
- **Smart split** — 50/50, payer-pays-100%, full-repayment (e.g. mortgage), or excluded.
- **Recurring expenses** — Jumeirah maintenance (JMD 20,000) and mortgage (JMD 35,152,
  full repayment) auto-create each month; backfill into past months in one tap.
- **Insights** — 6-month spend trend, who-paid chart, year-to-date, top categories.
- **Settlement** — one tap to mark a month settled; history is preserved and never
  rewrites the underlying expenses. Editing after settlement warns and recalculates.
- **Shared & live** — both phones see the same data in real time (Supabase).
- **CSV export**, category breakdown, settlement history, and a built-in settlement
  self-test.
- **Liquid-glass UI**, light & dark, mobile-first.

## Tech

- Single self-contained `index.html` — vanilla JS, no build step.
- [Supabase](https://supabase.com) free tier for the shared database, realtime, and
  receipt file storage.
- [Tesseract.js](https://tesseract.projectnaptha.com/) for in-browser receipt OCR (no
  server, no key).
- Hosted on GitHub Pages.

## Setup (once, ~10 min)

See **[SETUP.md](./SETUP.md)** for the full walkthrough. In short:

1. Create a free Supabase project.
2. Run **[supabase-setup.sql](./supabase-setup.sql)** in its SQL editor (creates tables,
   access policies, realtime, and the receipts bucket).
3. Open the live app, paste your Supabase **Project URL** + **anon public key**, choose a
   **household code**, and tap **Connect**.
4. **Settings → Sharing → Copy invite link**, send it to your partner with the household
   code. They open it on any device/account, enter the same code, and you're both live.

## Security note

The Supabase **URL and anon key are entered at runtime** and stored only in each viewer's
browser — they are **not** in this source code, which is why this repo can be public
safely. Access is governed by the row-level-security policies in `supabase-setup.sql`.
Keep your invite link private. For stronger control (email sign-in, per-user rules),
Supabase Auth can be layered on later.

## Roadmap

Custom split percentages, individual/non-shared expenses, multiple properties, budgets,
WhatsApp settlement sharing, and bill reminders — the data model already accommodates
these. (Higher-accuracy cloud OCR via a Supabase Edge Function is an optional future
upgrade over the free on-device reader.)
