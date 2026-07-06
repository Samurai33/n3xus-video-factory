import express from 'express';
import fs from 'node:fs/promises';
import path from 'node:path';
import crypto from 'node:crypto';

const app = express();

const PORT = Number(process.env.PORT || 8787);
const GATEWAY_API_KEY = process.env.GPT_GATEWAY_API_KEY || '';
const N8N_BASE_URL = (process.env.N8N_BASE_URL || 'http://n8n:5678').replace(/\/$/, '');
const N8N_API_KEY = process.env.N8N_API_KEY || '';
const JOB_DIR = process.env.NVF_JOB_DIR || '/media/scripts';
const REQUIRE_AUTH = process.env.GPT_GATEWAY_REQUIRE_AUTH !== 'false';

app.use(express.json({ limit: '1mb' }));

function assertAuth(req, res, next) {
  if (!REQUIRE_AUTH) return next();

  const header = req.headers.authorization || '';
  const expected = `Bearer ${GATEWAY_API_KEY}`;

  if (!GATEWAY_API_KEY || header !== expected) {
    return res.status(401).json({ ok: false, error: 'unauthorized' });
  }

  next();
}

function safeSlug(input) {
  return String(input || 'job')
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/(^-|-$)/g, '')
    .slice(0, 60) || 'job';
}

function nowStamp() {
  const d = new Date();
  return d.toISOString().replace(/[-:]/g, '').replace(/\.\d{3}Z$/, 'Z');
}

function publicWorkflowShape(workflow) {
  return {
    id: workflow.id,
    name: workflow.name,
    active: workflow.active,
    createdAt: workflow.createdAt,
    updatedAt: workflow.updatedAt,
    tags: workflow.tags || []
  };
}

async function callN8n(pathname, options = {}) {
  if (!N8N_API_KEY) {
    throw new Error('N8N_API_KEY is not configured on the gateway');
  }

  const response = await fetch(`${N8N_BASE_URL}${pathname}`, {
    ...options,
    headers: {
      'Content-Type': 'application/json',
      'X-N8N-API-KEY': N8N_API_KEY,
      ...(options.headers || {})
    }
  });

  const text = await response.text();
  let body;
  try {
    body = text ? JSON.parse(text) : {};
  } catch {
    body = { raw: text };
  }

  if (!response.ok) {
    const message = body?.message || body?.error || `n8n returned HTTP ${response.status}`;
    const error = new Error(message);
    error.status = response.status;
    error.body = body;
    throw error;
  }

  return body;
}

app.get('/health', (_req, res) => {
  res.json({
    ok: true,
    service: 'n3xus-n8n-control-gateway',
    mode: 'restricted',
    authRequired: REQUIRE_AUTH,
    n8nBaseUrl: N8N_BASE_URL
  });
});

app.post('/video-requests', assertAuth, async (req, res) => {
  const input = req.body || {};

  if (!input.project || !input.idea || !input.targetAudience) {
    return res.status(400).json({
      ok: false,
      error: 'project, idea and targetAudience are required'
    });
  }

  const jobId = `${safeSlug(input.project)}-${nowStamp()}-${crypto.randomBytes(3).toString('hex')}`;
  const fileName = `${jobId}.json`;
  const filePath = path.join(JOB_DIR, fileName);

  const job = {
    id: jobId,
    type: 'video-request',
    status: 'draft',
    createdAt: new Date().toISOString(),
    source: 'gpt-gateway',
    project: input.project,
    pillar: input.pillar || 'Pain',
    idea: input.idea,
    targetAudience: input.targetAudience,
    cta: input.cta || '',
    priority: input.priority || 'normal',
    policy: {
      autoPublish: false,
      requiresHumanReview: true
    }
  };

  await fs.mkdir(JOB_DIR, { recursive: true });
  await fs.writeFile(filePath, JSON.stringify(job, null, 2), 'utf8');

  res.status(201).json({
    ok: true,
    jobId,
    filePath,
    status: 'draft'
  });
});

app.get('/n8n/workflows', assertAuth, async (_req, res) => {
  try {
    const body = await callN8n('/api/v1/workflows');
    const workflows = Array.isArray(body.data) ? body.data : Array.isArray(body) ? body : [];

    res.json({
      ok: true,
      workflows: workflows.map(publicWorkflowShape)
    });
  } catch (error) {
    res.status(error.status || 500).json({
      ok: false,
      error: error.message,
      details: error.body || null
    });
  }
});

app.post('/n8n/workflows/draft', assertAuth, async (req, res) => {
  const input = req.body || {};

  if (!input.name || !Array.isArray(input.nodes) || !input.connections) {
    return res.status(400).json({
      ok: false,
      error: 'name, nodes and connections are required'
    });
  }

  const workflow = {
    name: input.name,
    nodes: input.nodes,
    connections: input.connections,
    settings: input.settings || {},
    tags: input.tags || [],
    active: false
  };

  try {
    const created = await callN8n('/api/v1/workflows', {
      method: 'POST',
      body: JSON.stringify(workflow)
    });

    res.status(201).json({
      ok: true,
      workflow: publicWorkflowShape(created),
      policy: 'created as inactive draft; human activation required'
    });
  } catch (error) {
    res.status(error.status || 500).json({
      ok: false,
      error: error.message,
      details: error.body || null
    });
  }
});

app.post('/n8n/import-command', assertAuth, (req, res) => {
  const inputPath = String(req.body?.inputPath || '').trim();

  if (!inputPath) {
    return res.status(400).json({ ok: false, error: 'inputPath is required' });
  }

  const command = inputPath.endsWith('/')
    ? `docker exec -it nvf-n8n n8n import:workflow --separate --input=${inputPath}`
    : `docker exec -it nvf-n8n n8n import:workflow --input=${inputPath}`;

  res.json({
    ok: true,
    command,
    note: 'Imports are inactive by default. Review in n8n before activating.'
  });
});

app.use((_req, res) => {
  res.status(404).json({ ok: false, error: 'not_found' });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`N3XUS n8n control gateway listening on ${PORT}`);
});
