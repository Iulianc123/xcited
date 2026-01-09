export default function Home() {
  return (
    <div className="min-h-screen bg-gradient-to-b from-zinc-50 via-white to-zinc-50">
      {/* Header */}
      <header className="sticky top-0 z-50 border-b border-zinc-200/50 bg-white/80 backdrop-blur-sm">
        <div className="mx-auto flex w-full max-w-7xl items-center justify-between px-6 py-4">
          <div className="text-lg font-semibold tracking-tight text-zinc-950">
            xcited
          </div>
          <nav className="flex items-center gap-6">
            <a
              className="text-sm font-medium text-zinc-600 transition-colors hover:text-zinc-950"
              href="#cum-functioneaza"
            >
              Cum funcționează
            </a>
            <a
              className="text-sm font-medium text-zinc-600 transition-colors hover:text-zinc-950"
              href="#principii"
            >
              Principii
            </a>
            <a
              className="rounded-full bg-zinc-950 px-5 py-2 text-sm font-medium text-white transition-all hover:bg-zinc-800 hover:shadow-lg"
              href="/auth"
            >
              Autentificare
            </a>
          </nav>
        </div>
      </header>

      <main>
        {/* Hero Section */}
        <section className="relative overflow-hidden px-6 pt-20 pb-32 sm:pt-32 sm:pb-40">
          <div className="absolute inset-0 -z-10 bg-gradient-to-br from-rose-50 via-white to-amber-50 opacity-50" />
          <div className="mx-auto max-w-4xl text-center">
            <div className="mb-6 inline-flex items-center gap-2 rounded-full border border-zinc-200 bg-white/80 px-4 py-1.5 text-xs font-medium text-zinc-700 backdrop-blur-sm">
              <span className="h-2 w-2 rounded-full bg-emerald-500" />
              Platformă pentru relații serioase
            </div>
            <h1 className="text-5xl font-bold tracking-tight text-zinc-950 sm:text-6xl lg:text-7xl">
              Cunoaștere conștientă
              <br />
              <span className="bg-gradient-to-r from-rose-600 to-amber-600 bg-clip-text text-transparent">
                pentru relație serioasă
              </span>
            </h1>
            <p className="mx-auto mt-6 max-w-2xl text-xl leading-8 text-zinc-600 sm:text-2xl">
              Pentru oameni care vor claritate, calm și respect.
              <br />
              <span className="font-medium text-zinc-800">
                Fără swipe. Fără jocuri. Fără risipă de timp.
              </span>
            </p>

            <div className="mt-10 flex flex-col items-center justify-center gap-4 sm:flex-row">
              <a
                className="group relative inline-flex h-14 items-center justify-center overflow-hidden rounded-full bg-gradient-to-r from-rose-600 to-amber-600 px-8 text-base font-semibold text-white shadow-lg shadow-rose-500/25 transition-all hover:scale-105 hover:shadow-xl hover:shadow-rose-500/30"
                href="/auth"
              >
                <span className="relative z-10">Creează cont gratuit</span>
                <div className="absolute inset-0 bg-gradient-to-r from-rose-700 to-amber-700 opacity-0 transition-opacity group-hover:opacity-100" />
              </a>
              <a
                className="inline-flex h-14 items-center justify-center rounded-full border-2 border-zinc-300 bg-white px-8 text-base font-semibold text-zinc-950 transition-all hover:border-zinc-400 hover:bg-zinc-50"
                href="/auth"
              >
                Autentificare
              </a>
            </div>

            {/* Trust Indicators */}
            <div className="mt-12 flex flex-wrap items-center justify-center gap-8 text-sm text-zinc-500">
              <div className="flex items-center gap-2">
                <svg className="h-5 w-5 text-emerald-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                <span>Verificare profil</span>
              </div>
              <div className="flex items-center gap-2">
                <svg className="h-5 w-5 text-emerald-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
                </svg>
                <span>Confidențialitate maximă</span>
              </div>
              <div className="flex items-center gap-2">
                <svg className="h-5 w-5 text-emerald-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
                </svg>
                <span>100% sigur</span>
              </div>
            </div>
          </div>
        </section>

        {/* Stats Section */}
        <section className="border-y border-zinc-200 bg-white py-12">
          <div className="mx-auto max-w-7xl px-6">
            <div className="grid grid-cols-2 gap-8 md:grid-cols-4">
              <div className="text-center">
                <div className="text-3xl font-bold text-zinc-950 sm:text-4xl">3</div>
                <div className="mt-2 text-sm font-medium text-zinc-600">Conexiuni pe săptămână</div>
              </div>
              <div className="text-center">
                <div className="text-3xl font-bold text-zinc-950 sm:text-4xl">100%</div>
                <div className="mt-2 text-sm font-medium text-zinc-600">Fără swipe</div>
              </div>
              <div className="text-center">
                <div className="text-3xl font-bold text-zinc-950 sm:text-4xl">0</div>
                <div className="mt-2 text-sm font-medium text-zinc-600">Ghosting</div>
              </div>
              <div className="text-center">
                <div className="text-3xl font-bold text-zinc-950 sm:text-4xl">∞</div>
                <div className="mt-2 text-sm font-medium text-zinc-600">Respect reciproc</div>
              </div>
            </div>
          </div>
        </section>

        {/* How It Works Section */}
        <section id="cum-functioneaza" className="py-24 px-6">
          <div className="mx-auto max-w-7xl">
            <div className="text-center">
              <h2 className="text-4xl font-bold tracking-tight text-zinc-950 sm:text-5xl">
                Cum funcționează
              </h2>
              <p className="mx-auto mt-4 max-w-2xl text-lg text-zinc-600">
                Un proces simplu, conștient și respectuos
              </p>
            </div>

            <div className="mt-16 grid gap-8 md:grid-cols-3">
              <div className="group relative rounded-2xl border border-zinc-200 bg-white p-8 transition-all hover:border-rose-300 hover:shadow-xl">
                <div className="absolute -top-4 left-8 flex h-12 w-12 items-center justify-center rounded-full bg-gradient-to-br from-rose-500 to-rose-600 text-xl font-bold text-white shadow-lg">
                  1
                </div>
                <h3 className="mt-4 text-xl font-semibold text-zinc-950">
                  Profil relațional
                </h3>
                <p className="mt-3 text-zinc-600 leading-relaxed">
                  Completezi un profil detaliat despre ce cauți într-o relație. Nu doar despre tine, ci despre ce vrei să construiești împreună.
                </p>
              </div>

              <div className="group relative rounded-2xl border border-zinc-200 bg-white p-8 transition-all hover:border-amber-300 hover:shadow-xl">
                <div className="absolute -top-4 left-8 flex h-12 w-12 items-center justify-center rounded-full bg-gradient-to-br from-amber-500 to-amber-600 text-xl font-bold text-white shadow-lg">
                  2
                </div>
                <h3 className="mt-4 text-xl font-semibold text-zinc-950">
                  Conexiuni selectate
                </h3>
                <p className="mt-3 text-zinc-600 leading-relaxed">
                  Primești maximum 3 conexiuni pe săptămână, bazate pe compatibilitate relațională reală, nu pe aparențe.
                </p>
              </div>

              <div className="group relative rounded-2xl border border-zinc-200 bg-white p-8 transition-all hover:border-emerald-300 hover:shadow-xl">
                <div className="absolute -top-4 left-8 flex h-12 w-12 items-center justify-center rounded-full bg-gradient-to-br from-emerald-500 to-emerald-600 text-xl font-bold text-white shadow-lg">
                  3
                </div>
                <h3 className="mt-4 text-xl font-semibold text-zinc-950">
                  Conversație profundă
                </h3>
                <p className="mt-3 text-zinc-600 leading-relaxed">
                  Începeți cu o întrebare reală, nu cu "Hey". Apoi decideți calm și respectuos dacă vreți să continuați.
                </p>
              </div>
            </div>
          </div>
        </section>

        {/* Principles Section */}
        <section id="principii" className="bg-gradient-to-br from-zinc-50 to-white py-24 px-6">
          <div className="mx-auto max-w-7xl">
            <div className="text-center">
              <h2 className="text-4xl font-bold tracking-tight text-zinc-950 sm:text-5xl">
                Principiile xcited
              </h2>
              <p className="mx-auto mt-4 max-w-2xl text-lg text-zinc-600">
                Ce ne face diferiți de restul
              </p>
            </div>

            <div className="mt-16 grid gap-6 md:grid-cols-2 lg:grid-cols-4">
              <div className="rounded-xl border border-zinc-200 bg-white p-6 shadow-sm transition-shadow hover:shadow-md">
                <div className="mb-4 flex h-12 w-12 items-center justify-center rounded-lg bg-rose-100">
                  <svg className="h-6 w-6 text-rose-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                  </svg>
                </div>
                <h3 className="text-lg font-semibold text-zinc-950">Fără swipe</h3>
                <p className="mt-2 text-sm text-zinc-600">
                  Nu judeci oameni după o poză. Fiecare conexiune este aleasă cu grijă.
                </p>
              </div>

              <div className="rounded-xl border border-zinc-200 bg-white p-6 shadow-sm transition-shadow hover:shadow-md">
                <div className="mb-4 flex h-12 w-12 items-center justify-center rounded-lg bg-amber-100">
                  <svg className="h-6 w-6 text-amber-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                </div>
                <h3 className="text-lg font-semibold text-zinc-950">Fără small talk</h3>
                <p className="mt-2 text-sm text-zinc-600">
                  Conversația pornește cu o întrebare reală, nu cu "Ce faci?".
                </p>
              </div>

              <div className="rounded-xl border border-zinc-200 bg-white p-6 shadow-sm transition-shadow hover:shadow-md">
                <div className="mb-4 flex h-12 w-12 items-center justify-center rounded-lg bg-emerald-100">
                  <svg className="h-6 w-6 text-emerald-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                </div>
                <h3 className="text-lg font-semibold text-zinc-950">Fără ghosting</h3>
                <p className="mt-2 text-sm text-zinc-600">
                  Dacă nu răspunzi, conexiunea se închide automat. Fără incertitudine.
                </p>
              </div>

              <div className="rounded-xl border border-zinc-200 bg-white p-6 shadow-sm transition-shadow hover:shadow-md">
                <div className="mb-4 flex h-12 w-12 items-center justify-center rounded-lg bg-blue-100">
                  <svg className="h-6 w-6 text-blue-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
                  </svg>
                </div>
                <h3 className="text-lg font-semibold text-zinc-950">Ieșire curată</h3>
                <p className="mt-2 text-sm text-zinc-600">
                  Poți încheia respectuos oricând, fără explicații sau drame.
                </p>
              </div>
            </div>
          </div>
        </section>

        {/* CTA Section */}
        <section className="py-24 px-6">
          <div className="mx-auto max-w-4xl">
            <div className="relative overflow-hidden rounded-3xl bg-gradient-to-br from-rose-600 via-rose-500 to-amber-600 p-12 text-center shadow-2xl">
              <div className="absolute inset-0 bg-[url('data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNjAiIGhlaWdodD0iNjAiIHZpZXdCb3g9IjAgMCA2MCA2MCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48ZyBmaWxsPSJub25lIiBmaWxsLXJ1bGU9ImV2ZW5vZGQiPjxnIGZpbGw9IiNmZmYiIGZpbGwtb3BhY2l0eT0iMC4xIj48Y2lyY2xlIGN4PSIzMCIgY3k9IjMwIiByPSIyIi8+PC9nPjwvZz48L3N2Zz4=')] opacity-20" />
              <div className="relative z-10">
                <h2 className="text-3xl font-bold text-white sm:text-4xl">
                  Gata să începi o relație serioasă?
                </h2>
                <p className="mx-auto mt-4 max-w-xl text-lg text-rose-50">
                  Alătură-te comunității de oameni care caută conexiuni reale, nu distracții.
                </p>
                <div className="mt-8 flex flex-col items-center justify-center gap-4 sm:flex-row">
                  <a
                    className="inline-flex h-14 items-center justify-center rounded-full bg-white px-8 text-base font-semibold text-rose-600 shadow-lg transition-all hover:scale-105 hover:shadow-xl"
                    href="/auth"
                  >
                    Creează cont gratuit
                  </a>
                  <a
                    className="inline-flex h-14 items-center justify-center rounded-full border-2 border-white/30 bg-white/10 px-8 text-base font-semibold text-white backdrop-blur-sm transition-all hover:bg-white/20"
                    href="/auth"
                  >
                    Autentificare
                  </a>
                </div>
              </div>
            </div>
          </div>
        </section>
      </main>

      {/* Footer */}
      <footer className="border-t border-zinc-200 bg-white py-12 px-6">
        <div className="mx-auto max-w-7xl">
          <div className="flex flex-col items-center justify-between gap-4 sm:flex-row">
            <div className="text-sm font-medium text-zinc-600">
              © 2026 xcited. Toate drepturile rezervate.
            </div>
            <nav className="flex gap-6 text-sm text-zinc-600">
              <a href="#" className="hover:text-zinc-950">Confidențialitate</a>
              <a href="#" className="hover:text-zinc-950">Termeni</a>
              <a href="#" className="hover:text-zinc-950">Contact</a>
            </nav>
          </div>
        </div>
      </footer>
    </div>
  );
}
