BEGIN;

-- =============================================================
-- ENTERPRISE SCALE LAYER (Facebook + Discord-like capabilities)
-- =============================================================

-- Multi-tenant / shard catalog (for very large scale)
CREATE TABLE platform_regions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(16) NOT NULL UNIQUE,
    name VARCHAR(120) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE platform_shards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    region_id UUID NOT NULL REFERENCES platform_regions(id) ON DELETE CASCADE,
    shard_key VARCHAR(64) NOT NULL UNIQUE,
    writer_dsn TEXT NOT NULL,
    reader_dsn TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE user_shard_map (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    shard_id UUID NOT NULL REFERENCES platform_shards(id) ON DELETE RESTRICT,
    assigned_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- OAuth / Passkeys / External identities
CREATE TABLE oauth_providers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    provider_code VARCHAR(50) NOT NULL UNIQUE,
    display_name VARCHAR(120) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE user_oauth_accounts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    provider_id UUID NOT NULL REFERENCES oauth_providers(id) ON DELETE CASCADE,
    provider_user_id VARCHAR(255) NOT NULL,
    provider_email VARCHAR(255),
    access_token_encrypted TEXT,
    refresh_token_encrypted TEXT,
    expires_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (provider_id, provider_user_id)
);

CREATE TABLE user_passkeys (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    credential_id TEXT NOT NULL UNIQUE,
    public_key TEXT NOT NULL,
    sign_count BIGINT NOT NULL DEFAULT 0,
    transports TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    last_used_at TIMESTAMPTZ
);

-- Discord-like communities (servers/channels/voice)
CREATE TABLE servers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(150) NOT NULL,
    slug VARCHAR(150) NOT NULL UNIQUE,
    description TEXT,
    icon_url TEXT,
    is_public BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE server_members (
    server_id UUID NOT NULL REFERENCES servers(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    nickname VARCHAR(120),
    joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (server_id, user_id)
);

CREATE TABLE server_roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    server_id UUID NOT NULL REFERENCES servers(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    color_hex VARCHAR(7),
    position INT NOT NULL DEFAULT 0,
    permissions BIGINT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE server_member_roles (
    server_id UUID NOT NULL REFERENCES servers(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role_id UUID NOT NULL REFERENCES server_roles(id) ON DELETE CASCADE,
    assigned_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (server_id, user_id, role_id)
);

CREATE TABLE channels (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    server_id UUID NOT NULL REFERENCES servers(id) ON DELETE CASCADE,
    parent_channel_id UUID REFERENCES channels(id) ON DELETE SET NULL,
    name VARCHAR(120) NOT NULL,
    channel_type VARCHAR(20) NOT NULL CHECK (channel_type IN ('text', 'voice', 'announcement', 'forum')),
    position INT NOT NULL DEFAULT 0,
    topic TEXT,
    is_private BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE channel_permissions (
    channel_id UUID NOT NULL REFERENCES channels(id) ON DELETE CASCADE,
    role_id UUID NOT NULL REFERENCES server_roles(id) ON DELETE CASCADE,
    allow_bits BIGINT NOT NULL DEFAULT 0,
    deny_bits BIGINT NOT NULL DEFAULT 0,
    PRIMARY KEY (channel_id, role_id)
);

CREATE TABLE channel_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    channel_id UUID NOT NULL REFERENCES channels(id) ON DELETE CASCADE,
    author_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    content TEXT,
    attachments JSONB NOT NULL DEFAULT '[]'::jsonb,
    mentions JSONB NOT NULL DEFAULT '[]'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    edited_at TIMESTAMPTZ
);

CREATE TABLE voice_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    channel_id UUID NOT NULL REFERENCES channels(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    rtc_session_id VARCHAR(255) NOT NULL,
    joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    left_at TIMESTAMPTZ,
    is_muted BOOLEAN NOT NULL DEFAULT FALSE,
    is_deafened BOOLEAN NOT NULL DEFAULT FALSE,
    UNIQUE (channel_id, user_id, rtc_session_id)
);

-- Public publishing / domains / deployments
CREATE TABLE site_domains (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    host VARCHAR(255) NOT NULL UNIQUE,
    is_primary BOOLEAN NOT NULL DEFAULT FALSE,
    ssl_enabled BOOLEAN NOT NULL DEFAULT TRUE,
    dns_verified BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE deployment_releases (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    release_tag VARCHAR(120) NOT NULL UNIQUE,
    git_commit_sha VARCHAR(64) NOT NULL,
    environment VARCHAR(30) NOT NULL CHECK (environment IN ('staging', 'production')),
    status VARCHAR(30) NOT NULL CHECK (status IN ('queued', 'running', 'success', 'failed')),
    started_at TIMESTAMPTZ,
    finished_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Enterprise indexes
CREATE INDEX idx_server_members_user ON server_members(user_id);
CREATE INDEX idx_channels_server_type_pos ON channels(server_id, channel_type, position);
CREATE INDEX idx_channel_messages_channel_created ON channel_messages(channel_id, created_at DESC);
CREATE INDEX idx_voice_sessions_channel_joined ON voice_sessions(channel_id, joined_at DESC);
CREATE INDEX idx_user_oauth_accounts_user ON user_oauth_accounts(user_id);
CREATE INDEX idx_user_shard_map_shard ON user_shard_map(shard_id);

COMMIT;
