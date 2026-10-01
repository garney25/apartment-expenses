# Ours — Apartment Expenses: setup (about 10 minutes, one time)

This version works across **any** accounts/devices — your girlfriend's separate Claude account doesn't matter. It runs as a normal web app backed by your own free Supabase database.

You do this once. She just opens a link.

---

## 1. Create a free Supabase project
1. Go to **supabase.com** → sign up (free).
2. **New project** → name it (e.g. `apartment`), set a database password, pick a region near Jamaica (e.g. East US). Wait ~2 min for it to provision.

## 2. Create the tables
1. In the project, open **SQL Editor** (left sidebar) → **New query**.
2. Paste the entire contents of **`supabase-setup.sql`** → **Run**.
3. You should see "Success". (This makes the tables, access rules, realtime, and a `receipts` file bucket.)

## 3. Get your two keys
1. **Project Settings** (gear) → **API**.
2. Copy the **Project URL** (looks like `https://abcd1234.supabase.co`).
3. Copy the **anon public** key (a long `eyJ…` string). *Not* the service_role key.

## 4. The app is already online
It's hosted free on GitHub Pages at:

**https://garney25.github.io/apartment-expenses/**

No Netlify or other host needed. (The source is one self-contained file, `index.html`, in this repo — you can host it anywhere static if you ever want to move it.)

## 5. Connect
1. Open **https://garney25.github.io/apartment-expenses/** on your phone.
2. On the **Set up shared sync** screen, paste the **Project URL** + **anon key**, and choose a **household code** — any shared word you'll both type, e.g. `jumeirah-us`.
3. Tap **Connect**. You're in.

## 6. Add your girlfriend
1. Go to **Settings → Sharing → Invite your partner → Copy link**.
2. Send her that link (WhatsApp, etc.) **and** tell her the household code.
3. She opens the link on her phone (any account, no Claude needed), enters the **same household code**, taps Connect.
4. Done — you're both live on the same data, in real time.

---

## Notes
- **Cost:** free. Supabase's free tier is far more than a two-person expense tracker needs.
- **Security:** the anon key is public by design; access is governed by the policies in the SQL. Because it's your private project, only your data lives there. Keep the invite link private. Want stronger (email sign-in, per-user rules)? Ask me and I'll add Supabase Auth.
- **Receipts:** photo/PDF uploads are stored in your Supabase `receipts` bucket and attached to each expense.
- **Receipt reading (OCR):** runs on your device, free, no setup — snap a bill photo and
  it reads the provider, date and total for you to confirm. First receipt downloads a
  small reader file (~a few MB, then cached). Works on photos; PDFs are stored but entered
  manually. For even higher accuracy later, a cloud reader can be added via a Supabase
  Edge Function.
- **Settlement math:** the four required test cases + rounding are verified in-app (Settings → Settlement self-test → Run).
- **Trouble?** Settings → **Sync → Test** tells you if the app can reach your database, and shows the exact error if not (usually a wrong URL/key or the SQL wasn't run).
