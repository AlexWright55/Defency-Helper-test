<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Мой проект</title>
    <style>
        :root {
            --bg: #0f0f1a;
            --card: #1a1a2e;
            --accent: #7c3aed;
            --text: #e2e8f0;
            --muted: #94a3b8;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            background: var(--bg);
            color: var(--text);
            min-height: 100vh;
            background-image:
                radial-gradient(ellipse at 20% 50%, rgba(124, 58, 237, 0.15) 0%, transparent 50%),
                radial-gradient(ellipse at 80% 20%, rgba(59, 130, 246, 0.1) 0%, transparent 50%);
        }

        .container {
            max-width: 900px;
            margin: 0 auto;
            padding: 2rem;
        }

        /* Заголовок */
        header {
            text-align: center;
            padding: 4rem 0 2rem;
        }

        .avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background: linear-gradient(135deg, #7c3aed, #3b82f6);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 0 40px rgba(124, 58, 237, 0.3);
            animation: float 3s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }

        h1 {
            font-size: 2.5rem;
            font-weight: 700;
            background: linear-gradient(135deg, #c084fc, #60a5fa);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 0.5rem;
        }

        .subtitle {
            color: var(--muted);
            font-size: 1.1rem;
        }

        /* Карточки */
        .cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin: 2rem 0;
        }

        .card {
            background: var(--card);
            border-radius: 16px;
            padding: 1.8rem;
            border: 1px solid rgba(255,255,255,0.05);
            transition: all 0.3s ease;
            cursor: default;
        }

        .card:hover {
            transform: translateY(-4px);
            border-color: rgba(124, 58, 237, 0.3);
            box-shadow: 0 8px 30px rgba(124, 58, 237, 0.15);
        }

        .card-icon {
            font-size: 2rem;
            margin-bottom: 1rem;
        }

        .card h3 {
            margin-bottom: 0.5rem;
            font-size: 1.2rem;
        }

        .card p {
            color: var(--muted);
            font-size: 0.9rem;
            line-height: 1.6;
        }

        /* Кнопки */
        .buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
            margin: 2rem 0;
        }

        .btn {
            padding: 0.75rem 1.8rem;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
        }

        .btn-primary {
            background: linear-gradient(135deg, #7c3aed, #3b82f6);
            color: white;
            box-shadow: 0 4px 20px rgba(124, 58, 237, 0.4);
        }

        .btn-primary:hover {
            box-shadow: 0 6px 30px rgba(124, 58, 237, 0.6);
            transform: translateY(-2px);
        }

        .btn-outline {
            border: 2px solid rgba(255,255,255,0.2);
            color: var(--text);
            background: transparent;
        }

        .btn-outline:hover {
            border-color: #7c3aed;
            background: rgba(124, 58, 237, 0.1);
        }

        /* Статус */
        .status {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            margin: 2rem 0;
            color: var(--muted);
        }

        .status-dot {
            width: 8px;
            height: 8px;
            background: #22c55e;
            border-radius: 50%;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.4; }
        }

        /* Подвал */
        footer {
            text-align: center;
            padding: 2rem;
            color: var(--muted);
            font-size: 0.85rem;
        }

        footer a {
            color: #c084fc;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <div class="avatar">??</div>
            <h1>Мой проект</h1>
            <p class="subtitle">Красивый лендинг на GitHub Pages</p>
        </header>

        <div class="status">
            <span class="status-dot"></span>
            Активная разработка
        </div>

        <div class="cards">
            <div class="card">
                <div class="card-icon">?</div>
                <h3>Быстрый</h3>
                <p>Оптимизированная загрузка и высокая производительность из коробки.</p>
            </div>
            <div class="card">
                <div class="card-icon">??</div>
                <h3>Стильный</h3>
                <p>Современный дизайн с градиентами, анимациями и тёмной темой.</p>
            </div>
            <div class="card">
                <div class="card-icon">??</div>
                <h3>Надёжный</h3>
                <p>Бесплатный хостинг от GitHub с автоматическим HTTPS.</p>
            </div>
        </div>

        <div class="buttons">
            <a href="https://github.com" class="btn btn-primary">? На GitHub</a>
            <a href="#" class="btn btn-outline">?? Документация</a>
            <a href="#" class="btn btn-outline">?? Контакты</a>
        </div>
    </div>

    <footer>
        Сделано с ?? на <a href="https://pages.github.com">GitHub Pages</a>
    </footer>
</body>
</html>