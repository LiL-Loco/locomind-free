/**
 * LocoMind TTS Sidecar
 * 
 * A tiny HTTP server that converts text to speech using edge-tts (free, Microsoft voices)
 * and returns base64-encoded MP3 audio.
 * 
 * Requirements:
 *   - Python + pip
 *   - edge-tts: pip install edge-tts
 *   - Node.js 18+
 * 
 * Usage:
 *   node index.js [--port 3210]
 * 
 * Then set in server.cfg:
 *   set locomind_tts_url "http://localhost:3210"
 *   set locomind_tts_key ""   (not needed for edge-tts)
 */

const http = require('http');
const { exec } = require('child_process');
const fs = require('fs');
const os = require('os');
const path = require('path');
const crypto = require('crypto');

const PORT = parseInt(process.argv[2] || process.env.TTS_PORT || '3210');

// Available voices — subset of popular edge-tts voices
// Full list: edge-tts --list-voices
const VOICES = {
    // English
    'en-US-GuyNeural':         'en-US-GuyNeural',
    'en-US-ChristopherNeural': 'en-US-ChristopherNeural',
    'en-US-JennyNeural':       'en-US-JennyNeural',
    'en-US-AriaNeural':        'en-US-AriaNeural',
    'en-GB-RyanNeural':        'en-GB-RyanNeural',
    // German
    'de-DE-ConradNeural':      'de-DE-ConradNeural',
    'de-DE-KatjaNeural':       'de-DE-KatjaNeural',
    // French
    'fr-FR-HenriNeural':       'fr-FR-HenriNeural',
    // Spanish
    'es-ES-AlvaroNeural':      'es-ES-AlvaroNeural',
};

function sanitize(text) {
    // Remove characters that could break the shell command
    return text
        .replace(/["\\\n\r`$]/g, ' ')
        .substring(0, 300)
        .trim();
}

const server = http.createServer((req, res) => {
    if (req.method === 'GET' && req.url === '/health') {
        res.writeHead(200);
        res.end(JSON.stringify({ status: 'ok', port: PORT }));
        return;
    }

    if (req.method === 'GET' && req.url === '/voices') {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify(Object.keys(VOICES)));
        return;
    }

    if (req.method === 'POST' && req.url === '/tts') {
        let body = '';
        req.on('data', chunk => { body += chunk; });
        req.on('end', () => {
            let parsed;
            try {
                parsed = JSON.parse(body);
            } catch {
                res.writeHead(400);
                res.end('Invalid JSON');
                return;
            }

            const text  = sanitize(parsed.text || '');
            const voice = VOICES[parsed.voice] || 'en-US-GuyNeural';

            if (!text) {
                res.writeHead(400);
                res.end('No text provided');
                return;
            }

            // Create temp file path
            const tmpId   = crypto.randomBytes(8).toString('hex');
            const tmpFile = path.join(os.tmpdir(), `locomind_${tmpId}.mp3`);
            const cmd     = `edge-tts --voice "${voice}" --text "${text}" --write-media "${tmpFile}"`;

            exec(cmd, { timeout: 15000 }, (err, stdout, stderr) => {
                if (err) {
                    console.error('[LocoMind TTS] edge-tts error:', err.message);
                    res.writeHead(500);
                    res.end('TTS error: ' + err.message);
                    return;
                }

                if (!fs.existsSync(tmpFile)) {
                    console.error('[LocoMind TTS] Output file not found');
                    res.writeHead(500);
                    res.end('Output file not found');
                    return;
                }

                const mp3 = fs.readFileSync(tmpFile);
                fs.unlinkSync(tmpFile); // cleanup
                const b64 = mp3.toString('base64');

                res.writeHead(200, { 'Content-Type': 'text/plain' });
                res.end(b64);
            });
        });
        return;
    }

    res.writeHead(404);
    res.end('Not found');
});

server.listen(PORT, '127.0.0.1', () => {
    console.log(`[LocoMind TTS Sidecar] Running on http://127.0.0.1:${PORT}`);
    console.log('[LocoMind TTS Sidecar] POST /tts   — synthesize speech');
    console.log('[LocoMind TTS Sidecar] GET  /voices — list available voices');
    console.log('[LocoMind TTS Sidecar] GET  /health — health check');
    console.log('[LocoMind TTS Sidecar] Make sure edge-tts is installed: pip install edge-tts');
});
