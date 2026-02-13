// Simple JavaScript demo
let clickCount = 0;

function handleClick() {
    clickCount++;
    document.getElementById('clickCount').textContent = `Clicks: ${clickCount}`;

    // Add a fun animation
    const button = document.getElementById('demoButton');
    button.textContent = getRandomEmoji() + ' Click Me Again!';

    if (clickCount >= 10) {
        button.textContent = '🎉 You clicked 10 times! 🎉';
        setTimeout(() => {
            button.textContent = 'Click Me!';
            clickCount = 0;
            document.getElementById('clickCount').textContent = 'Clicks: 0';
        }, 3000);
    }
}

function getRandomEmoji() {
    const emojis = ['🚀', '⭐', '🎯', '💫', '🔥', '✨', '🎪', '🎨', '🎭', '🎬'];
    return emojis[Math.floor(Math.random() * emojis.length)];
}

// Add a welcome message to console
console.log('%c Welcome to the Static Site Example! ', 'background: #667eea; color: white; font-size: 16px; padding: 10px;');
console.log('%c Deployed with OpenRun ', 'background: #764ba2; color: white; font-size: 14px; padding: 5px;');
