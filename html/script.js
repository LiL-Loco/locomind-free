let waiting = false;

window.addEventListener('message', function(event) {
    const data = event.data;

    if (data.action === 'openChat') {
        document.getElementById('npc-name').textContent = data.npcName;
        document.getElementById('chat-container').classList.remove('hidden');
        document.getElementById('chat-messages').innerHTML = '';
        document.getElementById('chat-input').value = '';
        document.getElementById('chat-input').focus();
        waiting = false;
    }

    if (data.action === 'closeChat') {
        document.getElementById('chat-container').classList.add('hidden');
    }

    if (data.action === 'npcResponse') {
        removeTyping();
        addMessage(data.npcName, data.message, 'npc');
        waiting = false;
        document.getElementById('send-btn').disabled = false;
        document.getElementById('chat-input').focus();
    }
});

function sendMessage() {
    if (waiting) return;
    const input = document.getElementById('chat-input');
    const message = input.value.trim();
    if (!message) return;

    addMessage('You', message, 'player');
    input.value = '';
    waiting = true;
    document.getElementById('send-btn').disabled = true;

    addTyping();

    fetch('https://locomind-free/sendMessage', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ message })
    });
}

function closeChat() {
    fetch('https://locomind-free/closeChat', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
}

function addMessage(sender, text, type) {
    const msgs = document.getElementById('chat-messages');
    const div = document.createElement('div');
    div.className = 'message ' + type;
    div.innerHTML = `<div class="sender">${escapeHtml(sender)}</div><div>${escapeHtml(text)}</div>`;
    msgs.appendChild(div);
    msgs.scrollTop = msgs.scrollHeight;
}

function addTyping() {
    const msgs = document.getElementById('chat-messages');
    const div = document.createElement('div');
    div.className = 'typing';
    div.id = 'typing-indicator';
    div.textContent = document.getElementById('npc-name').textContent + ' is typing...';
    msgs.appendChild(div);
    msgs.scrollTop = msgs.scrollHeight;
}

function removeTyping() {
    const el = document.getElementById('typing-indicator');
    if (el) el.remove();
}

function escapeHtml(str) {
    return str.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
}

// Enter key to send
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') closeChat();
    if (e.key === 'Enter') sendMessage();
});
