export enum AnimeStatus {
  AIRING = "Airing",
  FINISHED = "Finished",
  NOT_YET_AIRED = "Not Yet Aired",
}

export interface Genre {
  id: number;
  name: string;
}

export interface Episode {
  id: string;
  anime_id: string;
  episode_number: number;
  title?: string;
  hls_playlist_url?: string;
  duration_seconds?: number;
  created_at: string;
}

export interface Anime {
  id: string;
  title: string;
  synopsis?: string;
  cover_image_url?: string;
  release_year?: number;
  status: AnimeStatus;
  created_at: string;
  genres: Genre[];
}

export interface AnimeWithEpisodes extends Anime {
  episodes: Episode[];
}

export interface AnimeListResponse {
  animes: Anime[];
  total: number;
  page: number;
  per_page: number;
  has_next: boolean;
}

export interface AnimeSearchParams {
  query?: string;
  genres?: number[];
  status?: AnimeStatus;
  release_year?: number;
  page?: number;
  per_page?: number;
}

export interface WatchlistItem {
  anime: Anime;
  added_at: string;
}

export interface WatchProgress {
  id: string;
  user_id: string;
  episode_id: string;
  progress_seconds: number;
  completed: boolean;
  last_watched: string;
}
