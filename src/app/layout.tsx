import type { Metadata } from "next";
import { Geist, Geist_Mono } from "next/font/google";
import "./globals.css";

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: "xcited – cunoaștere conștientă pentru relație serioasă",
  description:
    "xcited este o platformă pentru conexiune conștientă care poate duce la o relație serioasă. Fără swipe. Fără jocuri. Fără risipă de timp.",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="ro">
      <body
        className={`${geistSans.variable} ${geistMono.variable} antialiased bg-white text-zinc-950`}
      >
        {children}
      </body>
    </html>
  );
}
