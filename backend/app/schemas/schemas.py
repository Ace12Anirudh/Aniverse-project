from typing import List, Optional
from pydantic import BaseModel, EmailStr
from datetime import datetime
from app.models.models import AnimeStatus


# Base schemas
class UserBase(BaseModel):
    username: str
    email: EmailStr


class UserCreate(UserBase):
    password: str


class UserLogin(BaseModel):
    username: str
    password: str


class User(UserBase):
    id: str
    is_admin: bool
    created_at: datetime

    class Config:
        from_attributes = True


class UserInDB(User):
    hashed_password: str


# Token schemas
class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseModel):
    username: Optional[str] = None


# Genre schemas
class GenreBase(BaseModel):
    name: str


class GenreCreate(GenreBase):
    pass


class Genre(GenreBase):
    id: int

    class Config:
        from_attributes = True


# Episode schemas
class EpisodeBase(BaseModel):
    episode_number: int
    title: Optional[str] = None
    duration_seconds: Optional[int] = None


class EpisodeCreate(EpisodeBase):
    anime_id: str


class EpisodeUpdate(BaseModel):
    title: Optional[str] = None
    hls_playlist_url: Optional[str] = None
    duration_seconds: Optional[int] = None


class Episode(EpisodeBase):
    id: str
    anime_id: str
    hls_playlist_url: Optional[str] = None
    created_at: datetime

    class Config:
        from_attributes = True


# Anime schemas
class AnimeBase(BaseModel):
    title: str
    synopsis: Optional[str] = None
    cover_image_url: Optional[str] = None
    release_year: Optional[int] = None
    status: AnimeStatus = AnimeStatus.NOT_YET_AIRED


class AnimeCreate(AnimeBase):
    genre_ids: List[int] = []


class AnimeUpdate(BaseModel):
    title: Optional[str] = None
    synopsis: Optional[str] = None
    cover_image_url: Optional[str] = None
    release_year: Optional[int] = None
    status: Optional[AnimeStatus] = None
    genre_ids: Optional[List[int]] = None


class Anime(AnimeBase):
    id: str
    created_at: datetime
    genres: List[Genre] = []

    class Config:
        from_attributes = True


class AnimeWithEpisodes(Anime):
    episodes: List[Episode] = []


class AnimeListResponse(BaseModel):
    animes: List[Anime]
    total: int
    page: int
    per_page: int
    has_next: bool


# Watchlist schemas
class WatchlistAdd(BaseModel):
    anime_id: str


class WatchlistItem(BaseModel):
    anime: Anime
    added_at: datetime

    class Config:
        from_attributes = True


# Watch progress schemas
class WatchProgressCreate(BaseModel):
    episode_id: str
    progress_seconds: int


class WatchProgressUpdate(BaseModel):
    progress_seconds: Optional[int] = None
    completed: Optional[bool] = None


class WatchProgress(BaseModel):
    id: str
    user_id: str
    episode_id: str
    progress_seconds: int
    completed: bool
    last_watched: datetime

    class Config:
        from_attributes = True


# Admin schemas
class AdminStats(BaseModel):
    total_users: int
    total_animes: int
    total_episodes: int
    total_genres: int
    recent_signups: int
    popular_animes: List[dict]


# Upload schemas
class PresignedUploadResponse(BaseModel):
    upload_url: str
    fields: dict
    key: str


class MediaProcessingRequest(BaseModel):
    s3_key: str
    episode_id: str


# Search and filter schemas
class AnimeSearchParams(BaseModel):
    query: Optional[str] = None
    genres: Optional[List[int]] = None
    status: Optional[AnimeStatus] = None
    release_year: Optional[int] = None
    page: int = 1
    per_page: int = 20
