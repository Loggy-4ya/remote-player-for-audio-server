FROM node:24-alpine


RUN cat <<EOF > /etc/asound.conf
pcm.!default {
    type pipewire
    hint {
        show on
        description "PipeWire Sound Server"
    }
}

ctl.!default {
    type pipewire
}
EOF

# Note: On some hosts, the 'audio' group ID must match the host's ID
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
RUN addgroup appuser audio

# 3. Set workdir and ownership
WORKDIR /app
COPY . .
RUN chown -R appuser:appgroup /app

RUN apk update && \
    apk add --no-cache pulseaudio-utils yt-dlp mpv

# 4. Switch to the user
USER appuser


RUN npm install


CMD ["sh"]