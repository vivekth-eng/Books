import os
import sys
from pathlib import Path
from sqlalchemy import text
from app.core.database import engine, Session

def reconcile():
    current_dir = Path(__file__).resolve().parent
    covers_dir = current_dir.parent / "assets" / "covers"
    
    if not covers_dir.exists():
        print(f"Error: Covers directory {covers_dir} does not exist.")
        sys.exit(1)
        
    print(f"Scanning covers in: {covers_dir}")
    files = [f for f in os.listdir(covers_dir) if f.lower().endswith(('.jpg', '.jpeg', '.png'))]
    print(f"Found {len(files)} cover files on disk.")
    
    updated_count = 0
    not_found_count = 0
    
    with Session(engine) as session:
        for filename in files:
            # Parse Title and ISBN from filename
            name_without_ext, _ = os.path.splitext(filename)
            parts = name_without_ext.split('_')
            if not parts:
                continue
                
            isbn = parts[-1].strip()
            
            # Resolve float truncation anomalies (e.g. '9780451205766' vs '9780451205766.0')
            if isbn.endswith(".0"):
                isbn_clean = isbn[:-2]
            else:
                isbn_clean = isbn
                
            isbn_with_dot_zero = isbn_clean + ".0"
            
            # Execute UPDATE statement matching either variation of ISBN
            local_path = f"/assets/covers/{filename}"
            query = text("""
                UPDATE book 
                SET cover_name = :filename, cover_local_path = :local_path
                WHERE isbn = :isbn_clean OR isbn = :isbn_with_dot_zero
                RETURNING id;
            """)
            
            result = session.execute(query, {
                "filename": filename,
                "local_path": local_path,
                "isbn_clean": isbn_clean,
                "isbn_with_dot_zero": isbn_with_dot_zero
            })
            
            updated_rows = result.fetchall()
            if updated_rows:
                updated_count += len(updated_rows)
            else:
                not_found_count += 1
                
        session.commit()
        
    print("\nReconciliation Summary:")
    print(f"-> Successfully linked {updated_count} books in the database to physical cover assets.")
    print(f"-> {not_found_count} covers on disk did not match any book records in the database.")

if __name__ == "__main__":
    reconcile()
