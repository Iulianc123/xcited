"use client";

import { signIn } from "next-auth/react";
import { useState } from "react";
import { useRouter } from "next/navigation";

export default function AuthPage() {
  const [mode, setMode] = useState<"login" | "register">("login");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [name, setName] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState("");
  const router = useRouter();

  async function handleLogin(e: React.FormEvent) {
    e.preventDefault();
    setIsLoading(true);
    setError("");

    try {
      const result = await signIn("credentials", {
        email,
        password,
        redirect: false,
      });

      if (result?.error) {
        setError("Email sau parolă incorectă");
      } else {
        router.push("/app");
      }
    } catch (err) {
      setError("A apărut o eroare. Încearcă din nou.");
    } finally {
      setIsLoading(false);
    }
  }

  async function handleRegister(e: React.FormEvent) {
    e.preventDefault();
    setIsLoading(true);
    setError("");

    try {
      const response = await fetch("/api/register", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email, password, name }),
      });

      const data = await response.json();

      if (!response.ok) {
        setError(data.error || "A apărut o eroare la înregistrare");
        return;
      }

      // Auto-login after registration
      const result = await signIn("credentials", {
        email,
        password,
        redirect: false,
      });

      if (result?.error) {
        setError("Cont creat, dar autentificarea a eșuat. Te rugăm să te conectezi manual.");
      } else {
        router.push("/app");
      }
    } catch (err) {
      setError("A apărut o eroare. Încearcă din nou.");
    } finally {
      setIsLoading(false);
    }
  }

  return (
    <div className="min-h-screen bg-gradient-to-b from-zinc-50 via-white to-zinc-50 px-6 py-16">
      <main className="mx-auto w-full max-w-md rounded-2xl border border-zinc-200 bg-white p-8 shadow-lg">
        <div className="mb-6 flex gap-2 border-b border-zinc-200">
          <button
            type="button"
            onClick={() => {
              setMode("login");
              setError("");
            }}
            className={`flex-1 pb-3 text-sm font-medium transition-colors ${
              mode === "login"
                ? "text-zinc-950 border-b-2 border-zinc-950"
                : "text-zinc-500 hover:text-zinc-700"
            }`}
          >
            Autentificare
          </button>
          <button
            type="button"
            onClick={() => {
              setMode("register");
              setError("");
            }}
            className={`flex-1 pb-3 text-sm font-medium transition-colors ${
              mode === "register"
                ? "text-zinc-950 border-b-2 border-zinc-950"
                : "text-zinc-500 hover:text-zinc-700"
            }`}
          >
            Înregistrare
          </button>
        </div>

        <h1 className="text-xl font-semibold tracking-tight text-zinc-950">
          {mode === "login" ? "Autentificare" : "Creează cont"}
        </h1>
        <p className="mt-2 text-sm leading-6 text-zinc-700">
          {mode === "login"
            ? "Conectează-te cu email și parolă"
            : "Creează un cont nou pentru a începe"}
        </p>

        {error && (
          <div className="mt-4 rounded-lg bg-rose-50 border border-rose-200 p-3 text-sm text-rose-700">
            {error}
          </div>
        )}

        <form
          className="mt-8 space-y-4"
          onSubmit={mode === "login" ? handleLogin : handleRegister}
        >
          {mode === "register" && (
            <div className="space-y-2">
              <label className="text-sm font-medium text-zinc-950" htmlFor="name">
                Nume
              </label>
              <input
                id="name"
                type="text"
                autoComplete="name"
                required
                value={name}
                onChange={(e) => setName(e.target.value)}
                placeholder="Numele tău"
                className="h-11 w-full rounded-xl border border-zinc-200 px-3 text-sm text-zinc-950 outline-none focus:border-zinc-400"
              />
            </div>
          )}

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

          <div className="space-y-2">
            <label className="text-sm font-medium text-zinc-950" htmlFor="password">
              Parolă
            </label>
            <input
              id="password"
              type="password"
              autoComplete={mode === "login" ? "current-password" : "new-password"}
              required
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="••••••••"
              minLength={6}
              className="h-11 w-full rounded-xl border border-zinc-200 px-3 text-sm text-zinc-950 outline-none focus:border-zinc-400"
            />
            {mode === "register" && (
              <p className="text-xs text-zinc-500">
                Minim 6 caractere
              </p>
            )}
          </div>

          <button
            type="submit"
            disabled={isLoading}
            className="inline-flex h-11 w-full items-center justify-center rounded-full bg-gradient-to-r from-rose-600 to-amber-600 px-6 text-sm font-medium text-white hover:from-rose-700 hover:to-amber-700 disabled:opacity-60 transition-all shadow-lg shadow-rose-500/25"
          >
            {isLoading
              ? "Se procesează…"
              : mode === "login"
              ? "Autentificare"
              : "Creează cont"}
          </button>
        </form>

        <div className="mt-6 border-t border-zinc-200 pt-6">
          <p className="text-xs text-center text-zinc-600">
            Sau continuă cu{" "}
            <button
              type="button"
              onClick={async () => {
                await signIn("email", {
                  email,
                  callbackUrl: "/app",
                });
              }}
              className="font-medium text-zinc-950 hover:underline"
            >
              link magic pe email
            </button>
          </p>
        </div>
      </main>
    </div>
  );
}
