import type { ReactNode } from "react";

export default function AppLayout({ children }: { children: ReactNode }) {
  return (
    <div className="min-h-screen bg-zinc-50">
      <header className="mx-auto flex w-full max-w-5xl items-center justify-between px-6 py-6">
        <a className="text-sm font-medium tracking-tight text-zinc-950" href="/">
          xcited
        </a>
        <a
          className="text-sm font-medium text-zinc-900 hover:text-zinc-950"
          href="/api/auth/signout"
        >
          Ieșire
        </a>
      </header>
      <main className="mx-auto w-full max-w-5xl px-6 pb-20">{children}</main>
    </div>
  );
}
