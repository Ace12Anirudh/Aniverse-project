from sqlalchemy import (
    Column, String, Text, Integer, Boolean, DateTime, ForeignKey,
    Enum, Table, UniqueConstraint
)
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.db.database import Base
import enum
import uuid


def generate_uuid():
    return str(uuid.uuid4())


class AnimeStatus(enum.Enum):
    AIRING = "Airing"
    FINISHED = "Finished"
    NOT_YET_AIRED = "Not Yet Aired"


# Association table for many-to-many relationship between anime and genres
anime_genres = Table(
    'anime_genres',
    Base.metadata,
    Column('anime_id', String(36), ForeignKey('animes.id', ondelete='CASCADE'), primary_key=True),
    Column('genre_id', Integer, ForeignKey('genres.id', ondelete='CASCADE'), primary_key=True)
)


class User(Base):
    __tablename__ = "users"

    id = Column(String(36), primary_key=True, default=generate_uuid)
    username = Column(String(50), unique=True, nullable=False, index=True)
    email = Column(String(255), unique=True, nullable=False, index=True)
    hashed_password = Column(Text, nullable=False)
    is_admin = Column(Boolean, default=False)
    created_at = Column(DateTime, default=func.current_timestamp())

    # Relationships
    watchlist = relationship("UserWatchlist", back_populates="user", cascade="all, delete-orphan")


class Anime(Base):
    __tablename__ = "animes"

    id = Column(String(36), primary_key=True, default=generate_uuid)
    title = Column(String(255), nullable=False, index=True)
    synopsis = Column(Text)
    cover_image_url = Column(String(1024))  # URL to S3/CloudFront
    release_year = Column(Integer)
    status = Column(Enum(AnimeStatus), default=AnimeStatus.NOT_YET_AIRED)
    created_at = Column(DateTime, default=func.current_timestamp())

    # Relationships
    episodes = relationship("Episode", back_populates="anime", cascade="all, delete-orphan")
    genres = relationship("Genre", secondary=anime_genres, back_populates="animes")
    watchlist_entries = relationship("UserWatchlist", back_populates="anime", cascade="all, delete-orphan")


class Episode(Base):
    __tablename__ = "episodes"

    id = Column(String(36), primary_key=True, default=generate_uuid)
    anime_id = Column(String(36), ForeignKey("animes.id", ondelete="CASCADE"), nullable=False)
    episode_number = Column(Integer, nullable=False)
    title = Column(String(255))
    hls_playlist_url = Column(String(1024))  # URL to the .m3u8 file
    duration_seconds = Column(Integer)
    created_at = Column(DateTime, default=func.current_timestamp())

    # Relationships
    anime = relationship("Anime", back_populates="episodes")

    # Constraints
    __table_args__ = (
        UniqueConstraint('anime_id', 'episode_number', name='unique_anime_episode'),
    )


class Genre(Base):
    __tablename__ = "genres"

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(50), unique=True, nullable=False, index=True)

    # Relationships
    animes = relationship("Anime", secondary=anime_genres, back_populates="genres")


class UserWatchlist(Base):
    __tablename__ = "user_watchlist"

    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), primary_key=True)
    anime_id = Column(String(36), ForeignKey("animes.id", ondelete="CASCADE"), primary_key=True)
    added_at = Column(DateTime, default=func.current_timestamp())

    # Relationships
    user = relationship("User", back_populates="watchlist")
    anime = relationship("Anime", back_populates="watchlist_entries")


class WatchProgress(Base):
    """Track user's watching progress for continue watching feature"""
    __tablename__ = "watch_progress"

    id = Column(String(36), primary_key=True, default=generate_uuid)
    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    episode_id = Column(String(36), ForeignKey("episodes.id", ondelete="CASCADE"), nullable=False)
    progress_seconds = Column(Integer, default=0)  # Current playback position
    completed = Column(Boolean, default=False)  # Whether episode is fully watched
    last_watched = Column(DateTime, default=func.current_timestamp(), onupdate=func.current_timestamp())

    # Relationships
    user = relationship("User")
    episode = relationship("Episode")

    # Constraints
    __table_args__ = (
        UniqueConstraint('user_id', 'episode_id', name='unique_user_episode_progress'),
    )
