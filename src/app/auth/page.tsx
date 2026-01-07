"use client";

import { signIn } from "next-auth/react";
import { useState } from "react";

export default function AuthPage() {
  const [email, setEmail] = useState("");
  const [isLoading, setIsLoading] = useState(false);

  async function onSubmit(e: React.FormEvent) {
    e.preventDefault();
    setIsLoading(true);

    await signIn("email", {
      email,
      callbackUrl: "/app",
    });

    setIsLoading(false);
  }

  return (
    <div className="min-h-screen bg-zinc-50 px-6 py-16">
      <main className="mx-auto w-full max-w-md rounded-2xl border border-zinc-200 bg-white p-8">
        <h1 className="text-xl font-semibold tracking-tight text-zinc-950">
          Autentificare
        </h1>
        <p className="mt-2 text-sm leading-6 text-zinc-700">
          Îți trimitem un link sigur pe email. Fără parolă.
        </p>

        <form className="mt-8 space-y-4" onSubmit={onSubmit}>
          <div className="space-y-2">
            <label className="text-sm font-medium text-zinc-950" htmlFor="email">
              Email
            </label>
            <input
              id="email"
              type="email"
              autoComplete="email"
              required
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="nume@exemplu.ro"
              className="h-11 w-full rounded-xl border border-zinc-200 px-3 text-sm text-zinc-950 outline-none focus:border-zinc-400"
            />
          </div>

          <button
            type="submit"
            disabled={isLoading}
            className="inline-flex h-11 w-full items-center justify-center rounded-full bg-zinc-950 px-6 text-sm font-medium text-white hover:bg-zinc-900 disabled:opacity-60"
          >
            {isLoading ? "Se trimite…" : "Trimite link-ul"}
          </button>

          <p className="text-xs leading-5 text-zinc-600">
            Dacă nu găsești emailul, verifică și Spam/Promotions.
          </p>
        </form>
      </main>
    </div>
  );
}
