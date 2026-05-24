<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Проводник — Defency Helper</title>
    <style>
        :root {
            --bg: #f0f0f0;
            --sidebar-bg: #fafafa;
            --titlebar: #0078d4;
            --titlebar-inactive: #e0e0e0;
            --border: #d1d1d1;
            --hover: #e5f3ff;
            --selected: #cce4f7;
            --text: #1a1a1a;
            --muted: #666;
            --address-bg: #f5f5f5;
            --taskbar: #e8e8e8;
            --accent: #0078d4;
            --ribbon-bg: #fafafa;
            --card-white: #fff;
            --danger: #c42b1c;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', 'Segoe UI Variable', system-ui, -apple-system, sans-serif;
            background: #e8ecf1;
            height: 100vh;
            display: flex;
            flex-direction: column;
            color: var(--text);
            user-select: none;
            background-image: linear-gradient(135deg, #e8ecf1 0%, #dce1e7 100%);
        }

        .titlebar {
            background: var(--titlebar);
            color: white;
            padding: 0 12px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 12px;
            font-weight: 400;
            flex-shrink: 0;
        }
        .titlebar-left { display: flex; align-items: center; gap: 8px; }
        .titlebar-icon { width: 16px; height: 16px; font-size: 14px; }
        .titlebar-title { opacity: 0.95; }
        .titlebar-controls { display: flex; gap: 2px; }
        .titlebar-btn {
            width: 46px; height: 32px; border: none; background: transparent;
            color: white; font-size: 10px; cursor: pointer;
            display: flex; align-items: center; justify-content: center;
            transition: background 0.1s;
        }
        .titlebar-btn:hover { background: rgba(255,255,255,0.15); }
        .titlebar-btn.close:hover { background: var(--danger); }

        .ribbon {
            background: var(--ribbon-bg);
            border-bottom: 1px solid var(--border);
            padding: 4px 8px;
            display: flex; gap: 2px; flex-shrink: 0; flex-wrap: wrap;
        }
        .ribbon-tab {
            padding: 6px 14px; font-size: 13px; cursor: pointer;
            border-radius: 4px 4px 0 0; color: var(--text);
            transition: background 0.15s; position: relative;
        }
        .ribbon-tab:hover { background: #e8e8e8; }
        .ribbon-tab.active {
            background: white; border: 1px solid var(--border);
            border-bottom: 2px solid var(--accent); font-weight: 600; margin-bottom: -1px;
        }
        .ribbon-actions { display: flex; gap: 4px; padding: 6px 0; align-items: center; }
        .ribbon-btn {
            display: flex; flex-direction: column; align-items: center;
            padding: 4px 10px; border: 1px solid transparent;
            background: transparent; cursor: pointer; border-radius: 4px;
            font-size: 11px; color: var(--text); min-width: 48px; transition: all 0.1s;
        }
        .ribbon-btn:hover { background: #e5e5e5; border-color: #ccc; }
        .ribbon-btn .icon { font-size: 18px; margin-bottom: 2px; }

        .address-bar {
            display: flex; align-items: center; background: white;
            border-bottom: 1px solid var(--border); padding: 4px 8px;
            gap: 8px; flex-shrink: 0;
        }
        .address-btns { display: flex; gap: 1px; }
        .address-btns button {
            width: 28px; height: 24px; border: 1px solid transparent;
            background: transparent; cursor: pointer; border-radius: 3px;
            font-size: 12px; color: #666; transition: all 0.1s;
        }
        .address-btns button:hover { background: #e5e5e5; border-color: #ccc; }
        .address-btns button:disabled { opacity: 0.35; cursor: default; }
        .address-path {
            flex: 1; background: var(--address-bg); border: 1px solid var(--border);
            border-radius: 4px; padding: 4px 10px; font-size: 13px;
            display: flex; align-items: center; gap: 4px; min-width: 0;
        }
        .path-segment {
            padding: 2px 6px; border-radius: 3px; cursor: pointer; white-space: nowrap;
        }
        .path-segment:hover { background: #dce1e7; }
        .path-arrow { color: #999; font-size: 10px; }
        .path-segment.current { font-weight: 600; background: #e5f3ff; }
        .search-box {
            width: 220px; padding: 4px 10px; border: 1px solid var(--border);
            border-radius: 4px; font-size: 13px; font-family: inherit; outline: none;
            transition: border 0.2s;
        }
        .search-box:focus {
            border-color: var(--accent); box-shadow: 0 0 0 1px rgba(0,120,212,0.2);
        }

        .main { display: flex; flex: 1; overflow: hidden; }

        .sidebar {
            width: 220px; background: var(--sidebar-bg);
            border-right: 1px solid var(--border); display: flex;
            flex-direction: column; flex-shrink: 0; overflow-y: auto;
        }
        .sidebar-section { padding: 8px 0; }
        .sidebar-title {
            padding: 8px 16px 4px; font-size: 11px; font-weight: 600;
            color: #555; text-transform: uppercase; letter-spacing: 0.5px;
        }
        .sidebar-item {
            display: flex; align-items: center; gap: 10px;
            padding: 8px 16px; cursor: pointer; font-size: 13px;
            transition: background 0.1s; border-left: 3px solid transparent;
        }
        .sidebar-item:hover { background: var(--hover); }
        .sidebar-item.active { background: var(--selected); border-left-color: var(--accent); font-weight: 500; }
        .sidebar-item .icon { font-size: 18px; width: 22px; text-align: center; }
        .sidebar-separator { height: 1px; background: var(--border); margin: 4px 12px; }

        .content {
            flex: 1; background: white; overflow-y: auto; padding: 16px;
            display: flex; flex-direction: column;
        }
        .content-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 12px; padding-bottom: 8px; border-bottom: 1px solid #eee;
        }
        .content-header h2 { font-size: 14px; font-weight: 500; color: #555; }
        .view-toggle { display: flex; gap: 2px; }
        .view-btn {
            padding: 4px 10px; border: 1px solid #ccc; background: white;
            cursor: pointer; font-size: 14px; border-radius: 3px; transition: all 0.1s;
        }
        .view-btn:hover { background: #e5e5e5; }
        .view-btn.active { background: var(--accent); color: white; border-color: var(--accent); }
        .files-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(100px, 1fr));
            gap: 10px;
        }
        .files-grid.list-view {
            grid-template-columns: 1fr;
            gap: 2px;
        }
        .file-item {
            display: flex; flex-direction: column; align-items: center;
            padding: 14px 8px; border-radius: 6px; cursor: pointer;
            transition: all 0.1s; text-align: center; border: 2px solid transparent;
            position: relative;
        }
        .files-grid.list-view .file-item {
            flex-direction: row; gap: 12px; padding: 8px 12px;
            text-align: left; align-items: center; border-radius: 2px;
        }
        .file-item:hover { background: var(--hover); border-color: #d0e4f7; }
        .file-item.selected { background: var(--selected); border-color: var(--accent); }
        .file-item .file-icon {
            font-size: 40px; margin-bottom: 6px; transition: transform 0.2s;
        }
        .files-grid.list-view .file-item .file-icon {
            font-size: 24px; margin-bottom: 0; min-width: 32px; text-align: center;
        }
        .file-item:hover .file-icon { transform: scale(1.08); }
        .files-grid.list-view .file-item:hover .file-icon { transform: scale(1.15); }
        .file-item .file-name {
            font-size: 12px; line-height: 1.3; word-break: break-word; max-width: 90px;
        }
        .files-grid.list-view .file-item .file-name {
            max-width: none; flex: 1; font-size: 13px;
        }
        .file-item .file-meta {
            font-size: 10px; color: var(--muted); margin-top: 2px;
        }
        .files-grid.list-view .file-item .file-meta {
            font-size: 11px; min-width: 60px; text-align: right;
        }
        .loading-spinner {
            display: flex; align-items: center; justify-content: center;
            padding: 40px; color: var(--muted); font-size: 14px; gap: 10px;
            grid-column: 1 / -1;
        }
        .spinner {
            width: 24px; height: 24px; border: 3px solid #e0e0e0;
            border-top-color: var(--accent); border-radius: 50%;
            animation: spin 0.8s linear infinite;
        }
        @keyframes spin { to { transform: rotate(360deg); } }

        .statusbar {
            background: var(--sidebar-bg); border-top: 1px solid var(--border);
            padding: 3px 12px; font-size: 12px; color: var(--muted);
            display: flex; justify-content: space-between; flex-shrink: 0;
        }

        .taskbar {
            background: var(--taskbar); border-top: 1px solid #d0d0d0;
            height: 44px; display: flex; align-items: center;
            padding: 0 8px; gap: 4px; flex-shrink: 0;
        }
        .taskbar-start {
            width: 40px; height: 36px; border: none; background: transparent;
            cursor: pointer; font-size: 20px; border-radius: 4px;
            transition: background 0.1s; display: flex;
            align-items: center; justify-content: center;
        }
        .taskbar-start:hover { background: #d5d5d5; }
        .taskbar-app {
            height: 36px; padding: 0 12px; border: none; background: transparent;
            cursor: pointer; font-size: 12px; border-radius: 4px;
            display: flex; align-items: center; gap: 6px;
            transition: all 0.1s; border-bottom: 2px solid transparent;
        }
        .taskbar-app:hover { background: #ddd; }
        .taskbar-app.active { background: #d0d0d0; border-bottom-color: var(--accent); }
        .taskbar-right { margin-left: auto; display: flex; align-items: center; gap: 6px; font-size: 12px; color: #333; }
        .taskbar-clock { padding: 4px 8px; border-radius: 4px; cursor: default; }
        .taskbar-clock:hover { background: #ddd; }

        ::-webkit-scrollbar { width: 8px; height: 8px; }
        ::-webkit-scrollbar-track { background: #f5f5f5; }
        ::-webkit-scrollbar-thumb { background: #c1c1c1; border-radius: 4px; }
        ::-webkit-scrollbar-thumb:hover { background: #a1a1a1; }

        .breadcrumb-nav {
            display: flex; align-items: center; gap: 2px; flex-wrap: wrap;
        }

        /* File Viewer Modal */
        .file-viewer {
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            z-index: 9999;
            display: none;
            align-items: center;
            justify-content: center;
        }
        .file-viewer-overlay {
            position: absolute;
            top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0,0,0,0.5);
            backdrop-filter: blur(2px);
        }
        .file-viewer-window {
            position: relative;
            width: 85%;
            max-width: 900px;
            height: 80%;
            background: #1e1e1e;
            border-radius: 10px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.4);
            display: flex;
            flex-direction: column;
            overflow: hidden;
            animation: viewerIn 0.2s ease;
        }
        @keyframes viewerIn {
            from { opacity: 0; transform: scale(0.95) translateY(-10px); }
            to { opacity: 1; transform: scale(1) translateY(0); }
        }
        .file-viewer-titlebar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 8px 16px;
            background: #2d2d2d;
            color: #ccc;
            font-size: 13px;
            border-bottom: 1px solid #444;
        }
        .file-viewer-titlebar button {
            background: transparent;
            border: 1px solid #555;
            color: #ccc;
            padding: 4px 10px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            transition: all 0.1s;
        }
        .file-viewer-titlebar button:hover {
            background: #444;
            color: white;
        }
        .file-viewer-content {
            flex: 1;
            overflow: auto;
            padding: 16px;
        }
        .file-viewer-content pre {
            margin: 0;
            font-family: 'Cascadia Code', 'Fira Code', 'JetBrains Mono', 'Consolas', monospace;
            font-size: 13px;
            line-height: 1.5;
            color: #d4d4d4;
            white-space: pre-wrap;
            word-break: break-all;
        }
        .file-viewer-content code {
            background: transparent;
            padding: 0;
        }
        .file-viewer-status {
            padding: 4px 16px;
            background: #007acc;
            color: white;
            font-size: 11px;
            text-align: right;
        }
    </style>
</head>
<body>

    <!-- Title Bar -->
    <div class="titlebar">
        <div class="titlebar-left">
            <span class="titlebar-icon">📁</span>
            <span class="titlebar-title">Проводник — Defency Helper</span>
        </div>
        <div class="titlebar-controls">
            <button class="titlebar-btn">─</button>
            <button class="titlebar-btn">□</button>
            <button class="titlebar-btn close">✕</button>
        </div>
    </div>

    <!-- Ribbon -->
    <div class="ribbon">
        <div class="ribbon-tab active">Главная</div>
        <div class="ribbon-tab">Поделиться</div>
        <div class="ribbon-tab">Вид</div>
        <div style="flex:1"></div>
        <div class="ribbon-actions">
            <button class="ribbon-btn" onclick="refreshFiles()" title="Обновить">
                <span class="icon">🔄</span> Обновить
            </button>
            <button class="ribbon-btn" onclick="window.open(REPO_URL, '_blank')" title="Открыть на GitHub">
                <span class="icon">🐙</span> GitHub
            </button>
        </div>
    </div>

    <!-- Address Bar -->
    <div class="address-bar">
        <div class="address-btns">
            <button id="btnBack" disabled title="Назад">◀</button>
            <button id="btnForward" disabled title="Вперёд">▶</button>
            <button id="btnUp" title="Вверх" onclick="navigateUp()">▲</button>
            <button title="Обновить" onclick="refreshFiles()">↻</button>
        </div>
        <div class="address-path" id="addressPath">
            <span class="breadcrumb-nav" id="breadcrumbNav">
                <span class="path-segment" onclick="navigateTo('')">🏠 root</span>
            </span>
        </div>
        <input class="search-box" id="searchBox" type="text" placeholder="🔍 Поиск в папке..." oninput="filterFiles()">
    </div>

    <!-- Main Layout -->
    <div class="main">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-section">
                <div class="sidebar-title">Навигация</div>
                <div class="sidebar-item active" data-path="" onclick="navigateTo('')">
                    <span class="icon">🏠</span> Корень проекта
                </div>
                <div class="sidebar-item" data-path="src" onclick="navigateTo('src')">
                    <span class="icon">📁</span> src
                </div>
                <div class="sidebar-item" data-path="assets" onclick="navigateTo('assets')">
                    <span class="icon">🎨</span> assets
                </div>
                <div class="sidebar-item" data-path="docs" onclick="navigateTo('docs')">
                    <span class="icon">📚</span> docs
                </div>
                <div class="sidebar-item" data-path="components" onclick="navigateTo('components')">
                    <span class="icon">🧩</span> components
                </div>
            </div>
            <div class="sidebar-separator"></div>
            <div class="sidebar-section">
                <div class="sidebar-title">Ссылки</div>
                <div class="sidebar-item" onclick="window.open(REPO_URL, '_blank')">
                    <span class="icon">🐙</span> Репозиторий
                </div>
                <div class="sidebar-item" onclick="window.open('https://pages.github.com', '_blank')">
                    <span class="icon">🌐</span> GitHub Pages
                </div>
            </div>
        </div>

        <!-- Content Area -->
        <div class="content">
            <div class="content-header">
                <h2 id="currentFolderLabel">📂 Содержимое папки</h2>
                <div class="view-toggle">
                    <button class="view-btn active" onclick="setView('grid')" title="Крупные значки">🔲</button>
                    <button class="view-btn" onclick="setView('list')" title="Таблица">📋</button>
                </div>
            </div>
            <div class="files-grid" id="filesGrid">
                <div class="loading-spinner">
                    <div class="spinner"></div>
                    Загрузка файлов...
                </div>
            </div>
        </div>
    </div>

    <!-- Status Bar -->
    <div class="statusbar">
        <span id="statusCount">Загрузка...</span>
        <span id="statusSelected">Выбрано: 0 элементов</span>
    </div>

    <!-- Taskbar -->
    <div class="taskbar">
        <button class="taskbar-start" title="Пуск">🪟</button>
        <button class="taskbar-app active">
            <span>📁</span> Проводник
        </button>
        <div class="taskbar-right">
            <span class="taskbar-clock" id="clock"></span>
        </div>
    </div>

    <!-- File Viewer Modal -->
    <div class="file-viewer" id="fileViewer">
        <div class="file-viewer-overlay" onclick="closeFileViewer()"></div>
        <div class="file-viewer-window">
            <div class="file-viewer-titlebar">
                <span id="viewerTitle">📄 file.txt</span>
                <div id="viewerButtons">
                    <button onclick="copyFileContent()" title="Копировать">📋</button>
                    <button id="btnRaw" title="Raw">🔗</button>
                    <button id="btnDownload" title="Скачать">💾</button>
                    <button onclick="closeFileViewer()" title="Закрыть">✕</button>
                </div>
            </div>
            <div class="file-viewer-content" id="viewerContent">
                <pre><code id="viewerCode" class="language-plaintext">Загрузка...</code></pre>
            </div>
            <div class="file-viewer-status">
                <span id="viewerStatus">Готов</span>
            </div>
        </div>
    </div>

    <script>
        // ==================== НАСТРОЙКИ — УКАЖИ СВОИ ДАННЫЕ ====================
        const REPO_OWNER = 'AlexWright55';
        const REPO_NAME = 'Defency-Helper-test';
        const REPO_BRANCH = 'main';

        // ==================== АВТОМАТИКА ====================
        const API_BASE = `https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}`;
        const RAW_BASE = `https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/${REPO_BRANCH}`;
        const REPO_URL = `https://github.com/${REPO_OWNER}/${REPO_NAME}`;

        // ==================== СОСТОЯНИЕ ====================
        let currentPath = '';
        let navigationHistory = [''];
        let historyIndex = 0;
        let allFiles = [];
        let selectedFiles = new Set();
        window._currentViewerRawUrl = '';

        // ==================== ЗАГРУЗКА ФАЙЛОВ ====================
        async function fetchFiles(path = '') {
            const url = `${API_BASE}/contents/${path}`;
            console.log('🔄 Загрузка:', url);
            try {
                const response = await fetch(url, {
                    headers: { 'Accept': 'application/vnd.github.v3+json' }
                });
                if (!response.ok) {
                    console.error('❌ Ошибка ответа:', response.status, response.statusText);
                    throw new Error(`Ошибка ${response.status}: ${response.statusText}`);
                }
                const data = await response.json();
                console.log('✅ Загружено элементов:', Array.isArray(data) ? data.length : 1);
                return Array.isArray(data) ? data : [data];
            } catch (error) {
                console.error('❌ Ошибка загрузки:', error);
                return [];
            }
        }

        function getFileIcon(file) {
            if (file.type === 'dir') return '📁';
            const name = file.name.toLowerCase();
            const ext = name.split('.').pop();

            const iconMap = {
                'html': '🌐', 'htm': '🌐',
                'css': '🎨', 'scss': '🎨', 'less': '🎨',
                'js': '⚡', 'ts': '📘', 'jsx': '⚛️', 'tsx': '⚛️',
                'json': '📋', 'xml': '📋', 'yaml': '⚙️', 'yml': '⚙️',
                'md': '📝', 'txt': '📄', 'log': '📄',
                'png': '🖼️', 'jpg': '🖼️', 'jpeg': '🖼️', 'gif': '🖼️', 'svg': '🖼️', 'ico': '🖼️', 'webp': '🖼️',
                'mp4': '🎬', 'webm': '🎬', 'avi': '🎬',
                'mp3': '🎵', 'wav': '🎵', 'ogg': '🎵',
                'pdf': '📕', 'doc': '📘', 'docx': '📘',
                'zip': '📦', 'tar': '📦', 'gz': '📦', 'rar': '📦',
                'gitignore': '🔒', 'lock': '🔒',
                'sh': '💻', 'bat': '💻', 'py': '🐍', 'rb': '💎', 'php': '🐘',
                'toml': '⚙️', 'cfg': '⚙️', 'ini': '⚙️',
            };

            if (iconMap[ext]) return iconMap[ext];
            if (iconMap[name]) return iconMap[name];
            if (name.startsWith('.')) return '🔒';
            return '📄';
        }

        function formatSize(bytes) {
            if (!bytes) return '';
            if (bytes < 1024) return bytes + ' Б';
            if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(1) + ' КБ';
            return (bytes / (1024 * 1024)).toFixed(1) + ' МБ';
        }

        function renderFiles(files) {
            const grid = document.getElementById('filesGrid');
            const searchQuery = document.getElementById('searchBox').value.toLowerCase();

            let filteredFiles = files;
            if (searchQuery) {
                filteredFiles = files.filter(f =>
                    f.name.toLowerCase().includes(searchQuery)
                );
            }

            if (filteredFiles.length === 0) {
                grid.innerHTML = `
                    <div class="loading-spinner">
                        ${searchQuery ? '🔍 Ничего не найдено' : '📭 Папка пуста'}
                    </div>`;
            } else {
                filteredFiles.sort((a, b) => {
                    if (a.type !== b.type) return a.type === 'dir' ? -1 : 1;
                    return a.name.localeCompare(b.name);
                });

                grid.innerHTML = filteredFiles.map(file => {
                    const icon = getFileIcon(file);
                    const meta = file.type === 'dir' ? 'Папка' : formatSize(file.size);
                    const isSelected = selectedFiles.has(file.path);
                    const escapedPath = file.path.replace(/'/g, "\\'").replace(/"/g, '&quot;');
                    return `
                        <div class="file-item ${isSelected ? 'selected' : ''}"
                             data-path="${escapedPath}"
                             data-type="${file.type}"
                             onclick="handleFileClick(event, '${escapedPath}', '${file.type}')"
                             ondblclick="handleFileDoubleClick('${escapedPath}', '${file.type}')"
                             tabindex="0">
                            <span class="file-icon">${icon}</span>
                            <span class="file-name">${file.name}</span>
                            <span class="file-meta">${meta}</span>
                        </div>
                    `;
                }).join('');
            }

            document.getElementById('statusCount').textContent =
                `${filteredFiles.length} элемент(ов)`;
            updateSelectionCount();
            updateSidebarActive();
        }

        // ==================== НАВИГАЦИЯ ====================
        async function navigateTo(path) {
            path = path || '';
            if (historyIndex < navigationHistory.length - 1) {
                navigationHistory = navigationHistory.slice(0, historyIndex + 1);
            }
            if (navigationHistory[navigationHistory.length - 1] !== path) {
                navigationHistory.push(path);
                historyIndex = navigationHistory.length - 1;
            }
            currentPath = path;
            updateNavigationButtons();
            updateBreadcrumbs();
            await loadCurrentDirectory();
        }

        async function navigateUp() {
            if (!currentPath) return;
            const parts = currentPath.split('/');
            parts.pop();
            await navigateTo(parts.join('/'));
        }

        function updateNavigationButtons() {
            document.getElementById('btnBack').disabled = historyIndex <= 0;
            document.getElementById('btnForward').disabled = historyIndex >= navigationHistory.length - 1;
        }

        document.getElementById('btnBack').addEventListener('click', async () => {
            if (historyIndex > 0) {
                historyIndex--;
                currentPath = navigationHistory[historyIndex];
                updateNavigationButtons();
                updateBreadcrumbs();
                await loadCurrentDirectory(false);
            }
        });

        document.getElementById('btnForward').addEventListener('click', async () => {
            if (historyIndex < navigationHistory.length - 1) {
                historyIndex++;
                currentPath = navigationHistory[historyIndex];
                updateNavigationButtons();
                updateBreadcrumbs();
                await loadCurrentDirectory(false);
            }
        });

        function updateBreadcrumbs() {
            const nav = document.getElementById('breadcrumbNav');
            const parts = currentPath ? currentPath.split('/') : [];
            let html = '<span class="path-segment" onclick="navigateTo(\'\')">🏠 root</span>';
            let accumulatedPath = '';
            parts.forEach((part, i) => {
                accumulatedPath += (accumulatedPath ? '/' : '') + part;
                html += ' <span class="path-arrow">▸</span> ';
                if (i === parts.length - 1) {
                    html += `<span class="path-segment current">📁 ${part}</span>`;
                } else {
                    html += `<span class="path-segment" onclick="navigateTo('${accumulatedPath}')">📁 ${part}</span>`;
                }
            });
            document.getElementById('breadcrumbNav').innerHTML = html;
            const label = currentPath
                ? `📂 ${currentPath.split('/').pop()}`
                : '📂 Корень проекта';
            document.getElementById('currentFolderLabel').textContent = label;
        }

        async function loadCurrentDirectory(addToHistory = true) {
            const grid = document.getElementById('filesGrid');
            grid.innerHTML = '<div class="loading-spinner"><div class="spinner"></div>Загрузка...</div>';
            allFiles = await fetchFiles(currentPath);
            selectedFiles.clear();
            renderFiles(allFiles);
        }

        function refreshFiles() {
            loadCurrentDirectory(false);
        }

        // ==================== ВЫДЕЛЕНИЕ И КЛИКИ ====================
        function handleFileClick(event, path, type) {
            const item = event.currentTarget;
            if (event.ctrlKey || event.metaKey) {
                if (selectedFiles.has(path)) {
                    selectedFiles.delete(path);
                    item.classList.remove('selected');
                } else {
                    selectedFiles.add(path);
                    item.classList.add('selected');
                }
            } else {
                document.querySelectorAll('.file-item').forEach(el => el.classList.remove('selected'));
                selectedFiles.clear();
                selectedFiles.add(path);
                item.classList.add('selected');
            }
            updateSelectionCount();
        }

        async function handleFileDoubleClick(path, type) {
            if (type === 'dir') {
                navigateTo(path);
                return;
            }

            const rawUrl = `${RAW_BASE}/${path}`;
            window._currentViewerRawUrl = rawUrl;

            const ext = path.split('.').pop().toLowerCase();
            const name = path.split('/').pop();

            // Изображения — показываем в просмотрщике
            const imageExtensions = ['png', 'jpg', 'jpeg', 'gif', 'webp', 'bmp', 'ico', 'svg'];
            if (imageExtensions.includes(ext)) {
                openImageViewer(name, rawUrl);
                return;
            }

            // Бинарные файлы — скачиваем
            const binaryExtensions = ['zip', 'tar', 'gz', 'rar', '7z', 'exe', 'dll', 'so', 'dylib',
                'pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx',
                'mp3', 'wav', 'ogg', 'mp4', 'avi', 'mov', 'webm',
                'ttf', 'otf', 'woff', 'woff2', 'eot'
            ];
            if (binaryExtensions.includes(ext)) {
                downloadFile(rawUrl, name);
                return;
            }

            // Всё остальное (текст) — открываем в редакторе
            openFileViewer(name, rawUrl);
        }

        // ==================== ПРОСМОТРЩИК ИЗОБРАЖЕНИЙ ====================
        function openImageViewer(filename, url) {
            const viewer = document.getElementById('fileViewer');
            const titleEl = document.getElementById('viewerTitle');
            const statusEl = document.getElementById('viewerStatus');
            const contentDiv = document.getElementById('viewerContent');
            const buttonsDiv = document.getElementById('viewerButtons');

            viewer.style.display = 'flex';
            titleEl.textContent = `🖼️ ${filename}`;
            statusEl.textContent = url;

            contentDiv.innerHTML = `
                <div style="display:flex;align-items:center;justify-content:center;height:100%;">
                    <img src="${url}" alt="${filename}" 
                         style="max-width:100%;max-height:100%;object-fit:contain;border-radius:4px;"
                         onerror="this.parentElement.innerHTML='<p style=color:#ccc;text-align:center;>❌ Не удалось загрузить изображение</p>'">
                </div>
            `;

            buttonsDiv.innerHTML = `
                <button onclick="window.open('${url}', '_blank')" title="Открыть в новой вкладке">🔗</button>
                <button onclick="downloadFile('${url}', '${filename}')" title="Скачать">💾</button>
                <button onclick="closeFileViewer()" title="Закрыть">✕</button>
            `;
        }

        // ==================== ПРОСМОТРЩИК ТЕКСТОВЫХ ФАЙЛОВ ====================
        async function openFileViewer(filename, url) {
            const viewer = document.getElementById('fileViewer');
            const titleEl = document.getElementById('viewerTitle');
            const statusEl = document.getElementById('viewerStatus');
            const contentDiv = document.getElementById('viewerContent');
            const buttonsDiv = document.getElementById('viewerButtons');

            viewer.style.display = 'flex';
            titleEl.textContent = `📄 ${filename}`;
            contentDiv.innerHTML = '<pre><code id="viewerCode">Загрузка...</code></pre>';
            statusEl.textContent = 'Загрузка...';

            buttonsDiv.innerHTML = `
                <button onclick="copyFileContent()" title="Копировать">📋</button>
                <button onclick="window.open('${url}', '_blank')" title="Raw (может скачаться)">🔗</button>
                <button onclick="downloadFile('${url}', '${filename}')" title="Скачать">💾</button>
                <button onclick="closeFileViewer()" title="Закрыть">✕</button>
            `;

            const codeEl = document.getElementById('viewerCode');

            try {
                const response = await fetch(url);
                if (!response.ok) throw new Error(`Ошибка ${response.status}`);
                const text = await response.text();
                codeEl.textContent = text;

                const ext = filename.split('.').pop().toLowerCase();
                const langMap = {
                    'js': 'javascript', 'jsx': 'javascript', 'ts': 'typescript', 'tsx': 'typescript',
                    'py': 'python', 'rb': 'ruby', 'java': 'java', 'c': 'c', 'cpp': 'cpp',
                    'css': 'css', 'html': 'html', 'json': 'json', 'xml': 'xml',
                    'sh': 'bash', 'bat': 'batch', 'sql': 'sql', 'go': 'go', 'rs': 'rust',
                    'md': 'markdown', 'yaml': 'yaml', 'yml': 'yaml', 'toml': 'toml',
                };
                codeEl.className = `language-${langMap[ext] || 'plaintext'}`;

                const size = new Blob([text]).size;
                const lines = text.split('\n').length;
                statusEl.textContent = `${lines} строк(и) · ${formatSize(size)}`;

            } catch (error) {
                codeEl.textContent = `Ошибка загрузки: ${error.message}\n\nURL: ${url}`;
                statusEl.textContent = '❌ Ошибка';
            }
        }

        // ==================== СКАЧИВАНИЕ ====================
        function downloadFile(url, filename) {
            const a = document.createElement('a');
            a.href = url;
            a.download = filename;
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
        }

        // ==================== ЗАКРЫТИЕ ПРОСМОТРЩИКА ====================
        function closeFileViewer() {
            document.getElementById('fileViewer').style.display = 'none';
        }

        function copyFileContent() {
            const codeEl = document.getElementById('viewerCode');
            if (!codeEl) return;
            const text = codeEl.textContent;
            navigator.clipboard.writeText(text).then(() => {
                const statusEl = document.getElementById('viewerStatus');
                const prevText = statusEl.textContent;
                statusEl.textContent = '✅ Скопировано!';
                setTimeout(() => {
                    statusEl.textContent = prevText;
                }, 1500);
            }).catch(() => {
                // Fallback для старых браузеров
                const textarea = document.createElement('textarea');
                textarea.value = text;
                document.body.appendChild(textarea);
                textarea.select();
                document.execCommand('copy');
                document.body.removeChild(textarea);
            });
        }

        function updateSelectionCount() {
            const count = selectedFiles.size;
            document.getElementById('statusSelected').textContent =
                count > 0 ? `Выбрано: ${count} элем.` : 'Выбрано: 0 элементов';
        }

        // ==================== ПОИСК ====================
        function filterFiles() {
            renderFiles(allFiles);
        }

        // ==================== ВИД (СЕТКА / ТАБЛИЦА) ====================
        function setView(view) {
            const grid = document.getElementById('filesGrid');
            const buttons = document.querySelectorAll('.view-btn');
            buttons.forEach(b => b.classList.remove('active'));
            if (view === 'list') {
                grid.classList.add('list-view');
                buttons[1].classList.add('active');
            } else {
                grid.classList.remove('list-view');
                buttons[0].classList.add('active');
            }
        }

        // ==================== БОКОВОЕ МЕНЮ ====================
        function updateSidebarActive() {
            document.querySelectorAll('.sidebar-item[data-path]').forEach(item => {
                item.classList.remove('active');
                if (item.dataset.path === currentPath) {
                    item.classList.add('active');
                }
            });
        }

        // ==================== КЛАВИАТУРА ====================
        document.addEventListener('keydown', (e) => {
            // Закрыть просмотрщик по Escape
            if (e.key === 'Escape') {
                const viewer = document.getElementById('fileViewer');
                if (viewer.style.display === 'flex') {
                    closeFileViewer();
                    return;
                }
            }

            // Копировать по Ctrl+C когда просмотрщик открыт
            if ((e.ctrlKey || e.metaKey) && e.key === 'c') {
                const viewer = document.getElementById('fileViewer');
                if (viewer.style.display === 'flex') {
                    copyFileContent();
                    e.preventDefault();
                    return;
                }
            }

            // Backspace — на уровень вверх
            if (e.key === 'Backspace' && document.activeElement === document.body) {
                const viewer = document.getElementById('fileViewer');
                if (viewer.style.display !== 'flex') {
                    navigateUp();
                }
            }

            // F5 — обновить
            if (e.key === 'F5') {
                e.preventDefault();
                refreshFiles();
            }

            // Ctrl+A — выбрать всё
            if ((e.ctrlKey || e.metaKey) && e.key === 'a') {
                const viewer = document.getElementById('fileViewer');
                if (viewer.style.display !== 'flex') {
                    e.preventDefault();
                    document.querySelectorAll('.file-item').forEach(el => {
                        el.classList.add('selected');
                        selectedFiles.add(el.dataset.path);
                    });
                    updateSelectionCount();
                }
            }
        });

        // ==================== ЧАСЫ ====================
        function updateClock() {
            const now = new Date();
            const time = now.toLocaleTimeString('ru-RU', { hour: '2-digit', minute: '2-digit' });
            const date = now.toLocaleDateString('ru-RU', { day: '2-digit', month: '2-digit', year: 'numeric' });
            document.getElementById('clock').textContent = `${time}  ${date}`;
        }
        updateClock();
        setInterval(updateClock, 10000);

        // ==================== ЗАПУСК ====================
        async function init() {
            console.log('🪟 Проводник запущен');
            console.log('📁 Репозиторий:', `${REPO_OWNER}/${REPO_NAME}`);
            console.log('🌐 API:', API_BASE);
            console.log('📄 Raw:', RAW_BASE);
            await loadCurrentDirectory();
        }

        init();
    </script>
</body>
</html>
