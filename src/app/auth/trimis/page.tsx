export default function AuthSentPage() {
  return (
    <div className="min-h-screen bg-zinc-50 px-6 py-16">
      <main className="mx-auto w-full max-w-md rounded-2xl border border-zinc-200 bg-white p-8">
        <h1 className="text-xl font-semibold tracking-tight text-zinc-950">
          Link trimis
        </h1>
        <p className="mt-2 text-sm leading-6 text-zinc-700">
          Am trimis un link de autentificare pe email. Dacă nu îl găsești, verifică și
          Spam/Promotions.
        </p>
        <p className="mt-6 text-xs leading-5 text-zinc-600">
          Link-ul expiră în 15 minute.
        </p>
        <a
          className="mt-8 inline-flex h-11 w-full items-center justify-center rounded-full border border-zinc-200 bg-white px-6 text-sm font-medium text-zinc-950 hover:bg-zinc-50"
          href="/auth"
        >
          Înapoi
        </a>
      </main>
    </div>
  );
}
