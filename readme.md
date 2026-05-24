<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Проводник — Портфолио</title>
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
            --green: #107c10;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', 'Segoe UI Variable', system-ui, -apple-system, sans-serif;
            background: #e8ecf1;
            height: 100vh;
            display: flex;
            flex-direction: column;
            color: var(--text);
            user-select: none;
            background-image:
                linear-gradient(135deg, #e8ecf1 0%, #dce1e7 100%);
        }

        /* ========== TITLE BAR ========== */
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
        .titlebar-left {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .titlebar-icon {
            width: 16px;
            height: 16px;
            font-size: 14px;
        }
        .titlebar-title {
            opacity: 0.95;
        }
        .titlebar-controls {
            display: flex;
            gap: 2px;
        }
        .titlebar-btn {
            width: 46px;
            height: 32px;
            border: none;
            background: transparent;
            color: white;
            font-size: 10px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: background 0.1s;
        }
        .titlebar-btn:hover {
            background: rgba(255, 255, 255, 0.15);
        }
        .titlebar-btn.close:hover {
            background: var(--danger);
        }

        /* ========== RIBBON ========== */
        .ribbon {
            background: var(--ribbon-bg);
            border-bottom: 1px solid var(--border);
            padding: 4px 8px;
            display: flex;
            gap: 2px;
            flex-shrink: 0;
            flex-wrap: wrap;
        }
        .ribbon-tab {
            padding: 6px 14px;
            font-size: 13px;
            cursor: pointer;
            border-radius: 4px 4px 0 0;
            color: var(--text);
            transition: background 0.15s;
            position: relative;
        }
        .ribbon-tab:hover {
            background: #e8e8e8;
        }
        .ribbon-tab.active {
            background: white;
            border: 1px solid var(--border);
            border-bottom: 2px solid var(--accent);
            font-weight: 600;
            margin-bottom: -1px;
        }
        .ribbon-actions {
            display: flex;
            gap: 4px;
            padding: 6px 0;
            align-items: center;
        }
        .ribbon-btn {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 4px 10px;
            border: 1px solid transparent;
            background: transparent;
            cursor: pointer;
            border-radius: 4px;
            font-size: 11px;
            color: var(--text);
            min-width: 48px;
            transition: all 0.1s;
        }
        .ribbon-btn:hover {
            background: #e5e5e5;
            border-color: #ccc;
        }
        .ribbon-btn .icon {
            font-size: 18px;
            margin-bottom: 2px;
        }

        /* ========== ADDRESS BAR ========== */
        .address-bar {
            display: flex;
            align-items: center;
            background: white;
            border-bottom: 1px solid var(--border);
            padding: 4px 8px;
            gap: 8px;
            flex-shrink: 0;
        }
        .address-btns {
            display: flex;
            gap: 1px;
        }
        .address-btns button {
            width: 28px;
            height: 24px;
            border: 1px solid transparent;
            background: transparent;
            cursor: pointer;
            border-radius: 3px;
            font-size: 12px;
            color: #666;
            transition: all 0.1s;
        }
        .address-btns button:hover {
            background: #e5e5e5;
            border-color: #ccc;
        }
        .address-btns button:disabled {
            opacity: 0.35;
            cursor: default;
        }
        .address-path {
            flex: 1;
            background: var(--address-bg);
            border: 1px solid var(--border);
            border-radius: 4px;
            padding: 4px 10px;
            font-size: 13px;
            display: flex;
            align-items: center;
            gap: 4px;
            min-width: 0;
        }
        .path-segment {
            padding: 2px 6px;
            border-radius: 3px;
            cursor: pointer;
            white-space: nowrap;
        }
        .path-segment:hover {
            background: #dce1e7;
        }
        .path-arrow {
            color: #999;
            font-size: 10px;
        }
        .path-segment.current {
            font-weight: 600;
            background: #e5f3ff;
        }
        .search-box {
            width: 220px;
            padding: 4px 10px;
            border: 1px solid var(--border);
            border-radius: 4px;
            font-size: 13px;
            font-family: inherit;
            outline: none;
            transition: border 0.2s;
        }
        .search-box:focus {
            border-color: var(--accent);
            box-shadow: 0 0 0 1px rgba(0, 120, 212, 0.2);
        }

        /* ========== MAIN LAYOUT ========== */
        .main {
            display: flex;
            flex: 1;
            overflow: hidden;
        }

        /* ========== SIDEBAR ========== */
        .sidebar {
            width: 220px;
            background: var(--sidebar-bg);
            border-right: 1px solid var(--border);
            display: flex;
            flex-direction: column;
            flex-shrink: 0;
            overflow-y: auto;
        }
        .sidebar-section {
            padding: 8px 0;
        }
        .sidebar-title {
            padding: 8px 16px 4px;
            font-size: 11px;
            font-weight: 600;
            color: #555;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .sidebar-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 8px 16px;
            cursor: pointer;
            font-size: 13px;
            transition: background 0.1s;
            border-left: 3px solid transparent;
        }
        .sidebar-item:hover {
            background: var(--hover);
        }
        .sidebar-item.active {
            background: var(--selected);
            border-left-color: var(--accent);
            font-weight: 500;
        }
        .sidebar-item .icon {
            font-size: 18px;
            width: 22px;
            text-align: center;
        }
        .sidebar-separator {
            height: 1px;
            background: var(--border);
            margin: 4px 12px;
        }

        /* ========== CONTENT ========== */
        .content {
            flex: 1;
            background: white;
            overflow-y: auto;
            padding: 16px;
        }
        .files-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(100px, 1fr));
            gap: 10px;
        }
        .file-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 14px 8px;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.1s;
            text-align: center;
            border: 2px solid transparent;
        }
        .file-item:hover {
            background: var(--hover);
            border-color: #d0e4f7;
        }
        .file-item.selected {
            background: var(--selected);
            border-color: var(--accent);
        }
        .file-item .file-icon {
            font-size: 40px;
            margin-bottom: 6px;
            transition: transform 0.2s;
        }
        .file-item:hover .file-icon {
            transform: scale(1.08);
        }
        .file-item .file-name {
            font-size: 12px;
            line-height: 1.3;
            word-break: break-word;
            max-width: 90px;
        }
        .file-item .file-meta {
            font-size: 10px;
            color: var(--muted);
            margin-top: 2px;
        }

        /* ========== STATUS BAR ========== */
        .statusbar {
            background: var(--sidebar-bg);
            border-top: 1px solid var(--border);
            padding: 3px 12px;
            font-size: 12px;
            color: var(--muted);
            display: flex;
            justify-content: space-between;
            flex-shrink: 0;
        }

        /* ========== TASKBAR ========== */
        .taskbar {
            background: var(--taskbar);
            border-top: 1px solid #d0d0d0;
            height: 44px;
            display: flex;
            align-items: center;
            padding: 0 8px;
            gap: 4px;
            flex-shrink: 0;
        }
        .taskbar-start {
            width: 40px;
            height: 36px;
            border: none;
            background: transparent;
            cursor: pointer;
            font-size: 20px;
            border-radius: 4px;
            transition: background 0.1s;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .taskbar-start:hover {
            background: #d5d5d5;
        }
        .taskbar-app {
            height: 36px;
            padding: 0 12px;
            border: none;
            background: transparent;
            cursor: pointer;
            font-size: 12px;
            border-radius: 4px;
            display: flex;
            align-items: center;
            gap: 6px;
            transition: all 0.1s;
            border-bottom: 2px solid transparent;
        }
        .taskbar-app:hover {
            background: #ddd;
        }
        .taskbar-app.active {
            background: #d0d0d0;
            border-bottom-color: var(--accent);
        }
        .taskbar-right {
            margin-left: auto;
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 12px;
            color: #333;
        }
        .taskbar-clock {
            padding: 4px 8px;
            border-radius: 4px;
            cursor: default;
        }
        .taskbar-clock:hover {
            background: #ddd;
        }

        /* ========== TOOLTIP ========== */
        [data-tooltip] {
            position: relative;
        }
        [data-tooltip]:hover::after {
            content: attr(data-tooltip);
            position: absolute;
            bottom: 110%;
            left: 50%;
            transform: translateX(-50%);
            background: #333;
            color: white;
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 11px;
            white-space: nowrap;
            z-index: 100;
            pointer-events: none;
        }

        /* ========== SCROLLBAR ========== */
        ::-webkit-scrollbar {
            width: 8px;
            height: 8px;
        }
        ::-webkit-scrollbar-track {
            background: #f5f5f5;
        }
        ::-webkit-scrollbar-thumb {
            background: #c1c1c1;
            border-radius: 4px;
        }
        ::-webkit-scrollbar-thumb:hover {
            background: #a1a1a1;
        }
    </style>
</head>
<body>

    <!-- Title Bar -->
    <div class="titlebar">
        <div class="titlebar-left">
            <span class="titlebar-icon">📁</span>
            <span class="titlebar-title">Проводник — Портфолио</span>
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
            <button class="ribbon-btn" data-tooltip="Копировать">
                <span class="icon">📋</span> Копировать
            </button>
            <button class="ribbon-btn" data-tooltip="Вставить">
                <span class="icon">📄</span> Вставить
            </button>
            <button class="ribbon-btn" data-tooltip="Удалить">
                <span class="icon">🗑️</span> Удалить
            </button>
            <button class="ribbon-btn" data-tooltip="Свойства">
                <span class="icon">ℹ️</span> Свойства
            </button>
        </div>
    </div>

    <!-- Address Bar -->
    <div class="address-bar">
        <div class="address-btns">
            <button disabled title="Назад">◀</button>
            <button disabled title="Вперёд">▶</button>
            <button title="Вверх">▲</button>
            <button title="Обновить" onclick="location.reload()">↻</button>
        </div>
        <div class="address-path">
            <span class="path-segment">💻 Этот компьютер</span>
            <span class="path-arrow">▸</span>
            <span class="path-segment">📁 Проекты</span>
            <span class="path-arrow">▸</span>
            <span class="path-segment current">📂 GitHub Pages</span>
        </div>
        <input class="search-box" type="text" placeholder="🔍 Поиск в папке...">
    </div>

    <!-- Main Layout -->
    <div class="main">

        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-section">
                <div class="sidebar-title">Быстрый доступ</div>
                <div class="sidebar-item active">
                    <span class="icon">📂</span> Рабочий стол
                </div>
                <div class="sidebar-item">
                    <span class="icon">⬇️</span> Загрузки
                </div>
                <div class="sidebar-item">
                    <span class="icon">📄</span> Документы
                </div>
                <div class="sidebar-item">
                    <span class="icon">🖼️</span> Изображения
                </div>
                <div class="sidebar-item">
                    <span class="icon">🎵</span> Музыка
                </div>
                <div class="sidebar-item">
                    <span class="icon">🎬</span> Видео
                </div>
            </div>
            <div class="sidebar-separator"></div>
            <div class="sidebar-section">
                <div class="sidebar-title">Этот компьютер</div>
                <div class="sidebar-item">
                    <span class="icon">💿</span> Локальный диск (C:)
                </div>
                <div class="sidebar-item">
                    <span class="icon">💿</span> Диск (D:)
                </div>
            </div>
            <div class="sidebar-separator"></div>
            <div class="sidebar-section">
                <div class="sidebar-title">Сеть</div>
                <div class="sidebar-item">
                    <span class="icon">🌐</span> GitHub
                </div>
                <div class="sidebar-item">
                    <span class="icon">🐦</span> Twitter
                </div>
                <div class="sidebar-item">
                    <span class="icon">💼</span> LinkedIn
                </div>
            </div>
        </div>

        <!-- Content Area -->
        <div class="content">
            <div class="files-grid" id="filesGrid">
                <!-- Папки -->
                <div class="file-item" tabindex="0">
                    <span class="file-icon">📁</span>
                    <span class="file-name">src</span>
                    <span class="file-meta">Папка</span>
                </div>
                <div class="file-item" tabindex="0">
                    <span class="file-icon">📁</span>
                    <span class="file-name">assets</span>
                    <span class="file-meta">Папка</span>
                </div>
                <div class="file-item" tabindex="0">
                    <span class="file-icon">📁</span>
                    <span class="file-name">docs</span>
                    <span class="file-meta">Папка</span>
                </div>
                <div class="file-item" tabindex="0">
                    <span class="file-icon">📁</span>
                    <span class="file-name">components</span>
                    <span class="file-meta">Папка</span>
                </div>
                <!-- Файлы -->
                <div class="file-item" tabindex="0">
                    <span class="file-icon">📄</span>
                    <span class="file-name">index.html</span>
                    <span class="file-meta">12 КБ</span>
                </div>
                <div class="file-item" tabindex="0">
                    <span class="file-icon">🎨</span>
                    <span class="file-name">style.css</span>
                    <span class="file-meta">8 КБ</span>
                </div>
                <div class="file-item" tabindex="0">
                    <span class="file-icon">⚡</span>
                    <span class="file-name">script.js</span>
                    <span class="file-meta">5 КБ</span>
                </div>
                <div class="file-item" tabindex="0">
                    <span class="file-icon">📝</span>
                    <span class="file-name">README.md</span>
                    <span class="file-meta">2 КБ</span>
                </div>
                <div class="file-item" tabindex="0">
                    <span class="file-icon">⚙️</span>
                    <span class="file-name">_config.yml</span>
                    <span class="file-meta">1 КБ</span>
                </div>
                <div class="file-item" tabindex="0">
                    <span class="file-icon">📦</span>
                    <span class="file-name">package.json</span>
                    <span class="file-meta">3 КБ</span>
                </div>
                <div class="file-item" tabindex="0">
                    <span class="file-icon">🔒</span>
                    <span class="file-name">.gitignore</span>
                    <span class="file-meta">0.5 КБ</span>
                </div>
                <div class="file-item" tabindex="0">
                    <span class="file-icon">📸</span>
                    <span class="file-name">screenshot.png</span>
                    <span class="file-meta">240 КБ</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Status Bar -->
    <div class="statusbar">
        <span>12 элементов</span>
        <span>Выбрано: 0 элементов</span>
    </div>

    <!-- Taskbar -->
    <div class="taskbar">
        <button class="taskbar-start" title="Пуск">🪟</button>
        <button class="taskbar-app active">
            <span>📁</span> Проводник
        </button>
        <button class="taskbar-app">
            <span>🌐</span> Браузер
        </button>
        <button class="taskbar-app">
            <span>💬</span> Telegram
        </button>
        <div class="taskbar-right">
            <span>🔊</span>
            <span>📶</span>
            <span>🔋 100%</span>
            <span class="taskbar-clock" id="clock"></span>
        </div>
    </div>

    <script>
        // Обновление часов
        function updateClock() {
            const now = new Date();
            const time = now.toLocaleTimeString('ru-RU', { hour: '2-digit', minute: '2-digit' });
            const date = now.toLocaleDateString('ru-RU', { day: '2-digit', month: '2-digit', year: 'numeric' });
            document.getElementById('clock').textContent = `${time}  ${date}`;
        }
        updateClock();
        setInterval(updateClock, 10000);

        // Клик по файлам — выделение
        const fileItems = document.querySelectorAll('.file-item');
        const statusBar = document.querySelector('.statusbar span:last-child');

        fileItems.forEach(item => {
            item.addEventListener('click', function(e) {
                // Ctrl+клик — мультивыделение
                if (e.ctrlKey || e.metaKey) {
                    this.classList.toggle('selected');
                } else {
                    // Обычный клик — снять всё, выделить этот
                    fileItems.forEach(f => f.classList.remove('selected'));
                    this.classList.add('selected');
                }
                updateSelectionCount();
            });

            // Двойной клик — "открыть" (анимация)
            item.addEventListener('dblclick', function() {
                const icon = this.querySelector('.file-icon');
                icon.style.transform = 'scale(1.3)';
                setTimeout(() => {
                    icon.style.transform = '';
                    // Имитация открытия — меняем путь
                    const pathCurrent = document.querySelector('.path-segment.current');
                    if (pathCurrent && this.querySelector('.file-name').textContent.includes('.')) {
                        // Это файл — подсветим его
                        this.style.background = '#cce4f7';
                        setTimeout(() => { this.style.background = ''; }, 600);
                    }
                }, 200);
            });
        });

        function updateSelectionCount() {
            const count = document.querySelectorAll('.file-item.selected').length;
            statusBar.textContent = count > 0 ? `Выбрано: ${count} элем.` : 'Выбрано: 0 элементов';
        }

        // Боковое меню — переключение активного пункта
        document.querySelectorAll('.sidebar-item').forEach(item => {
            item.addEventListener('click', function() {
                document.querySelectorAll('.sidebar-item').forEach(i => i.classList.remove('active'));
                this.classList.add('active');
                // Меняем путь
                const name = this.textContent.trim().replace(/^\S+\s*/, '');
                const pathCurrent = document.querySelector('.path-segment.current');
                if (pathCurrent) {
                    pathCurrent.textContent = '📂 ' + name;
                }
            });
        });

        // Кнопка Пуск — небольшой эффект
        document.querySelector('.taskbar-start').addEventListener('click', function() {
            this.style.transform = 'scale(0.9)';
            setTimeout(() => { this.style.transform = ''; }, 150);
        });

        console.log('🪟 Проводник готов! Добро пожаловать в портфолио.');
    </script>
</body>
</html>
