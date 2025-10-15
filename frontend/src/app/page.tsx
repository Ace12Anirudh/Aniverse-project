"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import { Play, Plus, Info } from "lucide-react";
import { motion } from "framer-motion";
import { animeApi } from "@/lib/api";
import { Anime } from "@/types/anime";

export default function HomePage() {
  const [featuredAnimes, setFeaturedAnimes] = useState<Anime[]>([]);
  const [newReleases, setNewReleases] = useState<Anime[]>([]);
  const [popularAnimes, setPopularAnimes] = useState<Anime[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const loadData = async () => {
      try {
        // For now, we'll create some mock data since the API isn't running yet
        const mockAnimes: Anime[] = [
          {
            id: "1",
            title: "Attack on Titan",
            synopsis: "When man-eating Titans first appeared 100 years ago, humans found safety behind massive walls that stopped the giants in their tracks.",
            cover_image_url: "https://via.placeholder.com/300x400?text=AOT",
            release_year: 2013,
            status: "Airing" as any,
            created_at: "2023-01-01",
            genres: [{ id: 1, name: "Action" }, { id: 2, name: "Drama" }]
          },
          {
            id: "2",
            title: "Demon Slayer",
            synopsis: "A family is attacked by demons and only two members survive - Tanjiro and his sister Nezuko, who is turning into a demon slowly.",
            cover_image_url: "https://via.placeholder.com/300x400?text=DS",
            release_year: 2019,
            status: "Finished" as any,
            created_at: "2023-01-01",
            genres: [{ id: 1, name: "Action" }, { id: 3, name: "Supernatural" }]
          }
        ];
        
        setFeaturedAnimes(mockAnimes);
        setNewReleases(mockAnimes);
        setPopularAnimes(mockAnimes);
      } catch (error) {
        console.error("Failed to load homepage data:", error);
      } finally {
        setIsLoading(false);
      }
    };

    loadData();
  }, []);

  if (isLoading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-purple-500"></div>
      </div>
    );
  }

  return (
    <div className="min-h-screen">
      {/* Hero Section */}
      <section className="relative h-screen bg-gradient-to-r from-purple-900 via-blue-900 to-indigo-900">
        <div className="absolute inset-0 bg-black bg-opacity-50"></div>
        <div className="relative z-10 flex items-center justify-center h-full">
          <div className="text-center max-w-4xl px-4">
            <motion.h1
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 1 }}
              className="text-5xl md:text-7xl font-bold text-white mb-6"
            >
              Welcome to <span className="bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent">AniVerse</span>
            </motion.h1>
            <motion.p
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 1, delay: 0.2 }}
              className="text-xl md:text-2xl text-gray-300 mb-8"
            >
              Stream your favorite anime series and movies in stunning quality
            </motion.p>
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 1, delay: 0.4 }}
              className="flex flex-col sm:flex-row gap-4 justify-center"
            >
              <Link
                href="/catalog"
                className="bg-purple-600 hover:bg-purple-700 text-white px-8 py-4 rounded-lg text-lg font-semibold transition-colors flex items-center gap-2"
              >
                <Play size={24} />
                Start Watching
              </Link>
              <Link
                href="/signup"
                className="border-2 border-white text-white hover:bg-white hover:text-purple-600 px-8 py-4 rounded-lg text-lg font-semibold transition-colors"
              >
                Sign Up Free
              </Link>
            </motion.div>
          </div>
        </div>
      </section>

      {/* Content Sections */}
      <div className="space-y-12 py-8">
        {/* Featured Section */}
        <section className="px-4 sm:px-6 lg:px-8">
          <div className="max-w-7xl mx-auto">
            <div className="flex items-center justify-between mb-6">
              <h2 className="text-2xl font-bold text-white">Featured Anime</h2>
              <Link
                href="/catalog"
                className="text-purple-400 hover:text-purple-300 font-medium"
              >
                View All
              </Link>
            </div>
            <div className="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-4">
              {featuredAnimes.map((anime) => (
                <motion.div
                  key={anime.id}
                  whileHover={{ scale: 1.05 }}
                  className="bg-gray-800 rounded-lg overflow-hidden shadow-lg"
                >
                  <div className="aspect-[3/4] bg-gradient-to-br from-purple-500 to-pink-500 flex items-center justify-center">
                    <span className="text-white font-bold text-lg">{anime.title.slice(0, 3)}</span>
                  </div>
                  <div className="p-3">
                    <h3 className="text-white font-semibold text-sm truncate">{anime.title}</h3>
                    <p className="text-gray-400 text-xs">{anime.release_year}</p>
                  </div>
                </motion.div>
              ))}
            </div>
          </div>
        </section>

        {/* Call to Action */}
        <section className="px-4 sm:px-6 lg:px-8 py-16">
          <div className="max-w-4xl mx-auto text-center">
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.8 }}
              className="bg-gradient-to-r from-purple-600 to-pink-600 rounded-2xl p-12"
            >
              <h3 className="text-3xl font-bold text-white mb-4">
                Ready to Start Watching?
              </h3>
              <p className="text-lg text-gray-200 mb-8">
                Join thousands of anime fans and discover your next favorite series.
                Create your account today and start your anime journey!
              </p>
              <div className="flex flex-col sm:flex-row gap-4 justify-center">
                <Link
                  href="/signup"
                  className="bg-white text-purple-600 px-8 py-3 rounded-lg font-semibold hover:bg-gray-100 transition-colors"
                >
                  Get Started Free
                </Link>
                <Link
                  href="/catalog"
                  className="border-2 border-white text-white px-8 py-3 rounded-lg font-semibold hover:bg-white hover:text-purple-600 transition-colors"
                >
                  Browse Catalog
                </Link>
              </div>
            </motion.div>
          </div>
        </section>
      </div>
    </div>
  );
}
