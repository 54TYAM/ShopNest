<<<<<<< HEAD
# ShopNest
Ai Customer Support Agent
=======
# ShopNest - Enterprise-Grade AI Shopping Assistant

**ShopNest** is a production-ready, intelligent customer support AI system for e-commerce platforms. It combines **Retrieval-Augmented Generation (RAG)**, **LangChain agent orchestration**, **real-time observability**, and a **FastAPI REST API** to deliver accurate, contextual answers to customer inquiries while seamlessly performing transactional actions like order cancellations and refund initiations.

The system is meticulously architected in **7 modular phases**, each independently testable and deployable. This design ensures scalability, maintainability, and the ability to swap components without rippling changes throughout the codebase.

---

## 📊 Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Tech Stack & Rationale](#tech-stack--rationale)
3. [Detailed Phase Implementation](#detailed-phase-implementation)
4. [Component Alternatives](#component-alternatives)
5. [Data Flow & Integration](#data-flow--integration)
6. [Setup & Deployment](#setup--deployment)
7. [Advanced Features & Observability](#advanced-features--observability)
8. [Extensibility & Future Enhancements](#extensibility--future-enhancements)

---

## 🏗️ Architecture Overview

The application follows a **modular, pipeline-based architecture** where each phase handles a specific concern:

```
┌─────────────────────────────────────────────────────────────────┐
│                    SHOPNEST ARCHITECTURE                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  PHASE 0: DATA INGESTION & CHUNKING                        │ │
│  │  └─► Raw Policy/FAQ Files → Semantic Chunks               │ │
│  └────────────────────────────────────────────────────────────┘ │
│                          ↓                                        │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  PHASE 1-3: VECTORIZATION & STORAGE                        │ │
│  │  └─► Chunks → Embeddings → FAISS Vector DB                │ │
│  └────────────────────────────────────────────────────────────┘ │
│                          ↓                                        │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  PHASE 4-5: RETRIEVAL & RANKING                            │ │
│  │  └─► Query → Semantic Search → Top-K Chunks               │ │
│  └────────────────────────────────────────────────────────────┘ │
│                          ↓                                        │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  PHASE 6: CONTEXT ASSEMBLY                                 │ │
│  │  └─► Retrieved Chunks → Formatted Context                 │ │
│  └────────────────────────────────────────────────────────────┘ │
│                          ↓                                        │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  PHASE 7: LLM RESPONSE GENERATION (RAG Chain)              │ │
│  │  └─► Context + Question → Final Answer                    │ │
│  └────────────────────────────────────────────────────────────┘ │
│                          ↓                                        │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  PHASE 8: AGENT ORCHESTRATION & TOOLS                      │ │
│  │  └─► Intelligently Routes to RAG or Action Tools          │ │
│  │  └─► Tools: Refunds, Cancellations, Tickets, Status       │ │
│  └────────────────────────────────────────────────────────────┘ │
│                          ↓                                        │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  PHASE 9: API LAYER & FRONTEND                             │ │
│  │  └─► FastAPI REST Endpoints                               │ │
│  │  └─► Vanilla HTML/CSS/JS Chat UI                          │ │
│  └────────────────────────────────────────────────────────────┘ │
│                          ↓                                        │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  PHASE 10: OBSERVABILITY & TRACING (Optional)              │ │
│  │  └─► Arize Phoenix → Real-time LLM Insight                │ │
│  │  └─► Tool Execution Metrics & Latency Tracking            │ │
│  └────────────────────────────────────────────────────────────┘ │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🛠️ Tech Stack & Rationale

### **Core Framework**

| Component | Technology | Why Chosen | Alternatives |
|-----------|-----------|-----------|---|
| **LLM Orchestration** | LangChain 0.3+ | Industry standard for agentic AI; excellent tool integration; modular prompt management | LlamaIndex, Haystack, Semantic Kernel |
| **LLM Provider** | Groq (llama-3.3-70b-versatile) | **FREE**, ultra-fast inference (500+ tok/sec), no rate limits for development | OpenAI, Anthropic Claude, HuggingFace Inference, Ollama |
| **Vector Database** | FAISS (Facebook AI) | Lightweight, CPU-only, perfect for up to millions of vectors; offline; no external service | Pinecone, Weaviate, Milvus, Qdrant, Chroma |
| **Embeddings** | Sentence-Transformers (all-MiniLM-L6-v2) | Fast, local, free, 384-dim; no API calls; runs on CPU | OpenAI embeddings, Cohere, HuggingFace Transformers |
| **Web Framework** | FastAPI 0.115+ | Modern async Python; automatic OpenAPI docs; ultra-fast performance | Django, Flask, Quart, Starlette |
| **Server** | Uvicorn | ASGI-compliant; excellent for async FastAPI | Gunicorn + async worker, Hypercorn, Daphne |
| **Chat Memory** | In-Memory Session Store | Thread-safe, no external DB dependency; sufficient for MVP | Redis, MongoDB, PostgreSQL, DynamoDB |

### **Data & Processing**

| Component | Technology | Why Chosen | Alternatives |
|-----------|-----------|-----------|---|
| **Document Processing** | LangChain Text Splitters + Regex | Intelligent semantic chunking; metadata tagging | NLTK, spaCy, PyPDF2 (for PDFs) |
| **Data Format** | Plain Text (.txt) | Easy to edit, version control friendly, no parsing complexity | Markdown, JSON, CSV, YAML, Database |
| **Vector Computation** | PyTorch (CPU) | Efficient matrix operations; enables GPU later | NumPy, TensorFlow, ONNX |

### **Observability & Monitoring**

| Component | Technology | Why Chosen | Alternatives |
|-----------|-----------|-----------|---|
| **Distributed Tracing** | Arize Phoenix | Real-time LLM tracing; free self-hosted version; tool insights | Datadog, New Relic, LangSmith, Weights & Biases |
| **Instrumentation** | OpenInference + LangChain Callbacks | Standards-compliant; minimal code; works with Phoenix | Custom logging, Prometheus, OpenTelemetry |

### **Frontend**

| Component | Technology | Why Chosen | Alternatives |
|-----------|-----------|-----------|---|
| **UI** | Vanilla HTML/CSS/JS | Zero dependencies; instant load; learning-friendly | React, Vue, Svelte, Streamlit |
| **Communication** | Fetch API (HTTP) | Native browser API; no build step | WebSocket, Socket.io, gRPC-Web |

---

## 📚 Detailed Phase Implementation

### **Phase 0-2: Document Ingestion, Chunking & Metadata Tagging**

**File:** `src/ingestion/chunker.py`

#### What It Does:
1. **Reads raw policy & FAQ files** from `data/` directory
2. **Chunks policies intelligently** — splits on section boundaries (marked by `---`)
3. **Chunks FAQs** — one Q&A pair per chunk
4. **Attaches rich metadata** — source, section, category, chunk_type

#### Implementation Details:


```python
# Example Policy File Structure:
# ---------------------------------------------------------------
# 1. REFUND ELIGIBILITY
# ---------------------------------------------------------------
# Eligible items: ...
# 
# ---------------------------------------------------------------
# 2. REFUND PROCESS
# ---------------------------------------------------------------
# Steps: ...

# Output Chunk:
Document(
    page_content="1. REFUND ELIGIBILITY\n\nEligible items: ...",
    metadata={
        "source": "refund_policy",
        # ShopNest - Enterprise-Grade AI Shopping Assistant

        **ShopNest** is a production-ready, intelligent customer support AI system for e-commerce platforms. It combines **Retrieval-Augmented Generation (RAG)**, **LangChain agent orchestration**, **real-time observability**, and a **FastAPI REST API** to deliver accurate, contextual answers to customer inquiries while seamlessly performing transactional actions like order cancellations and refund initiations.

        The system is meticulously architected in **7 modular phases**, each independently testable and deployable. This design ensures scalability, maintainability, and the ability to swap components without rippling changes throughout the codebase.

        ---

        ## 📊 Table of Contents

        1. [Architecture Overview](#architecture-overview)
        2. [Tech Stack & Rationale](#tech-stack--rationale)
        3. [Detailed Phase Implementation](#detailed-phase-implementation)
        4. [Component Alternatives](#component-alternatives)
        5. [Data Flow & Integration](#data-flow--integration)
        6. [Setup & Deployment](#setup--deployment)
        7. [Advanced Features & Observability](#advanced-features--observability)
        8. [Extensibility & Future Enhancements](#extensibility--future-enhancements)

        ---

        ## 🏗️ Architecture Overview

        The application follows a **modular, pipeline-based architecture** where each phase handles a specific concern:

        ```
        ┌─────────────────────────────────────────────────────────────────┐
        │                    SHOPNEST ARCHITECTURE                         │
        ├─────────────────────────────────────────────────────────────────┤
        │                                                                   │
        │  ┌────────────────────────────────────────────────────────────┐ │
        │  │  PHASE 0: DATA INGESTION & CHUNKING                        │ │
        │  │  └─► Raw Policy/FAQ Files → Semantic Chunks               │ │
        │  └────────────────────────────────────────────────────────────┘ │
        │                          ↓                                        │
        │  ┌────────────────────────────────────────────────────────────┐ │
        │  │  PHASE 1-3: VECTORIZATION & STORAGE                        │ │
        │  │  └─► Chunks → Embeddings → FAISS Vector DB                │ │
        │  └────────────────────────────────────────────────────────────┘ │
        │                          ↓                                        │
        │  ┌────────────────────────────────────────────────────────────┐ │
        │  │  PHASE 4-5: RETRIEVAL & RANKING                            │ │
        │  │  └─► Query → Semantic Search → Top-K Chunks               │ │
        │  └────────────────────────────────────────────────────────────┘ │
        │                          ↓                                        │
        │  ┌────────────────────────────────────────────────────────────┐ │
        │  │  PHASE 6: CONTEXT ASSEMBLY                                 │ │
        │  │  └─► Retrieved Chunks → Formatted Context                 │ │
        │  └────────────────────────────────────────────────────────────┘ │
        │                          ↓                                        │
        │  ┌────────────────────────────────────────────────────────────┐ │
        │  │  PHASE 7: LLM RESPONSE GENERATION (RAG Chain)              │ │
        │  │  └─► Context + Question → Final Answer                    │ │
        │  └────────────────────────────────────────────────────────────┘ │
        │                          ↓                                        │
        │  ┌────────────────────────────────────────────────────────────┐ │
        │  │  PHASE 8: AGENT ORCHESTRATION & TOOLS                      │ │
        │  │  └─► Intelligently Routes to RAG or Action Tools          │ │
        │  │  └─► Tools: Refunds, Cancellations, Tickets, Status       │ │
        │  └────────────────────────────────────────────────────────────┘ │
        │                          ↓                                        │
        │  ┌────────────────────────────────────────────────────────────┐ │
        │  │  PHASE 9: API LAYER & FRONTEND                             │ │
        │  │  └─► FastAPI REST Endpoints                               │ │
        │  │  └─► Vanilla HTML/CSS/JS Chat UI                          │ │
        │  └────────────────────────────────────────────────────────────┘ │
        │                          ↓                                        │
        │  ┌────────────────────────────────────────────────────────────┐ │
        │  │  PHASE 10: OBSERVABILITY & TRACING (Optional)              │ │
        │  │  └─► Arize Phoenix → Real-time LLM Insight                │ │
        │  │  └─► Tool Execution Metrics & Latency Tracking            │ │
        │  └────────────────────────────────────────────────────────────┘ │
        │                                                                   │
        └─────────────────────────────────────────────────────────────────┘
        ```

        ---

        ## 🛠️ Tech Stack & Rationale

        ### **Core Framework**

        | Component | Technology | Why Chosen | Alternatives |
        |-----------|-----------|-----------|---|
        | **LLM Orchestration** | LangChain 0.3+ | Industry standard for agentic AI; excellent tool integration; modular prompt management | LlamaIndex, Haystack, Semantic Kernel |
        | **LLM Provider** | Groq (llama-3.3-70b-versatile) | **FREE**, ultra-fast inference (500+ tok/sec), no rate limits for development | OpenAI, Anthropic Claude, HuggingFace Inference, Ollama |
        | **Vector Database** | FAISS (Facebook AI) | Lightweight, CPU-only, perfect for up to millions of vectors; offline; no external service | Pinecone, Weaviate, Milvus, Qdrant, Chroma |
        | **Embeddings** | Sentence-Transformers (all-MiniLM-L6-v2) | Fast, local, free, 384-dim; no API calls; runs on CPU | OpenAI embeddings, Cohere, HuggingFace Transformers |
        | **Web Framework** | FastAPI 0.115+ | Modern async Python; automatic OpenAPI docs; ultra-fast performance | Django, Flask, Quart, Starlette |
        | **Server** | Uvicorn | ASGI-compliant; excellent for async FastAPI | Gunicorn + async worker, Hypercorn, Daphne |
        | **Chat Memory** | In-Memory Session Store | Thread-safe, no external DB dependency; sufficient for MVP | Redis, MongoDB, PostgreSQL, DynamoDB |

        ### **Data & Processing**

        | Component | Technology | Why Chosen | Alternatives |
        |-----------|-----------|-----------|---|
        | **Document Processing** | LangChain Text Splitters + Regex | Intelligent semantic chunking; metadata tagging | NLTK, spaCy, PyPDF2 (for PDFs) |
        | **Data Format** | Plain Text (.txt) | Easy to edit, version control friendly, no parsing complexity | Markdown, JSON, CSV, YAML, Database |
        | **Vector Computation** | PyTorch (CPU) | Efficient matrix operations; enables GPU later | NumPy, TensorFlow, ONNX |

        ### **Observability & Monitoring**

        | Component | Technology | Why Chosen | Alternatives |
        |-----------|-----------|-----------|---|
        | **Distributed Tracing** | Arize Phoenix | Real-time LLM tracing; free self-hosted version; tool insights | Datadog, New Relic, LangSmith, Weights & Biases |
        | **Instrumentation** | OpenInference + LangChain Callbacks | Standards-compliant; minimal code; works with Phoenix | Custom logging, Prometheus, OpenTelemetry |

        ### **Frontend**

        | Component | Technology | Why Chosen | Alternatives |
        |-----------|-----------|-----------|---|
        | **UI** | Vanilla HTML/CSS/JS | Zero dependencies; instant load; learning-friendly | React, Vue, Svelte, Streamlit |
        | **Communication** | Fetch API (HTTP) | Native browser API; no build step | WebSocket, Socket.io, gRPC-Web |

        ---

        ## 📚 Detailed Phase Implementation

        ### **Phase 0-2: Document Ingestion, Chunking & Metadata Tagging**

        **File:** `src/ingestion/chunker.py`

        #### What It Does:
        1. **Reads raw policy & FAQ files** from `data/` directory
        2. **Chunks policies intelligently** — splits on section boundaries (marked by `---`)
        3. **Chunks FAQs** — one Q&A pair per chunk
        4. **Attaches rich metadata** — source, section, category, chunk_type

        #### Implementation Details:

        ```python
        # Example Policy File Structure:
        # ---------------------------------------------------------------
        # 1. REFUND ELIGIBILITY
        # ---------------------------------------------------------------
        # Eligible items: ...
        # 
        # ---------------------------------------------------------------
        # 2. REFUND PROCESS
        # ---------------------------------------------------------------
        # Steps: ...

        # Output Chunk:
        Document(
            page_content="1. REFUND ELIGIBILITY\n\nEligible items: ...",
            metadata={
                "source": "refund_policy",
                "section": "refund_eligibility",
                "category": "refund",
                "chunk_type": "policy_section"
            }
        )
        ```

        #### Key Features:
        - **Regex-based section extraction** — captures numbered sections and their content
        - **Overview preservation** — extracts introductory text before first section
        - **Metadata enrichment** — enables filtering by category later (e.g., "show me only refund policies")
        - **Encoding handling** — UTF-8 safe; handles special characters

        #### How to Extend:
        - Add new file types (e.g., Markdown, YAML) by creating a new `chunk_*_file()` function
        - Modify metadata schema by updating `CATEGORY_MAP` in `src/config.py`
        - Adjust chunk size by changing regex patterns or adding a tokenizer-based splitter

        #### Alternatives:
        | Approach | Pros | Cons |
        |----------|------|------|
        | **LangChain RecursiveCharacterTextSplitter** | Handles arbitrary text, respects token limits | Less control over section semantics |
        | **spaCy Segmenter** | Linguistically aware sentence boundaries | Overkill for structured policy text |
        | **PyPDF2 (if PDFs)** | Handles PDF extraction natively | Slow, unreliable on complex layouts |

        ---

        ## **Phase 3: Embedding & Vector Representation**

        **File:** `src/rag/vectorstore.py`

        #### What It Does:
        1. **Loads the embedding model** (`all-MiniLM-L6-v2`) from HuggingFace once
        2. **Converts each chunk text to a 384-dimensional vector**
        3. **Builds a FAISS index** for similarity search
        4. **Persists the index** to disk (`faiss_index/`)

        #### Implementation Details:

        ```python
        # Embedding Model: all-MiniLM-L6-v2
        # - 22M parameters
        # - 384 dimensions
        # - ~1.3 GB on disk
        # - Inference: ~0.5ms per chunk on CPU
        # - Multilingual support

        # FAISS Index Strategy:
        # - Flat index (brute-force) for accurate retrieval
        # - Suitable for up to ~100M vectors
        # - Serialized as index.faiss + index.pkl

        embeddings = HuggingFaceEmbeddings(
            model_name="all-MiniLM-L6-v2",
            model_kwargs={"device": "cuda" if available else "cpu"},
            encode_kwargs={"normalize_embeddings": True}
        )

        vectorstore = FAISS.from_documents(docs, embeddings)
        vectorstore.save_local("faiss_index/")
        ```

        (content truncated)
```

### Implement Caching:
- In-memory with `@lru_cache`
- Redis with 24-hour expiry
- Database-backed for persistence

---

## 📊 Performance Tuning

### Latency Targets:
| Component | Current (ms) | Target (ms) |
|-----------|------|------|
| Embedding query | 5-10 | <10 |
| FAISS search | 2-5 | <5 |
| Context assembly | 5-10 | <10 |
| LLM call | 200-500 | <1000 |
| Tool execution | 50-200 | <500 |
| Total end-to-end | 300-800 | <2000 |

### Optimization Strategies:
- Batch embeddings (32+ at once)
- Use GPU if available (CUDA)
- Reduce context window (k=1 instead of k=3)
- Implement response caching
- Compress context with LLM summarization
- Run tools in parallel with async

### Cost Optimization:
- **Groq:** FREE tier for development/testing
- **Saves vs OpenAI:** ~$5,500/month for 1K queries/day
- **Cache popular queries** to reduce LLM calls by 20-40%

---

## 📝 Quick Reference Commands

```bash
python build_index.py                    # Build vector index
python run_api.py                        # Run API server
python -m phoenix.server.main serve      # Start Phoenix tracing
python -c "from src.agent.shop_agent import build_shop_agent; ..." # Test agent
pip list | grep langchain               # Check dependencies

# API Test
curl -X POST http://localhost:8000/chat \
  -H "Content-Type: application/json" \
  -d '{"session_id": "test-user-1", "message": "Can I return my order?"}'
```

---

## 🎓 Learning Path

**Beginners:** Read chunker → RAG chain → agent  
**Intermediate:** Modify config → add tool → experiment with TOP_K  
**Advanced:** Custom embeddings → hybrid search → A/B testing → Kubernetes  

---

## 📞 Support

- **API Docs:** http://localhost:8000/docs (Swagger UI)
- **Groq Console:** https://console.groq.com
- **LangChain Docs:** https://python.langchain.com
- **FAISS Docs:** https://github.com/facebookresearch/faiss

---

**ShopNest v4.0.0** — Enterprise AI for E-Commerce  
Built with LangChain, FAISS, Groq, and FastAPI.
>>>>>>> 32f5681 (Prepare for deployment)
