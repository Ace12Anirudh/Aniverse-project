"use client";

import React, { createContext, useContext, useEffect, useState } from "react";
import { User } from "@/types/auth";
import { authApi } from "@/lib/api";

interface AuthContextType {
  user: User | null;
  isLoading: boolean;
  login: (username: string, password: string) => Promise<void>;
  signup: (username: string, email: string, password: string) => Promise<void>;
  logout: () => void;
  token: string | null;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function useAuth() {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error("useAuth must be used within an AuthProvider");
  }
  return context;
}

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [token, setToken] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const storedToken = localStorage.getItem("token");
    if (storedToken) {
      setToken(storedToken);
      // Verify token and get user data
      authApi.getMe(storedToken)
        .then(setUser)
        .catch(() => {
          localStorage.removeItem("token");
        })
        .finally(() => setIsLoading(false));
    } else {
      setIsLoading(false);
    }
  }, []);

  const login = async (username: string, password: string) => {
    const response = await authApi.login(username, password);
    const newToken = response.access_token;
    
    localStorage.setItem("token", newToken);
    setToken(newToken);
    
    const userData = await authApi.getMe(newToken);
    setUser(userData);
  };

  const signup = async (username: string, email: string, password: string) => {
    const response = await authApi.signup(username, email, password);
    const newToken = response.access_token;
    
    localStorage.setItem("token", newToken);
    setToken(newToken);
    
    const userData = await authApi.getMe(newToken);
    setUser(userData);
  };

  const logout = () => {
    localStorage.removeItem("token");
    setToken(null);
    setUser(null);
  };

  const value = {
    user,
    isLoading,
    login,
    signup,
    logout,
    token,
  };

  return (
    <AuthContext.Provider value={value}>
      {children}
    </AuthContext.Provider>
  );
}
