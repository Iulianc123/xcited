export default function Home() {
  return (
    <div className="min-h-screen bg-zinc-50">
      <header className="mx-auto flex w-full max-w-5xl items-center justify-between px-6 py-6">
        <div className="text-sm font-medium tracking-tight text-zinc-950">xcited</div>
        <a
          className="text-sm font-medium text-zinc-900 hover:text-zinc-950"
          href="/auth"
        >
          Autentificare
        </a>
      </header>

      <main className="mx-auto w-full max-w-5xl px-6 pb-20 pt-10">
        <section className="max-w-2xl">
          <h1 className="text-3xl font-semibold leading-tight tracking-tight text-zinc-950 sm:text-4xl">
            xcited – cunoaștere conștientă pentru relație serioasă
          </h1>
          <p className="mt-5 text-lg leading-8 text-zinc-700">
            Pentru oameni care vor claritate, calm și respect. Fără swipe. Fără
            jocuri. Fără risipă de timp.
          </p>

          <div className="mt-8 flex flex-col gap-3 sm:flex-row">
            <a
              className="inline-flex h-11 items-center justify-center rounded-full bg-zinc-950 px-6 text-sm font-medium text-white hover:bg-zinc-900"
              href="/auth"
            >
              Creează cont
            </a>
            <a
              className="inline-flex h-11 items-center justify-center rounded-full border border-zinc-200 bg-white px-6 text-sm font-medium text-zinc-950 hover:bg-zinc-50"
              href="/auth"
            >
              Autentificare
            </a>
          </div>
        </section>

        <section className="mt-14 grid gap-6 md:grid-cols-2">
          <div className="rounded-2xl border border-zinc-200 bg-white p-6">
            <h2 className="text-sm font-semibold text-zinc-950">Cum funcționează</h2>
            <div className="mt-4 space-y-3 text-sm leading-6 text-zinc-700">
              <p>1) Completezi profilul relațional (obligatoriu).</p>
              <p>2) Primești cel mult 3 conexiuni pe săptămână, pe compatibilitate relațională.</p>
              <p>3) Începeți cu o întrebare profundă. Apoi decideți calm dacă merge mai departe.</p>
            </div>
          </div>

          <div className="rounded-2xl border border-zinc-200 bg-white p-6">
            <h2 className="text-sm font-semibold text-zinc-950">Principiile xcited</h2>
            <div className="mt-4 space-y-3 text-sm leading-6 text-zinc-700">
              <p>Fără swipe și fără opțiuni infinite.</p>
              <p>Fără „small talk” la început – conversația pornește cu o întrebare reală.</p>
              <p>Fără ghosting – dacă nu răspunzi, conexiunea se închide automat.</p>
              <p>Ieșire curată – poți încheia respectuos oricând, fără explicații.</p>
            </div>
          </div>
        </section>
      </main>
    </div>
  );
}
