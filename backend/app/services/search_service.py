import gc
import time
import threading
import warnings
import logging
from typing import Optional, List, Any

# Suppress pynvml warnings
with warnings.catch_warnings():
    warnings.filterwarnings("ignore", category=FutureWarning)
    try:
        import pynvml
    except ImportError:
        pynvml = None

logger = logging.getLogger("search_service")

class LocalSearchService:
    _instance = None
    _lock = threading.Lock()
    
    def __init__(self):
        self.models: dict[str, Any] = {}
        self.last_used: float = 0.0
        self.cleanup_timeout = 300  # 5 minutes idle cleanup
        
        # Lazy detection of device
        self.device = "cpu"
        try:
            import torch
            if torch.cuda.is_available():
                self.device = "cuda"
        except ImportError:
            pass
            
        self._monitor_thread = threading.Thread(target=self._resource_monitor, daemon=True)
        self._monitor_thread.start()
        logger.info(f"Initialized LocalSearchService on {self.device}")

    @classmethod
    def get_instance(cls) -> "LocalSearchService":
        with cls._lock:
            if cls._instance is None:
                cls._instance = cls()
        return cls._instance

    def _load_model(self, model_name: str = "all-mpnet-base-v2"):
        if model_name not in self.models:
            logger.info(f"Loading SentenceTransformer model: {model_name} on {self.device}")
            from sentence_transformers import SentenceTransformer
            self.models[model_name] = SentenceTransformer(model_name, device=self.device)
        self.last_used = time.time()
        return self.models[model_name]

    def get_embedding(self, text: str, model_name: str = "all-mpnet-base-v2") -> List[float]:
        with self._lock:
            model = self._load_model(model_name)
            embedding = model.encode(text).tolist()
            return embedding

    def _resource_monitor(self):
        while True:
            time.sleep(30)
            if self.models:
                idle_time = time.time() - self.last_used
                if idle_time > self.cleanup_timeout:
                    self._cleanup_resources()
            else:
                # Periodic cache clearing to reclaim VRAM held by PyTorch
                try:
                    import torch
                    if self.device == "cuda" and torch.cuda.is_available():
                        torch.cuda.empty_cache()
                except ImportError:
                    pass

    def _cleanup_resources(self):
        with self._lock:
            if self.models:
                logger.info("Cleaning up idle AI resources...")
                self.models.clear()
                gc.collect()
                
                try:
                    import torch
                    if self.device == "cuda":
                        torch.cuda.empty_cache()
                except ImportError:
                    pass
                logger.info("Resource cleanup complete.")

    def get_gpu_status(self) -> str:
        if self.device != "cuda" or not pynvml:
            return "N/A"
        try:
            pynvml.nvmlInit()
            handle = pynvml.nvmlDeviceGetHandleByIndex(0)
            info = pynvml.nvmlDeviceGetMemoryInfo(handle)
            pynvml.nvmlShutdown()
            return f"Used: {info.used // 1024**2}MB / Total: {info.total // 1024**2}MB"
        except Exception as e:
            return f"Error: {e}"
