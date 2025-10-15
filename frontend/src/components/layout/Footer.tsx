import Link from "next/link";
import { Github, Twitter, Discord } from "lucide-react";

export function Footer() {
  return (
    <footer className="bg-gray-800 border-t border-gray-700">
      <div className="max-w-7xl mx-auto py-8 px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
          {/* About */}
          <div className="col-span-1">
            <div className="flex items-center space-x-2 mb-4">
              <div className="w-8 h-8 bg-gradient-to-r from-purple-500 to-pink-500 rounded-lg flex items-center justify-center">
                <span className="text-white font-bold text-lg">A</span>
              </div>
              <span className="text-white font-bold text-xl">AniVerse</span>
            </div>
            <p className="text-gray-400 text-sm">
              The ultimate destination for anime streaming. Discover, watch, and enjoy
              your favorite anime series and movies in high quality.
            </p>
          </div>

          {/* Browse */}
          <div className="col-span-1">
            <h3 className="text-white font-semibold mb-4">Browse</h3>
            <ul className="space-y-2">
              <li>
                <Link href="/catalog" className="text-gray-400 hover:text-white text-sm transition-colors">
                  All Anime
                </Link>
              </li>
              <li>
                <Link href="/genres" className="text-gray-400 hover:text-white text-sm transition-colors">
                  Genres
                </Link>
              </li>
              <li>
                <Link href="/new-releases" className="text-gray-400 hover:text-white text-sm transition-colors">
                  New Releases
                </Link>
              </li>
              <li>
                <Link href="/popular" className="text-gray-400 hover:text-white text-sm transition-colors">
                  Popular
                </Link>
              </li>
            </ul>
          </div>

          {/* Support */}
          <div className="col-span-1">
            <h3 className="text-white font-semibold mb-4">Support</h3>
            <ul className="space-y-2">
              <li>
                <Link href="/help" className="text-gray-400 hover:text-white text-sm transition-colors">
                  Help Center
                </Link>
              </li>
              <li>
                <Link href="/contact" className="text-gray-400 hover:text-white text-sm transition-colors">
                  Contact Us
                </Link>
              </li>
              <li>
                <Link href="/faq" className="text-gray-400 hover:text-white text-sm transition-colors">
                  FAQ
                </Link>
              </li>
              <li>
                <Link href="/feedback" className="text-gray-400 hover:text-white text-sm transition-colors">
                  Feedback
                </Link>
              </li>
            </ul>
          </div>

          {/* Legal */}
          <div className="col-span-1">
            <h3 className="text-white font-semibold mb-4">Legal</h3>
            <ul className="space-y-2">
              <li>
                <Link href="/privacy" className="text-gray-400 hover:text-white text-sm transition-colors">
                  Privacy Policy
                </Link>
              </li>
              <li>
                <Link href="/terms" className="text-gray-400 hover:text-white text-sm transition-colors">
                  Terms of Service
                </Link>
              </li>
              <li>
                <Link href="/dmca" className="text-gray-400 hover:text-white text-sm transition-colors">
                  DMCA Policy
                </Link>
              </li>
            </ul>
          </div>
        </div>

        <div className="mt-8 pt-8 border-t border-gray-700 flex flex-col md:flex-row justify-between items-center">
          <div className="text-gray-400 text-sm mb-4 md:mb-0">
            © {new Date().getFullYear()} AniVerse. All rights reserved.
          </div>
          
          <div className="flex space-x-4">
            <a
              href="https://github.com"
              className="text-gray-400 hover:text-white transition-colors"
              aria-label="GitHub"
            >
              <Github size={20} />
            </a>
            <a
              href="https://twitter.com"
              className="text-gray-400 hover:text-white transition-colors"
              aria-label="Twitter"
            >
              <Twitter size={20} />
            </a>
            <a
              href="https://discord.com"
              className="text-gray-400 hover:text-white transition-colors"
              aria-label="Discord"
            >
              <Discord size={20} />
            </a>
          </div>
        </div>
      </div>
    </footer>
  );
}
