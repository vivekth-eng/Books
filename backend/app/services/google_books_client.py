import os
import requests
from typing import Optional, Dict, Any

class GoogleBooksClient:
    def __init__(self):
        self.api_key = os.getenv("GOOGLE_API_KEY")
        self.base_url = "https://www.googleapis.com/books/v1/volumes"

    def clean_isbn(self, isbn: Any) -> Optional[str]:
        """Strip dashes, spaces, and normalize ISBN string."""
        if not isbn or str(isbn).strip() == "" or str(isbn).lower() == 'nan':
            return None
        # Keep alphanumeric characters
        cleaned = "".join(c for c in str(isbn) if c.isalnum())
        return cleaned if cleaned else None

    def search_by_isbn(self, isbn: str) -> Optional[Dict[str, Any]]:
        """Query Google Books by ISBN and return parsed volume info."""
        cleaned = self.clean_isbn(isbn)
        if not cleaned:
            return None

        url = self.base_url
        params = {"q": f"isbn:{cleaned}"}
        if self.api_key:
            params["key"] = self.api_key

        try:
            response = requests.get(url, params=params, timeout=12)
            response.raise_for_status()
            data = response.json()
            items = data.get("items", [])
            if items:
                return self._parse_item(items[0])
        except Exception as e:
            print(f"DEBUG: Google Books ISBN search error for '{isbn}': {e}")
        return None

    def search_by_title_and_author(self, title: str, author: str) -> Optional[Dict[str, Any]]:
        """Fallback search using title and author keywords."""
        if not title:
            return None
        
        query = f"intitle:{title}"
        if author:
            # Clean author slightly (take first author if comma-separated)
            first_author = author.split(",")[0].strip()
            query += f" inauthor:{first_author}"
            
        url = self.base_url
        params = {"q": query}
        if self.api_key:
            params["key"] = self.api_key

        try:
            response = requests.get(url, params=params, timeout=12)
            response.raise_for_status()
            data = response.json()
            items = data.get("items", [])
            if items:
                # Find the best match
                return self._parse_item(items[0])
        except Exception as e:
            print(f"DEBUG: Google Books title/author search error for '{title}': {e}")
        return None

    def _parse_item(self, item: Dict[str, Any]) -> Dict[str, Any]:
        """Extract metadata fields from a volume item."""
        volume_info = item.get("volumeInfo", {})
        google_books_id = item.get("id")
        
        title = volume_info.get("title", "")
        
        # Authors list to comma-separated string
        authors_list = volume_info.get("authors", [])
        authors = ", ".join(authors_list) if authors_list else ""
        
        publisher = volume_info.get("publisher", "")
        pages = volume_info.get("pageCount", 0)
        rating = volume_info.get("averageRating", 0.0)
        description = volume_info.get("description", "")
        
        # Publish Year extraction
        published_date = volume_info.get("publishedDate", "")
        publish_year = 0
        if published_date:
            try:
                # Format is typically YYYY-MM-DD or YYYY
                publish_year = int(published_date[:4])
            except:
                pass

        # Cover Image selection (prefer larger sizes if available)
        image_links = volume_info.get("imageLinks", {})
        cover_url = (
            image_links.get("extraLarge") or
            image_links.get("large") or
            image_links.get("medium") or
            image_links.get("thumbnail") or
            image_links.get("smallThumbnail") or
            None
        )

        # Force HTTPs for cover url
        if cover_url and cover_url.startswith("http://"):
            cover_url = cover_url.replace("http://", "https://")

        return {
            "google_books_id": google_books_id,
            "name": title,
            "authors": authors,
            "publisher": publisher,
            "pages": pages,
            "rating": rating,
            "description": description,
            "publish_year": publish_year,
            "cover_url": cover_url
        }
